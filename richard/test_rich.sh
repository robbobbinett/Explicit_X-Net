#!/bin/bash

while read p; do
	julia richard/test_rich.jl $p
done < richard/test_rich2.txt
