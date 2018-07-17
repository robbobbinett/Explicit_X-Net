# List of branching factors
D = [2, 3, 3, 5, 2]
L = length(D)
N = prod(D)

I = eye(N)::Array{Int32, 2}

# Construct weight matrices
W = Array{Array{Int32, 2}, 1}()
pv = 1
for d in D
	push!(W, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
	pv *= d
end

# Import networkx for graph visualization
using PyPlot, PyCall
@pyimport networkx as nx

# Figure for .png export
f = figure()
ax = gca()

# Create Cartesian product of {0,...,L} and {1,...,N}
cart = Array{Tuple{Int64, Int64}, 1}()
for j in 0:L
        for k in 1:N
                push!(cart, (j, k))
        end
end

# Initialize graph
B = nx.DiGraph()
B[:add_nodes_from](cart)

# Iterate over adjacency matrices
for j in 1:L
	w = W[j]

	# Create edges
	for row in 1:N
		for col in 1:N
			if w[row, col] == 1
				B[:add_edge]((j-1, row), (j, col))
			end
		end
	end
end

# Positions of nodes in graph
posB = Dict()
for node in B
	posB[node] = (node[1], node[2])
end

# Export .png
nx.draw(B, pos=posB, node_size=100)
savefig("exampleNN.png", format="png")

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Print values
println("Test: $(test1)")
println("Number of Paths: $(numpaths)")
