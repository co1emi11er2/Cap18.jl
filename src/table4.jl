"""
    struct StiffnessLoadData

A result from Table4 table (just one entry). Loads input as Cap and Stringer loads are 
applied directly to the cap. Loads input as Slab and Sidewalk Loads and Moving Loads 
are transmitted to the cap through the stringers, if any.  Concentrated overlay loads are 
applied directly to the cap while distributed overlay loads are automatically transmitted 
to the cap through the stringers. 

# Fields
- `sta_from::Int` - starting station
- `sta_to::Int` - ending station
- `contd::Int` - 
- `cap_bending_stiffness::Float64` - bending stiffness of the cap
- `sidewalk_slab_loads::Float64` - sidewalk load (transmitted through stringers)
- `stringer_cap_loads::Float64` - stringer loads
- `overlay_loads::Float64` - overlay loads
- `movable_position_slab_loads::Float64` - movable loads
"""
Base.@kwdef struct StiffnessLoadData
    sta_from::Int
    sta_to::Int
    contd::Int
    cap_bending_stiffness::Float64
    sidewalk_slab_loads::Float64
    stringer_cap_loads::Float64
    overlay_loads::Float64
    movable_position_slab_loads::Float64
end

function StiffnessLoadData(line::String)
    StiffnessLoadData(
        sta_from=parse(Int, line[1:10]),
        sta_to=parse(Int, line[11:15]),
        contd=parse(Int, line[16:20]),
        cap_bending_stiffness=parse(Float64, line[21:35]),
        sidewalk_slab_loads=parse(Float64, line[36:46]),
        stringer_cap_loads=parse(Float64, line[47:57]),
        overlay_loads=parse(Float64, line[58:68]),
        movable_position_slab_loads=parse(Float64, line[69:79]),
    )
end

struct Table4
    results::Vector{StiffnessLoadData}
end

Table4() = Table4(StiffnessLoadData[])

function parse_table4(file, index, table1::Table1, problem, problems)
    in_table4 = true
    table4 = Table4()

    if table1.keep_table4_from_prev_prob == true
        table4 = problems[problem-1].tb4
        while in_table4 && index < length(file)
            line = file[index]
            if startswith(line, " TABLE 4A")
                # println("in table 4A")
                in_table4 = false
                in_table4a = true
                continue
            end
            index +=1
        end
    else
        while in_table4 && index < length(file)
            line = file[index]
            if startswith(line, " TABLE 4.")
                index += 8
                line = file[index]
                in_table = true

                while in_table && index < length(file)
                    if line == "\f"
                        in_table = false
                        continue
                    end
                    stiff_load_data = StiffnessLoadData(line)
                    push!(table4.results, stiff_load_data)
                    index += 1
                    line = file[index]
                end
            end
            if startswith(line, " TABLE 4A")
                # println("in table 4A")
                in_table4 = false
                continue
            end
            index += 1
        end
    end

    return table4, index
end