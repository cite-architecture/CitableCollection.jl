
"""A cataloged collection of citable data.
$(SIGNATURES)
"""
struct CatalogedCollection
    catalogentry::CiteCatalogEntry
    data::TypedTables.Table
end


function show(io::IO, coll::CatalogedCollection)
    if catalog.entries == 1
        print(io, "Cataloged collection containing ", length(coll.data), " citable object")
    else
        print(io, "Cataloged collection containing ", length(catalog.entries), " citable objects")
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
    # COMPOSE citeproperties block
    # COMPOSE citedata block
    #=
    header = "#!citecollection\n"
    strings = map(entry -> cex(entry, delimiter=delimiter), catalog.entries)
    header * join(strings, "\n")
    =#
end

function fromcex(trait::CatalogCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)

    # Call fromcex to:
    # - get collections
    # - get catalog
    #
    # cycle through collections
    # add catalog entry
end
