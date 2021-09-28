module CitableCollection
using CitableObject
using CiteEXchange
using CitableBase

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

export CatalogedCollection 
export catalog

end # module
