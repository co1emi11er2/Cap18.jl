struct Moments
    dist::Vector{float_ft}
    moments::Vector{float_kip_ft}
end

function moments(tb4a::Table4A)
    dist = float_ft[]
    moments = float_kip_ft[]

    for result in tb4a.results
        push!(dist, result.dist*ft)
        push!(moments, result.moment*ft*kip)
    end

    return Moments(dist, moments)
end

function max_moments(tb6::Table6)
    dist = float_ft[]
    moments = float_kip_ft[]

    for result in tb6.results
        push!(dist, result.dist*ft)
        push!(moments, result.max_moment*ft*kip)
    end

    return Moments(dist, moments)
end

function min_moments(tb6::Table6)
    dist = float_ft[]
    moments = float_kip_ft[]

    for result in tb6.results
        push!(dist, result.dist*ft)
        push!(moments, result.min_moment*ft*kip)
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
    dist::Vector{float_ft}
    max_moment::Vector{float_kip_ft}
    min_moment::Vector{float_kip_ft}
end

function moment_envelopes(tb6::Table6)
    dist = float_ft[]
    max_moments = float_kip_ft[]
    min_moments = float_kip_ft[]

    for result in tb6.results
        push!(dist, result.dist*ft)
        push!(max_moments, result.max_moment*ft*kip)
        push!(min_moments, result.min_moment*ft*kip)
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