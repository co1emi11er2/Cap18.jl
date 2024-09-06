struct Shears
    dist::Vector{Float64}
    shear::Vector{Float64}
end

function shears(tb4a::Table4A)
    dist = Float64[]
    shears = Float64[]

    for result in tb4a.results
        push!(dist, result.dist)
        push!(shears, result.shear)
    end

    return Shears(dist, shears)
end

@recipe function plot(shear::Shears)
    legend --> false
    title --> "Shear"

    @series begin
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :blue
        shear.dist, shear.shear
    end
end