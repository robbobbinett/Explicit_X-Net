#!/bin/bash

while read p; do
	julia circshift/kepnerCircshift/kepnerCircshift.jl $p
done <circshift/d_n_combos.txt
