"""A collection of citable data.

The collection is itself a citable object.  In addition,
it contains a table of citable objects represented as a `TypedTables.Table`.
"""
struct RawDataCollection
    data::TypedTables.Table
    label::AbstractString
    propertydefinitions::Vector{PropertyDefinition}
end

"""Compose `PropertyDefinition`s for a table.
$(SIGNATURES)
"""
function propertydefinitions(t::Table)
    sch = Tables.schema(t)
    props = PropertyDefinition[]
    count = 0
    for n in sch.names
        count = count + 1
        propname = string(n)
        proplabel = "Property $(propname)"
        proptype = sch.types[count]
        push!(props, PropertyDefinition(propname, proplabel, proptype, []) )
        #string(n) * ": " * CitableCollection.cpropfortype(sch.types[count]))
    end
    props
end

"""Create a `RawDataCollection` from a `Table`
by generating label and properties automatically.
$(SIGNATURES)
"""
function rawdatacollection(t::TypedTables.Table)
    label = string("Citable collection of ", length(t), " items with automatically inferred schema.")
    RawDataCollection(t, label, propertydefinitions(t))
end

"""Override `Base.show` for `RawDataCollection`.
$(SIGNATURES)
"""
function show(io::IO, coll::RawDataCollection)
    print(io,  coll.label)
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

"""Implement `istable` for `RawDataCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function istable(rdc::RawDataCollection)
    true
end

"""Implement `columns` for `RawDataCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function columns(rdc::RawDataCollection)
    columns(rdc.data)
end

"""Implement `rows` for `RawDataCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function rows(rdc::RawDataCollection)
    rows(rdc.data)
end


"""Implement `schema` for `RawDataCollection`.
$(SIGNATURES)
"""
function schema(rdc::RawDataCollection)
    schema(rdc.data)
end

"""Implement `length` for `RawDataCollection`.
$(SIGNATURES)
"""
function length(rdc::RawDataCollection)
    length(rdc.data)
end

"""Implement `eltype` for `RawDataCollection`.
$(SIGNATURES)
"""
function eltype(rdc::RawDataCollection)
    eltype(rdc.data)
end


"""Define singleton type for `CexTrait`."""
struct RawDataCollectionCex <: CexTrait end

"""Assign `CexTrait` for `RawDataCollection`.
$(SIGNATURES)
"""
function cextrait(::Type{RawDataCollection})
    RawDataCollectionCex()
end

"""Compose delimited text representation of `rdc`.
$(SIGNATURES)
"""
function cex(rdc::RawDataCollection; delimiter = "|")
    # Do a cite properties section
    proplines = ["#!citeproperties",
        join(["Property", "Label", "Type", "Authority list"], delimiter)
    ]
    for p in rdc.propertydefinitions
        push!(proplines, cex(p))
    end

    # Do a citedata section
    sch = Tables.schema(rdc)
    datalines = [
        "#!citedata",
        join(sch.names .|> string |> collect, delimiter)
        ]
    for row in Tables.rows(rdc)
        rowdata = []
        for n in sch.names
            push!(rowdata, row[n])
        end
        push!(datalines, join(rowdata, delimiter))
    end
    @debug("Generating cex for rawdatacollection with property block", join(proplines, "\n"))
    join(proplines, "\n") * "\n\n" *  join(datalines, "\n")
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
        strictread(cexsrc,  delimiter)
    else
        @warn("Reading CEX data lazily")
        lazyread(cexsrc, delimiter) 
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
        colnames = split(blk.lines[1] |> lowercase , delimiter) .|> Symbol

        c = CSV.File(IOBuffer(join(blk.lines, "\n")), delim = delimiter, skipto = 2, header = colnames)
        cdata = citetable(Table(c))
        push!(datacollections, cdata)
    end
    datacollections .|> rawdatacollection
end

"""Define initial iteration of a `RawDataCollection`.
#(SIGNATURES)
"""
function iterate(rdc::RawDataCollection)
    isempty(rdc.data) ? nothing : (rdc.data[1], 2)
end

"""Define iteration with state of a `RawDataCollection`.
#(SIGNATURES)
"""
function iterate(rdc::RawDataCollection, state)
    state > length(rdc.data) ? nothing : (rdc.data[state], state + 1)
end

"""Implement filtering for `RawDataCollection`
$(SIGNATURES)
"""
function filter(f, rdc::RawDataCollection)
     Iterators.filter(f, rdc.data) |> collect
end


"""Singleton type for value of `UrnComparisonTrait`.
$(SIGNATURES)
"""
struct RawDataCollectionComparable <: UrnComparisonTrait end
"""Assign value of `UrnComparisonTrait` for `RawDataCollection`
$(SIGNATURES)
"""
function urncomparisontrait(::Type{RawDataCollection})
    RawDataCollectionComparable()
end

"""Filter `rdc` by `urn` based on URN equality. 
$(SIGNATURES)
"""
function urnequals(urn::Cite2Urn, rdc::RawDataCollection, )
    filter(item -> urnequals(item.urn, urn), rdc.data)
end

"""Filter `rdc` by `urn` based on URN containment.
$(SIGNATURES)
"""
function urncontains(urn::Cite2Urn, rdc::RawDataCollection)
    filter(r -> urncontains(urn, r.urn),  rdc.data)
end

"""Filter `rdc` by `urn` based on URN similarity.
$(SIGNATURES)
"""
function urnsimilar(urn::Cite2Urn, rdc::RawDataCollection)
    filter(item -> urnsimilar(item.urn, urn), rdc)
end
