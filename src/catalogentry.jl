"""Metadata for a collection of citable objects."""
struct CiteCatalogEntry <: Citable
    urn::Cite2Urn
    label::AbstractString
    labelling_property::Cite2Urn
    ordering_property::Union{Cite2Urn, Nothing}
    license::AbstractString
end

"""Override `Base.show` for a `CiteCatalogEntry`.
$(SIGNATURES)
"""
function show(io::IO, doc::CiteCatalogEntry)
    print(io, doc.label)
end


"""True if a value is defined for `ordering_property`.
$(SIGNATURES)
"""
function isordered(catentry::CiteCatalogEntry)
    ! isnothing(catentry.ordering_property)
end


"""Define singleton type of `CitableTrait` value.
$(SIGNATURES)
"""
struct CitableCatEntry <: CitableTrait end
"""Set value of `CitableTrait` for `CiteCatalogEntry`.
$(SIGNATURES)
"""
function citabletrait(::Type{CiteCatalogEntry})
    CitableCatEntry()
end

"""Define URN type of `CiteCatalogEntry`.
$(SIGNATURES)
"""
function urntype(doc::CiteCatalogEntry)
    Cite2Urn
end

"""Find identifying URN for `collection`.
$(SIGNATURES)
"""
function urn(collection::CiteCatalogEntry)
    collection.urn
end

"""Find readable label for `collection`.
$(SIGNATURES)
"""
function label(collection::CiteCatalogEntry)
    collection.label
end

"""Define singleton type for value of `UrnComparisonTrait`."""
struct CatEntryComparable <: UrnComparisonTrait end
"""Assign value of `UrnComparisonTrait` for `CiteCatalogEntry`.
$(SIGNATURES)
"""
function urncomparisontrait(::Type{CiteCatalogEntry})
    CatEntryComparable()
end

"""True if URN for `catentry` equals `u`
$(SIGNATURES)
"""
function urnequals(u::Cite2Urn, catentry::CiteCatalogEntry)
    u == catentry.urn
end

"""True if `u` contains URN for `catentry`.
$(SIGNATURES)
"""
function urncontains(u::Cite2Urn, catentry::CiteCatalogEntry)
    urncontains(u, catentry.urn)
end

"""True if `u` and URN for `catentry` are URN similar.
$(SIGNATURES)
"""
function urnsimilar(u::Cite2Urn, catentry::CiteCatalogEntry)
    urnsimilar(u, catentry.urn)
end

"""Define singleton type for `CexTrait` value."""
struct CatEntryCex <: CexTrait end
"""Assign value of `CexTrait` for `CiteCatalogEntry`.
$(SIGNATURES)
"""
function cextrait(::Type{CiteCatalogEntry})
    CatEntryCex()
end

"""Serialize a `CiteCatalogEntry` to delimited-text format.
$(SIGNATURES)
"""
function cex(catentry::CiteCatalogEntry; delimiter = "|")
    columns = [catentry.urn, catentry.label, catentry.labelling_property]
    isnothing(catentry.ordering_property) ? push!(columns, "") : push!(columns, catentry.ordering_property)
    push!(columns, catentry.license)
    join(columns, delimiter)
end

"""Instantiate a `CiteCatalogEntry` from CEX source.
$(SIGNATURES)
"""
function fromcex(traitvalue::CatEntryCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)
    fields = split(cexsrc, delimiter)
    idurn = Cite2Urn(fields[1])
    label = fields[2]
    labelprop = Cite2Urn(fields[3])
    orderprop = isempty(fields[4]) ? nothing : Cite2Urn(fields[4])
    license = fields[5]
    CiteCatalogEntry(idurn, label, labelprop, orderprop, license)
end