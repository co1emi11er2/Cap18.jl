const tb1_desc = raw"""

$TABLE 1 - CONTROL DATA --------------------------------------------------------
$                Enter 1 to keep:       Number cards   Options:
$                 Env Tab2 Tab3 Tab4    on Table 4  Envelope  Print   Skew Angle
$                  X    X    X    X             XX    X        XX     XXXXXXXXXX   
"""

Base.@kwdef struct Table1
    srs_option::Bool=false
    keep_env_from_prev_prob::Bool=false
    keep_table2_from_prev_prob::Bool=false
    keep_table3_from_prev_prob::Bool=false
    keep_table4_from_prev_prob::Bool=false
    card_inputs::Int
    clear_envelopes_before_lane_loading::Bool=false
    print_option::Int
    skew::Float64
end

function parse_table1(file, index)
    
    inputs = Any[]
    line = file[index]
    if startswith(line, " TABLE 1")
        index += 1
        line = file[index]
        in_table = true
        while in_table && index < length(file)
            if startswith(strip(line), "OPTION TO PRINT TABLE SRS (1=YES)")
                push!(inputs, parse(Bool, line[76]))
            elseif startswith(strip(line), "KEEP FROM PRECEDING PROBLEM (1=YES)")
                push!(inputs,
                [
                    parse(Bool, line[58]), 
                    parse(Bool,line[66]), 
                    parse(Bool,line[71]), 
                    parse(Bool,line[76])
                ]...)
            elseif startswith(strip(line), "CARDS INPUT THIS PROBLEM")
                push!(inputs, parse(Int, line[60:76]))
            elseif startswith(strip(line), "OPTION TO CLEAR ENVELOPES BEFORE LANE LOADINGS")
                push!(inputs, parse(Bool, line[76]))
            elseif startswith(strip(line), "-1(4A), -2(5) -3(4A,5), -4(4A,5,6), -5(4A,5,6,7)")
                push!(inputs, parse(Int, line[60:end]))
            elseif startswith(strip(line), "SKEW ANGLE, DEGREES")
                push!(inputs, parse(Float64, line[60:end]))
            elseif startswith(strip(line), "TABLE 2")
                in_table = false
                continue
            end
            index += 1
            line = file[index]
        end
    end
 
    table1 = Table1(inputs...)
    return table1, index

end

function Base.write(tb1::Table1, path=input_data_dir, hdr1_desc=hdr1_desc)
    # header 1 input length info. See cap18 user guide
    input_info = Dict(
        :srs_option => (14, 15),
        :keep_env_from_prev_prob => (20, 20),
        :keep_table2_from_prev_prob => (25, 25),
        :keep_table3_from_prev_prob => (30, 30),
        :keep_table4_from_prev_prob => (35, 35),
        :card_inputs => (49, 50),
        :clear_envelopes_before_lane_loading => (55, 55),
        :print_option => (64, 65),
        :skew => (71, 80),
    )
    # get input line for cap 18 .dat file
    line_txt = get_input_line(tb1, input_info, 80)

    # write to cap18 input file table 1 description
    open(path, "a") do io
        write(io, tb1_desc)
    end

    # write cap18 input line for table 1
    open(path, "a") do io
        write(io, line_txt)
    end

end