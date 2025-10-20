# the equations

# end of zlp

function calculate_VplusZLP(V_minus::Float64, ξ::Float64, μ0::Float64, Τ_minus::Float64, a::Float64)
    return V_minus * exp(((ξ * μ0) - Τ_minus) / a)
end

# at each ΔPf increase for simple P steps

function calculate_ThetaPlus(Θ_minus::Float64, σ_minus::Float64, Δσ::Float64, α::Float64, b::Float64)
    return Θ_minus * (σ_minus / (σ_minus + Δσ))^(α / b)
end

function calculate_Vplus(
    V_minus::Float64,
    σ_minus::Float64,
    Δσ::Float64,
    α::Float64,
    a::Float64,
    mu::Float64,  # Pass a function μ(V_minus, Θ_minus)
)
    factor1 = ((σ_minus + Δσ) / σ_minus)^(α / a)  # First multiplicative factor
    factor2 = exp(-Δσ / (a * (σ_minus + Δσ)) * mu)  # Exponential term
    return V_minus * factor1 * factor2  # Compute V_plus
end

# Define μ(V_minus, Θ_minus)
function mu(mu0::Float64, a::Float64, V_minus::Float64, b::Float64, Θ_minus::Float64)
    return mu0 + a * log(V_minus) + b * log(Θ_minus)  # Example function for μ
end

# Define the ODE system of equations in each case

using DifferentialEquations


function zlp!(du, u, p, t)
    Τ, Θ, V, U, Φ, P, Prev = u        # Unpack variables
    a, b, k, ϵ, η, α, T, ĉ, β̂ , mu0  = p  # Unpack parameters

    # Avoid division by zero or log of non-positive numbers
    # Θ = max(Θ, 1e-8)   # Prevent Θ from being zero
    # V = max(V, 1e-8)   # Prevent V from being zero or negative

    # Compute intermediate variables
    dΤ = -k * V
    dΘ = 1 - Θ * V
    dV = V / a * (dΤ - b / Θ * dΘ) / (1 + V * η / a)
    dU = V
    dΦ = -V * (Φ - ϵ * log(V))
    dP = 0
    dPrev = 0

    # Assign to du
    du[1] = dΤ 
    du[2] = dΘ 
    du[3] = dV 
    du[4] = dU 
    du[5] = dΦ 
    du[6] = dP 
    du[7] = dPrev 

    # Debugging outputs
    # println("τ = $τ, Τ = $Τ, Θ = $Θ, V = $V, U = $U, Φ = $Φ")
    # println("du = [$dΤ, $dΘ, $dV, $dU, $dΦ]")
end

function creep!(du, u, p, t)
    Τ, Θ, V, U, Φ, P, Prev = u        # Unpack variables
    a, b, k, ϵ, η, α, T, ĉ, β̂ , mu0  = p  # Unpack parameters

    # Avoid division by zero or log of non-positive numbers
    # Θ = max(Θ, 1e-8)   # Prevent Θ from being zero
    # V = max(V, 1e-8)   # Prevent V from being zero or negative

    # Compute intermediate variables
    dΤ = 0
    dΘ = 1 - Θ * V
    dV = -b/a * V * (1/Θ * dΘ)
    dU = V
    dΦ = -V * (Φ - ϵ * log(V))
    dP = 0
    dPrev = 0

    # Assign to du
    du[1] = dΤ 
    du[2] = dΘ 
    du[3] = dV 
    du[4] = dU 
    du[5] = dΦ 
    du[6] = dP 
    du[7] = dPrev 

    # Debugging outputs
    # println("τ = $τ, Τ = $Τ, Θ = $Θ, V = $V, U = $U, Φ = $Φ")
    # println("du = [$dΤ, $dΘ, $dV, $dU, $dΦ]")
end

