"""A collection of citable data.
$(SIGNATURES)
"""
struct RawDataCollection
    data::TypedTables.Table
end


"""Override `Base.show` for `RawDataCollection`.
$(SIGNATURES)
"""
function show(io::IO, coll::RawDataCollection)
    print(io,  "Citable collection of ", length(coll.data), " items with automatically inferred schema.")
end


"""Override `Base.==` for `RawDataCollection`.
$(SIGNATURES)
"""
function ==(c1::RawDataCollection, c2::RawDataCollection)
    c1.data == c2.data
end

"""Define singleton type for `CitableTrait` value."""
struct RawTableCitable <: CitableTrait end

"""Set `CitableTrait` for `RawDataCollection`.
$(SIGNATURES)
"""
function citabletrait(::Type{RawDataCollection})
    RawTableCitable()
end

"""Compute URN for entire collection.
$(SIGNATURES)
"""
function urn(rdc::RawDataCollection)
    rdc.data[1].urn |> dropobject
end

"""Define URN type for `RawDataCollection`.
$(SIGNATURES)
"""
function urntype(rdc::RawDataCollection)
    Cite2Urn
end

"""Label collection.
$(SIGNATURES)
"""
function label(rdc::RawDataCollection)
   string(rdc)
end





"""Define singleton type for `CexTrait`."""
struct RawDataCollectionCex <: CexTrait end

"""Assign `CexTrait` for `RawDataCollection`.
$(SIGNATURES)
"""
function cextrait(::Type{RawDataCollection})
    RawDataCollectionCex()
end

"""Instantiate a (possibly empty) list of `RawDataCollection`s from CEX source.
$(SIGNATURES)
If `strict` is `true`, then the types of the columns are set from reading
`citeproperties` entries for the collection; it is an error if the `citeproperties`
entries and the header of the `citedata` table do not agree.

If `strict` is `false`, a column named `urn` is convereted to `Cite2Urn` values,
and other columns are assigned types by `CSV.File`.
"""
function fromcex(traitvalue::RawDataCollectionCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)
    if strict
        @warn("Strict CEX reading not yet implemented")
        strictread(cexsrc,  delimiter)
    else
        @warn("Reading CEX data lazily")
        lazyread(cexsrc,delimiter) 
    end
end



"""Given a `Table` with a column named `urn` containing
string values, create a new table with the same data but with
the `urn` column converted to `Cite2Urn` values.
$(SIGNATURES)
"""
function citetable(t::Table)
    coldata = []
   for col in columnnames(t)
        if col == :urn 
            idrow = map(row -> Cite2Urn(row.urn), t)
            push!(coldata, idrow)
        else
            row = map(getproperty(col), t)
            push!(coldata, row)
        end
   end
   NamedTuple{columnnames(t)}(coldata) |> Table 
end


"""Read CITE collections from a CEX source without reference to
`citeproperties` configuration.
$(SIGNATURES)
Collections are assumed to have a field named `urn` that 
has the unique identifier for objects in the collection.
"""
function lazyread(cexsrc::AbstractString, delimiter = "|")
    datablocks = blocks(cexsrc, "citedata")
    datacollections = Table[]
    for blk in datablocks
        c = CSV.File(IOBuffer(join(blk.lines, "\n")), delim = delimiter)
        cdata = citetable(Table(c))
        push!(datacollections, cdata)
    end
    datacollections .|> RawDataCollection
end
