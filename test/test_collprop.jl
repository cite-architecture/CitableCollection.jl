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

@test "Test comparison of type hierarchies of a `PropertyDefinition`" begin

comparablehierarchy(pd1::PropertyDefinition, pd2::PropertyDefinition)
    labelprop = PropertyDefinition(
        Cite2Urn("urn:cite2:citedemo:testprops.v1.label:"),
        "Label",
        String,
        []
    )
    substrprop = PropertyDefinition(
        Cite2Urn("urn:cite2:citedemo:testprops.v1.substringdata:"),
        "Data created by function yielding a substring",
        SubString{String} ,
        []
    )

    countprop = PropertyDefinition(
        Cite2Urn("urn:cite2:citedemo:testprops.v1.count:"),
        "Integer from counting something",
        Int64,
        []
    )
    @test CiteCollection.comparablehierarchy(labelprop, substrprop)
    @test CiteCollection.comparablehierarchy(labelprop, countprop) == false
end