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
        label --> "M"
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :blue
        linecolor --> :blue
        moments.dist, moments.moments
    end
end

struct MomentEnvelopes
    dist::Vector{Float64}
    max_moment::Vector{Float64}
    min_moment::Vector{Float64}
end
max_moments(mom_envelopes::MomentEnvelopes) = Moments(mom_envelopes.dist, mom_envelopes.max_moment)
min_moments(mom_envelopes::MomentEnvelopes) = Moments(mom_envelopes.dist, mom_envelopes.min_moment)

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

@recipe function plot(moments::MomentEnvelopes; 
    maxcolor=:blue, mincolor=:red,
    maxlabel="+ M", minlabel="- M")
    title --> "Moment Envelopes"

    @series begin
        label --> maxlabel
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> maxcolor
        linecolor --> maxcolor
        moments.dist, moments.max_moment
    end

    @series begin
        label --> minlabel
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> mincolor
        linecolor --> mincolor
        moments.dist, moments.min_moment
    end
end

Base.:-(m1::Moments, m2::Moments) = Moments(m1.dist, m1.moments - m2.moments)
function Base.:-(m1::MomentEnvelopes, m2::MomentEnvelopes) 
    MomentEnvelopes(m1.dist, m1.max_moment - m2.max_moment, m1.min_moment - m2.min_moment)
end

Base.:/(m1::Moments, m2::Moments) = Moments(m1.dist, m1.moments ./ m2.moments)
function Base.:/(m1::MomentEnvelopes, m2::MomentEnvelopes) 
    MomentEnvelopes(m1.dist, m1.max_moment / m2.max_moment, m1.min_moment / m2.min_moment)
end

Base.:*(num::Real, m::Moments) = Moments(m.dist, m.moments .* num)
function Base.:-(num::Real, m::MomentEnvelopes) 
    MomentEnvelopes(m.dist, m.max_moment .* num, m.min_moment .* num)
end

Base.abs(m1::Moments) = Moments(m1.dist, abs.(m1.moments))
Base.abs(m1::MomentEnvelopes) = MomentEnvelopes(m1.dist, abs.(m1.max_moment), abs.(m1.min_moment))