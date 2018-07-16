# Get working directory
myDir = pwd()

# Read in filename prefix
Wpre = map(x -> eval(parse(x)), ARGS)
name = string(Wpre)

# Move files
dest = myDir*"/test29/"*name
mkdir(dest)
for filename in readdir()
	if contains(filename, name) && !contains(filename, "test29")
		mv(filename, dest*"/"*filename)
	end
end
