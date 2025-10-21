include("myfunctions_reltime.jl")
using CSV, XLSX, DataFrames, DifferentialEquations, Plots

## looping across a list of models

root_path=joinpath(@__DIR__, "..", "..")
save_path=joinpath(root_path,"results")
savefig_path=joinpath(root_path,"results","plots")
parameters_path=root_path
log_file=joinpath(root_path,"code","julia","output.log")

function log_message(msg)
    println(msg)  # Print to console
    open(log_file, "a") do io
        println(io, msg)  # Print to log file
    end
end

# 1. Read the file
df = CSV.read(joinpath(root_path,"code","julia","model.list"), DataFrame, header=1, delim=',', quotechar='"')

brava_gouge = collect(skipmissing(filter(:group => ==("brava_gouge"), df).model))
shiva_gouge = collect(skipmissing(filter(:group => ==("shiva_gouge"), df).model))
shiva_barerock = collect(skipmissing(filter(:group => ==("shiva_barerock"), df).model))
benchmarks = collect(skipmissing(filter(:group => ==("benchmarks"), df).model))

bedretto=vcat(brava_gouge,shiva_gouge,shiva_barerock)

# for testing three models only
model_names=shiva_gouge[1:3,:]

# model_names=bedretto

println(model_names)

for model_name in model_names
    params = import_and_process_model_data(model_name, parameters_path)
    run_model(model_name,params)
end