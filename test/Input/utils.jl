import Cap18: change_string_by_slicing

# Replace string that is too short.
let 
    original_string = "     "
    idx1 = 1
    idx2 = 5
    sub_string = "0"
    expected = "    0"
    calc = change_string_by_slicing(original_string, idx1, idx2, sub_string)
    @test expected == calc
end

# when start and stop are the same
let 
    original_string = "     "
    idx1 = 5
    idx2 = 5
    sub_string = "0"
    expected = "    0"
    calc = change_string_by_slicing(original_string, idx1, idx2, sub_string)
    @test expected == calc
end

# Replace string that is correct size
let 
    original_string = "     "
    idx1 = 1
    idx2 = 5
    sub_string = "12345"
    expected = "12345"
    calc = change_string_by_slicing(original_string, idx1, idx2, sub_string)
    @test expected == calc
end

# Replace string that is too long
let 
    original_string = "     "
    idx1 = 1
    idx2 = 5
    sub_string = "123456"
    @test_throws(
        """
        \"123456\" is greater than 5 characters. 
        It must be equal to or less than this number.
        """,
        change_string_by_slicing(original_string, idx1, idx2, sub_string)
        )
end