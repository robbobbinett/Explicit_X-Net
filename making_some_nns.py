import os
from shutil import move

# Current directory
cdir = os.getcwd()

names = ['a', 'b', 'c', 'd', 'e']
dirs = ['A', 'B', 'C', 'D', 'E']

for name, dirr in zip(names, dirs):
	for filename in os.listdir(cdir):
		if name in filename and len(filename) == 6:
			move(filename, cdir+"/example_nns/"+dirr+"/")

import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import ImageGrid

plt.axis("off")

for name, dir in zip(names, dirs):
	pngs = []
	for j in range(8):
		with open(cdir+"/example_nns/"+dir+"/"+name+str(j+1)+".png", "rb") as file:
			pngs.append(plt.imread(file))
	grid = ImageGrid(plt.figure(figsize=(40, 30)), 111, nrows_ncols=(2, 4))
	for ax, im in zip(grid, pngs):
		ax.imshow(im)
		ax.axison = False

	plt.savefig(cdir+"/example_nns/"+dir+"/"+dir+"nnet.png", format="png")
