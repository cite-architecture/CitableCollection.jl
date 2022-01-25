
"""A cataloged collection of citable data.
$(SIGNATURES)
"""
struct CatalogedCollection
    catalogentry::CiteCatalogEntry
    data::RawDataCollection
end

"""Override `Base.show` for `CatalogedCollection`.
$(SIGNATURES)
"""
function show(io::IO, coll::CatalogedCollection)
    if coll.data == 1
        print(io, coll.catalogentry.label, "\nA cataloged collection containing ", length(coll.data), " citable object")
    else
        print(io, coll.catalogentry.label, "\nA cataloged collection containing ", length(coll.data), " citable objects")
    end
end

function ==(cc1::CatalogedCollection, cc2::CatalogedCollection)
    cc1.catalogentry == cc2.catalogentry &&
    cc1.data == cc2.data
end

"Singleton type to use as value of `CitableTrait`."
struct CitableCatalogedCollection <: CitableTrait end
"""Set value of `CitableTrait` for `CatalogedCollection`.
$(SIGNATURES)
"""
function citabletrait(::Type{CatalogedCollection})
    CitableCatalogedCollection()
end


"""Find URN for cataloged collection.
$(SIGNATURES)
"""
function urn(cc::CatalogedCollection)
    urn(cc.catalogentry)
end


"""Find URN type for cataloged collection.
$(SIGNATURES)
"""
function urntype(cc::CatalogedCollection)
    Cite2Urn
end

"""Find label for cataloged collection.
$(SIGNATURES)
"""
function label(cc::CatalogedCollection)
    label(cc.catalogentry)
end


"Singleton type for value of `CitableCollectionTrait"
struct CollectionTraitCatalogedCitable <: CitableCollectionTrait end
"""Set value of `CitableCollectionTrait` for `CatalogedCollection`.
$(SIGNATURES)
"""
function citablecollectiontrait(::Type{CatalogedCollection})
    CollectionTraitCatalogedCitable()
end


"Singleton type for value of `UrnComparisonTrait"
struct CatalogedCollectionComparable <: UrnComparisonTrait end
"""Set value of `UrnComparisonTrait` for `CatalogedCollection`.
$(SIGNATURES)
"""
function urncomparisontrait(::Type{CatalogedCollection})
    CatalogedCollectionComparable()
end


"""Filter records from collection data matching `urn` for equality.
$(SIGNATURES)
"""
function urnequals(u::Cite2Urn, coll::CatalogedCollection)
    filter(item -> urnequals(u, item.urn), coll.data)
end

"""Filter records from collection data matching `urn` for containment.
$(SIGNATURES)
"""
function urncontains(u::Cite2Urn,  coll::CatalogedCollection)
    filter(item -> urncontains(u, item.urn), coll.data)
end


"""Filter records from collection data matching `urn` for similarity.
$(SIGNATURES)
"""
function urnsimilar(u::Cite2Urn,  coll::CatalogedCollection)
    filter(item -> urnsimilar(u, item.urn), coll.data)
end

"Singleton type for value of `CexTrait`."
struct CatalogedCollectionCex <: CexTrait end
"""Set value of `CexTrait` for `CatalogedCollection`.
$(SIGNATURES)
"""
function cextrait(::Type{CatalogedCollection})
    CatalogedCollectionCex()
end


"""Compose CEX representation of a `CatalogedCollection` including
`citecollections`, `citeproperties` and `citedata` blocks.
$(SIGNATURES)
"""
function cex(coll::CatalogedCollection; delimiter = "|")
    @debug("HEY!")
    # COMPOSE citecollections block
    ccollines = ["#!citecollections",
    join(["URN", "Description","Labelling property",
    "Ordering property", "License"], delimiter),
    ]
    orderprop = ""
    if ! isnothing(coll.catalogentry.ordering_property)
        orderprop = string(coll.catalogentry.ordering_property)
    end

    push!(ccollines, 
        join([string(coll.catalogentry.urn), 
            coll.catalogentry.label,
            string(coll.catalogentry.labelling_property),
            orderprop,
            coll.catalogentry.license
            ], delimiter
        )
    )
    join(ccollines,"\n") * "\n\n" * cex(coll.data)
end


"""Compose `CatalogedCollection`s from a CEX source.
$(SIGNATURES)
Returns a Vector of zero or more `CatalogedCollection`s.
"""
function fromcex(trait::CatalogedCollectionCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)

    rawcollections = fromcex(cexsrc, RawDataCollection, delimiter = delimiter)
    cat = fromcex(cexsrc, CiteCollectionCatalog, delimiter = delimiter)


    results = CatalogedCollection[]
    for c in rawcollections
        entries = urnequals(urn(c), cat)
        if length(entries) > 1
            throw(DomainError(urn(c)), "Multiple catalog entries for collection $(urn(c))")
        elseif isempty(entries)
            throw(DomainError(urn(c)), "No catalog entry for collection $(urn(c))")
        end
        push!(results, CatalogedCollection(entries[1], c))
    end
    @debug("Found ", length(results), " collections")
    results

end



"""Implement `istable` for `CatalogedCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function istable(cc::CatalogedCollection)
    true
end

"""Implement `columns` for `CatalogedCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function columns(cc::CatalogedCollection)
    columns(cc.data)
end

"""Implement `rows` for `CatalogedCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function rows(cc::CatalogedCollection)
    rows(cc.data)
end


"""Implement `schema` for `CatalogedCollection`.
$(SIGNATURES)
"""
function schema(cc::CatalogedCollection)
    schema(cc.data)
end

"""Implement `length` for `RawDataCollection`.
$(SIGNATURES)
"""
function length(cc::CatalogedCollection)
    length(cc.data)
end

"""Implement `eltype` for `RawDataCollection`.
$(SIGNATURES)
"""
function eltype(cc::CatalogedCollection)
    eltype(cc.data)
end

"""Define initial iteration of a `RawDataCollection`.
#(SIGNATURES)
"""
function iterate(cc::CatalogedCollection)
    isempty(cc.data) ? nothing : (cc.data.data[1], 2)
end

"""Define iteration with state of a `RawDataCollection`.
#(SIGNATURES)
"""
function iterate(cc::CatalogedCollection, state)
    state > length(cc.data) ? nothing : (cc.data.data[state], state + 1)
end

"""Implement filtering for `RawDataCollection`
$(SIGNATURES)
"""
function filter(f, cc::CatalogedCollection)
     Iterators.filter(f, cc.data) |> collect
end
