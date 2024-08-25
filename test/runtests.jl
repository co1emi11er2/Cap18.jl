using TestItems, TestItemRunner

if isdefined(@__MODULE__,:LanguageServer)
    include("../src/Cap18.jl")
end
@testitem "Table4A" begin
    include("table4a.jl")
end

@testitem "Table4" begin
    include("table4.jl")
end

@testitem "Parse" begin
    include("parse.jl")
end

@run_package_tests verbose=true