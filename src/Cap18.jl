# """
#     module Cap18

# This package can parse Cap18 analysis results. Cap18 is a program developed by TxDOT
# to analyze bridge bent caps. The program utilizes a discrete element model that produces 
# envelopes of maximum bending and shear forces acting on bridge bent caps. Analytical 
# results are for working stress and/or load factor design in accordance with the AASHTO LRFD 
# Bridge Design Specifications or the AASHTO Standard Specifications for Highway Bridges. 
# User input live loads are automatically placed within user defined lanes to generate maximum 
# forces at user specified points. A table of maximum reactions of each beam/girder/stringer 
# with concomitant reactions at all other beam/girder/stringers is optionally reported.
# """
module Cap18

export Header1, Header2, ProblemCard, Table1, Table2, Table3, Table4
export DLResult, Table4A, parse_cap18


# project directory
global const proj_dir = @__DIR__

# Input
include("Input/input.jl")
include("Input/utils.jl")
include("Input/header1.jl")
include("Input/header2.jl")
include("Input/problemcard.jl")


# Tables
include("table1.jl")
include("table2.jl")
include("table3.jl")
include("table4.jl")
include("table4a.jl")
include("table5.jl")
include("table6.jl")
include("table7.jl")

# Problem
include("problem.jl")

# parse
include("parse.jl")

end
