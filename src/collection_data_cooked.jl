
"""Read data for citable collections from `cexsrc`.
Determine types of columns for each table from configuration
in `citeproperties` section of the CEX.
$(SIGNATURES)
If any columns of a collection are not configured, it is an error.
"""
function strictread(cexsrc::AbstractString, delimiter = "|")
    simpletables = lazyread(cexsrc, delimiter)
    propslist = propertiesfromcex(cexsrc, delimiter)


    for t in simpletables

    end


    
    colls = collectionsfromprops(propslist)
    for blk in blocks(cexsrc, "citedata")
        headers = split(blk.lines[1], delimiter)
    end
end 

"""True if for all column names in tables of `tablelist`, there is a corresponding
property definition in `propertieslist`.
$(SIGNATURES)
"""
function columnnamesok(tablelist::Vector{Table}, propertieslist::Vector{PropertyDefinition})
    for t in tablelist
    end
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