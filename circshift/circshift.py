import os
from sys import argv
from shutil import move

ident = argv[1] + "_" + argv[2]
path = os.getcwd()
samples_path = path + "/samples/"
os.mkdir(samples_path+ident)

for filename in os.listdir(path):
	if ident in filename:
		move(filename, samples_path+ident)
