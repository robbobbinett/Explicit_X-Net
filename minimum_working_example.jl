# List of branching factors
D = [2, 3, 11]

# List of pseudo-branching factors which do not contribute to N
Dprime = [5, 7]

# List of indices for the insertion of layers corresponding to
# elements of Dprime
inds = [3, 4]

L = length(D)+length(Dprime)
N = prod(D)

I = eye(Int32, N)

# Construct weight matrices
W = Array{Array{Int32, 2}, 1}()
pv = 1
for d in D
	push!(W, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
	pv *= d
end

# Insert weight matrices corresponding to elements of Dprime
for (d, ind) in zip(Dprime, inds)
	w = sum([circshift(I, (j, 0)) for j in 0:(d-1)])
	insert!(W, ind, w)
end

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Print values
println("Test: $(test1)")
println("Number of Paths: $(numpaths)")
