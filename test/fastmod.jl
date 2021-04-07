
@testset "fastmod" begin
    a = convert(Vector{UInt32},sample(1:typemax(UInt32),10_000))
    a2 = copy(a)
    b = convert(Vector{UInt32},sample(1:typemax(UInt32),1_000))
     
    @testset for m in b
            modm = Mod(m)
            for i in eachindex(a)
                c1 = mod(a[i],m)
                c2 = fastmod(a[i],modm)
                @test c1==c2
            end
    end
end


@testset "fastmod!" begin
    a = convert(Vector{UInt32},sample(1:typemax(UInt32),10_000))
    a2 = copy(a)
    b = convert(Vector{UInt32},sample(1:typemax(UInt32),1_000))
     
    @testset for m in b
        modm = Mod(m)
        fastmod!(a,modm)
        inplace_mod!(a2,m)
        @test all(a.==a2)
    end
end

@testset "divtest" begin
    a = convert(Vector{UInt32},sample(1:typemax(UInt32),10_000))
    a2 = copy(a)
    b = convert(Vector{UInt32},sample(1:typemax(UInt32),1_000))
    c1 = similar(a)
    c2 = similar(a)
     
    @testset for m in b
        modm = Mod(m)
        for i in eachindex(a)
            c1[i] = (mod(a[i],m) == 0)
            c2[i] = (divtest(a[i],modm))
        end
        @test all(c1.==c2)
    end
end
