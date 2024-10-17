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
        label --> "S"
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> :blue
        linecolor --> :blue
        shear.dist, shear.shear
    end
end

struct ShearEnvelopes
    dist::Vector{Float64}
    max_shear::Vector{Float64}
    min_shear::Vector{Float64}
end
max_shears(shear_envelopes::ShearEnvelopes) = Shears(shear_envelopes.dist, shear_envelopes.max_shear)
min_shears(shear_envelopes::ShearEnvelopes) = Shears(shear_envelopes.dist, shear_envelopes.min_shear)

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

@recipe function plot(shear::ShearEnvelopes; 
    maxcolor=:blue, mincolor=:red,
    maxlabel="+ V", minlabel="- V")
    title --> "Shear Envelopes"

    @series begin
        label --> maxlabel
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> maxcolor
        linecolor --> maxcolor
        shear.dist, shear.max_shear
    end

    @series begin
        label --> minlabel
        fillrange --> 0
    	fillalpha --> 0.5
    	fillcolor --> mincolor
        linecolor --> mincolor
        shear.dist, shear.min_shear
    end
end

Base.:-(v1::Shears, v2::Shears) = Shears(v1.dist, v1.shear - v2.shear)
function Base.:-(v1::ShearEnvelopes, v2::ShearEnvelopes) 
    ShearEnvelopes(v1.dist, v1.max_shear - v2.max_shear, v1.min_shear - v2.min_shear)
end

Base.:/(v1::Shears, v2::Shears) = Shears(v1.dist, v1.shear ./ v2.shear)
function Base.:/(v1::ShearEnvelopes, v2::ShearEnvelopes) 
    ShearEnvelopes(v1.dist, v1.max_shear / v2.max_shear, v1.min_shear / v2.min_shear)
end

Base.:*(num::Real, v::Shears) = Shears(v.dist, v.shear .* num)
function Base.:-(num::Real, v::ShearEnvelopes) 
    ShearEnvelopes(v.dist, v.max_shear .* num, v.min_shear .* num)
end

Base.abs(v1::Shears) = Shears(m1.dist, abs.(v1.shear))
Base.abs(v1::ShearEnvelopes) = ShearEnvelopes(v1.dist, abs.(v1.max_shear), abs.(v1.min_shear))