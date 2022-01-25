
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


"""Override `Base.==` for `CiteCollectionCatalog`.
$(SIGNATURES)
"""
function ==(cat1::CiteCollectionCatalog, cat2::CiteCollectionCatalog)
    all(cat1.entries .== cat2.entries)
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
    header = "#!citecollections\n" * join(["URN", "Description", "Labelling property", "Ordering property", "License"], delimiter) * "\n"
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



"""Implement `istable` for `RawDataCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function istable(catalog::CiteCollectionCatalog)
    true
end


"""Implement `columns` for `RawDataCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function columns(catalog::CiteCollectionCatalog)
    columns(catalog.entries)
end


"""Implement `rows` for `RawDataCollection`.
$(SIGNATURES)
Required for citable collection trait.
"""
function rows(catalog::CiteCollectionCatalog)
    rows(catalog.entries)
end


"""Implement `length` for `RawDataCollection`.
$(SIGNATURES)
"""
function length(catalog::CiteCollectionCatalog)
    length(catalog.entries)
end

"""Implement `eltype` for `RawDataCollection`.
$(SIGNATURES)
"""
function eltype(catalog::CiteCollectionCatalog)
    eltype(catalog.entries)
end

"""Define initial iteration of a `RawDataCollection`.
#(SIGNATURES)
"""
function iterate(catalog::CiteCollectionCatalog)
    isempty(catalog.entries) ? nothing : (catalog.entries[1], 2)
end

"""Define iteration with state of a `RawDataCollection`.
#(SIGNATURES)
"""
function iterate(catalog::CiteCollectionCatalog, state)
    state > length(catalog.entries) ? nothing : (catalog.entries[state], state + 1)
end

"""Implement filtering for `RawDataCollection`
$(SIGNATURES)
"""
function filter(f, catalog::CiteCollectionCatalog)
     Iterators.filter(f, catalog.entries) |> collect
end

