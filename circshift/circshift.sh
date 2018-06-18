#!/bin/bash
rm -f *.png
rm -fr samples

mkdir samples

while read p; do
	julia circshift.jl $p
	python3 circshift.py $p
done <d_n_combos.txt
