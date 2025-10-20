using DataFrames
using CSV

analysis_name = "gsa-shiva-bg-lf"

# 1. Define the folder path and an empty DataFrame to store results
folder_path=joinpath(@__DIR__, "..", "..", "results", analysis_name)

results_df = DataFrame(
    name = String[], 
    difftime = Float64[], 
    alpha = Float64[], 
    epsilon = Float64[], 
    beta = Float64[], 
    Vfinal = Float64[]
)

# 2. Loop through all files in the folder
for filename in readdir(folder_path)
    # print(filename)

    # Check if the file is a CSV file
    if endswith(filename, ".csv")
        
        # 3. Use regular expressions to extract values from the filename
        m = match(r"^(?<model_name>[\w-]+?)--difftime-(?<difftime>[+-]?[\d.e+-]+?)--alpha-(?<alpha>[+-]?[\d.e+-]+?)--epsilon-(?<epsilon>[+-]?[\d.e+-]+?)--beta-(?<beta>[+-]?[\d.e+-]+?)rt\.csv$", filename)

        if m !== nothing
            name = m[:model_name]
            difftime = parse(Float64, m[:difftime])
            alpha = parse(Float64, m[:alpha])
            epsilon = parse(Float64, m[:epsilon])
            beta = parse(Float64, m[:beta])
            
            # 4. Open and read the CSV file
            file_path = joinpath(folder_path, filename)
            df = CSV.read(file_path, DataFrame)
            
            # 5. Get the final value of the "V" column
            if "V" in names(df)
                Vfinal = df.V[end]
            else
                Vfinal = missing # Handle case where column is missing
            end
            
            # 6. Push the new row to the results DataFrame
            push!(results_df, (name, difftime, alpha, epsilon, beta, Vfinal))
        end
    end
end

# Now results_df contains all the extracted data
println(results_df)
CSV.write(joinpath(folder_path,results_df[!, "name"][1]*"_analysis.csv"), results_df)