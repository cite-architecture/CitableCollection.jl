
"""Read data for citable collections from `cexsrc`.
Determine types of columns for each table from configuration
in `citeproperties` section of the CEX.
$(SIGNATURES)
If any columns of a collection are not configured, it is an error.
"""
function strictread(cexsrc::AbstractString, delimiter = "|")
    rdclist = lazyread(cexsrc, delimiter)
    propslist = propertiesfromcex(cexsrc, delimiter)
    colnamescheck = columnnamesok(rdclist, propslist)
    if colnamescheck == false
        DomainError(cexsrc, "Invalid configuration of CITE collection.")
    else
        converted = RawDataCollection[]
        # Now convert types as needed.
        for rdc in rdclist
            rdcprops = filter(prop -> urncontains(urn(rdc), urn(prop)), propslist)
            convertedfields = converttypes(rdc, rdcprops) 
            @warn("Converted datacolletion to a $(typeof(convertedfields))")
            push!(converted, convertedfields)
        end
        return converted
    end
end 

#= 
Look at conversion in lazy reader.
Build up list of col names, list of arrays of col values
=#
function converttypes(rdc::RawDataCollection, rdcprops::Vector{PropertyDefinition})
    sch = Tables.schema(rdc.data)
    coldata = []
    colidx = 0
    for rdcprop in rdcprops
        colidx = colidx + 1
        colname = sch.names[colidx] #tablecols[colidx]
        coltype = rdcprop.property_type #sch.types[colidx]
        if coltype == Cite2Urn 
            @warn("NEED TO CONVERT COLUMN")
            @warn("But first peek and see if it's already converted")
            if sch.types[colidx] == Cite2Urn
                @warn("ALREADY CONVERTED")
                row = map(getproperty(colname), rdc.data)
                push!(coldata, row)
            else
                urnrow = map(row -> Cite2Urn(row.urn), rdc.data)
                push!(coldata, urnrow)
            end
         
            
        elseif coltype == CtsUrn
            idrow = map(row -> CtsUrn(row.urn), rdc.data)
            push!(coldata, idrow)
        else
            @warn("Reuse column as is.")
            row = map(getproperty(colname), rdc.data)
            push!(coldata, row)
        end
    end
    NamedTuple{sch.names}(coldata) |> Table  |> RawDataCollection
end

"""True if for all column names in tables of `tablelist`, there is a corresponding
property definition in `propertieslist`.
$(SIGNATURES)
"""
function columnnamesok(rdclist::Vector{RawDataCollection}, propertieslist::Vector{PropertyDefinition})
    for rdc in rdclist
        # println(Tables.columnnames(rdc.data))
        set1 = CitableCollection.propertyids(propertieslist, urn(rdc))  |> Set 
        set2 = Tables.columnnames(rdc.data) .|> string  |> Set
        if set1 != set2
            @warn("Column names in table did not match configured values for collection $(urn(rdc)): $(set1) != $(set2)")
            return false
        end
    end
    true
end



"""Compute property names for properties in a list of `PropertyDefinition`s
matching a give collection URN.
$(SIGNATURES)
"""
function propertyids(propslist::Vector{PropertyDefinition}, collectionurn::Cite2Urn)
    props = filter(prop -> urncontains(collectionurn, urn(prop)), propslist)
    map(prop -> propertyid(urn(prop)), props)
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