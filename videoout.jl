using Pkg
Pkg.activate(".")

include("model.jl")

model = generateModel()

using CairoMakie # choosing a plotting backend

groupcolor(a) = a.health == 1 ? :red : :blue
groupmarker(a) = a.awareness > 0 ? :circle : :rect
adata = [(:health, sum)]

abmvideo(
   "uau-sis.mp4", model, agent_step!;
   ac=groupcolor, am=groupmarker, as=10,
   framerate=20, frames=400,
   title="sis model"
)