function zlpshale!(du, u, p, t)
    Τ, Θ, V, U, Φ, P, Prev = u        # Unpack variables
    a, b, k, ϵ, η, α, T, ĉ, β̂ , mu0  = p  # Unpack parameters

    # Avoid division by zero or log of non-positive numbers
    # Θ = max(Θ, 1e-8)   # Prevent Θ from being zero
    # V = max(V, 1e-8)   # Prevent V from being zero or negative

    # Compute intermediate variables
    dΤ = -k * V
    dΘ = 1 - Θ * V
    dV = V / a * (dΤ - b / Θ * dΘ) / (1 + V * η / a)
    dU = 0
    dΦ = -V * (Φ - ϵ * log(V))
    dP = 0
    dPrev = 0

    # Assign to du
    du[1] = dΤ 
    du[2] = dΘ 
    du[3] = dV 
    du[4] = dU 
    du[5] = dΦ 
    du[6] = dP 
    du[7] = dPrev 

    # Debugging outputs
    # println("τ = $τ, Τ = $Τ, Θ = $Θ, V = $V, U = $U, Φ = $Φ")
    # println("du = [$dΤ, $dΘ, $dV, $dU, $dΦ]")
end

function creepshale!(du, u, p, t)
    Τ, Θ, V, U, Φ, P, Prev = u        # Unpack variables
    a, b, k, ϵ, η, α, T, ĉ, β̂ , mu0  = p  # Unpack parameters

    # Avoid division by zero or log of non-positive numbers
    # Θ = max(Θ, 1e-8)   # Prevent Θ from being zero
    # V = max(V, 1e-8)   # Prevent V from being zero or negative

    # Compute intermediate variables
    dΤ = 0
    dΘ = 1 - Θ * V
    dV = -b/a * V * (1/Θ * dΘ)
    dU = 0
    dΦ = -V * (Φ - ϵ * log(V))
    dP = 0
    dPrev = 0

    # Assign to du
    du[1] = dΤ 
    du[2] = dΘ 
    du[3] = dV 
    du[4] = dU 
    du[5] = dΦ 
    du[6] = dP 
    du[7] = dPrev 

    # Debugging outputs
    # println("τ = $τ, Τ = $Τ, Θ = $Θ, V = $V, U = $U, Φ = $Φ")
    # println("du = [$dΤ, $dΘ, $dV, $dU, $dΦ]")
end

function creepinjshale!(du, u, p, t)
    Τ, Θ, V, U, Φ, P, Prev = u        # Unpack variables
    a, b, k, ϵ, η, α, T, ĉ, β̂ , mu0 = p  # Unpack parameters

    # Avoid division by zero or log of non-positive numbers
    # Θ = max(Θ, 1e-8)   # Prevent Θ from being zero
    # V = max(V, 1e-8)   # Prevent V from being zero or negative

    # Compute intermediate variables

    dΦ = -V * (Φ - ϵ * log(V))
    dP = ĉ * (Prev-P) - dΦ/β̂
    dΘ = 1 - Θ * V + α/b * Θ/(1-P) * dP
    dV = V/a * (dP * (mu0 + a * log(V) + b* log(Θ)) - b/Θ * dΘ)
    dU = V
    dPrev = 0
    dΤ = 0

    # Assign to du
    du[1] = dΤ 
    du[2] = dΘ 
    du[3] = dV 
    du[4] = dU 
    du[5] = dΦ 
    du[6] = dP 
    du[7] = dPrev 

    # Debugging outputs
    # println("τ = $τ, Τ = $Τ, Θ = $Θ, V = $V, U = $U, Φ = $Φ")
    # println("du = [$dΤ, $dΘ, $dV, $dU, $dΦ]")
end

using XLSX, DataFrames

