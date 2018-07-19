# Read in each of the layers
D = eval(parse(ARGS[1]))
N = div(prod(D), eval(parse(ARGS[2])))
L = length(D)

# Define vertical rotations of indices
I = eye(Int32, N)

# Construct weight matrices
W = Array{Array{Int32, 2}, 1}()
pv = 1
for d in D
	push!(W, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
        pv *= d
end

# Create name for saving files from input
name = ARGS[1]*", "*ARGS[2]

# Check for entries that are neither one or zero
for w in W
	if maximum(w) != 1
		error(name*"\nThe maximum of this matrix is $(maximum(w)).")
	end
end

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Save values to .txt file
open("test34/results.txt", "a+") do f
	write(f, name*", "*string(test1)*", "*string(numpaths)*"\n")
end
