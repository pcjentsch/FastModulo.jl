@testset "signed FastMod" begin
    a = convert(Vector{Int32},sample(typemin(Int32):typemax(Int32),1_000_000))
    a2 = copy(a)
    b = convert(Vector{Int32},sample(typemin(Int32):typemax(Int32),1_000))
    c1 = similar(a)
    c2 = similar(a)
     
    @testset for m in b
        modm = SignedMod(m)
        for i in eachindex(a)
            c1[i] = mod(a[i],m)
            c2[i] = fastmod(a[i],modm)
        end
        @test all(c1.==c2)
    end
    @testset for m in b
        modm = Mod(m)
        fastmod!(a,modm)
        inplace_mod!(a2,m)
        @test all(a.==a2)
    end
end