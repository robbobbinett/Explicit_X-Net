#!/bin/bash

while read p; do
	julia circshift/experimentation/test29.jl $p
done < circshift/experimentation/vars.txt