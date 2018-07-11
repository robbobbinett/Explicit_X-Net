D = parse(ARGS[1])
L = parse(ARGS[2])

# print D and L
println("D = $(D), L = $(L)")

N = D^L
I = speye(N, N)

J = Array{Int64, 1}()
K = Array{Int64, 1}()
V = Array{Int64, 1}()
for n in 1:N
	for d in 1:D
		push!(J, n)
		push!(K, ((n+d-1) % N) + 1)
		push!(V, 1)
	end
end
lens = map(x -> length(x), [J, K, V])
println(maximum(lens) == minimum(lens))

W = sparse(J, K, V)

Wprod = W^L

men = minimum(Wprod)
maxx = maximum(Wprod)
some = sum(Wprod, 1)
println("Connected: $(men > 0)")
println("Symmetry: $(maxx == men)")
println("Same Degree: $(minimum(some) == maximum(some))")
