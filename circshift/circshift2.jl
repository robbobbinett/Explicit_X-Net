D = parse(ARGS[1])
L = parse(ARGS[2])

# print D and L
println("D = $(D), L = $(L)")

N = D^L
W = speye(N, N)
# W = Array{SparseMatrixCSC{Int64,Int64}, 1}()

J = repeat(1:N, inner=D)
V = ones(Int64, N*D)
for i in 0:(L-1)
	K = Array{Int64, 1}()
	for arr in map(x -> [((x+(D^i*d)-1) % N) + 1 for d in 1:D], 1:N)
		append!(K, arr)
	end
	W *= sparse(J, K, V)
end

men = minimum(W)
maxx = maximum(W)
some = sum(W, 1)
println("Connected: $(men > 0)")
println("Symmetry: $(maxx == men)")
println("Same Degree: $(minimum(some) == maximum(some))")
