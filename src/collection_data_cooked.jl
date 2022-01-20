
"""Read data for citable collections from `cexsrc`.
Determine types of columns for each table from configuration
in `citeproperties` section of the CEX.
$(SIGNATURES)
If any columns of a collection are not configured, it is an error.
"""
function strictread(cexsrc::AbstractString, delimiter = "|")
    #lazyread(cexsrc, delimiter)
    propslist = propertiesfromcex(cexsrc, delimiter)
    colls = collectionsfromprops(propslist)
end 


"""Compute a list of URNs identifying collections from a list of `PropertyDefinition`s.
$(SIGNATURES)
"""
function collectionsfromprops(proplist::Vector{PropertyDefinition})
    map(prop -> dropobject(dropproperty(prop.property_urn)), proplist) |> unique
end



"""Construct a list of `PropertyDefinition`s from a `cexsrc`.
$(SIGNATURES)
"""
function propertiesfromcex(cexsrc::AbstractString, delimiter = "|")
    proplist = PropertyDefinition[]
    for line in data(cexsrc, "citeproperties")
        push!(proplist, fromcex(line, PropertyDefinition, delimiter = delimiter))
    end
    proplist
end

# pds = map(ln -> fromcex(ln, PropertyDefinition, delimiter = "#"),   data(f, FileReader, "citeproperties")) 
# ccs[2][1].urn |> dropobject 
# filter to collect PropertyDefinitions for collection.
# Then match propertydefinition to table columns