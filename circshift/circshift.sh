#!/bin/bash
rm -f *.png
rm -fr samples

mkdir samples

while read p; do
	julia circshift/circshift.jl $p
	python3 circshift/circshift.py $p
done <circshift/d_n_combos.txt
