using Pkg
Pkg.activate(".")

include("model.jl")

model = generateModel()

using CairoMakie # choosing a plotting backend

groupcolor(a) = a.health == 1 ? :red : :blue
groupmarker(a) = a.awareness > 0 ? :circle : :rect
adata = [(:health, sum)]

figure, _ = abmplot(model; ac=groupcolor, am=groupmarker, as=10)
figure # returning the figure displays it


scan_parameters = Dict(
      :total_agents => 25*25,
      :grid_dimensions => (25,25),
      :susceptibility => collect(0.1:0.1:1), 
      :duration => 15, 
      :awareness_duration => 30,
      :seed => 123
   
)

adata = [(:health, sum)]

adf, _ = paramscan(scan_parameters, generateModel; adata, agent_step!, n = 20)

using CSV

CSV.write("test.csv", adf)