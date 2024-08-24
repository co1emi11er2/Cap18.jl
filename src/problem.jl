struct Problem
    tb1::Table1
    tb2::Table2
    tb3::Table3
    tb4::Table4
    tb4a::Table4A
    tb5ws::Table5
    tb6ws::Table6
    tb7ws::Table7
    tb5lf::Table5
    tb6lf::Table6
    tb7lf::Table7
end

struct Problems
    prob::Vector{Problem}
end

Problems() = Problem[]

function get_num_problems(file)
    current_prob = ""
    num_prob = 0
    for line in file
        if startswith(line, " PROB")
            prob = line[1:12] # problem number
            if current_prob != prob
                num_prob += 1
                current_prob = prob
            end
        end
    end

    return num_prob
end
