Base.@kwdef struct Table3
    num_lanes::Int
    num_stringers::Int
    num_supports::Int
    num_moment_points::Int
    num_shear_points::Int
    sta_lane_left::Vector{Float64}
    sta_lane_right::Vector{Float64}
    sta_stringers::Vector{Float64}
    sta_supports::Vector{Float64}
    sta_moment_points::Vector{Float64}
    sta_shear_points::Vector{Float64}
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
