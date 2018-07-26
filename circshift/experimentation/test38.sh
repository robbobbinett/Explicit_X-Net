#!/bin/bash

while read p; do
	julia circshift/experimentation/test38.jl $p
done < circshift/experimentation/vars37.txt
