struct Deflections
    dist::Vector{float_ft}
    defl::Vector{float_ft}
end

function deflections(tb4a::Table4A)
    dist = float_ft[]
    defl = float_ft[]

    for result in tb4a.results
        push!(dist, result.dist*ft)
        push!(defl, result.defl*ft)
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