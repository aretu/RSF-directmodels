include("myfunctions_reltime.jl")
using CSV, XLSX, DataFrames, DifferentialEquations, Plots, Printf

## looping across a list of models

analysis_name = "gsa-shiva-bg-lf"

root_path=joinpath(@__DIR__, "..", "..")
save_path=joinpath(root_path,"results",analysis_name)
savefig_path=joinpath(root_path,"results","plots",analysis_name)
parameters_path=root_path
log_file=joinpath(root_path,"code","julia","output.log")

function log_message(msg)
    println(msg)  # Print to console
    open(log_file, "a") do io
        println(io, msg)  # Print to log file
    end
end

model_names=[analysis_name]

for model_name in model_names
    nominal_params = import_and_process_model_data(model_name, parameters_path)
    
    # print(nominal_params)
    alpha_list=range(0, stop=0.3, length=4)
    epsilon_list=range(-5,stop=-2, length=4)
    beta_list=range(-12,stop=-9,length=4)
    difftime_list=range(-3,stop=0,length=4)

    for difftime_val in exp10.(difftime_list)
        for alpha_val in alpha_list
            for epsilon_val in exp10.(epsilon_list)
                for beta_val in exp10.(beta_list)

                    # Create a copy of the nominal parameters to avoid modifying the original
                    current_params = copy(nominal_params)

                    # Overwrite the parameters being varied
                    current_params[:alpha] = alpha_val
                    current_params[:epsilon] = epsilon_val
                    
                    current_params[:beta] = beta_val
                    betahat = beta_val * current_params[:sigma]
                    current_params[:betahat] = betahat

                    current_params[:difftime] = difftime_val
                    cstar = 1/difftime_val
                    chat = cstar * current_params[:dc] / current_params[:v0]
                    current_params[:cstar] = cstar
                    current_params[:chat] = chat
                    
                    s0 = @sprintf "%.2e" difftime_val
                    s1 = @sprintf "%.2e" alpha_val
                    s2 = @sprintf "%.2e" epsilon_val
                    s3 = @sprintf "%.2e" beta_val
                    
                    current_params[:option]=model_name*"--difftime-"*s0*"--alpha-"*s1*"--epsilon-"*s2*"--beta-"*s3

                    print(current_params)

                    run_model(model_name,current_params)
                end
            end
        end
    end
end