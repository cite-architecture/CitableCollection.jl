"""A collection of citable data.
$(SIGNATURES)
"""
struct CiteCollection
    data::TypedTables.Table
end

"""Define singleton type for `CexTrait`."""
struct CiteCollectionCex <: CexTrait end

"""Assign `CexTrait` for `CiteCollection`.
$(SIGNATURES)
"""
function cextrait(::Type{CiteCollection})
    CiteCollectionCex()
end

function fromcex(traitvalue::CiteCollectionCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)
    if strict
        @warn("Strict CEX reading not yet implemented")
        strictread(cexsrc,  delimiter)
    else
        @warn("Reading CEX data lazily")
        lazyread(cexsrc,delimiter)
    end
end


function strictread(cexsrc::AbstractString, delimiter = "|")
    lazyread(cexsrc, delimiter)
end


"""
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
    datacollections = []
    for blk in datablocks
        c = CSV.File(IOBuffer(join(blk.lines, "\n")), delim = delimiter)
        cdata = citetable(Table(c))
        push!(datacollections, cdata)
    end
    length(datacollections) == 1 ? datacollections : datacollections |> Iterators.flatten |> collect
end
