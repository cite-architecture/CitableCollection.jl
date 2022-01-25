
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

"""Define URN type of a `CiteCollectionCatalog`.
$(SIGNATURES)
"""
function urntype(catalog::CiteCollectionCatalog)
    Cite2Urn
end


"""Singleton to use for value of `UrnComparisonTrait`."""
struct CatalogComparable <: UrnComparisonTrait end
"""Define value of `UrnComparisonTrait` for `CiteCollectionCatalog`.
$(SIGNATURES)
"""
function urncomparisontrait(::Type{CiteCollectionCatalog})
    CatalogComparable()
end

"""Filter catalog on equality with `urn`.
$(SIGNATURES)
"""
function urnequals(u::Cite2Urn, catalog::CiteCollectionCatalog)
    filter(item -> urnequals(u, item.urn), catalog.entries)
end

"""Filter catalog on URN containment by `urn`.
$(SIGNATURES)
"""
function urncontains(u::Cite2Urn, catalog::CiteCollectionCatalog)
    filter(item -> urncontains(u, item.urn), catalog.entries)
end

"""Filter catalog on URN similarity with `urn`.
$(SIGNATURES)
"""
function urnsimilar(u::Cite2Urn, catalog::CiteCollectionCatalog )
    filter(item -> urnsimilar(u, item.urn), catalog.entries)
end

"""Singleton type to use as value for `CexTrait`."""
struct CatalogCex <: CexTrait end
"""Assign value of `CexTrait` for `CiteCollectionCatalog`.
$(SIGNATURES)
"""
function cextrait(::Type{CiteCollectionCatalog})
    CatalogCex()
end

"""Serialize `catalog` to delimited text in CEX format.
$(SIGNATURES).
"""
function cex(catalog::CiteCollectionCatalog; delimiter = "|")
    header = "#!citecollections\n"
    strings = map(entry -> cex(entry, delimiter=delimiter), catalog.entries)
    header * join(strings, "\n")
end


"""Instantiate a catalog from CEX source.
$(SIGNATURES)
Returns a single `CiteCollectionCatalog` with 0 or more catalog entries.
"""
function fromcex(trait::CatalogCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)
    datalines = data(cexsrc, "citecollections")
    entries = CiteCatalogEntry[]
    for ln in datalines
        push!(entries, fromcex(ln, CiteCatalogEntry, delimiter = delimiter))
    end
    CiteCollectionCatalog(entries)
end