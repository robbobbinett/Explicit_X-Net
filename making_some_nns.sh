#!/bin/bash
rm -f *.png
rm -rf example_nns

julia making_some_nns.jl
#mkdir example_nns example_nns/A example_nns/B example_nns/C example_nns/D example_nns/E
#python3 making_some_nns.py