"""
Import parameters and process data for a given model.

# Arguments
- `model_name::String`: The name of the model to extract parameters for.
- `parameters_path::String`: Path to the directory containing the Excel file.
- `file_name::String`: Name of the Excel file.
- `sheet_name::String`: Sheet name in the Excel file.

# Returns
- A dictionary containing the processed parameters and computed values.
"""
function import_and_process_model_data(
    model_name::String,
    parameters_path::String,
    file_name::String = "inputparameters.xlsx",
    sheet_name::String = "Sheet1"
)
    # Load the Excel file
    data = DataFrame(XLSX.readtable(joinpath(parameters_path,file_name), sheet_name))

    # Define column types
    coltypes = Dict(
        "name" => String,
        "machine" => String,
        "material" => String,
        "area (m^2)" => Float64,
        "k_vert (kN/mm)" => Float64,
        "d_c (mm)" => Float64,
        "Pf (MPa)" => Float64,
        "sigma (MPa)" => Float64,
        "difftime (s)" => Float64,
        "beta (1/Pa)" => Float64,
        "v0 (µm/s)" => Float64,
        "mu0" => Float64,
        "a" => Float64,
        "b" => Float64,
        "eta" => Float64,
        "alpha" => Float64,
        "epsilon" => Float64,
        "model_type" => String,
        "zlp" => String,
        "zlp_steptype" => String,
        "crp_steptype" => String,
        "crpinj_modtype" => String,
        "crpinj_steptype" => String,
        "dtzlp (hours)" => Float64,
        "dtcreep (hours)" => Float64,
        "dtinj (hours)" => Float64,
        "dpinj (MPa)" => Float64,
        "dpinjfactor" => Float64,
        "dtauinj (MPa)" => Float64,
        "xi" => Float64,
        "N" => Int,
        "M" => Int,
        "data" => String,
        "notes" => String
    )

    # Process column types
    for (col, coltype) in coltypes
        if col in names(data)
            if any(ismissing, data[!, col])
                # Replace `missing` with default values based on column type
                if coltype == String
                    data[!, col] = string.(coalesce.(data[!, col], ""))
                elseif coltype == Int
                    data[!, col] = Int.(coalesce.(data[!, col], 0))
                elseif coltype == Float64
                    data[!, col] = Float64.(coalesce.(data[!, col], 0.0))
                else
                    data[!, col] = coltype.(coalesce.(data[!, col], 0))
                end
            else
                data[!, col] = coltype.(data[!, col])
            end
        end
    end

    # Extract the row for the specific model
    model = data[data.name .== model_name, :]

    # Process parameters and return as a dictionary
    Area = model[!,"area (m^2)"][1]
    kvert = model[!,"k_vert (kN/mm)"][1] * 1e6  # N/m
    dc = model[!,"d_c (mm)"][1] * 1e-3         # m
    sigma = model[!,"sigma (MPa)"][1] * 1e6    # Pa
    pf0 = model[!,"Pf (MPa)"][1] * 1e6         # Pa
    DtZLP = model[!,"dtzlp (hours)"][1] * 3600 # sec
    DtCreep = model[!,"dtcreep (hours)"][1] * 3600 # sec
    DtInj = model[!,"dtinj (hours)"][1] * 3600 # sec
    dpinjfactor = model.dpinjfactor[1]
    DPInj = model[!,"dpinj (MPa)"][1] * 1e6    # Pa
    DtauInj = model[!,"dtauinj (MPa)"][1] * 1e6 # Pa
    v0 = model[!,"v0 (µm/s)"][1] * 1e-6        # m/s
    mu0 = model.mu0[1]
    a = model.a[1]
    b = model.b[1]
    eta = model.eta[1]
    alpha = model.alpha[1]
    epsilon = model.epsilon[1]
    xi = model.xi[1]
    N = model.N[1]
    M = model.M[1]
    k = kvert * dc / (sigma * Area)
    cstar, beta, betahat, chat = if model.crpinj_modtype[1] == "complex"
        cstar = 1 / model[!,"difftime (s)"][1] # 1/s
        beta = model[!,"beta (1/Pa)"][1]       # 1/Pa
        betahat = beta * sigma
        chat = cstar * dc / v0
        (cstar, beta, betahat, chat)
    else
        cstar = 1 / 1e-6 # Default
        beta = 1e-11
        betahat = beta * sigma
        chat = cstar * dc / v0
        (cstar, beta, betahat, chat)
    end

    # Calculate normalized time and stress steps

    T = dc / v0

    deltZLP = DtZLP / T
    deltcreep = DtCreep / T
    delt = DtInj / T

    delp = DPInj / sigma
    deltau = DtauInj / sigma
    TstartZLP = 100
    TstartCreep = TstartZLP + deltZLP
    TstartInj = TstartZLP + deltZLP + deltcreep

    return Dict(
        :Area => Area, :kvert => kvert, :dc => dc, :sigma => sigma,
        :pf0 => pf0, :DtZLP => DtZLP, :DtCreep => DtCreep, :DtInj => DtInj,
        :dpinjfactor => dpinjfactor, :DPInj => DPInj, :DtauInj => DtauInj,
        :v0 => v0, :mu0 => mu0, :a => a, :b => b, :eta => eta, :alpha => alpha,
        :epsilon => epsilon, :xi => xi, :N => N, :M => M, :k => k,
        :cstar => cstar, :beta => beta, :betahat => betahat, :chat => chat,
        :deltZLP => deltZLP, :deltcreep => deltcreep, :delt => delt,
        :delp => delp, :deltau => deltau,
        :TstartZLP => TstartZLP, :TstartCreep => TstartCreep, :TstartInj => TstartInj,
        :model_type => model.model_type[1], :zlp_steptype => model.zlp_steptype[1],
        :crp_steptype => model.crp_steptype[1], :crpinj_steptype => model.crpinj_steptype[1],
    )
