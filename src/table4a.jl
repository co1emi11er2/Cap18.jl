"""
    struct DLResult

A result from the Table4A table (just one entry).

# Fields
- `sta::Int` -  station along bent
- `dist::Float64` - actual distance along bent
- `defl::Float64` - deflection of bent at station
- `moment::Float64` - moment of bent at station
- `shear::Float64` - sheat of bent at station
"""
Base.@kwdef struct DLResult
    sta::Int
    dist::Float64
    defl::Float64
    moment::Float64
    shear::Float64
end
function DLResult(line::String)
    DLResult(
        sta=parse(Int, line[1:9]),
        dist=parse(Float64, line[10:24]),
        defl=parse(Float64, line[25:43]),
        moment=parse(Float64, line[44:58]),
        shear=parse(Float64, line[59:73]),
    )
end

"""
    struct Table4A

Table4A of the Cap18 analysis results.

# Fields
- `results::Vector{DLResult}` -  collection of the dead load results from Table4A
"""
struct Table4A
    results::Vector{DLResult}
end

Table4A() = Table4A(DLResult[])

function parse_table4a(txt)::Table4A



end


