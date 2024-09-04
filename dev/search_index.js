var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = Cap18","category":"page"},{"location":"#Cap18","page":"Home","title":"Cap18","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for Cap18.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [Cap18]","category":"page"},{"location":"#Cap18.DLResult","page":"Home","title":"Cap18.DLResult","text":"struct DLResult\n\nA result from the Table4A table (just one entry).\n\nFields\n\nsta::Int -  station along bent\ndist::Float64 - actual distance along bent\ndefl::Float64 - deflection of bent at station\nmoment::Float64 - moment of bent at station\nshear::Float64 - sheat of bent at station\n\n\n\n\n\n","category":"type"},{"location":"#Cap18.Envelopes","page":"Home","title":"Cap18.Envelopes","text":"struct Envelopes\n\nA result from Table6 table (just one entry). \n\nFields\n\nsta::Int - station along bent\ndist::Float64 - actual distance along bent\nmax_moment::Float64 - envelope of max positive moment\nmin_moment::Float64 - envelope of max negative moment\nmax_shear::Float64 - envelope of max positive shear\nmin_shear::Float64 - envelope of max negative shear\n\n\n\n\n\n","category":"type"},{"location":"#Cap18.Reactions","page":"Home","title":"Cap18.Reactions","text":"struct Reactions\n\nA result from Table7 table (just one entry). \n\nFields\n\nsta::Int - station along bent\ndist::Float64 - actual distance along bent\nmax_reaction::Float64 - maximum reaction at support\nmin_reaction::Float64 - minimum reaction at support\n\n\n\n\n\n","category":"type"},{"location":"#Cap18.StiffnessLoadData","page":"Home","title":"Cap18.StiffnessLoadData","text":"struct StiffnessLoadData\n\nA result from Table4 table (just one entry). Loads input as Cap and Stringer loads are  applied directly to the cap. Loads input as Slab and Sidewalk Loads and Moving Loads  are transmitted to the cap through the stringers, if any.  Concentrated overlay loads are  applied directly to the cap while distributed overlay loads are automatically transmitted  to the cap through the stringers. \n\nFields\n\nsta_from::Int - starting station\nsta_to::Int - ending station\ncontd::Int - \ncap_bending_stiffness::Float64 - bending stiffness of the cap\nsidewalk_slab_loads::Float64 - sidewalk load (transmitted through stringers)\nstringer_cap_loads::Float64 - stringer loads\noverlay_loads::Float64 - overlay loads\nmovable_position_slab_loads::Float64 - movable loads\n\n\n\n\n\n","category":"type"},{"location":"#Cap18.Table4A","page":"Home","title":"Cap18.Table4A","text":"struct Table4A\n\nTable4A of the Cap18 analysis results.\n\nFields\n\nresults::Vector{DLResult} -  collection of the dead load results from Table4A\n\n\n\n\n\n","category":"type"},{"location":"#Cap18.change_string_by_slicing-Tuple{AbstractString, Int64, Int64, AbstractString}","page":"Home","title":"Cap18.change_string_by_slicing","text":"change_string_by_slicing(original_string, start_index, end_index, new_substring)\n\nA function to change parts of a string by slicing. This returns a new string. It is strict. The start and ending index range of the string will be replaced with the same  number of characters. The function will error if more characters are given than the  range provided. It will fill the left side of the range with spaces if the substring is  smaller than the range provided.\n\nParameters\n\noriginal_string -  original string to modify   start_index - index where modification starts   end_index - index where modification ends   new_substring - substring which will be inserted into string  \n\n\n\n\n\n","category":"method"},{"location":"#Cap18.get_input_line-Union{Tuple{T}, Tuple{Any, Dict{Symbol, T}, Int64}} where T<:Tuple","page":"Home","title":"Cap18.get_input_line","text":"get_input_line(\nx::T, \ninput_info::Dict{Symbol, Tuple{Int64, Int64}}, \nn::Int) where T\n\nget_input_line(\nx::T, \ninput_info::Dict{Symbol, Tuple{Int64, Int64, Int64}}, \nn::Int) where T\n\nThis function takes a cap18 input struct, and outputs the line string for the .dat file that  the CAP18.exe file uses.\n\n\n\n\n\n","category":"method"},{"location":"#Cap18.parse_to_string-Tuple{Any}","page":"Home","title":"Cap18.parse_to_string","text":"parse_to_string(x) = string(x)\nparse_to_string(x::Bool) = string(convert(Int, x))\n\nParses an object type to a string type. For a boolean type, it parses as 1 or 0.\n\n\n\n\n\n","category":"method"}]
}
