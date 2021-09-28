

# CSV.File(map(IOBuffer,data)) |> DataFrame
# CSV.File(map(IOBuffer, [str]), delim="|") |> DataFrame


"""Parse CEX source data into a catalog of `CitableCollection`s.
$(SIGNATURES)

`cexsrc` must have at least one `citecollections` block and one `citeproperties` block.
"""
function catalog(cexsrc, delim = "|")
    allblocks = blocks(cexsrc)
    collblocks = blocksfortype("citecollections", allblocks)
    if isempty(collblocks)
        throw(DomainError(cexsrc, "No citecollections block found in CEX source"))
    end
    collectionsdata = []
    for cblock in collblocks
        push!(collectionsdata, cblock.lines[2:end])
    end
    flatcollections = collectionsdata |> Iterators.flatten |> collect

    propblocks = blocksfortype("citeproperties", allblocks)
    if isempty(propblocks)
        throw(DomainError(cexsrc, "No citeproperties block found in CEX source"))
    end
    propertiesdata = []
    for pblock in propblocks
        push!(propertiesdata, pblock.lines[2:end])
    end
    flatproperties = propertiesdata |> Iterators.flatten |> collect

    catalogurns = []
    for coll in flatcollections
        parts = split(coll, delim)
        push!(catalogurns, Cite2Urn(parts[1]))
    end
    catalogurns
    propertiesurns = []
    for prop in flatproperties
        parts = split(prop, delim)
        push!(propertiesurns, Cite2Urn(parts[1]) |> dropobject)
    end
    propertiesurns |> unique

end