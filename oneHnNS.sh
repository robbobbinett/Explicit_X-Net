#!/bin/bash
rm -f *.png
rm -rf oneHexample_nns

julia oneHnNS.jl
mkdir oneHexample_nns oneHexample_nns/A oneHexample_nns/B oneHexample_nns/C oneHexample_nns/D oneHexample_nns/E
#python3 making_some_nns.py
