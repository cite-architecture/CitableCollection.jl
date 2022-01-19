
"""Configuration data for a single property in a collection.
"""
struct PropertyDefinition <: Citable
    property_urn
    property_label
    property_type
    authority_list
end

"""Define singleton type for `CitableTrait`."""
struct CitablePropDef <: CitableTrait end

"""Set value of `CitableTrait` on `PropertyDefinition`
$(SIGNATURES)
"""
function citabletrait(::Type{PropertyDefinition})
    CitablePropDef()
end


"""Define `urntype` for `PropertyDefinition`
$(SIGNATURES)
Required for `CitableTrait`.
"""
function urntype(pdef::PropertyDefinition)
    Cite2Urn
end

"""Retrieve URN value.
$(SIGNATURES)
Required for `CitableTrait`.
"""
function urn(pdef::PropertyDefinition)
    pdef.property_urn
end

"""Retrieve label for property.
$(SIGNATURES)
Required for `CitableTrait`.
"""
function label(pdef::PropertyDefinition)
    pdef.property_label
end


"""Retrieve CITE type for property.
$(SIGNATURES)
"""
function citetype(pdef::PropertyDefinition)
    pdef.property_type
end



"""Retrieve (possibly empty) list of allowed values.
$(SIGNATURES)
"""
function authlist(pdef::PropertyDefinition)
    pdef.authority_list
end


#=
data(f, FileReader,"citeproperties")
=#

#=


"""Create a DataFrame of `PropertyDefinition`s 
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
        config = PropertyDefinition(
            urn, label, ptype, authlist
            )
        push!(propertylist, config)
    end
    propertylist |> DataFrame
end


"""Extract list of property names from a DataFrame of `PropertyDefinition` objects.
$(SIGNATURES)
"""
function configured_propertynames(df)
    map(u -> propertyid(u), df[:, :property_urn])
end
=#