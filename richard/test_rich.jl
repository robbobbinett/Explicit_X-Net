Ns = eval(parse(ARGS[1]))

include("rich_method.jl")
include("emr_method.jl")

rich = rich_method(Ns)
emr = emr_method(Ns)

# if ARGS[1] == "[[10,10]]"
if true
	println(rich[1])
	println("\n\n\n")
end

rich = map(x -> Array(x), rich)

# if ARGS[1] == "[[10,10]]"
if true
	println(rich[1])
	println("\n\n\n")
	println(emr[1])
end

for (chard, em) in zip(rich, emr)
	chard == em || error("Test "*ARGS[1]*" failed.")
end

println("Test "*ARGS[1]*" passed!")
