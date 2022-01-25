@testset "Test definition of a `CatalogedCollection" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    colls = fromcex(f, CatalogedCollection, FileReader)
end

# Traits to test:
#
    # citable
    # urncomparison
    # cex
    # Also, should implement colleciton on data:
    #
    # urncomparison
    # 5 cite traits