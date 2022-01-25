using CitableCollection
using CitableBase
using CiteEXchange, CitableObject, CitableText
using CSV, TypedTables, Tables
using Test



include("test_collprop.jl")
include("test_utils.jl")
include("test_rawcollections.jl")
include("test_catentry.jl")
include("test_catalog.jl")
include("test_cataloged_collection.jl")


#=
Add tests for:

converttypes
columnnamesok

lazyread
strictread

istable
columns
rows
schema

=#