#!/bin/bash

rm -rf test34
mkdir test34
while read p; do
	julia circshift/experimentation/test34.jl $p
done < circshift/experimentation/varsPerm.txt
