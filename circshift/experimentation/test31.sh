#!/bin/bash

rm -rf test31
mkdir test31
while read p; do
	julia circshift/experimentation/test31.jl $p
done < circshift/experimentation/vars3.txt
