export Hankel

immutable Hankel{T} <: AbstractArray{T, 2}
    c::Vector{T}
    n::Int
    function Hankel(c::Vector{T})
        length(c) % 2 == 0 && throw(ArgumentError("Number of elements should be odd"))
        new(c, div(length(c)+1,2))
    end
end
function Hankel(c::Vector)
    T = eltype(c)
    Hankel{T}(c)
end


getindex(H::Hankel, i::Int, j::Int) = H.c[i+j-1]
isassigned(H::Hankel, i::Int, j::Int) = i>=1 && i <= H.n && j>=1 && j <= H.n

size(H::Hankel, r::Int) = (r==1 || r==2) ? H.n :
    throw(ArgumentError("Invalid dimension $r"))
size(H::Hankel) = H.n, H.n

# Fast matrix x vector via fft()
function *{T}(A::Hankel{T},x::Vector{T})
    Toeplitz(A.c)*reverse(x)
end

function A_mul_B!{T}(y::StridedVector{T},A::Hankel{T},x::StridedVector{T})
    xx=reverse(x)
    return A_mul_B!(y,Toeplitz(A.c),xx)
end

function full{T}(H::Hankel{T})
    n=size(H, 1)
    M=Array(T, n, n)
    for i=1:n
        M[:,i] = H.c[i:i+n-1]
    end
    M
end
