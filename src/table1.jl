Base.@kwdef struct Table1
    srs_option::Bool
    keep_env_from_prev_prob::Bool
    keep_table2_from_prev_prob::Bool
    keep_table3_from_prev_prob::Bool
    keep_table4_from_prev_prob::Bool
    card_inputs::Int
    clear_envelopes_before_lane_loading::Bool
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
    @show inputs
    table1 = Table1(inputs...)
    return table1, index

end