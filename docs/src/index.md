# CitableCollection

> *Work with collections of citable objects.*


## Quick example

Citable objects belong to a cataloged collection.  We normally work with a single catalog with records for one or more collections, plus a set of data for each cataloged collection.  We can use Julia's `DataFrame` type for the catalog information, and a Vector of `DataFrame`s for one or more data sets.

While can work with either a catalog or a data set in distinct `DataFrame`s, the `CitableCollection` module also includes a `CollectionLibrary` structure that has members for a catalog DataFrame, and a Vector of DataFrame for data sets.

This page briefly shows:

1. how to read a catalog into a DataFrame
2. how to read datasets into a Vector of DataFrames
3. how to read both at once into a `CitableLibrary` from a single CEX source

### A cataloged collection

A `CatalogedCollection` records metadata about a single dataset, including the type of data represented by each property of an object.

We can read data about multiple cataloged collections with the `catalogdf` function. It creates a DataFrame for a catalog from a CEX source that must include at least one `citecollections` block and one `citeproperties` block.  This example builds a DataFrame with the catalog data for a single collection.


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

You can read data for one or more cataloged collections from CEX source. The result is a Vector of DataFrames.  This example has data for a single collection.


```jldoctest citecoll
datadbcex = """#!citedata
// Images of the Venetus A manuscript:

urn|caption|rights
urn:cite2:hmt:vaimg.v1:IMG1r|Folio 1 recto of the Venetus A, photographed in natural light|CC-attribution-share-alike
urn:cite2:hmt:vaimg.v1:IMG1v|Folio 1 verso of the Venetus A, photographed in natural light|CC-attribution-share-alike
"""
datadfs = collectiondfs(datadbcex, catdf)
length(datadfs)

# output

1
```

### Load a `CitableLibrary`

The `collectionlibrary` function reads from a CEX source that includes `citecatalog`, `citeproperties`, and `citedata` blocks.



```jldoctest citecoll
fullcex = """#!citecollections

URN|Description|Labelling property|Ordering property|License
urn:cite2:hmt:vaimg.v1:|Images of the Venetus A manuscriptscript|urn:cite2:hmt:vaimg.v1.caption:||CC-attribution-share-alike


#!citeproperties

Property|Label|Type|Authority list
urn:cite2:hmt:vaimg.v1.urn:|Image URN|Cite2Urn|
urn:cite2:hmt:vaimg.v1.caption:|Caption|String|
urn:cite2:hmt:vaimg.v1.rights:|License for binary image data|String|CC-attribution-share-alike,public domain

#!citedata
// Images of the Venetus A manuscript:

urn|caption|rights
urn:cite2:hmt:vaimg.v1:IMG1r|Folio 1 recto of the Venetus A, photographed in natural light|CC-attribution-share-alike
urn:cite2:hmt:vaimg.v1:IMG1v|Folio 1 verso of the Venetus A, photographed in natural light|CC-attribution-share-alike
"""
collectionlib = collectionlibrary(fullcex)
isa(collectionlib, CollectionLibrary)

# output

true
```