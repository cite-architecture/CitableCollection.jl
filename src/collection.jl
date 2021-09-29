
"""A collection of citable objects.
"""
struct CatalogedCollection <: Citable
    urn::Cite2Urn
    label
    labelling_property::Cite2Urn
    ordering_property # Cite2Urn or nothing
    license
    propertylist
end

"""URN identifying collection.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urn(coll::CatalogedCollection)
    coll.urn
end

"""Label for collection.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function label(coll::CatalogedCollection)
    coll.label
end


function cex(coll::CatalogedCollection)
    """TBD"""
end

"""Override Base.print for `CatalogedCollection`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function print(io::IO, coll::CatalogedCollection)
    s = string("<", coll.urn, "> ", coll.label)
    print(io, s)
end

"""Override Base.show for `CatalogedCollection`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function show(io::IO, coll::CatalogedCollection)
    s = string("<", coll.urn, "> ", coll.label)
    show(io, s)
end



