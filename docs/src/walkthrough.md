# A more detailed walkthrough

```@setup walk
root = pwd() |> dirname |> dirname
```

## Reading cataloged collections from a CEX source
```@example walk
f = joinpath(root, "test", "data", "hmtextract.cex")
cclist = fromcex(f, CatalogedCollection, FileReader)
```

## Reading a raw data collection

- strict parsing of CEX
- lazy parsing of CEX


## Querying collections



## Schemas and catalog metadata

Each column of a table is defined by a `PropertyDefinition`. It is a citable object.

```@example walk
using CitableCollection, CitableBase, CitableObject
idproperty = PropertyDefinition(
    Cite2Urn("urn:cite2:hmt:vaimg.v1.urn:"),
    "Image URN",
    Cite2Urn,
    []
)
```    
```@example schema
urn(idproperty) 
```
```@example schema
label(idproperty)
```
```@example schema
citetype(idproperty)
```
For string values, it includes an optional authority list. 
```@example schema
authlist(idproperty)
```