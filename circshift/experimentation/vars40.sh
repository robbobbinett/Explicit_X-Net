# To be run from within batch40.sh

while read p; do
	julia circshift/experimentation/vars40.jl $p
done < circshift/experimentation/vars39.txt
