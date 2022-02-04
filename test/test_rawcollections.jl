@testset "Test lazy construction of `RawDataCollection`s with `CitableTrait`" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    rdcs1 = fromcex(f, RawDataCollection, FileReader, strict = false)
    @test length(rdcs1) == 1

    cexsrc = read(f, String)
    rdcs2 = fromcex(cexsrc, RawDataCollection, strict = false)
    @test rdcs1 == rdcs2

    rdc = rdcs1[1]
    @test urn(rdc) == Cite2Urn("urn:cite2:hmt:vaimg.v1:")
    @test label(rdc) == "Citable collection of 2 items with automatically inferred schema."
    @test urntype(rdc) == Cite2Urn
end

@testset "Test CEX trait of `RawDataCollection`"  begin
    f = joinpath(pwd(), "data", "hmtextract.cex")
    lazylist =  fromcex(f, RawDataCollection, FileReader, delimiter = "#", strict = false)
    strictlist =  fromcex(f, RawDataCollection, FileReader, delimiter = "#")
    @test length(lazylist) == length(strictlist)
end

@testset "Test table properties and five key functions of `RawDataCollection" begin
    f = joinpath(pwd(), "data", "hmtextract.cex")
    rdc = fromcex(f, RawDataCollection, FileReader, delimiter = "#")[2]
    @test eltype(rdc) <: NamedTuple
    @test urn(rdc) == Cite2Urn("urn:cite2:hmt:e3pages.v1:")
    @test label(rdc) == "Citable collection of 5 items with schema specified from `citeproperties` settings."
    @test Tables.schema(rdc).names == (:sequence, :image, :urn, :rv, :label)
    @test length(rdc) == 5
    @test typeof(collect(rdc))  <: Vector
    # filter
end

@testset "Test URN filtering on `RawDataCollection" begin
# urnequals
# urncontains
# urnsimilar
    f = joinpath(pwd(), "data", "hmtextract.cex")
    rdc = fromcex(f, RawDataCollection, FileReader, delimiter = "#")[2]
    collurn =  Cite2Urn("urn:cite2:hmt:e3pages:")
    @test isempty(urnequals(collurn, rdc))
    @test length(urncontains(collurn, rdc)) == 5
    @test length(urnsimilar(collurn, rdc)) == 5
end

@testset "Test case-insensitive labelling of column names in reading from CEX for `RawDataCollection" begin
    f = joinpath(pwd(), "data", "hmt-authlists", "astronomy.cex") 
    rdc = fromcex(f, RawDataCollection, FileReader)
    @test rdc isa Vector{RawDataCollection}

end