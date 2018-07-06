#!/bin/bash

while read p; do
	julia circshift/circshift2.jl $p
done <circshift/d_n_combos.txt
