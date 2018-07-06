#!/bin/bash

while read p; do
	julia circshift/circshift3.jl $p
done <circshift/d_n_combos.txt
