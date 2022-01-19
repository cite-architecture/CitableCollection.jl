@testset "Test conversion of types to CITE type labels" begin
    pairs = [
        (Cite2Urn, "cite2urn"),
        (CtsUrn, "ctsurn"),
        (Bool, "boolean"),
        (Int64, "number"),
        (String, "string")
    ]
    for pr in pairs
        @test CitableCollection.cpropfortype(pr[1]) == pr[2]
    end
end

@testset "Text conversion of CITE type labels to Julia types" begin
    @test_throws DomainError CitableCollection.typeforcprop("phony")

    pairs = [
        (Cite2Urn, "Cite2Urn"),
        (CtsUrn, "CtsUrn"),
        (Bool, "Boolean"),
        (Number, "number"),
        (AbstractString, "string")
    ]
    for pr in pairs
        @test CitableCollection.typeforcprop(pr[2]) == pr[1]
    end
end

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
        String,
        ["CC-attribution-share-alike","public domain"]
    )
    @test length(authlist(rightsprop)) == 2
end


@testset "Test URN comparable trait of CollectionProperty" begin
    uprop = PropertyDefinition(
        Cite2Urn("urn:cite2:hmt:vaimg.v1.urn:"),
        "Image URN",
        Cite2Urn,
        []
    )
    rightsprop = PropertyDefinition(
        Cite2Urn("urn:cite2:hmt:vaimg.v1.rights:"),
        "License for binary image data",
        String,
        ["CC-attribution-share-alike","public domain"]
    )
    collurn = Cite2Urn("urn:cite2:hmt:vaimg.v1:")
    @test urnequals(uprop,rightsprop) == false
    @test urncontains(uprop, rightsprop) == false
    @test urncontains(collurn, urn(uprop))
    @test urnsimilar(uprop, rightsprop)

end


@testset "Test CEX trait of CollectionProperty" begin
    rightsprop = PropertyDefinition(
        Cite2Urn("urn:cite2:hmt:vaimg.v1.rights:"),
        "License for binary image data",
        String,
        ["CC-attribution-share-alike","public domain"]
    )
    expectedcex = "urn:cite2:hmt:vaimg.v1.rights:|License for binary image data|string|CC-attribution-share-alike,public domain"
    @test cex(rightsprop) == expectedcex


    @test fromcex(expectedcex, PropertyDefinition) == rightsprop
end