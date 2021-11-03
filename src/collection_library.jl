
struct CollectionLibrary
    catalog::DataFrame
    datasets
end


"""Parse CEX source data into a CollectionLibrary.
$(SIGNATURES)

`cexsrc` must have at least one `citecollections` block and one `citeproperties` block
cataloging the collection, and at least one `citedata` block with data records.
"""
function collectionlibrary(cexsrc, delim = "|"; limitto = nothing)
    catdf = catalogdf(cexsrc; delimiter = delim)
    colldfs = collectiondfs(cexsrc, catdf, delim; limitto=limitto)
    CollectionLibrary(catdf, colldfs)
end