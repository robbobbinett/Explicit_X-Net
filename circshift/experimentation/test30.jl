toops = map(x -> eval(parse(x)), ARGS)
somes = Set{Int32}()
for j in toops[1]
	for k in toops[2]
		for l in toops[3]
			for m in toops[4]
				push!(somes, j+k+l+m)
			end
		end
	end
end

println(ARGS)
println(length(somes) == 16)
println("\n")
