
# Relation of CEX data to `CitableCollection` data structures

In CEX, a table of *data* is represented by two blocks: the `citeproperties` block describes schemas, while the `citedata` block contains the table of data.

In addition, collections may be cataloged with further *metadata* in a `citecollections` block.

The `CitableCollection` package can instantiate four kinds of objects from a CEX source.

1. a `PropertyDefinition` defines name and data type of a single property or field of a data table.  This can be created from a single line of a `citeproperties` block.
2. a `RawDataCollection` associates the data from a `citedata` block with a schema.  If CEX source includes schema information for a given collection, the schema for the `RawDataCollection` is built using that.  If the `citedata` block does not have associated `citeproperties` information, a schema is inferred.  
3. a `CiteCollectionCatalog` catalogs one or more data sets with metadata associated with the collection as a whole, incuding a label or description, licensing information, and information about natural ordering, if any, of the data set.
4. a `CatalogedDataCollection` unites a single entry from a `CiteCollectionCatalog` with a `RawDataCollection`.

