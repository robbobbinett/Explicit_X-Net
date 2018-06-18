using CayleyGraphs

# Set of (unordered) bases, to be stored
S = Set{Set{CayleyGraphs.Cfield}}()

# Total number of bases for (Z/2Z)^4
tot = (prod([2^4-2^j for j in 0:3])::Int64)/(factorial(4)::Int64)

# Generate F=(Z/2Z)^4
F = CayleyGraphs.cfield_maker(4)

# Populate S
while length(S) < tot
    push!(S, randH(F, 4))
end

# Store S
import JLD: save
save("bases_F^4.jld", "S", S)
