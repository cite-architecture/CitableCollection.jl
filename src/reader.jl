"""True if list of URNs from collections block and properties block document the same set of collections.
$(SIGNATURES)
"""
function blocksagree(collurns, propurns)
    sort(map(u -> u.urn, collurns)) == sort(map(u -> u.urn, propurns))
end

"""From a list of CEX blocks, extract all data lines from one or more `citecollections` blocks.
$(SIGNATURES)
It is a DomainError if `blocklist` includes no `citecollections` blocks.
"""
function catalogdata(blocklist)
    collblocks = blocksfortype("citecollections", blocklist)
    if isempty(collblocks)
        throw(DomainError(cexsrc, "No citecollections block found in CEX source"))
    end
    collectionsdata = []
    for cblock in collblocks
        push!(collectionsdata, cblock.lines[2:end])
    end
    datalines = collectionsdata |> Iterators.flatten |> collect
    datalines
end

"""Extract URNs of collections documented in `datalines`.
$(SIGNATURES)
"""
function collectionurns(datalines, delim = "|")
    catalogurns = []
    for coll in datalines
        parts = split(coll, delim)
        push!(catalogurns, Cite2Urn(parts[1]))
    end
    catalogurns
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


"""Create a DataFrame of `PropertyConfiguration`s 
from delimited-text source.
$(SIGNATURES)
"""
function propertyconfigs(datalines, delim = "|")
    propertylist = []
    for prop in datalines
        parts = split(prop, delim)
        urn = Cite2Urn(parts[1])
        label = parts[2]
        ptype = parts[3]
        authlist = isempty(parts[4]) ? [] : split(parts[4], ",")
        config = PropertyConfiguration(
            urn, label, ptype, authlist
            )
        push!(propertylist, config)
    end
    propertylist |> DataFrame
end

"""Extract list of property names from a DataFrame of `PropertyConfiguration` objects.
$(SIGNATURES)
"""
function propertynames(df)
    map(u -> propertyid(u), df[:, :property_urn])
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
function collectiondf(datalines, colnames, delim= "|")
    CSV.File(IOBuffer(join(datalines,"\n")), select=colnames, delim=delim) |> DataFrame
end


"""Parse CEX source data into a catalog of `CitableCollection`s.
$(SIGNATURES)

`cexsrc` must have at least one `citecollections` block and one `citeproperties` block.
"""
function collectiondf(cexsrc, delim = "|")
    allblocks = blocks(cexsrc)
    catdata = catalogdata(allblocks)
    propdata = propertydata(allblocks)

    caturns = collectionurns(catdata, delim)
    propurns = propertyurns(propdata, delim)
    if ! blocksagree(caturns, propurns)
        diffs = setdiff(Set(sort(map(p -> p.urn, propurns))), Set(sort(map(p -> p.urn, caturns))))
        throw(DomainError(diffs,"Collection URNs in citecollections and citeproperties blocks do not agree" ))
    end

    propconf = propertyconfigs(propdata, delim)
    propnames = propertynames(propconf)
    #@info("Select these property names for DF ", propnames)
    datadf = collectiondf(collectiondata(allblocks), propnames, delim)

    # Replace string URN column with parsed Cite2Urns:
    dataurns = []
    for r in eachrow(datadf)
        push!(dataurns, Cite2Urn(r.urn))
    end
    dropped = select!(datadf, Not(:urn))
    insertcols!(dropped,1, :urn => dataurns)
end