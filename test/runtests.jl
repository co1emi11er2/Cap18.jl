using TestItems, TestItemRunner
@testitem "Table4A" begin
    include("table4a.jl")
end

@testitem "Table4" begin
    include("table4.jl")
end

@run_package_tests verbose=true