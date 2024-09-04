"""
    change_string_by_slicing(original_string, start_index, end_index, new_substring)

A function to change parts of a string by slicing. This returns a new string. It is
strict. The start and ending index range of the string will be replaced with the same 
number of characters. The function will error if more characters are given than the 
range provided. It will fill the left side of the range with spaces if the substring is 
smaller than the range provided.

# Parameters
`original_string` -  original string to modify  
`start_index` - index where modification starts  
`end_index` - index where modification ends  
`new_substring` - substring which will be inserted into string  
"""
function change_string_by_slicing(
    original_string::AbstractString, 
    start_index::Int, 
    end_index::Int, 
    new_substring::AbstractString)

    # Slice the original string and replace the specified part with the new substring
    n = end_index - start_index + 1
    new_substring = lpad(new_substring, n)
    if length(new_substring) > n
        error("""
        \"$new_substring\" is greater than $n characters. 
        It must be equal to or less than this number.
        """)
    end

    mod_string = original_string[1:start_index-1] * new_substring * original_string[end_index+1:end]
    return mod_string
end

"""
    parse_to_string(x) = string(x)
    parse_to_string(x::Bool) = string(convert(Int, x))

Parses an object type to a string type. For a boolean type, it parses as 1 or 0.
"""
parse_to_string(x) = string(x)
parse_to_string(x::Bool) = string(convert(Int, x))
# parse_to_string(x, n) = string(x)
# parse_to_string(x::Bool) = string(convert(Int, x))

# function parse_to_string(x, n)


"""
    get_input_line(
    x::T, 
    input_info::Dict{Symbol, Tuple{Int64, Int64}}, 
    n::Int) where T

    get_input_line(
    x::T, 
    input_info::Dict{Symbol, Tuple{Int64, Int64, Int64}}, 
    n::Int) where T

This function takes a cap18 input struct, and outputs the line string for the .dat file that 
the CAP18.exe file uses.
"""
function get_input_line(
    x, 
    input_info::Dict{Symbol, T}, 
    n::Int) where T <: Tuple

    # Init blank string of correct size
    line_txt = lpad("", n)

    # replace parts of string for fields
    for key in keys(input_info)
        index_info = input_info[key]
        field = getproperty(x, key)
        line_txt = parse_input(field, index_info, line_txt)
    end

    return line_txt

end

function parse_input(field, index_info::Tuple{Int64, Int64}, line_txt)
    start_index = index_info[1]
    end_index = index_info[2]
    txt = parse_to_string(field)
    line_txt = change_string_by_slicing(line_txt, start_index, end_index, txt)

    return line_txt
end

function parse_input(field::Vector, index_info::Tuple{Int64, Int64, Int64}, line_txt)
    start_index = index_info[1]
    end_index = index_info[2]
    txt_range = (end_index + 1) - start_index
    n_entries = index_info[3]
    interval::Int = txt_range/n_entries

    for value in field
        end_index = start_index + interval - 1

        txt = parse_to_string(value)
        line_txt = change_string_by_slicing(line_txt, start_index, end_index, txt)

        start_index += interval
    end

    return line_txt
end

# function get_input_line(
#     x::T, 
#     input_info::Dict{Symbol, Tuple{Int64, Int64, Int64}}, 
#     n::Int) where T

#     # Init blank string of correct size
#     line_txt = lpad("", n)

#     # replace parts of string for fields
#     for key in keys(input_info)
#         if input_info[key][3] == 1
#             start_index = input_info[key][1]
#             end_index = input_info[key][2]
#             txt = parse_to_string(getproperty(x, key))
#             line_txt = change_string_by_slicing(line_txt, start_index, end_index, txt)
#         else
#             start_index = input_info[key][1]
#             end_index = input_info[key][2]
#             n_entries = input_info[key][3]

#         end
#         end

#     return line_txt

# end

