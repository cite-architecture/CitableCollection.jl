@testset "Test CITE properties of a catalog" begin
    f = joinpath(pwd(), "data", "hmtextract.cex")
    catalog = fromcex(f, CiteCollectionCatalog, FileReader, delimiter = "#")
    @test catalog isa CiteCollectionCatalog
    @test citablecollection(catalog)

    # URN comparison
    @test urncomparable(catalog)
    unversioned = Cite2Urn("urn:cite2:hmt:e3pages:")
    @test isempty(urnequals(unversioned, catalog))
    @test length(urncontains(unversioned, catalog)) == 1
    @test length(urnsimilar(unversioned, catalog)) == 1
    
    # cex serialization
    @test cexserializable(catalog)
    cexout = cex(catalog)
    derived = fromcex(cexout, CiteCollectionCatalog)
    #@test derived == catalog

    # 5 table functions
end