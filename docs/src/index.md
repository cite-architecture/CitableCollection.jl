# CitableCollection

## Overview

Collections of citable objects are generic tabular data structures with a schema.  They  meet two specific requirements of the CITE architecture:

1. they can be filtered using URN logic
2. they support serialization to and instantiation from delimited text following the CEX format

## TL;DR

```@setup eg
root = pwd() |> dirname |> dirname
```

Read a brief CEX sample with data in two cataloged collections from a sample data file in this repository's `test/data` directory.

```@example eg
using CitableBase, CitableCollection
f = joinpath(root, "test", "data", "hmtextract.cex")
catalogedcollections = fromcex(f, CatalogedCollection, FileReader, delimiter = "#")
```