

# CSV.File(map(IOBuffer,data)) |> DataFrame

"""A collection of citable objects.
"""
struct CitableObjects <: Citable
    urn::Cite2Urn
end