using Documenter
using OhMyThreads

const ci = get(ENV, "CI", "") == "true"

@info "Generating Documenter.jl site"
makedocs(;
    sitename = "OhMyThreads.jl",
    authors = "Carsten Bauer, Mason Protter",
    modules = [OhMyThreads],
    checkdocs = :exports,
    doctest = false,
    pages = [
        "OhMyThreads" => "index.md",
        # "Getting Started" => "examples/getting_started.md",
         "Examples" => [
             "Parallel Monte Carlo" => "examples/mc/mc.md",
             "Julia Set" => "examples/juliaset/juliaset.md",
         ],
        #  "Explanations" => [
        #      "B" => "explanations/B.md",
        #  ],
        "Translation Guide" => "translation.md",
        "References" => [
            "Public API" => "refs/api.md",
            "Internal" => "refs/internal.md",
        ],
    ],
    repo = "https://github.com/JuliaFolds2/OhMyThreads.jl/blob/{commit}{path}#{line}",
    format = Documenter.HTML(repolink = "https://github.com/JuliaFolds2/OhMyThreads.jl";
        collapselevel = 1))

if ci
    @info "Deploying documentation to GitHub"
    deploydocs(;
        repo = "github.com/JuliaFolds2/OhMyThreads.jl.git",
        devbranch = "master",
        push_preview = true,)
end
