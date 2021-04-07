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
function bench_divtest(a,b,c)
    for m in b
        for i in eachindex(a)
            c[i] = (mod(a[i],m) == 0)
        end
    end
end
function bench_fast_divtest(a,b,c)
    for m in b
        modm = Mod(m)
        for i in eachindex(a)
            c[i] = divtest(a[i],modm)
        end
    end
end
@testset "unsigned modulus performance" begin
    a = convert.(UInt32,collect(100:100_000))
    b = convert.(UInt32,collect(2:1000))
    c1 = similar(a)
    c2 = similar(a)
     
    bench_fastmod = @benchmark bench_fastmod($a,$b,$c2)
    bench_mod = @benchmark bench_mod($a,$b,$c1)
    display(bench_fastmod)
    display(bench_mod)
    @test minimum(bench_fastmod.times) < minimum(bench_mod.times)/2 #should be at least twice as fast for these sizes
end


@testset "unsigned divtest performance" begin
    a = convert.(UInt32,collect(100:100_000))
    b = convert.(UInt32,collect(2:1000))
    c1 = BitVector(undef,length(a))
    c2 = BitVector(undef,length(a))
     
    bench_fastmod = @benchmark bench_fast_divtest($a,$b,$c2)
    bench_mod = @benchmark bench_divtest($a,$b,$c1)
    display(bench_fastmod)
    display(bench_mod)
    @test minimum(bench_fastmod.times) < minimum(bench_mod.times) #shockingly slow
end