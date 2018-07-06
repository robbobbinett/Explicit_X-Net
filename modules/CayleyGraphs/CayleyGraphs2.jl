module CayleyGraphs2
	export Cfield, F, x, S

	import Base: +, isless, isequal, ==, hash, zero
	import Combinatorics: powerset
	using AbstractAlgebra
	using Nemo

	# Dimension of binary vector space
	n = 4

	# Create Nemo finite field
	F, x = FiniteField(2, 1, "x")

	# Create AbstractAlgebra vector space from F
	S = MatrixSpace(F, n, 1)

	# Create class for implementation of Cailey modules
	immutable Cfield
		arr::Nemo.fq_nmod_mat
	end

	# Define zero element
	zero(Cfield) = Cfield(zero_matrix(F, n, 1))
	zero(x::Cfield) = zero(Cfield)

	# Define addition modulo 2
	+(x::Cfield, y::Cfield) = Cfield(x.arr + y.arr)

	# Define equality
	isequal(x::Cfield, y::Cfield) = (x.arr == y.arr)
	==(x::Cfield, y::Cfield) = isequal(x::Cfield, y::Cfield)

	# Set hash equal to hash of x.arr
	hash(x::Cfield) = hash(x.arr)

	# function mapping element of power set of {1,...,n} bijectively to {0,1}^n
	function inj(x::Array{Int64, 1}, n::Int64)
		a = zeros(Int32, n)
		for i in x
			a[i] = 1
		end
		return Cfield(S(a))
	end

	# Create {0,1}^n as sorted Array{Cfield, 1}
	# Sorted by default powerset sort: first by cardinality of set,
	# then sorted lexicographically by nonzero indices
	function cfield_maker(n::Int64)
		ps = collect(powerset(1:n))
		F = map(x -> inj(x, n), ps)
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

	# Create random generating set H of {0,1}^n with m elements.
	# When m=n, this set comprises a basis of {0,1}^n
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

# End module
end
