struct Moments
    dist::Vector{Float64}
    moments::Vector{Float64}
end

function moments(tb4a::Table4A)
    dist = Float64[]
    moments = Float64[]

    for result in tb4a.results
        push!(dist, result.dist)
        push!(moments, result.moment)
    end

    return Moments(dist, moments)
end

@recipe function plot(moments::Moments)
    legend --> false
    title --> "Moment"

    @series begin
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :blue
        moments.dist, moments.moments
    end
end