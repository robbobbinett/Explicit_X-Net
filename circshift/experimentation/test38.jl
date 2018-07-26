BD = eval(parse(ARGS[1]))
B = BD[1]
D = BD[2]

Ns = map(x -> eval(parse("Int32"*x)), ARGS[2:end])

NN = prod(Ns[1])
L = sum(map(x -> length(x), Ns))

for (j, d) in enumerate(D)
	if (gcd(B[j], B[j+1]) % d) != 0
		error("D[$j] must divide gcd(B[$j], B[$j+1]).")
	end
end

# Construct weight matrices for the case B = ones(Int32, L+1),
# D = ones(Int32, L)
I = eye(Int32, NN)
preW = Array{Array{Int32, 2}, 1}()
for N in Ns
	pv = 1
	for d in N
		push!(preW, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
        	pv *= d
	end
end

# Construct matrices A for Kronecker products A x B
krons = Array{Array{Int32, 2}, 1}()
for j in 1:L
	kMatD = zeros(Int32, (B[j], B[j+1]))
        g = gcd(B[j], B[j+1])
        g_to_d = div(g, D[j])
        preb = div(B[j], g)
        postb = div(B[j+1], g)
        eyeD = eye(Int32, g)
        kMatD = sum([circshift(eyeD, (0, dd*g_to_d)) for dd in 0:D[j]-1])
        kMat = kron(ones(Int32, (preb, postb)), kMatD)
        push!(krons, kMat)
end

W = map(x -> kron(x[1], x[2]), zip(krons, preW))

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Print values
println("Test: $(test1)")
println("Number of Paths: $(numpaths)")
