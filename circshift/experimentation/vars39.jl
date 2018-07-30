BD = eval(parse(ARGS[1]))
B = BD[1]

Ns = map(x -> eval(parse("Int32"*x)), ARGS[2:end])
num = prod(Ns[1])
N = map(b -> b*num, B)
D = Array{Int32, 1}()
for ns in Ns
	for n in ns
		push!(D, n)
	end
end

for perm in (N, D)
	p = string(perm)
	p = replace(p, " ", "")
	print(p*" ")
end
print("\n")
