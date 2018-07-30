#!/bin/bash

while read p; do
	julia circshift/experimentation/test40.jl $p
done < circshift/experimentation/vars40.txt
