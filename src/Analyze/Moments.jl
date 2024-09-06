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

function max_moments(tb6::Table6)
    dist = Float64[]
    moments = Float64[]

    for result in tb6.results
        push!(dist, result.dist)
        push!(moments, result.max_moment)
    end

    return Moments(dist, moments)
end

function min_moments(tb6::Table6)
    dist = Float64[]
    moments = Float64[]

    for result in tb6.results
        push!(dist, result.dist)
        push!(moments, result.min_moment)
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

struct MomentEnvelopes
    dist::Vector{Float64}
    max_moment::Vector{Float64}
    min_moment::Vector{Float64}
end

function moment_envelopes(tb6::Table6)
    dist = Float64[]
    max_moments = Float64[]
    min_moments = Float64[]

    for result in tb6.results
        push!(dist, result.dist)
        push!(max_moments, result.max_moment)
        push!(min_moments, result.min_moment)
    end

    return MomentEnvelopes(dist, max_moments, min_moments)
end

@recipe function plot(moments::MomentEnvelopes)
    title --> "Moment Envelopes"

    @series begin
        label --> "+ M"
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :blue
        moments.dist, moments.max_moment
    end

    @series begin
        label --> "- M"
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :red
        moments.dist, moments.min_moment
    end
end