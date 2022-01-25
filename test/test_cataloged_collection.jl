@testset "Test definition of a `CatalogedCollection" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    cc = fromcex(f, CatalogedCollection, FileReader)[1]
    @test citable(cc)
    @test urn(cc) == Cite2Urn("urn:cite2:hmt:vaimg.v1:")
    @test label(cc) == "Images of the Venetus A manuscript"
    @test urntype(cc) == Cite2Urn

    @test citablecollection(cc)
    @test urncomparable(cc)



end

# Traits to test:
#
    # urncomparison
    # cex
    # Also, should implement colleciton on data:
    #
    # 5 cite traits