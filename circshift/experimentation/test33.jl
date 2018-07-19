# Read in each of the layers
D = eval(parse(ARGS[1]))
N = prod(D)
Nprime = div(prod(D), eval(parse(ARGS[2])))
L = length(D)

# Define vertical rotations of indices
I = eye(Int32, N)
Iprime = eye(Int32, Nprime)

# Construct weight matrices
W = Array{Array{Int32, 2}, 1}()
Wprime = Array{Array{Int32, 2}, 1}()
pv = 1
for d in D
	push!(W, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
	push!(Wprime, sum([circshift(Iprime, (j*pv, 0)) for j in 0:(d-1)]))
        pv *= d
end

# Create name for saving files from input
name = ARGS[1]*", "*ARGS[2]

# Import networkx for graph visualization
using PyPlot, PyCall
@pyimport networkx as nx

# Create Cartesian product of {0,...,L} and {1,...,N}
cart = Array{Tuple{Int64, Int64}, 1}()
for j in 0:L
        for k in 1:N
                push!(cart, (j, k))
        end
end

# Create Cartesian product of {0,...,L} and {1,...,Nprime}
cartPrime = Array{Tuple{Int64, Int64}, 1}()
for j in 0:L
        for k in 1:Nprime
                push!(cartPrime, (j, k))
        end
end

# Initialize graphs
B = nx.DiGraph()
Bprime = nx.DiGraph()
B[:add_nodes_from](cart)
Bprime[:add_nodes_from](cartPrime)

# Iterate over adjacency matrices
for j in 1:L
	w = W[j]
	wprime = Wprime[j]

	# Create edges for B
	for row in 1:N
		for col in 1:N
			if w[row, col] == 1
				B[:add_edge]((j-1, row), (j, col))
			end
		end
	end

	# Create edges for Bprime
	for row in 1:Nprime
		for col in 1:Nprime
			if wprime[row, col] == 1
				Bprime[:add_edge]((j-1, row), (j, col))
			end
		end
	end
end

for thing in B[:edges]()
	println(thing)
end
