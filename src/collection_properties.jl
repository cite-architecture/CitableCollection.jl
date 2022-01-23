
"""Configuration data for a single property in a collection.
"""
struct PropertyDefinition <: Citable
    property_urn
    property_label
    property_type
    authority_list
end

"""True if either of two property types is a subtype of the other.
"""
function comparablehierarchy(pd1::PropertyDefinition, pd2::PropertyDefinition)
    pd1.property_type <: pd2.property_type || pd2.property_type <: pd1.property_type
end

"""Define equality of `PropertyDefinition`s to allow
comparable Julia types in dynamic instantiation of types.
$(SIGNATURES)
"""
function ==(pd1::PropertyDefinition, pd2::PropertyDefinition)
    pd1.property_urn == pd2.property_urn &&
    pd1.property_label == pd2.property_label &&
    comparablehierarchy(pd1, pd2) &&
    pd1.authority_list == pd2.authority_list
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




"""Define singleton type for `CitableTrait`."""
struct PropDefComparable <: UrnComparisonTrait end
"""Set value of `CitableTrait` on `PropertyDefinition`
$(SIGNATURES)
"""
function urncomparisontrait(::Type{PropertyDefinition})
    PropDefComparable()
end

"""URN comparison for equality on `PropertyDefinition`s.
$(SIGNATURES)
Required for `UrnComparisonTrait`.
"""
function urnequals(prop1::PropertyDefinition,  prop2::PropertyDefinition)
    prop1.property_urn == prop2.property_urn
end


"""URN comparison for equality on `PropertyDefinition`s.
$(SIGNATURES)
Required for `UrnComparisonTrait`.
"""
function urncontains(prop1::PropertyDefinition,  prop2::PropertyDefinition)
    urncontains(prop1.property_urn, prop2.property_urn)
end


"""URN comparison for equality on `PropertyDefinition`s.
$(SIGNATURES)
Required for `UrnComparisonTrait`.
"""
function urnsimilar(prop1::PropertyDefinition,  prop2::PropertyDefinition)
    urnequals(dropversion(prop1.property_urn), dropversion(prop2.property_urn))
end


"Define singleton type for `CexTrait`."
struct PropDefCex <: CexTrait end

"""Set value of `CitableTrait` on `PropertyDefinition`
$(SIGNATURES)
"""
function cextrait(::Type{PropertyDefinition})
    PropDefCex()
end


"""Format `pd` as delimited text.
$(SIGNATURES)
Required for `CexTrait`.
"""
function cex(pd::PropertyDefinition; delimiter = "|")
    str = join([
        string(pd.property_urn),
        pd.property_label,
        cpropfortype(pd),
        join(pd.authority_list, ",")
    ], delimiter)
    isempty(pd.authority_list) ? str * delimiter : str
end


"""Find CITE string value to use in serializing property 
type.
$(SIGNATURES)
"""
function cpropfortype(pd::PropertyDefinition)
    citetype(pd) |> cpropfortype
end


"""Find CITE string value to use in serializing property 
type.
$(SIGNATURES)
"""
function cpropfortype(citeproptype)
    @debug("Find string label for type ", citeproptype)
    if citeproptype == Bool
        "boolean"
    elseif citeproptype <: Number
        "number"
    elseif citeproptype <: AbstractString
        "string"
    elseif citeproptype == Cite2Urn
        "cite2urn"
    elseif citeproptype == CtsUrn
        "ctsurn"
    else 
        nothing
    end
end

function typeforcprop(cprop::AbstractString)
    dict = Dict(
        "boolean" => Bool,
        "number" => Number,
        "string" => AbstractString,
        "cite2urn" => Cite2Urn,
        "ctsurn" => CtsUrn
    )
    lc = lowercase(cprop)
    if haskey(dict, lc) 
        dict[lc]
    else
        throw(DomainError(cprop, "No mapping to Julia type for string $(cprop)"))
    end
end

"""Instantiate a PropertyDefinition from delimited-text source.
$(SIGNATURES)
Required for `CexTrait`.
"""
function fromcex(traitvalue::PropDefCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)
    fields = split(cexsrc, delimiter)
    urn = Cite2Urn(fields[1])

    labl = fields[2]
    jtype = typeforcprop(fields[3])
    auths = split(fields[4], ",")
    PropertyDefinition(urn, labl, jtype, auths)

end
