# Script to parse .lis file
using DataFrames
using Plots
using PrettyTables
# function parse_cap18(path)
path = "t.lis"
file = readlines(path)
num_problems = get_num_problems(file)
problems = Problems(Vector{Problem}(undef, num_problems)) # init Problems

for problem in range(1, 1)
    index = 1
    before_table1 = true
    in_table1 = false
    in_table2 = false
    in_table3 = false
    in_table4 = false
    in_table4a = false
    in_table5 = false
    in_table6 = false
    in_table7 = false
    table4a = Table4A()

    while before_table1 && index < 1500
        line = file[index]
        if startswith(line, " TABLE 1")
            before_table1 = false
            in_table1 = true
            continue
        end
        index += 1
    end

    while in_table1 && index < 1500
        line = file[index]
        if startswith(line, " TABLE 2")
            table1 = Table1()
            in_table1 = false
            in_table2 = true
            continue
        end
        index += 1
    end

    while in_table2 && index < 1500
        line = file[index]
        if startswith(line, " TABLE 3")
            table2 = Table2()
            in_table2 = false
            in_table3 = true
            continue
        end
        index += 1
    end

    while in_table3 && index < 1500
        line = file[index]
        if startswith(line, " TABLE 4")
            table3 = Table3()
            in_table3 = false
            in_table4 = true
            continue
        end
        index += 1
    end

    while in_table4 && index < 1500
        line = file[index]
        if startswith(line, " TABLE 4A")
            table4 = Table4()
            in_table4 = false
            in_table4a = true
            continue
        end
        index += 1
    end

    while in_table4a && index < 1500
        line = file[index]
        if startswith(line, " TABLE 4A")
            index += 5 # jump to start of table
            line = file[index]
            in_table = true
            
            while in_table && index < 1500
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
            in_table4a = false
            in_table5 = true
            continue
        end
        index += 1
    end

    while in_table5 && index < 1500 #TODO: It repeats.. need to redo logic after table 5
        line = file[index]
        if startswith(line, " TABLE 6")
            table5 = Table5()
            in_table5 = false
            in_table6 = true
            continue
        end
        index += 1
    end

    while in_table6 && index < 1500 #TODO: It repeats.. need to redo logic after table 6
        line = file[index]
        if startswith(line, " TABLE 7")
            table6 = Table6()
            in_table6 = false
            in_table7 = true
            continue
        end
        index += 1
    end

    while in_table7 && index < 1500 #TODO: It repeats.. need to redo logic after table 7
        line = file[index]
        if startswith(line, " PROB   2") #TODO: FIXX!!!
            table6 = Table7()
            in_table7 = false
            continue
        end
        index += 1
    end

    # problem.tb1 = table1
    # problem.tb2 = table2
    # problem.tb3 = table3
    # problem.tb4 = table4
    # problem.tb4a = table4a
    # problem.tb5 = table5
    # problem.tb6 = table6
    # problem.tb7 = table7
    global df = DataFrame(table4a.results)
    
    plot(df.dist, df.moment)

end

# end