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

export DLResult, Table4A, parse_cap18

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
