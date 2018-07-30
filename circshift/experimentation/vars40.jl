N = eval(parse(ARGS[1]))
D = eval(parse(ARGS[2]))

gN = gcd(N)
NN = map(x -> div(x, gN), N)
D = map(x -> x[1]*x[2], zip(D, NN[2:end]))

for perm in (N, D)
	p = string(perm)
	p = replace(p, " ", "")
	print(p*" ")
end
print("\n")
