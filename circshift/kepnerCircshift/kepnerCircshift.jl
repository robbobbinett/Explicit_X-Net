# Read in D, L, where D is the radix and L is the number of place values
D = parse(ARGS[1])
L = parse(ARGS[2])

# print D and L
println("D = $(D), L = $(L)")

# Total number of edges per layer
N = D^L

using LightGraphs

# Create neural net topology as mutable digraph
g = SimpleDiGraph(N*(L+1))

# Array to be repeatedly referenced for edge generation
J = repeat(1:N, inner=D)

# Populate graph
for i in 0:(L-1)
	# Inlined circshift method
	K = Array{Int64, 1}()
	for arr in map(x -> [((x-1+(D^i*d)) % N) + 1 for d in 0:(D-1)], 1:N)
		append!(K, arr)
	end

	# Create edge
	JJ = map(x -> x + N*(i+1), J)
	KK = map(x -> x + N*(i+2), K)
	for edj in zip(J, K)
		add_edge!(g, edj)
	end
end

# Convert graph to immutable for reduced storage/runtime
g = LightGraphs.StaticGraph(g)



#men = minimum(W)
#maxx = maximum(W)
#some = sum(W, 1)
#println("Connected: $(men > 0)")
#println("Symmetry: $(maxx == men)")
#println("Same Degree: $(minimum(some) == maximum(some))")
