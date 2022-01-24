# CitableCollection

## Overview

Collections of citable objects are generic tabular data structures with a schema that meet two specific requirements of the CITE architecture:

1. they can be filtered using URN logic
2. they can be serialized delimited text following the CEX format

## TL;DR

```@setup eg
root = pwd() |> dirname |> dirname
```

Read sample data file in `test/data` directory.

```@example eg
using CitableBase, CitableCollection
f = joinpath(root, "test", "data", "collectionexample.cex")
catalogedcollections = fromcex(f, CatalogedCollection, FileReader)
```