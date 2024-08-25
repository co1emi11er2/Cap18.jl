# Script to parse .lis file
# using DataFrames
# using Plots
# using PrettyTables

# project directory
global const proj_dir = @__DIR__
global const proj_cap18 = proj_dir * "/../t.lis"

# parsing keywords
function parse_cap18(path=proj_cap18)

    file = readlines(path)
    num_problems = get_num_problems(file)
    problems = Problems() # init Problems
    index = 1

    for problem in range(1, num_problems)

        before_table1 = true
        in_table1 = false
        in_table2 = false
        in_table3 = false
        in_table4 = false
        in_table4a = false
        in_table5ws = false
        in_table6ws = false
        in_table7ws = false
        in_table5lf = false
        in_table6lf = false
        in_table7lf = false

        # Initialize table structs
        table4a = Table4A()
        table5ws = Table5()
        table6ws = Table6()
        table7ws = Table7()
        table5lf = Table5()
        table6lf = Table6()
        table7lf = Table7()

        while before_table1 && index < length(file)
            line = file[index]
            if startswith(line, " TABLE 1")
                # println("in table 1")
                before_table1 = false
                in_table1 = true
                continue
            end
            index += 1
        end

        table1, index = parse_table1(file, index)
        in_table2 = true

        if table1.keep_table2_from_prev_prob == false
            table2, index = parse_table2(file, index)
            in_table3 = true
        else # otherwise use previous Table2 and iterate until Table 3
            table2 = problems[problem-1].tb2
            while in_table2 && index < length(file)
                line = file[index]
                if startswith(line, " TABLE 3")
                    # println("in table 4")
                    in_table2 = false
                    in_table3 = true
                    continue
                end
                index += 1
            end
        end

        if table1.keep_table3_from_prev_prob == false
            table3, index = parse_table3(file, index)
            in_table4 = true
        else # otherwise use previous Table3 and iterate until Table 4
            table3 = problems[problem-1].tb3
            while in_table3 && index < length(file)
                line = file[index]
                if startswith(line, " TABLE 4")
                    # println("in table 4")
                    in_table3 = false
                    in_table4 = true
                    continue
                end
                index += 1
            end
        end

        table4, index = parse_table4(file, index, table1, problem, problems)
        in_table4a = true

        while in_table4a && index < length(file)
            line = file[index]
            if startswith(line, " TABLE 4A")
                index += 5 # jump to start of table
                line = file[index]
                in_table = true
                
                while in_table && index < length(file)
                    if line == "\f"
                        in_table = false
                        continue
                    end
                    dl = DLResult(line)
                    push!(table4a.results, dl)
                    index += 1
                    line = file[index]
                end
            end

            if startswith(line, " TABLE 5")
                # println("in table 5ws")
                in_table4a = false
                in_table5ws = true
                continue
            end
            index += 1
        end

        while in_table5ws && index < length(file) #&& file[index][42:59] == "( WORKING STRESS )"
            line = file[index]
            if startswith(line, " TABLE 6")
                # println("in table 6ws")
                in_table5ws = false
                in_table6ws = true
                continue
            end
            index += 1
        end


        while in_table6ws && index < length(file)  #&& file[index][42:59] == "( WORKING STRESS )"
            line = file[index]
            if startswith(line, " TABLE 6")
                index += 6
                line = file[index]
                in_table = true

                while in_table && index < length(file)
                    if line == "\f"
                        in_table = false
                        continue
                    end
                    envelopes = Envelopes(line)
                    push!(table6ws.results, envelopes)
                    index += 1
                    line = file[index]
                end
            end

            if startswith(line, " TABLE 7")
                # println("in table 7ws")
                in_table6ws = false
                in_table7ws = true
                continue
            end
            index += 1
        end

        while in_table7ws && index < length(file)  #&& file[index][40:57] == "( WORKING STRESS )"
            line = file[index]
            if startswith(line, " TABLE 7")
                index += 6
                line = file[index]
                in_table = true

                while in_table && index < length(file)
                    if line == "\f"
                        in_table = false
                        continue
                    end
                    reactions = Reactions(line)
                    push!(table7ws.results, reactions)
                    index += 1
                    line = file[index]
                end
            end

            if startswith(line, " TABLE 5")
                in_table7ws = false
                in_table5lf = true
                continue
            end
            index += 1
        end

        while in_table5lf && index < length(file) #&& file[index][42:55] == "( LOAD FACTOR)"
            line = file[index]
            if startswith(line, " TABLE 6")
                in_table5lf = false
                in_table6lf = true
                continue
            end
            index += 1
        end

        while in_table6lf && index < length(file)  #&& file[index][42:56] == "( LOAD FACTOR )"
            line = file[index]
            if startswith(line, " TABLE 6")
                index += 6
                line = file[index]
                in_table = true

                while in_table && index < length(file)
                    if line == "\f"
                        in_table = false
                        continue
                    end
                    envelopes = Envelopes(line)
                    push!(table6lf.results, envelopes)
                    index += 1
                    line = file[index]
                end
            end

            if startswith(line, " TABLE 7")
                in_table6lf = false
                in_table7lf = true
                continue
            end
            index += 1
        end

        while in_table7lf && index < length(file)  #&& file[index][40:54] == "( WORKING STRESS )"
            line = file[index]
            if startswith(line, " TABLE 7")
                index += 6
                line = file[index]
                in_table = true

                while in_table && index < length(file)
                    if line == "\f"
                        in_table = false
                        continue
                    end
                    reactions = Reactions(line)
                    push!(table7lf.results, reactions)
                    index += 1
                    line = file[index]
                end
            end

            if startswith(line, " PROB") #TODO: FIXX!!!
                in_table7lf = false
                before_table1 = true
                continue
            end
            index += 1
        end

        prob = Problem(
            table1,
            table2,
            table3,
            table4,
            table4a,
            table5ws,
            table6ws,
            table7ws,
            table5lf,
            table6lf,
            table7lf
        )
        push!(problems, prob)
        
    end
    return problems
end

# function get_parse_func(line::String)
#     if startswith(line, " TABLE 1")
#         return parse_table1_line
#     elseif startswith(line, " TABLE 2")
#         return parse_table2_line
#     elseif startswith(line, " TABLE 3")
#         return parse_table3_line
#     elseif startswith(line, " TABLE 4A")
#         return parse_table4a_line
#     elseif startswith(line, " TABLE 4")
#         return parse_table4_line
#     elseif startswith(line, " TABLE 5")
#         return parse_table3_line


# function parse_cap18_2(path=proj_cap18)
#     cap_18_output = eachline(path)

#     # initialize problem variable
#     current_prob = ""
#     problems = Problem[]

#     # initialize table 
#     in_table = false

#     tables = Dict{Symbol, Any}(
#         :tb1 => undef,
#         :tb2 => undef,
#         :tb3 => undef,
#         :tb4 => undef,
#         :tb4a => undef,
#         :tb5ws => undef,
#         :tb6ws => undef,
#         :tb7ws => undef,
#         :tb5lf => undef,
#         :tb6lf => undef,
#         :tb7lf => undef,
#     )

#     for line in cap_18_output

#         if startswith(line, " PROB")
#             # check if in new problem
#             prob = line[1:12] # potential new problem number
#             if current_prob != prob
#                 if current_prob != "" # skip if first problem
#                     p = Problem(tables...) # create new problem from parsed data
#                     push!(problems, ) # add problem to problems
#                 end
#                 current_prob = prob
#             end
#         elseif startswith(line, " TABLE") 
#             in_table = true
#             func = get_parse_func(line)
#         elseif in_table
#             obj = func(line)
#             objs = 






    
# end