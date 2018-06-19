using CayleyGraphs

# Set of generating sets, to be stored
S = Set{Set{CayleyGraphs.Cfield}}()

# Total number of generators of order 5 for (Z/2Z)^4
tot = (2^4-4)*(prod([2^4-2^j for j in 0:3])::Int64)/(factorial(4)::Int64)

# Generate F=(Z/2Z)^4
F = CayleyGraphs.cfield_maker(4)

# Populate S
while length(S) < tot
    push!(S, randH(F, 5))
end

# Store S
import JLD: save
save("5gens_F^4.jld", "S", S)
