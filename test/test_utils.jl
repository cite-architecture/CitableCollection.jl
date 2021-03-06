@testset "Test conversion of types to CITE type labels" begin
    pairs = [
        (Cite2Urn, "cite2urn"),
        (CtsUrn, "ctsurn"),
        (Bool, "boolean"),
        (Int64, "number"),
        (String, "string")
    ]
    for pr in pairs
        @test CitableCollection.cpropfortype(pr[1]) == pr[2]
    end
end

@testset "Text conversion of CITE type labels to Julia types" begin
    @test_throws DomainError CitableCollection.typeforcprop("phony")

    pairs = [
        (Cite2Urn, "Cite2Urn"),
        (CtsUrn, "CtsUrn"),
        (Bool, "Boolean"),
        (Number, "number"),
        (AbstractString, "string")
    ]
    for pr in pairs
        @test CitableCollection.typeforcprop(pr[2]) == pr[1]
    end
end


@testset "Test utilities for PropertyDefinition" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    cexsrc = read(f, String)
    props = CitableCollection.propertiesfromcex(cexsrc)
    @test length(props) == 3
    @test props isa Vector{PropertyDefinition}


    expected = [Cite2Urn("urn:cite2:hmt:vaimg.v1:")]    
    @test CitableCollection.collectionsfromprops(props) == expected

    collurn = Cite2Urn("urn:cite2:hmt:vaimg.v1:")
    expected =  ["urn","caption", "rights"]
    @test CitableCollection.propertyids(props, collurn) == expected
end


@testset "Test adding URN column to a table" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    blk = blocks(f, FileReader, "citedata")[1]
    t1 = CSV.File(IOBuffer(join(blk.lines, "\n")), delim = "|") |> Table
    t2 = CitableCollection.citetable(t1)
    
    @test propertynames(t1) == propertynames(t2)
    @test Tables.columntype(t1, :urn) <: AbstractString
    @test Tables.columntype(t2, :urn) == Cite2Urn
 
end


@testset "Test converting column types in strictly parsed CEX" begin
    f = joinpath(pwd(), "data", "hmtextract.cex")
    cexsrc = read(f, String)
    rdc = fromcex(cexsrc, RawDataCollection, strict = false, delimiter = "#")[2]
    rawschema = Tables.schema(rdc)


    propslist = CitableCollection.propertiesfromcex(cexsrc, "#") 
    rdcprops = filter(prop -> urncontains(urn(rdc), urn(prop)), propslist)
    converted = CitableCollection.converttypes(rdc, rdcprops)
    convertedschema = Tables.schema(converted)

    @test rawschema.names == convertedschema.names
    @test rawschema.names[2] == :image
    @test rawschema.types[2] == String
    @test_broken convertedschema.types[2] == Cite2Urn


end

@testset "Test collection reader utilities" begin
    f = joinpath(pwd(), "data", "hmtextract.cex")
    cexsrc = read(f, String)
    strictly = CitableCollection.strictread(cexsrc, "#")[2]
    lazily = CitableCollection.lazyread(cexsrc, "#")[2]
    @test Tables.schema(strictly).names == Tables.schema(lazily).names
    @test_broken Tables.schema(strictly).types != Tables.schema(lazily).types
    @test Tables.schema(lazily).types[2] == String
    @test_broken Tables.schema(strictly).types[2] == Cite2Urn


end



@testset "Test comparison of column names in schemata and property lists" begin
    f = joinpath(pwd(), "data", "hmtextract.cex")
    cexsrc = read(f, String)
    rdc = fromcex(cexsrc, RawDataCollection, strict = false, delimiter = "#")[2]
    propslist = CitableCollection.propertiesfromcex(cexsrc, "#") 
    rdcprops = filter(prop -> urncontains(urn(rdc), urn(prop)), propslist)
    @test CitableCollection.columnnamesok([rdc], rdcprops)
    @test CitableCollection.columnnamesok([rdc], rdcprops[2:end]) == false
end
