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
include("fastmod.jl")
include("performance.jl")