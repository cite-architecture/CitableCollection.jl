
"""A catalog of CITE object collections.
"""
struct CiteCollectionCatalog
    entries::Vector{CiteCatalogEntry}
end

"""Override `Base.show` for `CiteCollectionCatalog`.
$(SIGNATURES)
"""
function show(io::IO, catalog::CiteCollectionCatalog)
    if catalog.entries == 1
        print(io, "Catalog  of ", length(catalog.entries), " citable collection")
    else
        print(io, "Catalog  of ", length(catalog.entries), " citable collections")
    end
end

"""Singleton type for value of `CitableCollectionTrait`."""
struct CitableCollectionCatalog <: CitableCollectionTrait end
"""Define value of `CitableCollectionTrait` for `CiteCollectionCatalog`.
$(SIGNATURES)
"""
function citablecollectiontrait(::Type{CiteCollectionCatalog})
    CitableCollectionCatalog()
end

function urntype(catalog::CiteCollectionCatalog)
    Cite2Urn
end

struct CatalogComparable <: UrnComparisonTrait end
function urncomparisontrait(::Type{CiteCollectionCatalog})
    CatalogComparable()
end

function urnequals(urn::Cite2Urn, catalog::CiteCollectionCatalog)
    filter(item -> urnequals(item.urn, urn), catalog.entries)
end

function urncontains(urn::Cite2Urn, catalog::CiteCollectionCatalog)
    filter(item -> urncontains(item.urn, urn), catalog.entries)
end

function urnsimilar(urn::Cite2Urn, catalog::CiteCollectionCatalog )
    filter(item -> urnsimilar(item.urn, urn), catalog.entries)
end


struct CatalogCex <: CexTrait end
function cextrait(::Type{CiteCollectionCatalog})
    CatalogCex()
end


function cex(catalog::CiteCollectionCatalog; delimiter = "|")
    header = "#!citecollection\n"
    strings = map(entry -> cex(entry, delimiter=delimiter), catalog.entries)
    header * join(strings, "\n")
end

function fromcex(trait::CatalogCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)
    datalines = data(cexsrc, "citecollections")
    entries = CiteCatalogEntry[]
    for ln in datalines

        push!(entries, fromcex(ln, CiteCatalogEntry, delimiter = delimiter))
    end
    CiteCollectionCatalog(entries)
end