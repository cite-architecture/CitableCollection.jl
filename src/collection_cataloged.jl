
"""A cataloged collection of citable data.
$(SIGNATURES)
"""
struct CatalogedCollection
    catalogentry::CiteCatalogEntry
    data::TypedTables.Table
end


function show(io::IO, coll::CatalogedCollection)
    if coll.data == 1
        print(io, coll.catalogentry.label, "\nA cataloged collection containing ", length(coll.data), " citable object")
    else
        print(io, coll.catalogentry.label, "\nA cataloged collection containing ", length(coll.data), " citable objects")
    end
end


struct CitableCatalogedCollection <: CitableCollectionTrait end
function citablecollectiontrait(::Type{CatalogedCollection})
    CitableCatalogedCollection()
end

function urntype(catalog::CatalogedCollection)
    Cite2Urn
end

struct CatalogedCollectionComparable <: UrnComparisonTrait end
function urncomparisontrait(::Type{CatalogedCollection})
    CatalogedCollectionComparable()
end

function urnequals(urn::Cite2Urn, coll::CatalogedCollection)
    filter(item -> urnequals(item.urn, urn), coll.data)
end

function urncontains(urn::Cite2Urn,  coll::CatalogedCollection)
    filter(item -> urncontains(item.urn, urn), coll.data)
end

function urnsimilar(urn::Cite2Urn,  coll::CatalogedCollection)
    filter(item -> urnsimilar(item.urn, urn), coll.data)
end


struct CatalogedCollectionCex <: CexTrait end
function cextrait(::Type{CatalogedCollection})
    CatalogedCollectionCex()
end


function cex(coll::CatalogedCollection; delimiter = "|")
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
    
    join(ccollines, "\n") * cex(rawdatacollection(coll.data))
end


# returns a list
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
        push!(results, CatalogedCollection(entries[1], c.data))
    end
    @warn("Found ", length(results), " collections")
    results

end
