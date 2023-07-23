using Agents
using Random

# setting up our Agent-Type, as a 2-dimensional Grid Agent
@agent Person GridAgent{2} begin
   # 0 is susceptible, 1 is infected
   health::Int
   # 0 is unaware, 1 is aware
   awareness::Float64

   illness_duration::Int
   awareness_duration::Int
end




function generateModel(; total_agents=25*25, grid_dimensions=(25, 25), 
   susceptibility=0.3, duration=15, 
   awareness_susceptibility = 0.4, awareness_duration = 30,
   influx_probability = 0.0001,
   seed=12345)

   properties = Dict(
      :susceptibility => susceptibility,
      :duration => duration,
      :awareness_susceptibility => awareness_susceptibility,
      :awareness_duration => awareness_duration,
      :influx_probability => influx_probability
   )

   rng = Xoshiro(seed)
   space = GridSpaceSingle(grid_dimensions; periodic=false)

   model = UnremovableABM(Person, space; properties, rng, scheduler=Schedulers.Randomly())
   for n in 1:total_agents
      agent = Person(n, (1, 1), 0, 0, 0, 0)
      add_agent_single!(agent, model)
   end
   infected = random_agent(model)
   infected.health = 1
   
   return model
end


function agent_step!(agent, model)

   neighborhood = nearby_agents(agent, model)

   # random new infections
   if rand(model.rng) < model.influx_probability
      agent.health = 1
   end

   # agent is infected
   if agent.health == 1
      agent.illness_duration += 1

      neighbor = random_nearby_agent(agent, model)
      if neighbor.health == 0
        # test for possible infectious event
        if rand(model.rng) < (model.susceptibility * (1 - neighbor.awareness))
            neighbor.health = 1
        end

        for neighbor in neighborhood
            if rand(model.rng) < model.awareness_susceptibility
               neighbor.awareness = 1
               neighbor.awareness_duration =0
            end
        end

        if agent.illness_duration > model.duration
            agent.illness_duration = 0
            agent.health = 0
        end
    end
   end

   # agent is aware
   if agent.awareness > 0
      agent.awareness_duration += 1
      # after awareness duration forgets
      if agent.awareness_duration > model.awareness_duration
         agent.awareness /= 2
         agent.awareness_duration = 0
      end
   end



   
   
   avg_awareness = 0
   for neigbor in neighborhood
      avg_awareness += neigbor.awareness
   end
   avg_awareness /= length(collect(nearby_agents(agent, model)))
   #if (avg_awareness>0.8)
   #   agent.awareness = 1
   #end


   

end