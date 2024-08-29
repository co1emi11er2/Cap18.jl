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
