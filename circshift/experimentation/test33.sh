#!/bin/bash

rm -rf test33
mkdir test33
while read p; do
	julia circshift/experimentation/test33.jl $p
done < circshift/experimentation/varsTest.txt
