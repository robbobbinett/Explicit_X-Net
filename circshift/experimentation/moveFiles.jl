# Get working directory
myDir = pwd()

# Read in filename prefix
Wpre = map(x -> eval(parse(x)), ARGS)
name = string(Wpre)

# Move files
dest = myDir*"/test29/"*name
mkdir(dest)
for filename in readdir()
	if occursin(name, filename)
		mv(filename, dest)
	end
end
