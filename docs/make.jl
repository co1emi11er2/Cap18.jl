using Cap18
using Documenter

DocMeta.setdocmeta!(Cap18, :DocTestSetup, :(using Cap18); recursive=true)

makedocs(;
    modules=[Cap18],
    authors="Cole Miller",
    sitename="Cap18.jl",
    format=Documenter.HTML(;
        canonical="https://co1emi11er2.github.io/Cap18.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/co1emi11er2/Cap18.jl",
    devbranch="main",
)
