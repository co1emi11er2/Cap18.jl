const hdr2_desc = raw"""

$Header Card 2 -----------------------------------------------------------------
$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  
"""

Base.@kwdef struct Header2
    description_80::String = "Bent Cap Analysis For XXXX"
end

function Base.write(h2::Header2, path=input_data_dir, hdr2_desc=hdr2_desc)
    # header 2 input length info. See cap18 user guide
    lengths = Dict(
        :description_80 => (1, 80),
    )
    # Init blank string of correct size
    hdr_txt = lpad("", 80)

    # replace parts of string for fields
    for field in fieldnames(Header2)
        start_index = lengths[field][1]
        end_index = lengths[field][2]
        txt = string(getproperty(h2, field))
        hdr_txt = change_string_by_slicing(hdr_txt, start_index, end_index, txt)
    end

    # write to cap18 input file
    open(path, "a") do io
        write(io, hdr2_desc)
    end

    open(path, "a") do io
        write(io, hdr_txt)
    end

end