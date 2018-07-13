N = 16
L = 4
I = eye(N)

Is = map(x -> circshift(I, (x, 0)), 0:9)
Is = Dict(zip(0:9, Is))

Wpre = map(x -> eval(parse(x)), ARGS)
W = map(x -> sum([Is[ind] for ind in x]), Wpre)

# Initialize graph
using LightGraphs
g = SimpleDiGraph(N*(L+1))

# Iterate over adjacency matrices
for j in 1:L
	w = W[j]
	# Number of circshifts
	D = length(Wpre[j])

	# Create edges
	for row in w
		for col in row
			add_edge!(g, ((j-1)*N + row, j*N + col))
		end
	end
end

