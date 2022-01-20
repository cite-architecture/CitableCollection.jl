@testset "Test utilities for PropertyDefinition" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    cexsrc = read(f, String)
    props = CitableCollection.propertiesfromcex(cexsrc)
    @test length(props) == 3
    @test props isa Vector{PropertyDefinition}


    expected = [Cite2Urn("urn:cite2:hmt:vaimg.v1:")]    
    @test CitableCollection.collectionsfromprops(props) == expected
end