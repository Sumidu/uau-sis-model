using Pkg
Pkg.activate(".")

include("model.jl")

model = generateModel()

groupcolor(a) = a.health == 1 ? :red : :blue
groupmarker(a) = a.awareness > 0 ? :circle : :rect

adata = [(:health, sum), (:awareness, sum)]

params = Dict(
    :susceptibility => 0:0.01:1,
    :duration => collect(1:30),
    :awareness_susceptibility => 0:0.1:1,
    :awareness_duration => collect(1:30),
    :influx_probability => [0,0.001]
)


using GLMakie
fig, abmobs = abmexploration(model; agent_step!, adata, ac = groupcolor, am = groupmarker, params)
fig