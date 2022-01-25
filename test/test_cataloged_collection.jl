@testset "Test definition of a `CatalogedCollection" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    cc = fromcex(f, CatalogedCollection, FileReader)[1]
    @test citable(cc)
    @test urn(cc) == Cite2Urn("urn:cite2:hmt:vaimg.v1:")
    @test label(cc) == "Images of the Venetus A manuscript"
    @test urntype(cc) == Cite2Urn

    @test citablecollection(cc)
    @test urncomparable(cc)
    collurn = dropversion(urn(cc))
    @test urnequals(collurn, cc) |> isempty
    @test length(urncontains(collurn, cc)) == 2
    @test length(urnsimilar(collurn, cc)) == 2


end

# Traits to test:
#
    # urncomparison
    # cex
    # Also, should implement colleciton on data:
    #
    # 5 cite traits