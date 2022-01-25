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
    #
    # iterable
    # eltype
    # length
    # schema
    # filter
end

@testset "Test URN filtering on `RawDataCollection" begin
# urnequals
# urncontains
# urnsimilar

end