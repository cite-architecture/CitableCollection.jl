"""Metadata for a collection of citable objects.
"""
struct CiteCatalogEntry <: Citable
    urn::Cite2Urn
    label::AbstractString
    labelling_property::Cite2Urn
    ordering_property::Union{Cite2Urn, Nothing}
    license::AbstractString
    #propertydefs
end

