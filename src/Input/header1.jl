const hdr1_desc = raw"""
$Header Card 1 -----------------------------------------------------------------
$File                         Proj              User  Date (Today 
$ Num     County      Highway  Num     CSJ      Init     if Blank) Comment
$XXXX  XXXXXXXXXXXXX  XXXXXX  XXXX  XXXX-XX-XXX  XXX  XXXXXXXXXXXX XXXXXXX     
"""

Base.@kwdef struct Header1
    file_num_5::String = "00001"
    county_13::String = "___County____"
    hwy_num_6::String = "Highwy"
    proj_num_4::String = "Pro#"
    csj_11::String = "0000-00-000"
    coded_by_3::String = "BRG"
    date_12::String = ""
    comment_7::String = "Comment"
end

function Base.write(h1::Header1, path=input_data_dir, hdr1_desc=hdr1_desc)
    # header 1 input length info. See cap18 user guide
    lengths = Dict(
        :file_num_5 => (1, 5),
        :county_13 => (8, 20),
        :hwy_num_6 => (23, 28),
        :proj_num_4 => (31, 34),
        :csj_11 => (37, 47),
        :coded_by_3 => (50, 52),
        :date_12 => (55, 66),
        :comment_7 => (68, 74),
    )
    # Init blank string of correct size
    hdr_txt = lpad("", 74)

    # replace parts of string for fields
    for field in fieldnames(Header1)
        start_index = lengths[field][1]
        end_index = lengths[field][2]
        txt = string(getproperty(h1, field))
        hdr_txt = change_string_by_slicing(hdr_txt, start_index, end_index, txt)
    end

    # write to cap18 input file
    write(path, hdr1_desc)

    open(path, "a") do io
        write(io, hdr_txt)
    end

end


