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

function parse_input(field::Vector, index_info::Tuple{Int64, Int64, Int64}, begin_line_txt)

    # determine interval for each entry in line
    start_index = index_info[1]
    end_index = index_info[2]
    txt_range = (end_index + 1) - start_index
    n_entries = index_info[3]
    interval::Int = txt_range/n_entries

    # line can't fit all values in field, see how many lines are needed
    n_lines::Int = ceil(length(field)/n_entries)
    final_txt = "" # init final text that will be returned
    start_field_index = 1

    # loop over each line for field value inputs
    for i = range(1, n_lines)
        # init field_piece to parse into line string
        end_field_index = min(length(field), i*n_entries)
        field_piece = field[start_field_index: end_field_index]

        # reinit start and end index and line_txt
        start_index = index_info[1]
        end_index = index_info[2]
        line_txt = begin_line_txt

        # parse input into new line string
        for value in field_piece
            end_index = start_index + interval - 1

            txt = parse_to_string(value)
            line_txt = change_string_by_slicing(line_txt, start_index, end_index, txt)

            start_index += interval
        end

        # if i = 1 do not add a new line
        final_txt *= i==1 ? line_txt : "\n" * line_txt
        start_field_index += n_entries
    end


    return final_txt
end
