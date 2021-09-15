# Build docs from root directory of repository:
#
#   julia --project=docs/ docs/make.jl
#
# Serve docs this repository root to serve:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")'julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions
using CitableCollection

makedocs(
    sitename = "CitableCollection.jl",
    pages = [
        "Overview" => "index.md"
    ]
    )

deploydocs(
    repo = "github.com/cite-architecture/CitableCollection.jl.git",
) 
