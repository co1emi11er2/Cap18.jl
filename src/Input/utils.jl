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