N = 16
L = 4
I = eye(N)

# Define vertical rotations of indices
Is = map(x -> circshift(I, (x, 0)), 0:9)
Is = Dict(zip(0:9, Is))

# Read in each of the layers
Wpre = map(x -> eval(parse(x)), ARGS)
W = map(x -> sum([Is[ind] for ind in x]), Wpre)

# Create name for saving files from input
name = string(Wpre)

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

posB = Dict()
for node in B
	posB[node] = (node[1], node[2])
end

nx.draw(B, pos=posB, node_size=100)
savefig(name*"NN.png", format="png")
