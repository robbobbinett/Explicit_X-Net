#!/bin/bash

rm -rf test32
mkdir test32
while read p; do
	julia circshift/experimentation/test32.jl $p
done < circshift/experimentation/vars32.txt
