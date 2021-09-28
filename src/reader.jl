

# CSV.File(map(IOBuffer,data)) |> DataFrame
# CSV.File(map(IOBuffer, [str]), delim="|") |> DataFrame


"""Parse CEX source data into a catalog of `CitableCollection`s.
$(SIGNATURES)

`cexsrc` must have at least one `citecollections` block and one `citeproperties` block.
"""
function catalog(cexsrc, delim = "|")
    allblocks = blocks(cexsrc)
end