

@testset "Test structure of a `CiteCatalogEntry`" begin
    urn = Cite2Urn("urn:cite2:hmt:e3pages.v1:")
    label = "Pages of the Escorial Y 1.1 manuscript"
    labelurn = Cite2Urn("urn:cite2:hmt:e3pages.v1.label:")
    sequenceurn = Cite2URN("urn:cite2:hmt:e3pages.v1.sequence:") 
    license = "CC-attribution-share-alike"
    catentry = CiteCatalogEntry(urn, label, labelurn, sequence8rn, license)

end

@testset "Test citable trait of a `CiteCatalogEntry" begin
    #
end


@testset "Test URN comparison trait of a `CiteCatalogEntry" begin
    #
end

@testset "Test CEX trait of a `CiteCatalogEntry" begin
    #
end
