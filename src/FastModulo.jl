module FastModulo
export Mod,fastmod,fastmod!
struct Mod
    modulo::UInt32
    modulo_inv::UInt64
    function Mod(d::UInt32)
        cmod::UInt64 = div(typemax(UInt64), d) + 1
        return new(d,cmod)
    end 
    # function Mod(d::Int32)
    #     pd::UInt32 =
    #     cmod::UInt64 = div(typemax(UInt64), d) + 1
    #     return new(d,cmod)
    # end
end
@inline function fastmod(n::UInt32,T::Mod)::UInt32
    lowbits::UInt64 = T.modulo_inv * n
    return (convert(UInt128,lowbits) * T.modulo) >> 64
end

#not much better than a loop of fastmod
function fastmod!(n::Array{UInt32,N},T::Mod) where N
    n .= (convert.(UInt128, T.modulo_inv .* n) .* T.modulo) .>> 64
end


end
