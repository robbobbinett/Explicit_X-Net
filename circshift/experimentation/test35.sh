#!/bin/bash

while read p; do
	julia circshift/experimentation/test35.jl $p
done < circshift/experimentation/vars35.txt
