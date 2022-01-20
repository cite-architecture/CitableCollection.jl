@testset "Test lazy construction of `RawDataCollection`s" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    rdcs1 = fromcex(f, RawDataCollection, FileReader, strict = false)
    @test length(rdcs1) == 1
    rdcs2 = fromcex(cexsrc, RawDataCollection, strict = false)
    @test rdcs1 == rdcs2

    rdc = rdcs1[1]
    @test urn(rdc) == Cite2Urn("urn:cite2:hmt:vaimg.v1:")
    @test label(rdc) == "Citable collection of 2 items with automatically inferred schema."
    @test urntype(rdc) == Cite2Urn
end