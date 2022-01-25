# A more detailed walkthrough

```@setup walk
root = pwd() |> dirname |> dirname
```

Throughout these examples, we'll use a small sample file called `hmtextract.cex` in the `test/data` directory of this repository.

Since the file is in CEX format, we'll use the `fromcex` function from `CitableBase` to create different kinds of objects in the `CitableCollection` package.

```@example walk
f = joinpath(root, "test", "data", "hmtextract.cex")
using CitableBase, CitableCollection
```

## Reading a catalog of collections

We can read data in `citecollections` blocks into a single catalog comprising all collections cataloged in the CEX source.

```@example walk
catalog = fromcex(f, CiteCollectionCatalog, FileReader, delimiter = "#")
```

The catalog is a citable collection.  Let's get an idea of what's in it.

```@example walk
for coll in catalog
    println(coll)
end
```

## Reading tables of data


### Strict parsing

We can read data from `citedata` blocks into a series `RawDataCollection`s.  By default, the `fromcex` function will look for property definitions in a the `citeproperties` blocks of the CEX source, and require that each column in each table have a corresponding entry.  It will then use the information from `citeproperties` to create an appropriate schema for the resulting table.

```@example walk
strictly = fromcex(f, RawDataCollection, FileReader, delimiter = "#")
```

!!! note "Return types of `fromcex`"

    Note that while using `fromcex` to instantiate data for a`CiteCollectionCatalog` always returns a single `CiteCollectionCatalog` object, instantiating data for a `RawDataCollection` returns a *Vector* of `RawDataCollection`s, since each collection could have a different schema.


We can use the `Tables` package to examine the schema of a table.

```@example walk
using Tables
Tables.schema(strictly[2])
```

The metadata in the `cexproperties` block looks  like this:

```
#!citeproperties
Property#Label#Type#Authority list
urn:cite2:hmt:e3pages.v1.sequence:#Page sequence#Number#
urn:cite2:hmt:e3pages.v1.image:#TBS image#Cite2Urn#
urn:cite2:hmt:e3pages.v1.urn:#URN#Cite2Urn#
urn:cite2:hmt:e3pages.v1.rv:#Recto or Verso#String#recto,verso
urn:cite2:hmt:e3pages.v1.label:#Label#String#
```

Notice that `fromcex` choose appropriate Julia types for generic `Number` and `String` type indications, and converts the CEX data to URN types where they are indicated.


### Lazy parsing

The CEX standard says that any single CEX block constitutes a valid CEX source.  If you have a CEX source including `citedata` blocks, but no corresponding `citeproperties` blocks, you can still create `RawDataCollection`s from them by setting the `strict` parameter to `false`

```@example walk
lazily = fromcex(f, RawDataCollection, FileReader, delimiter = "#", strict = false)
``` 

When parsing lazily, `fromcex` converts the contents of a column named `urn` to type `Cite2Urn`; for other columns, it chooses types based on the column contents only.  Notice that this results in URN values being treated as string data.

```@example walk
Tables.schema(lazily[2])
```


## Reading cataloged collections from a CEX source


If your CEX source includes both `citeproperties` data for the schema of each collection and a catalog of metadata for your collections, you can create a Vector of `CatalogedCollection`s from the CEX.

```@example walk
cclist = fromcex(f, CatalogedCollection, FileReader, delimiter = "#")
```

Each `CatalogedCollection` has both a unique catalog entry and a raw data collection with a schema derived from its `citeproperties` information.

The schema will in other words is produced by strict parsing.

```@example walk
Tables.schema(cclist[2])
```

The associated catalog information makes the `CatalogedCollection` a citable object.

```@example walk
label(cclist[2])
```

```@example walk
urn(cclist[2])
```


## Querying collections


The `CatalogedCollection` is also a citable collection, so you can filter it using URN logic or by directly applying `filter`, `map`, or other generic Julia functions to it.

We could select data based on a version-agnostic URN, for example:

```@example walk
genericurn = dropversion(urn(cclist[2]))
urncontains(genericurn, cclist[2])
```

Since we have already examined the schema, we could use that knowledge to select only recto pages.

```@example walk
filter(r -> r.rv == "recto",  cclist[2])
```


`RawDataCollection`s (and therefore also `CatalogedCollection`s) make available all functions that can be applied to the `TypedTables.Table` type, so you can directly work with `for` loops, or operations like `group` and `reduce`, or you can use higher-order packages like `Query.jl`.