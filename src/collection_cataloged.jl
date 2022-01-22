
"""A cataloged collection of citable data.
$(SIGNATURES)
"""
struct CatalogedCollection
    catalogentry::CiteCatalogEntry
    data::TypedTables.Table
end
