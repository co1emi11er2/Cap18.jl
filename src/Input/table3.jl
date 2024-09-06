const tb3_desc_init = raw"""

$TABLE 3 - LIST OF STATIONS ----------------------------------------------------
$     Number of input values for                Str - Stringers, Sup - Supports
$                Lane Str  Sup  MCP  VCP        MCP - Moment Control Points
$                 XX   XX   XX   XX   XX        VCP - Shear Control Points
"""

const tb3_desc_left_lane = raw"""

$     Left Lane Boundary Stations
$                XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  
"""

const tb3_desc_right_lane = raw"""

$     Right Lane Boundary Stations
$                XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX
"""

const tb3_desc_stringers = raw"""

$     Station of Stringers (two rows max, may be at tenths of stations, XX.X)
$               XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX XXXX
"""

const tb3_desc_supports = raw"""

$     Station of Supports (two rows max)
$                XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX 
"""

const tb3_desc_mcp = raw"""

$     Moment Control Point Stations (two rows max)
$                XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX
"""

const tb3_desc_scp = raw"""

$     Shear Control Point Stations (two rows max)
$                XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX  XXX
"""

Base.@kwdef struct Table3
    num_lanes::Int
    num_stringers::Int
    num_supports::Int
    num_moment_points::Int
    num_shear_points::Int
    sta_lane_left::Vector{Int}
    sta_lane_right::Vector{Int}
    sta_stringers::Vector{Float64}
    sta_supports::Vector{Int}
    sta_moment_points::Vector{Int}
    sta_shear_points::Vector{Int}
end

function parse_table3(file, index, table1::Table1, problem, problems)
    in_table3 = true
    inputs = Any[]
    line = file[index]

    if table1.keep_table3_from_prev_prob == true
        table3 = problems[problem-1].tb3
        while in_table3 && index < length(file)
            line = file[index]
            if startswith(line, " TABLE 3")
                # println("in table 4A")
                in_table3 = false
                in_table4 = true
                return table3, index
            end
            index += 1
        end
    else
        index += 1
        line = file[index]
        in_table = true
        while in_table && index < length(file)
            if startswith(strip(line), "TOTAL")
                push!(inputs, parse.(Int, split(strip(line[19:end]), r"\s+"))...)
            elseif startswith(strip(line), "LANE LEFT")
                push!(inputs, parse.(Int, split(strip(line[19:end]), r"\s+")))
            elseif startswith(strip(line), "LANE RIGHT")
                push!(inputs, parse.(Int, split(strip(line[19:end]), r"\s+")))
            elseif startswith(strip(line), "STRINGERS")
                push!(inputs, parse.(Float64, split(strip(line[19:end]), r"\s+")))
            elseif startswith(strip(line), "SUPPORTS")
                push!(inputs, parse.(Int, split(strip(line[19:end]), r"\s+")))
            elseif startswith(strip(line), "MOM CONTR")
                push!(inputs, parse.(Int, split(strip(line[19:end]), r"\s+")))
            elseif startswith(strip(line), "SHEAR CONTR")
                push!(inputs, parse.(Int, split(strip(line[19:end]), r"\s+")))
            elseif startswith(strip(line), "TABLE 4")
                in_table = false
                continue
            end
            index += 1
            line = file[index]
        end
    end
    table3 = Table3(inputs...)
    return table3, index

end

function Base.write(tb3::Table3, path=input_data_dir)
    # header 1 input length info. See cap18 user guide
    input_info_init = Dict(
        :num_lanes => (19, 20),
        :num_stringers => (24, 25),
        :num_supports => (29, 30),
        :num_moment_points => (34, 35),
        :num_shear_points => (39, 40),
    )

    # Part init
    # get input line for cap 18 .dat file
    line_txt = get_input_line(tb3, input_info_init, 40)

    # write to cap18 input file table 1 description
    open(path, "a") do io
        write(io, tb3_desc_init, line_txt)
    end


    # (x, y, z) x and y are the start and end of position in the line of the .dat file
    # z is the number of inputs available in the x,y range
    # :mult_presence_factor is a vector, so z specifies how to separate the range in `z`
    # equal spaces
    input_info = (
        (:sta_lane_left, (16, 65, 10)),
        (:sta_lane_right, (16, 65, 10)),
        (:sta_stringers, (16, 65, 10)),
        (:sta_supports, (16, 65, 10)),
        (:sta_moment_points, (16, 65, 10)),
        (:sta_shear_points, (16, 65, 10)),
    )
    desc = [
        tb3_desc_left_lane,
        tb3_desc_right_lane,
        tb3_desc_stringers,
        tb3_desc_supports,
        tb3_desc_mcp,
        tb3_desc_scp,
    ]
    index = 1
    for (key, value) in input_info
        info = Dict(key => value)
        # get input line for cap 18 .dat file
        line_txt = get_input_line(tb3, info, 65)

        # write to cap18 input file table 1 description
        open(path, "a") do io
            write(io, desc[index], line_txt)
        end
        index += 1
    end




end