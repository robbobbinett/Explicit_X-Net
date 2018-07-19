# List of branching factors which contribute to N
D = [2, 3, 11]

# List of branching factors which do not contribute to N
Dprime = [5, 7]

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
pv = 1
for d in Dprime
	push!(W, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
	pv *= d
end

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Print values
println("Test: $(test1)")
println("Number of Paths: $(numpaths)")
