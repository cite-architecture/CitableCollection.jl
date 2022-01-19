"""A collection of citable data.
$(SIGNATURES)
"""
struct CiteCollection
    data::TypedTables.Table
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