const pc_desc = raw"""

$Problem Card ------------------------------------------------------------------
$Prob E   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX   
"""

Base.@kwdef struct ProblemCard
    problem_num_5::String
    unit_system_1::Char
    description_65::String
end

function Base.write(pc::ProblemCard, path=input_data_dir, pc_desc=pc_desc)
    # header 2 input length info. See cap18 user guide
    lengths = Dict(
        :problem_num_5 => (1, 5),
        :unit_system_1 => (7, 7),
        :description_65 => (11, 75),
    )
    # Init blank string of correct size
    hdr_txt = lpad("", 75)

    # replace parts of string for fields
    for field in fieldnames(ProblemCard)
        start_index = lengths[field][1]
        end_index = lengths[field][2]
        txt = string(getproperty(pc, field))
        hdr_txt = change_string_by_slicing(hdr_txt, start_index, end_index, txt)
    end

    # write to cap18 input file
    open(path, "a") do io
        write(io, pc_desc)
    end

    open(path, "a") do io
        write(io, hdr_txt)
    end

end