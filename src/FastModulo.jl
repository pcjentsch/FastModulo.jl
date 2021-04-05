module FastModulo
export SignedMod,Mod,fastmod,fastmod!, SmallMod
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
struct SmallMod
    modulo::UInt8
    modulo_inv::UInt16
    function SmallMod(d::UInt8)
        cmod::UInt16 = div(typemax(UInt16), d) + 1
        return new(d,cmod)
    end
    function SmallMod(d::Int)
        ud = convert(UInt8, d)
        return Mod(ud)
    end
end
# struct SignedMod
#     modulo::UInt32
#     modulo_inv::UInt64
#     function SignedMod(d::Int32)
#         pd = d < 0 ? -d : d
#         cmod::UInt64 = div(typemax(UInt64), d) + 1 + ((pd & (pd -1))==0 ? 1 : 0)
#         return new(pd,cmod)
#     end 
# end
@inline function fastmod(n::UInt32,T::Mod)::UInt32
    lowbits::UInt64 = T.modulo_inv * n
    return (convert(UInt128,lowbits) * T.modulo) >> 64
end
@inline function fastmod(n::Int,T::Mod)::UInt32
    return fastmod(convert(UInt32,n),T)
end
@inline function fastmod(n::UInt8,T::SmallMod)::UInt8
    lowbits::UInt16 = T.modulo_inv * n
    return (convert(UInt32,lowbits) * T.modulo) >> 16
end
# @inline function fastmod(n::Int32,T::SignedMod)::Int32
#     lowbits::UInt64 = T.modulo_inv * n
#     highbits::Int32 = (convert(UInt128,lowbits) * T.modulo) >> 64
#     return highbits  - ((T.modulo - 1) & (n >> 31))
# end

#not much better than a loop
function fastmod!(n::Array{UInt32,N},T::Mod) where N
    n .= (convert.(UInt128, T.modulo_inv .* n) .* T.modulo) .>> 64
end


end
