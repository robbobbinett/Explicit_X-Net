#!/bin/bash

while read p; do
	julia circshift/experimentation/test36.jl $p
done < circshift/experimentation/vars36b.txt
