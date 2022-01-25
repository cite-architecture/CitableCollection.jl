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


    @test cexserializable(cc)
    cexout = cex(cc)
    derived = fromcex(cexout, CatalogedCollection)
    @test [cc] == derived

    @test Tables.istable(cc)
    @test length(cc) == 2
    @test eltype(cc) <: NamedTuple
    @test Tables.rows(cc) |> typeof <: TypedTables.Table
    @test Tables.columns(cc) |> typeof <: NamedTuple

    @test collect(cc) |> typeof <: Vector
    @test filter(r -> contains(r.caption, "verso"), cc) |> length == 1

end
