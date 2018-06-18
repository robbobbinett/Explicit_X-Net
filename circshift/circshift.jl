using PyPlot
import StatsBase: sample

d = parse(ARGS[1])
n = parse(ARGS[2])

A = spdiagm(ones(Int64, n))

for i in 1:Int64(ceil(log(d, n)))
	W = sum([circshift(A, [j 0]) for j in sample(1:n, d, replace=false)])
	
	figure()
	gca()
	ylim(n, 0)
	p = pcolor(W)
	ident = string(d)*"_"*string(n)*":"*string(i)
	savefig("circshift"*ident*".png", format="png")
end
