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

# Function mapping all nonzero matrix entries to 1
to1 = (x::Int64 -> (x == 0) ? 0 : 1)
function To1(X::SparseMatrixCSC{Int64, Int64})
	@. X = to1(X)
	return X
end

for lett in ["a", "b", "c", "d", "e"]
	mat = CayleyGraphs.matrix_from_H(A[rand(1:end)], F)
	
	figure(figsize=(5, 5))
	gca()
	axis("off")
	ylim(16, 0)
	pcolor(mat, cmap=greys)
	savefig(lett*".png", format="png")

	figure(figsize=(5, 5))
	gca()
	axis("off")
	pcolor(To1(mat^L), cmap=greys, vmin=0, vmax=1)
	savefig(lett*"P.png", format="png")

	for j in 1:L

#		figure()
#		gca()
#		B = nx.Graph()
#		for k in 0:1
#			B[:add_nodes_from](sF, bipartite=k)
#		end
#		for k in 1:16
#			for l in 17:32
#				if mat[k, l] == 1
#					B[:add_edges_from]([(k, l)])
#				end
#			end
#		end
#		pos = Dict()
#		X, Y = nx.bipartite[:sets](B)
#		for (p, n) in enumerate(X)
#			pos[n] = (1, p)
#		end
#		for (p, n) in enumerate(Y)
#			pos[n] = (2, p)
#		end
#		nx.draw(B, pos=pos)
#		savefig(lett*string(j+4)*".png", format="png")
	end
end
