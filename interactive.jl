using Pkg
Pkg.activate(".")

include("model.jl")

using CairoMakie # choosing a plotting backend

model = generateModel()

groupcolor(a) = a.health == 1 ? :red : :blue
groupmarker(a) = a.awareness > 0 ? :circle : :rect

adata = [(:health, sum), (:awareness, sum)]

params = Dict(
    :susceptibility => 0:0.01:1,
    :influx_probability => 0
)


using GLMakie
fig, abmobs = abmexploration(model; agent_step!, adata, ac = groupcolor, am = groupmarker, params)
fig