# List of branching factors
D = [2, 3, 3, 5, 2]
L = length(D)
N = prod(D)

I = eye(Int32, N)

# Construct weight matrices
W = Array{Array{Int32, 2}, 1}()
pv = 1
for d in D
	push!(W, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
	pv *= d
end

# Create Cartesian product of {0,...,L} and {1,...,N}
cart = Array{Tuple{Int64, Int64}, 1}()
for j in 0:L
        for k in 1:N
                push!(cart, (j, k))
        end
end

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Print values
println("Test: $(test1)")
println("Number of Paths: $(numpaths)")
