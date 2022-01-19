module CitableCollection
using CitableBase, CitableObject, CiteEXchange, CitableText
using CSV, Tables, HTTP
using TypedTables

using Documenter, DocStringExtensions

import Base: ==

import CitableBase: citabletrait
import CitableBase: urntype
import CitableBase: urn
import CitableBase: label

import CitableBase: urncomparisontrait
import CitableBase: urnequals
import CitableBase: urncontains
import CitableBase: urnsimilar

import CitableBase: cextrait
import CitableBase: cex
import CitableBase: fromcex

include("collection_properties.jl")
include("collection_data.jl")


#include("collection_catalog.jl")
#
#include("collection_library.jl")
#include("reader.jl")

export PropertyDefinition
export citetype, authlist

export CiteCollection


#export CatalogedCollection

#export CollectionLibrary
#export collectiondfs, catalogdf, collectionlibrary

end # module
