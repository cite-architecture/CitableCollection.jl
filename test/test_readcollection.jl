


@testset "Test reading collection catalog and data from delimited text" begin
    cexdata = """#!citecollections

    URN|Description|Labelling property|Ordering property|License
    urn:cite2:hmt:vaimg.v1:|Images of the Venetus A manuscriptscript|urn:cite2:hmt:vaimg.v1.caption:||CC-attribution-share-alike


    #!citeproperties

    Property|Label|Type|Authority list
    urn:cite2:hmt:vaimg.v1.urn:|Image URN|Cite2Urn|
    urn:cite2:hmt:vaimg.v1.caption:|Caption|String|
    urn:cite2:hmt:vaimg.v1.rights:|License for binary image data|String|CC-attribution-share-alike,public domain


    #!citedata
    // Images of the Venetus A manuscript:

    urn|caption|rights
    urn:cite2:hmt:vaimg.v1:IMG1r|Folio 1 recto of the Venetus A, photographed in natural light|CC-attribution-share-alike
    urn:cite2:hmt:vaimg.v1:IMG1v|Folio 1 verso of the Venetus A, photographed in natural light|CC-attribution-share-alike
"""

    datalines = CitableCollection.catalogdata(blocks(cexdata))
    @test length(datalines) == 1
    caturns = CitableCollection.collectionurns(datalines)
    @test length(caturns) == 1
    expectedUrn = Cite2Urn("urn:cite2:hmt:vaimg.v1:")
    @test caturns[1] == expectedUrn

    proplines = CitableCollection.propertydata(blocks(cexdata))
    @test length(proplines) == 3
    propurns = CitableCollection.propertyurns(proplines)
    @test propurns[1] == expectedUrn
    
    @test CitableCollection.blocksagree(caturns, propurns)

    propsdf = CitableCollection.propertyconfigs(proplines)
    @test nrow(propsdf) == 3

    datadf = collectiondf()
end