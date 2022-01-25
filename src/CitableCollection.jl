module CitableCollection
using CitableBase, CitableObject, CiteEXchange, CitableText
using CSV, Tables, HTTP
using TypedTables

using Documenter, DocStringExtensions

import Base: ==
import Base: show
import Base: length

import Base: iterate
import Base: length
import Base: eltype

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

import Tables: istable
import Tables: columns
import Tables: rows
import Tables: schema

include("collection_properties.jl")
include("collection_data_raw.jl")
include("collection_data_cooked.jl")
include("catalogentry.jl")
include("catalog.jl")
include("collection_cataloged.jl")

export PropertyDefinition
export citetype, authlist

export RawDataCollection

export CiteCatalogEntry
export CiteCollectionCatalog
export CatalogedCollection

end # module
