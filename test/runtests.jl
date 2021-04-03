using FastModulo
using Test
using BenchmarkTools
using StatsBase
using LoopVectorization
function inplace_mod!(v,m) #fastest inplace mod I could think of to compare to
    @avx for i in eachindex(v)
        v[i] = mod(v[i],m)
    end
end

@testset "FastMod" begin
    a = convert(Vector{UInt32},sample(1:typemax(UInt32),1_000_000))
    a2 = copy(a)
    b = convert(Vector{UInt32},sample(1:typemax(UInt32),1_000))
    c1 = similar(a)
    c2 = similar(a)
     
    @testset for m in b
        modm = Mod(m)
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
function bench_mod(a,b,c)
    for m in b
        for i in eachindex(a)
            c[i] = mod(a[i],m)
        end
    end
end
function bench_fastmod(a,b,c)
    for m in b
        modm = Mod(m)
        for i in eachindex(a)
            c[i] = fastmod(a[i],modm)
        end
    end
end
function bench_fastmod_vec(a,b)
    for m in b
        modm = Mod(m)
        fastmod!(a,modm)
    end
end
function bench_mod_vec(a,b)
    for m in b
        inplace_mod!(a,m)
    end
end

@testset "FastMod performance" begin
    a = convert(Vector{UInt32},sample(1:typemax(UInt32),100_000))
    b = convert(Vector{UInt32},sample(1:typemax(UInt32),100))
    c1 = similar(a)
    c2 = similar(a)
     
    bench_fastmod = @benchmark bench_fastmod($a,$b,$c2)
    bench_mod = @benchmark bench_mod($a,$b,$c1)
    display(bench_fastmod)
    display(bench_mod)
    @test minimum(bench_fastmod.times) < minimum(bench_mod.times)/2 #should be at least twice as fast for these sizes

    a1 = convert(Vector{UInt32},sample(1:typemax(UInt32),100_000))
    a2 = copy(a)
    bench_fastmod = @benchmark bench_fastmod_vec($a1,$b)
    bench_mod = @benchmark bench_mod_vec($a2,$b)
    display(bench_fastmod)
    display(bench_mod)
    @test minimum(bench_fastmod.times) < minimum(bench_mod.times)/2 #should be at least twice as fast for these sizes

end
