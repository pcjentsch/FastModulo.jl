# FastModulo

This small package contains a Julia implementation of the algorithm given in this paper:
[Lemire, Daniel, Owen Kaser, and Nathan Kurz. "Faster remainder by direct computation: Applications to compilers and software libraries." Software: Practice and Experience 49.6 (2019): 953-970.](https://arxiv.org/abs/1902.01961)

It computes remainders for `a mod m`, where `a` and `m` are *unsigned* 32 bit integers. It's pretty quick, faster than Julia's native `mod` if you need to compute multiple remainders for a constant modulus.

The implementation compiles to the same instructions given in the paper (for Clang) which I think is preeettty coooool.

There is also a `divtest` function, which returns `a mod m == 0`, again with positive, unsigned 32 bit integer types.

This package defines a type `Mod`, that holds the result of the precomputation, and two functions, `fastmod` and `fastmod!`. The latter is an in-place version for arrays which is currently not faster than just looping `fastmod`, but I guess it is convenient.

Usage:
```
using FastModulo

julia> modm = Mod(UInt32(5))  #compute mod 5
Mod(0x00000005, 0x3333333333333334)

julia> fastmod(UInt32(24),modm)
0x00000004

julia> divtest(UInt32(10),modm)
true

```

I have also included convenience functions that accept `Int` arguments.