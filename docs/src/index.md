# CitableCollection

> *Work with collections of citable objects.*


## Quick example

### A cataloged collection

A `CatalogedCollection` records metadata about a dataset, including the type of data represented by each property of an object.

The `catalogdf` function creates a DataFrame for a catalog from a CEX source that must include at least one `citecollections` block and one `citeproperties` block.  This example builds a DataFrame with the catalog data for a single collection.


```jldoctest citecoll
using CitableCollection, DataFrames
collectionmetadata = """#!citecollections

URN|Description|Labelling property|Ordering property|License
urn:cite2:hmt:vaimg.v1:|Images of the Venetus A manuscriptscript|urn:cite2:hmt:vaimg.v1.caption:||CC-attribution-share-alike


#!citeproperties

Property|Label|Type|Authority list
urn:cite2:hmt:vaimg.v1.urn:|Image URN|Cite2Urn|
urn:cite2:hmt:vaimg.v1.caption:|Caption|String|
urn:cite2:hmt:vaimg.v1.rights:|License for binary image data|String|CC-attribution-share-alike,public domain
"""
catdf = catalogdf(collectionmetadata)
nrow(catdf)

# output

1
```



### Collection data

