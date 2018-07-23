Ds = [Int32[10,10,10], Int32[10]]::Array{Array{Int32, 1}, 1}
B = Int32[1, 2, 3, 2, 1]

N = prod(Ds[1])
L = sum(map(x -> length(x), Ds))

# Define map from layer index to specific number system in Ds
ind_to_sys = Dict{Integer, Integer}()
arr = zeros(Int32, length(Ds))
for j in 1:length(Ds)
	if j == 1
		arr[j] = length(Ds[j])
	else
		arr[j] = sum(arr[1:(j-1)])+length(Ds[j])
	end
end
ind = 1
for j in 1:L
	while (j > arr[ind])
		ind += 1
	end
	ind_to_sys[j] = ind
end

# Define map from layer index to specific place value
ind_to_pvInd = Dict{Integer, Integer}()
for j in 1:L
	if ind_to_sys[j] == 1
		ind_to_pvInd[j] = j
	else
		ind_to_pvInd[j] = j-sum(map(k -> length(Ds[k]), 1:(ind_to_sys[j]-1)))
	end
end

# Construct weight matrices for the case B = ones(Int32, L+1)
I = eye(Int32, N)
preW = Array{Array{Int32, 2}, 1}()
for D in Ds
	pv = 1
	for d in D
		push!(preW, sum([circshift(I, (j*pv, 0)) for j in 0:(d-1)]))
        	pv *= d
	end
end


# Padding at last D in Ds
if prod(Ds[end]) != N
	push!(Ds[end], div(N, prod(Ds[end])))
end

# Define functions for "weaving between" the distinct mixed-radix systems
# induced by B
function increment!(state::Array{Int32, 1}, radices::Array{Int32, 1})
	state[1] += 1
	for (j, rad) in enumerate(radices)
		if state[j] == rad
			state[j] = 0
			state[j+1] += 1
		end
	end
end

function to_dec(state::Array{Int32, 1}, radices::Array{Int32, 1})
	some = 0
        pv = 1
	for (s, rad) in zip(state, radices)
                some += pv*s
                pv *= rad
        end
	return some
end

function reducer(state::Array{Int32, 1}, radices::Array{Int32, 1}, ind::Integer)
	copy_state = [state[j] for j in 1:length(state) if j != ind]
	copy_radices = [radices[j] for j in 1:length(radices) if j != ind]
	return to_dec(copy_state, copy_radices)
end

function copy_insert(state::Array{Int32, 1}, ind::Integer, val::Integer)
	copy_state = copy(state)
	insert!(copy_state, ind, val)
	return copy_state
end

function expander(state::Array{Int32, 1}, radices::Array{Int32, 1}, ind::Integer, b::Integer)
	copy_radices = copy(radices)
	insert!(copy_radices, ind, b)
	return [to_dec(copy_insert(state, ind, j), copy_radices) for j in 0:(b-1)]
end

function mapper(NN, DD, prev, post, ind)
	map1 = Dict{Int64, Int64}()
	D1 = copy(DD)
	insert!(D1, ind, prev)
	state = zeros(Int32, length(DD)+1)
	term = prev*NN-1
	for j in 0:term
		map1[j] = reducer(state, D1, ind)
		if j != term
			increment!(state, D1)
		end
	end

	map2 = Dict{Int64, Array{Integer, 1}}()
	state = zeros(Int32, length(DD))
	term = NN-1
	for j in 0:term
		map2[j] = expander(state, DD, ind+1, post)
		if j != term
			increment!(state, DD)
		end
	end

	return (map1, map2)
end

# Create weight matrices
W = Array{Array{Int32, 2}, 1}()
for (j::Int32, prew) in enumerate(preW)
	map1, map2 = mapper(N, Ds[ind_to_sys[j]], B[j], B[j+1], ind_to_pvInd[j])
	w = zeros(Int32, (B[j]*N, B[j+1]*N))
	for k in 0:(B[j]*N-1)
		kp = map1[k]+1
		for l in 1:N
			if prew[kp, l] != 0
				for adj in map2[l-1]
					w[kp, adj+1] = 1
				end
			end
		end
	end
	push!(W, w)
end
