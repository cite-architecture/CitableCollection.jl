"""True if list of URNs from collections block and properties block document the same set of collections.
$(SIGNATURES)
"""
function blocksagree(collurns, propurns)
    sort(map(u -> u.urn, collurns)) == sort(map(u -> u.urn, propurns))
end


"""Extract URNs of collections documented in `datalines`.
$(SIGNATURES)
`datalines` is a Vector of delimited-string values.
"""
function collectionurns(datalines, delim = "|")
    catalogurns = []
    for coll in datalines
        parts = split(coll, delim)
        push!(catalogurns, Cite2Urn(parts[1]) |> dropobject)
    end
    catalogurns |> unique
end

"""From a list of CEX blocks, extract all data lines from one or more `citeproperties` blocks.
$(SIGNATURES)
It is a DomainError if `blocklist` includes no `citeproperties` blocks.
"""
function propertydata(blocklist)
    propblocks = blocksfortype("citeproperties", blocklist)
    if isempty(propblocks)
        throw(DomainError(cexsrc, "No citeproperties block found in CEX source"))
    end
    propertiesdata = []
    for pblock in propblocks
        push!(propertiesdata, pblock.lines[2:end])
    end
    propertylines = propertiesdata |> Iterators.flatten |> collect
    propertylines
end

"""Extract collection-level URNs of properties documented in `datalines`.
$(SIGNATURES)
"""
function propertyurns(datalines, delim = "|")
    propertiesurns = []
    for prop in datalines
        parts = split(prop, delim)
        push!(propertiesurns, Cite2Urn(parts[1]) |> dropobject |> dropproperty)
    end
    propurns = propertiesurns |> unique
    propurns
end

"""From a list of CEX blocks, extract all data lines from one or more `citedata` blocks.
$(SIGNATURES)
It is a DomainError if `blocklist` includes no `citedata` blocks.
"""
function collectiondata(blocklist)
    collblocks = blocksfortype("citedata", blocklist)
    if isempty(collblocks)
        throw(DomainError(cexsrc, "No citecollections block found in CEX source"))
    end
    collectionsdata = []
    for cblock in collblocks
        push!(collectionsdata, cblock.lines)
    end
    datalines = collectionsdata |> Iterators.flatten |> collect
    datalines
end

"""Create a DataFrame including specified columns from delimited-text data.
"""
function collectiondf(datalines, colnames, delim)
    CSV.File(IOBuffer(join(datalines,"\n")), select=colnames, delim=delim) |> DataFrame
end


"""Parse CEX source data into a Vector of DataFrames.
$(SIGNATURES)

`cexsrc` must have at least one `citecollections` block and one `citeproperties` block
cataloging the collection, and at least one `citedata` block with data records.
"""
function collectiondfs(cexsrc, delim = "|"; limitto = nothing)
    catdf = catalogdf(cexsrc, delim)
    allblocks = blocks(cexsrc)
    datablocks = blocksfortype("citedata", allblocks)

    collectiondflist = []
    # Construct each db listed.
    for db in datablocks
        urnlist = collectionurns(db.lines[2:end])
        for u in urnlist
            dbconf = filter(r -> r.urn == u, catdf)
            if nrow(dbconf) != 1
                throw(ArgumentError("Bad input. Found $(nrow(dbconf)) catalog entries for collection $(u)"))
            end
            propnames = dbconf[1, :propertiesdf] |> configured_propertynames

            #info("DF From datablock's lines ", db.lines, " and proplist ", propnames)
            datadf = collectiondf(db.lines, propnames, delim)

            #datadf = collectiondfs(collectiondata(allblocks), propnames, delim)
            # Replace string URN column with parsed Cite2Urns:
            dataurns = []
            for r in eachrow(datadf)
                push!(dataurns, Cite2Urn(r.urn))
            end
            dropped = select!(datadf, Not(:urn))
            insertcols!(dropped,1, :urn => dataurns)
            push!(collectiondflist, datadf)
        end
    end
    collectiondflist
  
end


