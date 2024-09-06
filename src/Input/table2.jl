const tb2_desc_a = raw"""

$TABLE 2 - CONSTANTS -----------------------------------------------------------
$   TABLE 2a                                              Anly Opt (1=Working,
$                                  |-Movable Load Data--|  2=Load Factor,3=Both)
$                Num  Increment    |Num  Start Stop Step|Anly|  Load Factors:
$                Inc   Length      |Inc  Sta   Sta  Size| Opt| Dead     Live
$                 XX XXXXXXXXX       XXX  XXX  XXX    X    X XXXXXXXX XXXXXXXX 
"""

const tb2_desc_b = raw"""

$   TABLE 2b
$    Overlay    Max #|-----------Live Load Reduction Factors---------|
$  Load Factor  Lanes| 1 lane   2 lanes	  3 lanes   4 lanes   5 lanes  
$    XXXXX         X      XXXX      XXXX      XXXX      XXXX      XXXX
"""

Base.@kwdef struct Table2
    num_increments_slab::Int
    increment_length::Float64
    num_total_increments_moving::Int
    mov_start_sta::Int
    mov_end_sta::Int
    num_btwn_increments_moving::Int
    analysis_option::Int
    dl_factor::Float64
    overlay_factor::Float64
    ll_factor::Float64
    max_lanes_loaded::Int
    mult_presence_factor::Vector{Float64}
end

function parse_table2(file, index, table1::Table1, problem, problems)
    in_table2 = true
    inputs = Any[]
    line = file[index]
    if table1.keep_table2_from_prev_prob == true
        table2 = problems[problem-1].tb2
        while in_table2 && index < length(file)
            line = file[index]
            if startswith(line, " TABLE 3")
                # println("in table 4A")
                in_table2 = false
                in_table3 = true
                return table2, index
            end
            index += 1
        end
    else
        index += 1
        line = file[index]
        in_table = true
        while in_table && index < length(file)
            if startswith(strip(line), "NUMBER OF INCREMENTS FOR SLAB AND CAP")
                push!(inputs, parse(Int, line[60:end]))
            elseif startswith(strip(line), "INCREMENT LENGTH, FT")
                push!(inputs, parse(Float64, line[60:end]))
            elseif startswith(strip(line), "NUMBER OF INCREMENTS FOR MOVABLE LOAD")
                push!(inputs, parse(Int, line[60:end]))
            elseif startswith(strip(line), "START POSITION OF MOVABLE-LOAD STA ZERO")
                push!(inputs, parse(Int, line[60:end]))
            elseif startswith(strip(line), "STOP POSITION OF MOVABLE-LOAD STA ZERO")
                push!(inputs, parse(Int, line[60:end]))
            elseif startswith(strip(line), "NUMBER OF INCREMENTS BETWEEN EACH POSITION")
                push!(inputs, parse(Int, line[65:end]))
            elseif startswith(strip(line), "ANALYSIS OPTION")
                push!(inputs, parse(Int, line[65:end]))
            elseif startswith(strip(line), "LOAD FACTOR FOR DEAD LOAD")
                push!(inputs, parse(Float64, line[60:end]))
            elseif startswith(strip(line), "LOAD FACTOR FOR OVERLAY LOAD")
                push!(inputs, parse(Float64, line[60:end]))
            elseif startswith(strip(line), "LOAD FACTOR FOR LIVE LOAD")
                push!(inputs, parse(Float64, line[60:end]))
            elseif startswith(strip(line), "MAXIMUM NUMBER OF LANES TO BE LOADED")
                push!(inputs, parse(Int, line[60:end]))
            elseif startswith(strip(line), "LIST OF LOAD COEFFICIENTS CORRESPONDING")
                index += 2
                line = file[index]
                push!(inputs, parse.(Float64, split(strip(line), r"\s+")))
            elseif startswith(strip(line), "TABLE 3")
                in_table = false
                continue
            end
            index += 1
            line = file[index]
        end
    end

    table2 = Table2(inputs...)
    return table2, index

end


function Base.write(tb2::Table2, path=input_data_dir, tb2_desc_a=tb2_desc_a, tb2_desc_b=tb2_desc_b)
    # header 1 input length info. See cap18 user guide
    input_info_a = Dict(
        :num_increments_slab => (18, 20),
        :increment_length => (22, 30),
        :num_total_increments_moving => (38, 40),
        :mov_start_sta => (42, 45),
        :mov_end_sta => (48, 50),
        :num_btwn_increments_moving => (55, 55),
        :analysis_option => (60, 60),
        :dl_factor => (62, 69),
        :ll_factor => (71, 78),
    )

    # (x, y, z) x and y are the start and end of position in the line of the .dat file
    # z is the number of inputs available in the x,y range
    # :mult_presence_factor is a vector, so z specifies how to separate the range in `z`
    # equal spaces
    input_info_b = Dict(
        :overlay_factor => (6, 10),
        :max_lanes_loaded => (20, 20),
        :mult_presence_factor => (21, 70, 5),
    )

    # Part a
    # get input line for cap 18 .dat file
    line_txt = get_input_line(tb2, input_info_a, 78)

    # write to cap18 input file table 1 description
    open(path, "a") do io
        write(io, tb2_desc_a, line_txt)
    end

    # Part b
    # get input line for cap 18 .dat file
    line_txt = get_input_line(tb2, input_info_b, 70)

    # write to cap18 input file table 1 description
    open(path, "a") do io
        write(io, tb2_desc_b, line_txt)
    end

end