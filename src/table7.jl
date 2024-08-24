"""
    struct Reactions

A result from `Table7` table (just one entry). 

# Fields
- `sta::Int` - station along bent
- `dist::Float64` - actual distance along bent
- `max_reaction::Float64` - maximum reaction at support
- `min_reaction::Float64` - minimum reaction at support
"""
Base.@kwdef struct Reactions
    sta::Int
    dist::Float64
    max_reaction::Float64
    min_reaction::Float64
end

function Reactions(line::String)
    Reactions(
        sta=parse(Int, line[1:9]),
        dist=parse(Float64, line[10:19]),
        max_reaction=parse(Float64, line[20:33]),
        min_reaction=parse(Float64, line[34:48]),
    )
end

struct Table7 
    results::Vector{Reactions}
end

Table7() = Table7(Reactions[])