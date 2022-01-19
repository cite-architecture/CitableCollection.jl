@testset "Test citable trait of CollectionProperty" begin
    urnprop = PropertyDefinition(
        Cite2Urn("urn:cite2:hmt:vaimg.v1.urn:"),
        "Image URN",
        Cite2Urn,
        []
    )

    @test urn(urnprop) == Cite2Urn("urn:cite2:hmt:vaimg.v1.urn:")
    @test label(urnprop) == "Image URN"
    @test citetype(urnprop) == Cite2Urn
    @test authlist(urnprop) |> isempty


    rightsprop = PropertyDefinition(
        Cite2Urn("urn:cite2:hmt:vaimg.v1.rights:"),
        "License for binary image data",
        "String",
        ["CC-attribution-share-alike","public domain"]
    )
    @test length(authlist(rightsprop)) == 2
end


@testset "Test URN comparable trait of CollectionProperty" begin
    
end


@testset "Test CEX trait of CollectionProperty" begin
    
end