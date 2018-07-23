# Original format:
# N = [1000 2000 3000 2000 1000]
# D = [20, 30, 20, 10]
# New format:
# Instead of having D and Dprime, have array of arrays which define
# a mixed-radix system for representing prod(Ns[1])
Ns = [[10, 10, 10], [10]]
B = [1, 2, 3, 2, 1]
D = [1, 1, 1, 1]
# Note that, after removing B[1], the elementwise products of Ns and 
# B give D in the original format.

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

# Construct actual weight matrices
W = Array{Array{Int32, 2}, 1}()
for (j, prew) in enumerate(preW)
	preB = B[j]
	preNN = preB*NN
	postB = B[j+1]
	postNN = postB*NN
	g = gcd(preB, postB)
	preB = div(preB, g)
	postB = div(postB, g)
	gNN = g*NN
	g_to_d = div(g, D[j])
	gdNN = g_to_d*NN
	w = zeros(Int32, (B[j]*NN, B[j+1]*NN))
	for k in 1:NN
		for l in 1:NN
			if prew[k, l] == 1
				for preb in 0:preB-1
					for postb in 0:postB-1
						for gtd in 0:g_to_d-1
							for gtd2 in 0:g_to_d-1
								w[((k+gtd*NN+preb*gNN-1)%preNN)+1, ((l+((gtd+gtd2) % g_to_d)*NN+postb*gNN-1)%postNN)+1] = 1
							end
						end
					end
				end
			end
		end
	end
	push!(W, w)
end

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Print values
println("Test: $(test1)")
println("Number of Paths: $(numpaths)")
