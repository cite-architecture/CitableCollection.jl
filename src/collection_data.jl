"""A collection of citable data.
$(SIGNATURES)
"""
struct CiteCollection
    data::TypedTables.Table
end

struct CiteCollectionCex <: CexTrait end
function cextrait(::Type{CiteCollection})
    CiteCollectionCex()
end

function fromcex(traitvalue::CiteCollectionCex, cexsrc::AbstractString, T;
    delimiter = "|", configuration = nothing, strict = true)
    @warn("fromcex: read source type $(T)")
    if strict
        @warn("Strict CEX reading not yet implemented")
        strictread(cexsrc, T, delimiter)
    else
        @warn("Read lazily")
        lazyread(cexsrc, T, delimiter)
    end
end

function strictread(cexsrc::AbstractString, StringReader, delimiter = "|")
    lazyread(cexsrc, StringReader, delimiter)
end

#=
function lazyread(url::AbstractString, UrlReader, delimiter = "|")
    cexsrc = HTTP.get(url).body |> String
    lazyread(cexsrc, StringReader, delimiter)
end

function lazyread(f::AbstractString, FileReader, delimiter = "|")
    cexsrc = read(f, String)
    lazyread(cexsrc, StringReader, delimiter = "|")
end
=#

function lazyread(f::AbstractString, delimiter = "|")
    println("read string ")
end

# Generator to convert urn type provided you know what column is what
#  Table((urn=Cite2Urn(row.urn), caption=row.caption, rights = row.rights) for row in cc.data)
#
#
#=
for k in keys(r)
    println(r[k])
end
=#
#  r[Symbol("urn")]

#=
for r in cc.data
    for c in columnnames(cc.data)
        print(r[c], "|" ) 
    end
    println()
end
=#