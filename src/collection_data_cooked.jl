
"""Read data for citable collections from `cexsrc`.
Determine types of columns for each table from configuration
in `citeproperties` section of the CEX.
$(SIGNATURES)
If any columns of a collection are not configured, it is an error.
"""
function strictread(cexsrc::AbstractString, delimiter = "|")
    lazyread(cexsrc, delimiter)
end
