# Original format:
# N = [1029 686 2058 3087 343]
# D = [14, 42, 63, 7]
# New format:
# Instead of having D and Dprime, have array of arrays which define
# a mixed-radix system for representing prod(Ns[1])
Ns = [[7, 7, 7], [7]]
B = [3, 2, 6, 9, 1]
D = [1, 2, 3, 1]
# Note that, after removing B[1], the elementwise products of Ns and 
# B give D in the original format.

NN = prod(Ns[1])
M = sum(map(x -> length(x), Ns))

for (j, d) in enumerate(D)
	if (gcd(B[j], B[j+1]) % d) != 0
		error("D[$j] must divide gcd(B[$j], B[$j+1]).")
	end
end

# Construct weight matrices for the case B = ones(Int32, M+1),
# D = ones(Int32, M)
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
for j in 1:M
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

# Construct actual weight matrices
W = [kron(kMat, prew) for (kMat, prew) in zip(krons, preW)]

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Print values
println("Test: $(test1)")
println("Number of Paths: $(numpaths)")
