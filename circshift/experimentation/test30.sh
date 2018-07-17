#!/bin/bash

while read p; do
	julia circshift/experimentation/test30.jl $p
done < circshift/experimentation/vars2.txt
