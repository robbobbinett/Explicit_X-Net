# To be run from within batch39.sh

while read p; do
	julia circshift/experimentation/vars39.jl $p
done < circshift/experimentation/vars37.txt
