using CayleyGraphs
using PyPlot, PyCall
import JLD: load
@pyimport networkx as nx

# Load set of all bases of F:=(Z/2Z)^4
S = load("bases_F^4.jld")["S"]

# Convert to Array
A = collect(S)

# Construct F
F = CayleyGraphs.cfield_maker(4)
sF = [enum[1] for enum in enumerate(F)]

# Get grayscale color map
greys = get_cmap("Greys")

# Number of neural net layers
L = 4

# Create iterable representing Cartesian product of {1,...,L} and sF
cart = Array{Tuple{Int64, Int64}, 1}()
for j in 1:L
	for k in sF
		push!(cart, (j, k))
	end
end

# Create iterable representing Cartesian product of {1, 2} and sF
cart2 = Array{Tuple{Int64, Int64}, 1}()
for j in 1:2
	for k in sF
		push!(cart2, (j, k))
	end
end

# Function mapping all nonzero matrix entries to 1
to1 = (x::Int64 -> (x == 0) ? 0 : 1)
function To1(X::SparseMatrixCSC{Int64, Int64})
	@. X = to1(X)
	return X
end

for lett in ["a", "b", "c", "d", "e"]
	mat = CayleyGraphs.matrix_from_H(A[rand(1:end)], F)
	Mat = mat^L
	
	f = figure(figsize=(5, 5))
	ax = gca()
	axis("off")
	ylim(16, 0)
	pcolor(mat, cmap=greys)
	savefig(lett*".png", format="png")

	f = figure(figsize=(5, 5))
	ax = gca()
	axis("off")
	pcolor(To1(Mat), cmap=greys, vmin=0, vmax=1)
	savefig(lett*"P.png", format="png")

	f = figure()
	ax = gca()
	B = nx.DiGraph()
	for elem in cart
		B[:add_nodes_from](cart)
	end
	for j in 1:(L-1)
		for k in sF
			for l in sF
				if mat[k, l] == 1
					B[:add_edges_from]([((j, k), (j+1, l))])
				end
			end
		end
	end

	posB = Dict()
	for node in B
		posB[node] = (node[1], node[2])
	end
	
	nx.draw(B, pos=posB)
	savefig(lett*"NN.png", format="png")

	f = figure()
	ax = gca()
	BB = nx.DiGraph()
	for j in 0:1
		BB[:add_nodes_from](cart2)
	end
	for j in sF
		for k in sF
			if Mat[j, k] != 0
				BB[:add_edges_from]([((1, j), (2, k))])
			end
		end
	end

	posBB = Dict()
	for node in BB
		posBB[node] = (node[1], node[2])
	end

	nx.draw(BB, pos=posBB)
	savefig(lett*"Paths.png", format="png")

end
