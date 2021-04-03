# FastModulo

This package contains a basic Julia implementation of the algorithm given in this paper:
[Lemire, Daniel, Owen Kaser, and Nathan Kurz. "Faster remainder by direct computation: Applications to compilers and software libraries." Software: Practice and Experience 49.6 (2019): 953-970.](https://arxiv.org/abs/1902.01961)

It computes remainders for `a mod m`, where `a` and `m` are 32 bit integers, and we are computing multiple remainders for a given modulus `m`. It's pretty quick, faster than Julia's native `mod` for this specific problem, although not as fast as their C implementation.

This package defines a type `Mod`, that holds the result of the precomputation, and two functions, `fastmod` and `fastmod!`. The latter is an in-place version for arrays which is currently not faster than just looping `fastmod`.

Usage:
```
using FastModulo

julia> modm = Mod(UInt32(5))  #compute mod 5
Mod(0x00000005, 0x3333333333333334)

julia> fastmod(UInt32(24),modm)
0x00000004

```
