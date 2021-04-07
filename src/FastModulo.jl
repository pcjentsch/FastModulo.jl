module FastModulo
export Mod,fastmod,fastmod!,divtest
struct Mod
    modulo::UInt32
    modulo_inv::UInt64
    function Mod(d::UInt32)
        cmod::UInt64 = div(typemax(UInt64), d) + 1
        return new(d,cmod)
    end
    function Mod(d::Int)
        ud = convert(UInt32, d)
        return Mod(ud)
    end
end

@inline function fastmod(n::UInt32,T::Mod)::UInt32
    lowbits::UInt64 = T.modulo_inv * n
    return unsafe_trunc(UInt32,(unsafe_trunc(UInt128,lowbits) * T.modulo) >> 64)
end
@inline function fastmod(n::Int,T::Mod)
    return fastmod(convert(UInt32,n),T)
end
#not much better than a loop, need avx to support UInt32
function fastmod!(n::Array{UInt32,N},T::Mod) where N
    n .= (convert.(UInt128,(T.modulo_inv .* n)) .* T.modulo) .>> 64
end
@inline @fastmath function divtest(n::UInt32,T::Mod)::Bool
    return (n*T.modulo_inv) <= (T.modulo_inv - 1)
end
@inline function divtest(n::Int32,T::Mod)
    return divtest(convert(UInt32,n),T)
end


# struct SignedMod
#     modulo::UInt32
#     modulo_inv::UInt64
#     function SignedMod(d::Int32)
#         pd = d < 0 ? -d : d
#         cmod::UInt64 = div(typemax(UInt64), d) + 1 + ((pd & (pd -1))==0 ? 1 : 0)
#         return new(pd,cmod)
#     end 
#     function SignedMod(d::Int)
#         ud = convert(Int32, d)
#         return SignedMod(ud)
#     end
# end

# @inline function fastmod(n::Int,T::SignedMod)
#     return fastmod(convert(Int32,n),T)
# end
# @inline function fastmod(n::Int32,T::SignedMod)::Int32
#     lowbits::UInt64 = T.modulo_inv * n
#     highbits::Int32 = (convert(UInt128,lowbits) * T.modulo) >> 64
#     return convert(Int32,highbits  - ((T.modulo - 1) & (n >> 31)))
# end

end
