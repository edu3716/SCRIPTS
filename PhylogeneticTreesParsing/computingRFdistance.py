#!/usr/bin/env python3
import sys; import re
from ete3 import Tree

if len(sys.argv) != 4:
	sys.exit('INFO: It computes the RF distance between two phylogenetic trees (Newick format, ETE3 tooklit must be installed). Both can be species trees, both can be gene trees, and both can be gene trees in which you are interested to compare the position of the species (assuming 1 gene per species, in such a casa write Yes in 3)).\nInsert:\n\t1) Species Tree [or Gene Tree]\n\t2) Gene Tree\n\t3) Compare species tags or gene tags [Yes or Not, respectively]')

treeA = ''
treeB = ''

if re.search('Yes',sys.argv[3]):
	treeA_file = open(sys.argv[1],'r')

	for line in treeA_file:
		line = re.sub('\n$','',line)
		if re.search('^$|^#',line):
			continue
		line = re.sub('_\S+?:',':',line)
		treeA = Tree(line)

	treeA_file.close()

	treeB_file = open(sys.argv[2],'r')
	
	for line in treeB_file:
		line = re.sub('\n$','',line)
		if re.search('^$|^#',line):
			continue
		line = re.sub('_\S+?:',':',line)
		treeB = Tree(line)

	treeB_file.close()
else:
	treeA_file = open(sys.argv[1],'r')

	for line in treeA_file:
		line = re.sub('\n$','',line)
		if re.search('^$|^#',line):
			continue
		treeA = Tree(line)

	treeA_file.close()

	treeB_file = open(sys.argv[2],'r')
	
	for line in treeB_file:
		line = re.sub('\n$','',line)
		if re.search('^$|^#',line):
			continue
		treeB = Tree(line)

	treeB_file.close()

rf = treeA.robinson_foulds(treeB,unrooted_trees=True)
print(sys.argv[2],'RFdist: ',rf[0],'. RFDist relative to max possible RFDist: ',rf[0]/rf[1],sep='\t')#
