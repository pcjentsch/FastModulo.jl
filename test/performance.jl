


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
function bench_fastmod_small(a,b,c)
    for m in b
        modm = SmallMod(m)
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

@testset "FastMod" begin
    a = sample(1:typemax(UInt32),100_000)
    b = sample(1:typemax(UInt32),100)
    c1 = similar(a)
    c2 = similar(a)
     
    bench_fastmod = @benchmark bench_fastmod($a,$b,$c2)
    bench_mod = @benchmark bench_mod($a,$b,$c1)
    display(bench_fastmod)
    display(bench_mod)
    @test minimum(bench_fastmod.times) < minimum(bench_mod.times)/2 #should be at least twice as fast for these sizes
end
@testset "FastMod_array" begin
    a1 = convert(Vector{UInt32},sample(1:typemax(UInt32),100_000))
    a2 =convert(Vector{UInt32},sample(1:typemax(UInt32),100_000))
    b =convert(Vector{UInt32},sample(1:typemax(UInt32),100))
    bench_fastmod = @benchmark bench_fastmod_vec($a1,$b)
    bench_mod = @benchmark bench_mod_vec($a2,$b)
    display(bench_fastmod)
    display(bench_mod)
    @test minimum(bench_fastmod.times) < minimum(bench_mod.times)/2 #should be at least twice as fast for these sizes
end

# @testset "FastMod_small" begin
#     a = convert.(UInt8,collect(1:255))
#     a_big = convert.(UInt32,collect(1:255))
#     b = convert.(UInt8,collect(2:255))
#     b_big = convert.(UInt32,collect(2:255))
#     c1 = similar(a)
#     c2 = similar(a)
     
#     benchmark_fastmod_small = @benchmark bench_fastmod_small($a,$b,$c2)
#     benchmark_fastmod = @benchmark bench_fastmod($a_big,$b_big,$c2)
#     benchmark_mod = @benchmark bench_mod($a,$b,$c1)
#     display(benchmark_fastmod_small)
#     display(benchmark_fastmod)
#     display(benchmark_mod)
#     @test minimum(benchmark_fastmod_small.times) < minimum(benchmark_mod.times)/2 #should be at least twice as fast for these sizes
# end
