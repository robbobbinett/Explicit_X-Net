#!/bin/bash

rm -rf test29
mkdir test29
while read p; do
	julia circshift/experimentation/test29.jl $p
	julia circshift/experimentation/moveFiles.jl $p
done < circshift/experimentation/vars.txt
