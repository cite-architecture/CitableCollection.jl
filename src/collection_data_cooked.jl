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
            @debug("Converted datacollection to a $(typeof(convertedfields))")
            push!(converted, convertedfields)
        end
        return converted
    end
end 

"""Convert any string-value columns in a `RawDataCollection` configured for URN values in their property definitions to the appropriate type of URN value.
$(SIGNATURES)
"""
function converttypes(rdc::RawDataCollection, rdcprops::Vector{PropertyDefinition})
    sch = Tables.schema(rdc.data)
    coldata = []
    colidx = 0
    for rdcprop in rdcprops
        colidx = colidx + 1
        @debug("==>At index $(colidx), property $(rdcprop)")
        @debug("==>Schema: $(sch.types[colidx]) for $(sch.names[colidx])")
        colname = sch.names[colidx] #tablecols[colidx]
        coltype = rdcprop.property_type #sch.types[colidx]
        @debug("==>CITE type: $(sch.names[colidx]) $(coltype) $(propertyid(rdcprop.property_urn))")
        if coltype == Cite2Urn 
            @debug("SEE if  already converted: $(sch.types[colidx]) for $(sch.names[colidx])")
            if sch.types[colidx] == Cite2Urn
                @debug("ALREADY CONVERTED")
                row = map(getproperty(colname), rdc.data)
                push!(coldata, row)
            else
                @debug("NOT yet converted. Pusing Cite2Urns to coldata.")
                urnrow = map(row -> Cite2Urn(row[colname]), rdc.data)
                push!(coldata, urnrow)
            end
         
            
        elseif coltype == CtsUrn
            urnrow = map(row -> CtsUrn(row[colname]), rdc.data)
            push!(coldata, urnrow)
        else
            @debug("REUSE column as is.")
            row = map(getproperty(colname), rdc.data)
            push!(coldata, row)
        end
    end
    t = NamedTuple{sch.names}(coldata) |> Table # |> rawdatacollection 
    tlabel = "Citable collection of $(length(t)) items with schema specified from `citeproperties` settings."
    RawDataCollection(t, tlabel)    
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
