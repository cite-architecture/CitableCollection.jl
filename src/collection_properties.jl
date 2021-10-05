
"""Configuration data for a single property in a collection.
"""
struct PropertyConfiguration
    property_urn
    property_label
    property_type
    authority_list
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
function configured_propertynames(df)
    map(u -> propertyid(u), df[:, :property_urn])
end