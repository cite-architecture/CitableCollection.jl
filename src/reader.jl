

# CSV.File(map(IOBuffer,data)) |> DataFrame
# CSV.File(map(IOBuffer, [str]), delim="|") |> DataFrame

"""True if collections block and properties block
document the same set of collections.
$(SIGNATURES)
"""
function blocksagree(collurns, propurns)
    # TBA
    false
end

"""From a list of CEX blocks, extract all data lines from one or more `citecollections` blocks.
$(SIGNATURES)
It is a DomainError if `blocklist` includes no `citecollections` blocks.
"""
function collectiondata(blocklist)
    collblocks = blocksfortype("citecollections", blocklist)
    if isempty(collblocks)
        throw(DomainError(cexsrc, "No citecollections block found in CEX source"))
    end
    collectionsdata = []
    for cblock in collblocks
        push!(collectionsdata, cblock.lines[2:end])
    end
    flatcollections = collectionsdata |> Iterators.flatten |> collect
    #=
    catalogurns = []
    for coll in flatcollections
        parts = split(coll, delim)
        push!(catalogurns, Cite2Urn(parts[1]))
    end
    catalogurns
    =#
end



"""Extract URNs of collections documented in
cex src.
$(SIGNATURES)
"""
function collectionurns()
end

"""Parse CEX source data into a catalog of `CitableCollection`s.
$(SIGNATURES)

`cexsrc` must have at least one `citecollections` block and one `citeproperties` block.
"""
function catalog(cexsrc, delim = "|")
    allblocks = blocks(cexsrc)
    

    propblocks = blocksfortype("citeproperties", allblocks)
    if isempty(propblocks)
        throw(DomainError(cexsrc, "No citeproperties block found in CEX source"))
    end
    propertiesdata = []
    for pblock in propblocks
        push!(propertiesdata, pblock.lines[2:end])
    end
    flatproperties = propertiesdata |> Iterators.flatten |> collect

    

    propertiesurns = []
    for prop in flatproperties
        parts = split(prop, delim)
        push!(propertiesurns, Cite2Urn(parts[1]) |> dropobject |> dropproperty)
    end


    purns = propertiesurns |> unique
    blocksagree(catalogurns, purns)
    
end