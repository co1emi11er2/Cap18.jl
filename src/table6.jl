"""
    struct Envelopes

A result from `Table6` table (just one entry). 

# Fields
- `sta::Int` - station along bent
- `dist::Float64` - actual distance along bent
- `max_moment::Float64` - envelope of max positive moment
- `min_moment::Float64` - envelope of max negative moment
- `max_shear::Float64` - envelope of max positive shear
- `min_shear::Float64` - envelope of max negative shear
"""
Base.@kwdef struct Envelopes
    sta::Int
    dist::Float64
    max_moment::Float64
    min_moment::Float64
    max_shear::Float64
    min_shear::Float64
end

function Envelopes(line::String)
    Envelopes(
        sta=parse(Int, line[1:9]),
        dist=parse(Float64, line[10:19]),
        max_moment=parse(Float64, line[20:33]),
        min_moment=parse(Float64, line[34:47]),
        max_shear=parse(Float64, line[48:61]),
        min_shear=parse(Float64, line[62:75]),
    )
end

struct Table6 
    results::Vector{Envelopes}
end

Table6() = Table6(Envelopes[])