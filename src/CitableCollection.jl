module CitableCollection
using CitableBase, CitableObject, CiteEXchange
using CSV, Tables
using TypedTables

using Documenter, DocStringExtensions

import Base:  print
import Base:  show
import Base:  ==

#=
import CitableBase: CitableTrait
import CitableBase: cex
import CitableBase: urn
import CitableBase: label
=#

include("collection_catalog.jl")
include("collection_properties.jl")
include("collection_data.jl")
#include("collection_library.jl")
#include("reader.jl")

#export CatalogedCollection
export CiteCollection
export PropertyDefinition
export CollectionLibrary
#export collectiondfs, catalogdf, collectionlibrary

end # module
