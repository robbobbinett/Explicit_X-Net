#!/bin/bash

while read p; do
	julia circshift/experimentation/test39.jl $p
done < circshift/experimentation/vars39.txt
