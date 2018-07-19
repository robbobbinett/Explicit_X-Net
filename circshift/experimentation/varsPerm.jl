import Combinatorics: permutations

A = [2,3,5,7,11]

for perm in permutations(A)
	p = string(perm)
	p = replace(p, " " => "")
	println(p*" 35")
end
