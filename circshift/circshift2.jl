D = parse(ARGS[1])
L = parse(ARGS[2])

# print D and L
println("D = $(D), L = $(L)")

N = D^L
I = speye(N, N)
Wprod = I
W = Array{SparseMatrixCSC{Float64, Int64}}(L)

for i in 0:(L-1)
	W[i+1] = I
	for d in 2:D
		Iid = circshift(I, ((D^i) * (d-1), 0))
		W[i+1] += Iid
	end
	Wprod = W[i+1]*Wprod
end

men = minimum(Wprod)
maxx = maximum(Wprod)
some = sum(Wprod, 1)
println("Connected: $(men > 0)")
println("Symmetry: $(maxx == men)")
println("Same Degree: $(minimum(some) == maximum(some))")
