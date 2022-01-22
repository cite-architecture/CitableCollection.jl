using CitableCollection
using CitableBase
using CiteEXchange, CitableObject, CitableText
using CSV, TypedTables, Tables
using Test


include("test_collprop.jl")
include("test_utils.jl")
include("test_rawcollections.jl")

#=
Add tests for:

comparablehierarchy

converttypes
columnnamesok

lazyread
strictread

istable
columns
rows
schema

=#