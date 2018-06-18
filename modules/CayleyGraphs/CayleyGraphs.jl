module CayleyGraphs
    export Cfield, cfield_maker, generates, randH

    import Base: +, isless, isequal, ==, hash, zero
    import Combinatorics: powerset

    abstract type cfield end

    # Immutable type for elements of {0,1}^n for some n
    immutable Cfield <: cfield
        arr::Array{Int32, 1}
    end

    # Immutable type for general additive identity
    immutable ZeroCfield <: cfield end

    # Define elementwise addition modulo 2
    +(x::Cfield, y::Cfield) = Cfield(mod.((x.arr+y.arr)::Array{Int32, 1}, 2))
    +(x::ZeroCfield, y::Cfield) = y
    +(x::Cfield, y::ZeroCfield) = x
    +(x::ZeroCfield, y::ZeroCfield) = x

    # Signify additive identity
    zero(Cfield) = ZeroCfield()
    zero(x::Cfield) = Cfield(zeros(Int32, length(x.arr)))
    zero(ZeroCfield) = ZeroCfield()
    zero(x::ZeroCfield) = x

    # Treat the array as a tuple when checking equality
    isequal(x::Cfield, y::Cfield) = repr(x) == repr(y)
    ==(x::Cfield, y::Cfield) = isequal(x,y)
    isequal(x::ZeroCfield, y::Cfield) = zero(y) == y
    ==(x::ZeroCfield, y::Cfield) = isequal(x::ZeroCfield, y::Cfield)
    isequal(x::Cfield, y::ZeroCfield) = x == zero(y)
    ==(x::ZeroCfield, y::Cfield) = isequal(x::Cfield, y::ZeroCfield)
    isequal(x::ZeroCfield, y::ZeroCfield) = true
    ==(x::ZeroCfield, y::ZeroCfield) = true

    # Allow for lexicographic sorting
    isless(x::Cfield, y::Cfield) = repr(x.arr) < repr(y.arr)
    isless(x::ZeroCfield, y::Cfield) = (y == zero(y)) ? false : true
    isless(x::Cfield, y::ZeroCfield) = false
    isless(x::ZeroCfield, y::ZeroCfield) = false

    # Identify hash with hash of repr
    hash(x::ZeroCfield) = hash(repr(x))
    hash(x::Cfield) = (x == zero(x)) ? hash(ZeroCfield) : hash(repr(x))

    # function mapping element of power set of {1,...,n} bijectively to {0,1}^n
    function inj(x::Array{Int64, 1}, n::Int64)
        a = zeros(Int32, n)
        for i in x
            a[i] = 1
        end
        return Cfield(a)
    end

    # Create {0,1}^n as lexicographically sorted Array{Cfield, 1}
    function cfield_maker(n::Int64)
        ps = collect(powerset(1:n))
        F = map(x -> inj(x, n), ps)
        sort!(F)
        return F
    end

    # Check if a set of elements (additively) generates the field
    function generates(H::Set{Cfield}, k::Int64)
        HH = collect(H)
        ps = collect(powerset(HH))
        FF = map(x -> sum(x), ps)
        FFF = Set{Cfield}()
        for ff in FF
            push!(FFF, ff)
        end
        return (length(FFF) == k)
    end

    # Create random generating set H of {0,1}^n with m elements. When m=n, this is a basis of {0,1}^n.
    function randH(F::Array{Cfield, 1}, m::Int64)
        H = Set{Cfield}()
        while length(H) < m
            push!(H, F[rand(1:end)])
        end
        if generates(H, length(F))
            return H
        else
            return randH(F, m)
        end
    end

    # Make map from element of F to its numerical index by lexicographic order
    indF(x::Cfield, F::Array{Cfield, 1}) = find(y -> (y == x), F)[1]


    # Make weights matrix from set of generators
    function matrix_from_H(H::Set{Cfield}, F::Array{Cfield, 1})
        # Construct edges
        edges = Dict{Cfield, Set{Cfield}}()
        for f in F
            ee = map(h -> (f+h), H)
            edges[f] = ee
        end

        # Construct (sparse) weights matrix from row and column indices R, C
        R = Array{Int64, 1}()
        C = Array{Int64, 1}()
        for f in F
            for e in edges[f]
                push!(R, indF(f, F))
                push!(C, indF(e, F))
            end
        end
        # Construct value vector V for sparse construction
        V = map(x -> 1::Int64, R)
        mat = sparse(R, C, V)
        return mat
    end

# End module
end
