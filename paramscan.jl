using Pkg
Pkg.activate(".")

include("model.jl")


adata = [(:health, sum)]

scan_parameters = Dict(
      :total_agents => 25*25,
      :grid_dimensions => (25,25),
      :susceptibility => collect(0.1:0.1:1), 
      :duration => 15, 
      :awareness_duration => 30,
      :seed => 123
   
)

adf, _ = paramscan(scan_parameters, generateModel; adata, agent_step!, n = 20)

using CSV

CSV.write("agent_data.csv", adf)