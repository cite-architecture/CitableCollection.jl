module CitableCollection
using CitableBase, CitableObject, CiteEXchange
using CSV, DataFrames

using Documenter, DocStringExtensions

import Base:  print
import Base:  show
import Base:  ==

import CitableBase: cex
import CitableBase: urn
import CitableBase: label


include("collection.jl")
include("collection_properties.jl")
include("reader.jl")

export CatalogedCollection, PropertyConfiguration
export collectiondf

end # module
