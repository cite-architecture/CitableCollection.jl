
"""A collection of citable objects.
"""
struct CatalogedCollection <: Citable
    urn::Cite2Urn
    label
    labelling_property::Cite2Urn
    ordering_property # Cite2Urn or nothing
    license
    propertiesdf
end

CitableTrait(::Type{CatalogedCollection}) = CitableByCite2Urn()


"""Parse CEX source data into a catalog of `CitableCollection`s.
$(SIGNATURES)

`cexsrc` must have at least one `citecollections` block and one `citeproperties` block.
"""
function catalogdf(cexsrc; delimiter = "|")
    allblocks = blocks(cexsrc)
    catdata = catalogdata(allblocks)
    propdata = propertydata(allblocks)
    caturns = collectionurns(catdata, delimiter)
    propurns = propertyurns(propdata, delimiter)
    if ! blocksagree(caturns, propurns)
        diffs = setdiff(Set(sort(map(p -> p.urn, propurns))), Set(sort(map(p -> p.urn, caturns))))
        throw(DomainError(diffs,"Collection URNs in citecollections and citeproperties blocks do not agree" ))
    end
    propconf = propertyconfigs(propdata, delimiter)

    catalogcolumns = []
    for row in catdata
        cols = split(row, delimiter)
        # Check on size of entries.
        if length(cols) != 5
            throw(ArgumentError("Invalid CEX source. $(length(cols)) columns found for configuration of collection: $(row)."))
        end
        push!(catalogcolumns, cols)
    end
    catalogobjects = []
    for u in caturns
        proplist = filter(r -> dropproperty(r.property_urn) == u, propconf)
        metadata = filter(v -> v[1] == u.urn, catalogcolumns)
        if length(metadata) != 1
            throw(ArgumentError("Invalid CEX source. $(length(metadata)) collections configured for URN $(u)."))
        end
        metadatarow = metadata[1]
        label = metadatarow[2]
        labelurn = Cite2Urn(metadatarow[3])
        orderingurn = isempty(metadatarow[4]) ? nothing : Cite2Urn(metadatarow[4])
        license = metadatarow[5]
        push!(catalogobjects, CatalogedCollection(u, label, labelurn, orderingurn, license, proplist))
    end
    catalogobjects |> DataFrame
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


function cex(coll::CatalogedCollection; delimiter = "|")
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



