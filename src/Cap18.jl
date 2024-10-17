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

using RecipesBase

# export input structs
export Header1, Header2, ProblemCard, Table1, Table2, Table3, Table4, StiffnessLoadData
export run_cap18

# export parsed structs
export parse_cap18

# export analysis portion
export deflections, moments, shears, moment_envelopes, shear_envelopes
export max_moments, min_moments, max_shears, min_shears


# project directory
global const proj_dir = @__DIR__
global const input_data_dir = proj_dir * "/../data/temp/t.dat"

# Input
include("Input/utils.jl")
include("Input/header1.jl")
include("Input/header2.jl")
include("Input/problemcard.jl")
include("Input/table1.jl")
include("Input/table2.jl")
include("Input/table3.jl")
include("Input/table4.jl")
include("Input/run.jl")


# Parse
include("Parse/table4a.jl")
include("Parse/table5.jl")
include("Parse/table6.jl")
include("Parse/table7.jl")
include("Parse/problem.jl")
include("Parse/parse.jl")

# Analyze
include("Analyze/Deflections.jl")
include("Analyze/Moments.jl")
include("Analyze/Shears.jl")

end
