struct Deflections
    dist::Vector{Float64}
    defl::Vector{Float64}
end

function deflections(tb4a::Table4A)
    dist = Float64[]
    defl = Float64[]

    for result in tb4a.results
        push!(dist, result.dist)
        push!(defl, result.defl)
    end

    return Deflections(dist, defl)
end

@recipe function plot(deflections::Deflections)
    legend --> false
    title --> "Deflections"

    @series begin
        deflections.dist, deflections.defl
    end
end