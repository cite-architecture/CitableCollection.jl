

# CSV.File(map(IOBuffer,data)) |> DataFrame
# CSV.File(map(IOBuffer, [str]), delim="|") |> DataFrame



"""A collection of citable objects.
"""
struct CitableObjectCollection <: Citable
    urn::Cite2Urn
    label
end


"""URN identifying collection.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urn(coll::CitableObjectCollection)
    coll.urn
end

"""Label for collection.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function label(coll::CitableObjectCollection)
    coll.label
end


function cex(coll::CitableObjectCollection)
    """TBD"""
end


"""Override Base.print for `CitableObjectCollection`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function print(io::IO, coll::CitableObjectCollection)
    print(io, "<", coll.urn, "> ", coll.label)
end


"""Override Base.show for `CitableObjectCollection`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function show(io::IO, coll::CitableObjectCollection)
    print(io, "<", coll.urn, "> ", coll.label)
end



