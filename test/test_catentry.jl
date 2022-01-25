

@testset "Test structure and citable trait of a `CiteCatalogEntry`" begin
    collurn = Cite2Urn("urn:cite2:hmt:e3pages.v1:")
    colllabel = "Pages of the Escorial Y 1.1 manuscript"
    labelurn = Cite2Urn("urn:cite2:hmt:e3pages.v1.label:")
    sequenceurn = Cite2Urn("urn:cite2:hmt:e3pages.v1.sequence:") 
    license = "CC-attribution-share-alike"
    catentry = CiteCatalogEntry(collurn, colllabel, labelurn, sequenceurn, license)
    @test isordered(catentry)
    @test citable(catentry)
    @test urn(catentry) == Cite2Urn("urn:cite2:hmt:e3pages.v1:")
    @test urntype(catentry) == Cite2Urn
    @test label(catentry) == "Pages of the Escorial Y 1.1 manuscript"
end

@testset "Test CEX trait of a `CiteCatalogEntry" begin
    cexstr = "urn:cite2:hmt:e3pages.v1:#Escorial Y 1.1 manuscript#urn:cite2:hmt:e3pages.v1.label:#urn:cite2:hmt:e3pages.v1.sequence:#CC-attribution-share-alike"
    catentry = fromcex(cexstr, CiteCatalogEntry, delimiter = "#")
    @test catentry isa CiteCatalogEntry
    @test cex(catentry, delimiter = "#") == cexstr
end


@testset "Test URN comparison trait of a `CiteCatalogEntry" begin
    cexstr = "urn:cite2:hmt:e3pages.v1:#Escorial Y 1.1 manuscript#urn:cite2:hmt:e3pages.v1.label:#urn:cite2:hmt:e3pages.v1.sequence:#CC-attribution-share-alike"
    catentry = fromcex(cexstr, CiteCatalogEntry, delimiter = "#")
    @test urncomparable(catentry)
    
    collurn = Cite2Urn("urn:cite2:hmt:e3pages.v1:")
    @test urnequals(collurn, catentry)
    @test urncontains(collurn, catentry)
    @test urnsimilar(collurn, catentry)
end
