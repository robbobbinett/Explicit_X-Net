N = eval(parse(ARGS[1]))
D = eval(parse(ARGS[2]))

# Array to store indices that begin new radix systems
inds = Array{Int32, 1}()

# Check that N, D define a valid topology,
# and convert to explicit format
gN = gcd(N)
# Make B (explicit format)
B = map(x -> div(x, gN), N)
DD = map(x -> div(x[1], x[2]), zip(D, B[2:end]))
fac = 1
start_ind = 1
push!(inds, start_ind)
for (j, d) in enumerate(DD)
	fac *= d
	if fac > gN
		factorization = map(x -> "("*string(x)*")", DD[start_ind:j])
		error("DD-indices $(start_ind) to $j; $(gN) != "*prod(factorization)*".")
	elseif fac == gN
		start_ind = j+1
		push!(inds, start_ind)
		fac = 1
	end
end
push!(inds, length(D)+1)
if gN % fac != 0
	factorization = map(x -> "("*string(x)*")", DD[start_ind:end])
	error("DD-indices $(start_ind) to end; $(gN) % "*prod(factorization)*" != 0.")
end

# Make Ns (explicit format)
if length(inds) == 1
	Ns = [DD]
else
	Ns = map(j -> DD[inds[j]:inds[j+1]-1], 1:(length(inds)-1))
end

# Make D (explicit format)
D = ones(Int32, length(DD))

NN = gN
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
