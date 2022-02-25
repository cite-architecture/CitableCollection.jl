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
        DomainError(propslist, "Invalid configuration of CITE collection.")
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
    rawschema = Tables.schema(rdc.data)
    @warn("Converting raw wiht sch ", rawschema)
    coldata = []
    colidx = 0
    for rdcprop in rdcprops   
        colidx = colidx + 1
        @warn("==>At index $(colidx), property $(rdcprop)")
        @warn("==>Schema: $(rawschema.types[colidx]) for $(rawschema.names[colidx])")
        colname = rawschema.names[colidx]
        coltype = rdcprop.property_type
        @warn("==>CITE type: $(rawschema.names[colidx]) $(coltype) $(propertyid(rdcprop.property_urn))")
        @warn("Checki if rawschema subtypes AbstractString/new type is Cite2Urn", (rawschema.types[colidx] <: AbstractString), (coltype == Cite2Urn))
        if coltype == Cite2Urn && ! (rawschema.types[colidx] <: AbstractString)
            @warn("SEE if  already converted: $(rawschema.types[colidx]) for $(rawschema.names[colidx])")
            if rawschema.types[colidx] == Cite2Urn 
                @warn("ALREADY CONVERTED")
                row = map(getproperty(colname), rdc.data)
                push!(coldata, row)
            else
                @warn("NOT yet converted. Creating Cite2Urns on column/type", colname, rawschema.types[colidx])


                #map(row -> Cite2Urn(row[colname]), rdc.data)
                urnrow = []
                for r in rdc.data
                    if ismissing(r[colname])
                        push!(urnrow, missing)
                    else
                        push!(urnrow, Cite2Urn(strip(r[colname])))
                    end
                end
                push!(coldata, urnrow)
            end
         
            
        elseif coltype == CtsUrn && ! (rawschema.types[colidx] <: AbstractString)
            #urnrow = map(row -> CtsUrn(row[colname]), rdc.data)
            #map(row -> Cite2Urn(row[colname]), rdc.data)
            urnrow = []
            for r in rdc.data
                if ismissing(r[colname])
                    push!(urnrow, missing)
                else
                    push!(urnrow, CtsUrn(strip(r[colname])))
                end
            end
            push!(coldata, urnrow)
        else
            @debug("REUSE column as is.")
            row = map(getproperty(colname), rdc.data)
            push!(coldata, row)
        end
    end
    t = NamedTuple{rawschema.names}(coldata) |> Table
    tlabel = "Citable collection of $(length(t)) items with schema specified from `citeproperties` settings."    
    RawDataCollection(t, tlabel, rdcprops)    
end

"""True if all column names in tables of `tablelist` have corresponding entries in `propertieslist`.  Comparison of column names and property  names is case-insensitive.
$(SIGNATURES)
"""
function columnnamesok(rdclist::Vector{RawDataCollection}, propertieslist::Vector{PropertyDefinition})
    for rdc in rdclist
        @debug("Raw propertyids:", CitableCollection.propertyids(propertieslist, urn(rdc)))
        set1 = CitableCollection.propertyids(propertieslist, urn(rdc)) .|> lowercase |> Set 
        set2 = Tables.columnnames(rdc.data) .|> string .|> lowercase |> Set
        @debug(">Compare ", set1, set2)
        if set1 != set2
            @warn("Column names in table did not match configured values for collection $(urn(rdc)): table/configuration:",set1, set2)
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
        @debug("PROP FROM", line)
        push!(proplist, fromcex(lowercase(line), PropertyDefinition, delimiter = delimiter))
    end
    proplist
end
