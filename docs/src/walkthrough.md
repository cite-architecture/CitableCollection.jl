# A more detailed walkthrough

```@setup walk
root = pwd() |> dirname |> dirname
```

## Reading cataloged collections from a CEX source
```@example walk
f = joinpath(root, "test", "data", "hmtextract.cex")
using CitableBase, CitableCollection
cclist = fromcex(f, CatalogedCollection, FileReader, delimiter = "#")
```

## Reading a raw data collection

- strict parsing of CEX

```@example walk
rawlist = fromcex(f, RawDataCollection, FileReader, delimiter = "#")
```

- lazy parsing of CEX

```@example walk
lazylist = fromcex(f, RawDataCollection, FileReader, delimiter = "#", strict = false)
``` 

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
```@example walk
urn(idproperty) 
```
```@example walk
label(idproperty)
```
```@example walk
citetype(idproperty)
```
For string values, it includes an optional authority list. 
```@example walk
authlist(idproperty)
```