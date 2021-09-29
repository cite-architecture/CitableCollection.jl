


@testset "Test reading collection catalog from delimited text" begin
    catdata = """#!citecollections

URN|Description|Labelling property|Ordering property|License
urn:cite2:hmt:vaimg.v1:|Images of the Venetus A manuscriptscript|urn:cite2:hmt:vaimg.v1.caption:||CC-attribution-share-alike


#!citeproperties

Property|Label|Type|Authority list
urn:cite2:hmt:vaimg.v1.urn:|Image URN|Cite2Urn|
urn:cite2:hmt:vaimg.v1.caption:|Caption|String|
urn:cite2:hmt:vaimg.v1.rights:|License for binary image data|String|CC-attribution-share-alike,public domain
"""
    
end