end

function run_model(
    model_name::String,
    params::Dict
    )

    root_path=joinpath(@__DIR__, "..", "..")
    save_path=joinpath(root_path,"results")
    savefig_path=joinpath(root_path,"results","plots")


    try
        # Import and process model parameters

        # ## the sequence of models
        log_message("~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~")
        log_message("Running model "*model_name)
        log_message(params[:model_type])

        # Parameters
        p = [params[:a], params[:b], params[:k], params[:epsilon], params[:eta], params[:alpha], params[:dc]/params[:v0], params[:chat], params[:betahat], params[:mu0]]
        # M Number of iterations for the third model, i.e., number of pressure steps

        # Optional: include steady state

        ## Initial conditions for the first model: zero load point stage
        u0_zlp = [params[:mu0], 1, params[:v0]/params[:v0], 100, 0, (params[:pf0]-params[:pf0])/params[:sigma], (params[:pf0]-params[:pf0])/params[:sigma]]   # [T, Θ, V, U, Φ, P, Prev]
        
        log_message(string("Zero load point stage ICs: ",u0_zlp))

        tspan_zlp = (100, 100+params[:deltZLP])

        # Solve the first model
        log_message("Running zero load point stage")
        log_message(params[:zlp_steptype])
        if params[:zlp_steptype] == "zlp"
            prob_zlp = ODEProblem(zlp!, u0_zlp, tspan_zlp, p)
        elseif params[:zlp_steptype] == "zlp-shale"
            prob_zlp = ODEProblem(zlpshale!, u0_zlp, tspan_zlp, p)
        end

        time_points_zlp = range(100, 100+params[:deltZLP], length=params[:N])

        sol_zlp = solve(
            prob_zlp, 
            Rodas5(), #RadauIIA5()
            saveat=time_points_zlp,
            abstol=1e-12,
            reltol=1e-12,
        )

        log_message("Zero load point stage complete!")

        ## Initial conditions for the second model: creep stage
        # Use the final solution of the first model as ICs for the second model
        u0_creep = sol_zlp.u[end]

        # Update slip rate after ZLP
        vpluszlp = calculate_VplusZLP(u0_creep[3], params[:xi], params[:mu0], u0_creep[1], params[:a])
        
        # Update ICs for slip rate and shear stress
        u0_creep[3] = vpluszlp
        u0_creep[1] = params[:xi]*params[:mu0]

        log_message(string("Creep stage ICs: ",u0_creep))

        tspan_creep = (100+params[:deltZLP], 100+params[:deltZLP]+params[:deltcreep])

        # Solve the second model
        log_message("Running creep stage")
        log_message(params[:crp_steptype])
        if params[:crp_steptype] == "creep"
            prob_creep = ODEProblem(creep!, u0_creep, tspan_creep, p)
        elseif params[:crp_steptype] == "creep-shale"
            prob_creep = ODEProblem(creepshale!, u0_creep, tspan_creep, p)
        end

        time_points_creep = range(100+params[:deltZLP], 100+params[:deltZLP]+params[:deltcreep], length=params[:N])

        sol_creep = solve(
            prob_creep, 
            Rodas5(), #RadauIIA5()
            saveat=time_points_creep,
            abstol=1e-12,
            reltol=1e-12,
        )

        log_message("Creep stage complete!")

        ## Initial conditions for the second model: fluid injection stage

        # Use the final solution of the second model as ICs for the third model
        u0_creepinj = sol_creep.u[end]

        global tstart = 100+params[:deltZLP]+params[:deltcreep]  # Start time for the third model
        global tend = 100+params[:deltZLP]+params[:deltcreep]+params[:delt]    # End time for the first iteration of the third model

        # Prepare to run the third model M times
        solutions_creepinj = Vector{Any}(undef, params[:M]+1)

        log_message("Running fluid injection stage")
        log_message(params[:crpinj_steptype])
        if params[:crpinj_steptype] == "creepinj-shale"
            for i in 1:params[:M]+1
                # Update initial condition for the third model
                if i == 1
                    log_message("First step i == 1")
                    u0 = u0_creepinj  # Use ICs from the second model for the first iteration
                    log_message(string("first ICs: ",u0))

                    u0[7] += params[:delp]*params[:dpinjfactor]

                    log_message(string("modified ICs due to step: ",u0))
                else
                    log_message("Other steps, i =/= 1")
                    # Use the final state of the last solution as the new initial condition
                    u0 = copy(solutions_creepinj[i - 1].u[end])  # Copy ensures no mutation of previous solutions
                    log_message(string("ICs of previous step: ",u0))

                    u0[7] += params[:delp]*params[:dpinjfactor]  # Increment the desired variable (e.g., Prev)

                    log_message(string("modified ICs due to step: ",u0))
                end

                # Update tspan dynamically for each iteration
                tspan_creepinj = (tstart, tend)
                time_points_creepinj = range(tstart, tend, length=params[:N])

                # Solve the third model
                prob_creepinj = ODEProblem(creepinjshale!, u0, tspan_creepinj, p)

                solutions_creepinj[i] = solve(
                    prob_creepinj, 
                    Rodas5(), #RadauIIA5()
                    saveat=time_points_creepinj,
                    abstol=1e-12,
                    reltol=1e-12,
                )
                
                log_message("Fluid injection stage, P step $i complete!")

                # Update start and end times for the next iteration
                global tstart = tend
                global tend += params[:delt]  # Increment the time span for the next iteration
            end
        elseif params[:crpinj_steptype] == "creep"
            for i in 1:params[:M]+1
                # Update initial condition for the third model
                if i == 1
                    log_message("First step i == 1")
                    u0 = u0_creepinj  # Use ICs from the second model for the first iteration
                    log_message(string("first ICs: ",u0))

                    sigma_minus = 1.0
                    Theta_minus = u0[2]
                    V_minus = u0[3]
                    mu_plus = mu(params[:mu0], params[:a], V_minus, params[:b], Theta_minus)
                    Δσ = params[:delp]*params[:dpinjfactor]

                    u0[6] += Δσ #increment pressure on fault
                    u0[7] += Δσ #increment pressure on reservoir
                    u0[3] = calculate_Vplus(V_minus,sigma_minus,-Δσ,params[:alpha],params[:a],mu_plus)
                    u0[2] = calculate_ThetaPlus(Theta_minus, sigma_minus, -Δσ, params[:alpha], params[:b])

                    log_message(string("modified ICs due to step: ",u0))

                else
                    log_message("Other steps, i =/= 1")
                    # Use the final state of the last solution as the new initial condition
                    u0 = copy(solutions_creepinj[i - 1].u[end])  # Copy ensures no mutation of previous solutions
                    log_message(string("ICs of previous step: ",u0))
                    
                    sigma_minus = 1-u0[7]
                    Theta_minus = u0[2]
                    V_minus = u0[3]
                    mu_plus = mu(params[:mu0], params[:a], V_minus, params[:b], Theta_minus)
                    Δσ = params[:delp]*params[:dpinjfactor]

                    u0[6] += Δσ #increment pressure on fault
                    u0[7] += Δσ #increment pressure on reservoir
                    u0[3] = calculate_Vplus(V_minus,sigma_minus,-Δσ,params[:alpha],params[:a],mu_plus)
                    u0[2] = calculate_ThetaPlus(Theta_minus, sigma_minus, -Δσ, params[:alpha], params[:b])
                    
                    log_message(string("modified ICs due to step: ",u0))
                end

                # Update tspan dynamically for each iteration
                tspan_creepinj = (tstart, tend)
                time_points_creepinj = range(tstart, tend, length=params[:N])

                # Solve the third model
                prob_creepinj = ODEProblem(creep!, u0, tspan_creepinj, p)

                solutions_creepinj[i] = solve(
                    prob_creepinj, 
                    Rodas5(), #RadauIIA5()
                    saveat=time_points_creepinj,
                    abstol=1e-12,
                    reltol=1e-12,
                )
                
                log_message("Fluid injection stage, P step $i complete!")

                # Update start and end times for the next iteration
                global tstart = tend
                global tend += params[:delt]  # Increment the time span for the next iteration
            end
        end

        # Plot all solutions
        # Plot the solution in 7 subplots without repeating x-axis labels
        log_message("Plotting model solution")

        p=plot(
            layout=(7, 1),               # 5 rows, 1 column
            size=(800, 1000),            # Adjust figure size
            bottom_margin=2Plots.mm,     # Reduce space at the bottom of each subplot
            legend=:none                 # Optional: Turn off legends for clarity
        )

        all_solutions = vcat([sol_zlp, sol_creep], solutions_creepinj)
        
        if !haskey(params, :option)
            plot_title=model_name
        else
            plot_title=params[:option]
        end

        for sol in all_solutions

            plot!(sol.t, sol[1, :], ylabel="Τ(τ)", title=plot_title, subplot=1)
            plot!(sol.t, sol[2, :], ylabel="Θ(τ)", subplot=2)
            plot!(sol.t, sol[3, :], yscale=:log10, ylabel="V(τ)", subplot=3)
            plot!(sol.t, sol[4, :], yscale=:log10, ylabel="U(τ)", subplot=4)
            plot!(sol.t, sol[3, :], ylabel="V(t)", subplot=3)
            plot!(sol.t, sol[4, :], ylabel="U(t)", subplot=4)
            plot!(sol.t, sol[5, :], ylabel="Φ(τ)", subplot=5)
            plot!(sol.t, sol[6, :], ylabel="P(τ)", subplot=6)
            plot!(sol.t, sol[7, :], xlabel="Normalized Time (τ)", ylabel="Prev(τ)", subplot=7)

        end

        display(p)

        # Save output

        # for sol in all_solutions
        #     log_message(size(sol.t))
        #     log_message(size(sol))
        #     log_message(size(sol'))
        # end


        # # Create an empty DataFrame to store all solutions
        all_data = DataFrame()

        # # Iterate over the container and unwrap solutions
        for sol in all_solutions
            # Extract time and variables
            t = sol.t # Time vector (length x)
            u = sol  # Solution matrix (7 rows, x columns)
            
            # Ensure the solution matrix is transposed for DataFrame compatibility
            u_transposed = u'  # Now (x, 7)
            
            # Create a DataFrame for this solution
            soldata = DataFrame(
                time=t, 
                V=u_transposed[:, 3], 
                Θ=u_transposed[:, 2], 
                U=u_transposed[:, 4], 
                Τ=u_transposed[:, 1],
                Φ=u_transposed[:, 5], 
                Prev=u_transposed[:, 7],
                P=u_transposed[:, 6]
            )
            
            # Add a model identifier column
            # data[!, :model] = "Model $i"  # Tag each row with the model number
            
            # Append this solution to the main DataFrame
            append!(all_data, soldata)
        end

        if !haskey(params, :option)
            # log_message(size(all_data))
            csvpath=joinpath(save_path,model_name*"rt.csv")
            pngpath=joinpath(savefig_path,model_name*"rt.png")
            
            log_message("Saving data in a .csv file in "*csvpath)
            CSV.write(csvpath, all_data)

            log_message("Saving plot as .png file in "*pngpath)
            savefig(pngpath)
        else
            csvpath=joinpath(save_path,params[:option]*"rt.csv")
            pngpath=joinpath(savefig_path,params[:option]*"rt.png")

            log_message("Saving data in a .csv file in "*csvpath)
            CSV.write(csvpath, all_data)

            log_message("Saving plot as .png file in "*pngpath)
            savefig(pngpath)
        end

    catch
        log_message("Running model "*model_name*" has failed!")

        if !haskey(params, :option)
            # log_message(size(all_data))
            csvpath=joinpath(save_path,model_name*"rt.csv")
            pngpath=joinpath(savefig_path,model_name*"rt.png")
            
            log_message("Saving data in a .csv file in "*csvpath)
            CSV.write(csvpath, all_data)

            log_message("Saving plot as .png file in "*pngpath)
            savefig(pngpath)
        else
            csvpath=joinpath(save_path,params[:option]*"rt.csv")
            pngpath=joinpath(savefig_path,params[:option]*"rt.png")

            log_message("Saving data in a .csv file in "*csvpath)
            CSV.write(csvpath, all_data)

            log_message("Saving plot as .png file in "*pngpath)
            savefig(pngpath)
        end
    end

end