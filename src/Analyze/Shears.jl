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

function max_shears(tb6::Table6)
    dist = Float64[]
    shears = Float64[]

    for result in tb6.results
        push!(dist, result.dist)
        push!(shears, result.max_shear)
    end

    return Shears(dist, shears)
end    

function min_shears(tb6::Table6)
    dist = Float64[]
    shears = Float64[]

    for result in tb6.results
        push!(dist, result.dist)
        push!(shears, result.min_shear)
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

struct ShearEnvelopes
    dist::Vector{Float64}
    max_shear::Vector{Float64}
    min_shear::Vector{Float64}
end

function shear_envelopes(tb6::Table6)
    dist = Float64[]
    max_shears = Float64[]
    min_shears = Float64[]

    for result in tb6.results
        push!(dist, result.dist)
        push!(max_shears, result.max_shear)
        push!(min_shears, result.min_shear)
    end

    return ShearEnvelopes(dist, max_shears, min_shears)
end

@recipe function plot(shear::ShearEnvelopes)
    title --> "Shear Envelopes"

    @series begin
        label --> "+ V"
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :blue
        shear.dist, shear.max_shear
    end

    @series begin
        label --> "- V"
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :red
        shear.dist, shear.min_shear
    end
end