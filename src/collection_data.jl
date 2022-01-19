abstract type AbstractCiteCollection end

struct CiteCollection{T}
    data::T
end

# Generator to convert urn type provided you know what column is what
#  Table((urn=Cite2Urn(row.urn), caption=row.caption, rights = row.rights) for row in cc.data)