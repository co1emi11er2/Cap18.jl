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
    comment::String = ""
    sta_from::Union{Nothing, Int}
    sta_to::Union{Nothing, Int}
    contd::Int
    cap_bending_stiffness::Float64
    sidewalk_slab_loads::Float64
    stringer_cap_loads::Float64
    overlay_loads::Float64
    movable_position_slab_loads::Float64
end

function StiffnessLoadData(line::String)
    l_from = lstrip(line[1:10])
    l_to = lstrip(line[11:15])
    StiffnessLoadData(
        sta_from= l_from == "" ? nothing : parse(Int, l_from),
        sta_to= l_to == "" ? nothing : parse(Int, l_to),
        contd=parse(Int, line[16:20]),
        cap_bending_stiffness=parse(Float64, line[21:35]),
        sidewalk_slab_loads=parse(Float64, line[36:46]),
        stringer_cap_loads=parse(Float64, line[47:57]),
        overlay_loads=parse(Float64, line[58:68]),
        movable_position_slab_loads=parse(Float64, line[69:79]),
    )
end

function Base.write(sld::StiffnessLoadData, path=input_data_dir)
    # Stiffness Load Data input length info. See cap18 user guide
    input_info = Dict(
        :comment => (1, 15),
        :sta_from => (18, 20),
        :sta_to => (23, 25),
        :contd => (30, 30),
        :cap_bending_stiffness => (31, 40),
        :sidewalk_slab_loads => (41, 50),
        :stringer_cap_loads => (51, 60),
        :overlay_loads => (61, 70),
        :movable_position_slab_loads => (71, 80),
    )

    # get input line for cap 18 .dat file
    line_txt = get_input_line(sld, input_info, 80)

    # write to cap18 input file table 1 description
    open(path, "a") do io
        write(io, line_txt, "\n")
    end

end 

const tb4_desc = raw"""

$TABLE 4 - STIFFNESS AND LOAD DATA ---------------------------------------------
$                               Bending   Sidewalk,  Cap &              
$                Station  1 if  Stiffness  Slab     Stringer  Moving    Overlay
$Comments       From  To Cont'd  of Cap    Loads     Loads     Loads    Loads,DW
$XXXXXXXXXXXXXX  XXX  XXX    X XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX XXXXXXXXX
"""

struct Table4
    data::Vector{StiffnessLoadData}
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
                    push!(table4.data, stiff_load_data)
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

function Base.write(tb4::Table4, path=input_data_dir)
    # write Table 4 description
    open(path, "a") do io
        write(io, tb4_desc)
    end


    for data in tb4.data
        write(data, path)
    end

end 