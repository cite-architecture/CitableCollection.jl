@testset "Test utilities for PropertyDefinition" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    cexsrc = read(f, String)
    props = CitableCollection.propertiesfromcex(cexsrc)
    @test length(props) == 3
    @test props isa Vector{PropertyDefinition}


    expected = [Cite2Urn("urn:cite2:hmt:vaimg.v1:")]    
    @test CitableCollection.collectionsfromprops(props) == expected
end


@testset "Test adding URN column to a table" begin
    f = joinpath(pwd(), "data", "collectionexample.cex")
    blk = blocks(f, FileReader, "citedata")[1]
    t1 = CSV.File(IOBuffer(join(blk.lines, "\n")), delim = "|") |> Table
    t2 = CitableCollection.citetable(t1)
    
    @test propertynames(t1) == propertynames(t2)
    @test Tables.columntype(t1, :urn) <: AbstractString
    @test Tables.columntype(t2, :urn) == Cite2Urn
    
end