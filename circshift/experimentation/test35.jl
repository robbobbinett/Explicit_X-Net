# Read in each of the layers
D = eval(parse(ARGS[1]))
omit = eval(parse(ARGS[2]))
N = prod(D)

# Define vertical rotations of indices
I = eye(Int32, N)

# Construct weight matrices
W = Array{Array{Int32, 2}, 1}()
pv = 1
for d in D
	push!(W, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
        pv *= d
end

for om in omit
	w = sum([circshift(I, (j, 0)) for j in 0:(om-1)])
	insert!(W, rand(1:length(W)), w)
end

# Create name for saving files from input
name = ARGS[1]*", "*ARGS[2]

# Mutliply adjacency matrices
Wprod = prod(W)

# Run test
test1 = maximum(Wprod) == minimum(Wprod)
numpaths = maximum(Wprod)

# Save values to .txt file
open("test35/results.txt", "a+") do f
	write(f, name*", "*string(test1)*", "*string(numpaths)*"\n")
end
