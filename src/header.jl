Base.@kwdef struct Header1
    file_num_5::Int = 1
    county_13::String = "___County____"
    hwy_num_6::Int = "Highwy"
    proj_num_4::Int = "Proj#"
    csj_11::String = "0000-00-000"
    coded_by_3::String = "BRG"
    date_12::String = ""
    comment_7::String = "Comment"
end

# Define a function to change parts of a string by slicing
function change_string_by_slicing(original_string, start_index, end_index, new_substring)
    # Slice the original string and replace the specified part with the new substring
    mod_string = original_string[1:start_index-1] * new_substring * original_string[end_index+1:end]
    return mod_string
end

function write_header1(h1::Header1)
    lengths = Dict(
        :file_num => (1, 5),
        :county => (8, 20),
        :hwy_num => (23, 28),
        :proj_num => (31, 34),
        :csj => (37, 47),
        :coded_by => (50, 52),
        :date => (55, 66),
        :comment => (68, 74),
    )

    hdr_txt = lpad("", 74)
    for field in fieldnames(Header1)
        start_index = lengths[field][1]
        end_index = lengths[field][2]
        n = end_index - start_index + 1
        txt = lpad(string(getproperty(h1, field)), n)
        hdr_txt = change_string_by_slicing(hdr_txt, start_index, end_index, txt)
        # if field == :file_num
        #     txt = txt * lpad(h1.field, n)
        # elseif field == :date
        #     txt = txt * " " * lpad(h1.field, n)
        # else
        #     txt = txt * "  " * lpad(h1.field, n)
        # end
    end
    return hdr_txt
end


Base.@kwdef struct Header2
    description
end

Base.@kwdef struct ProblemCard
    problem::String
    unit_system::Char
    description::String
end


