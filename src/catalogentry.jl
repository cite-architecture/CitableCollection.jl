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


function urntype(doc::CiteCatalogEntry)
    Isbn10Urn
end

function urn(doc::CiteCatalogEntry)
    doc.urn
end

function label(doc::CiteCatalogEntry)
    string(doc)
end


struct CatEntryComparable <: UrnComparisonTrait end

function urncomparisontrait(::Type{CiteCatalogEntry})
    CatEntryComparable()
end

function urnequals(doc1::CiteCatalogEntry, doc2::CiteCatalogEntry)
    doc1.urn == doc2.urn
end
function urncontains(doc1::CiteCatalogEntry, doc2::CiteCatalogEntry)
    urncontains(doc1.urn, doc2.urn)
end
function urnsimilar(doc1::CiteCatalogEntry, doc2::CiteCatalogEntry)
    urnsimilar(doc1.urn, doc2.urn)
end

struct CatEntryCex <: CexTrait end
function cextrait(::Type{CiteCatalogEntry})
    CatEntryCex()
end

function cex(doc::CiteCatalogEntry; delimiter = "|")
    columns = [doc.urn, doc.label, doc.labelling_property]
    isnothing(ordering_property) ? push!(columns, "") : push!(columns, doc.ordering_property)
    push!(columns, doc.license)
    join(columns, delimiter)
end

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