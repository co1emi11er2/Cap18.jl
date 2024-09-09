struct Shears
    dist::Vector{float_ft}
    shear::Vector{float_kip}
end

function shears(tb4a::Table4A)
    dist = float_ft[]
    shears = float_kip[]

    for result in tb4a.results
        push!(dist, result.dist*ft)
        push!(shears, result.shear*kip)
    end

    return Shears(dist, shears)
end

function max_shears(tb6::Table6)
    dist = float_ft[]
    shears = float_kip[]

    for result in tb6.results
        push!(dist, result.dist*ft)
        push!(shears, result.max_shear*kip)
    end

    return Shears(dist, shears)
end    

function min_shears(tb6::Table6)
    dist = float_ft[]
    shears = float_kip[]

    for result in tb6.results
        push!(dist, result.dist*ft)
        push!(shears, result.min_shear*kip)
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
    dist::Vector{float_ft}
    max_shear::Vector{float_kip}
    min_shear::Vector{float_kip}
end

function shear_envelopes(tb6::Table6)
    dist = float_ft[]
    max_shears = float_kip[]
    min_shears = float_kip[]

    for result in tb6.results
        push!(dist, result.dist*ft)
        push!(max_shears, result.max_shear*kip)
        push!(min_shears, result.min_shear*kip)
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