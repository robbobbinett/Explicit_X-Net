D = parse(ARGS[1])
L = parse(ARGS[2])

# print D and L
println("D = $(D), L = $(L)")

N = D^L
I = speye(N, N)

W = I
for d in 2:D
	W += circshift(I, (d-1, 0))
end

Wprod = W^L

men = minimum(Wprod)
maxx = maximum(Wprod)
some = sum(Wprod, 1)
println("Connected: $(men > 0)")
println("Symmetry: $(maxx == men)")
println("Same Degree: $(minimum(some) == maximum(some))")
