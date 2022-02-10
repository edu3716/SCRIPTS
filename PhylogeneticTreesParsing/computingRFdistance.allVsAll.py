#!/usr/bin/env python3
import sys; import re
from ete3 import Tree

if len(sys.argv) != 3:
	sys.exit('INFO: It computes the RF distance between a list of phylogenetic trees (Newick format, ETE3 tooklit must be installed). They can be species trees or gene trees.\n\nInsert:\n\t1) File with the paths to all Newick files for which the RFdistance between them will be checked\n\t2) Compare species tags or gene tags [Yes or Not, respectively]')

# 0) Loading files with Newick trees
inputFile = open(sys.argv[1])

pathsToTreeFiles_list = []
for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^$',line):
		continue
	pathsToTreeFiles_list.append(line)

inputFile.close()

# 1) Checking RF distances between all treefiles
for i in range(0,len(pathsToTreeFiles_list)):
	treeA_file = open(pathsToTreeFiles_list[i],'r')
	for line in treeA_file:
		line = re.sub('\n$','',line)
		if re.search('^$|^#',line):
			continue
		if re.search('Yes',sys.argv[2]):
			line = re.sub('_\S+?:',':',line)
		treeA = Tree(line)
	treeA_file.close()
	for j in range(0,len(pathsToTreeFiles_list)):
		if pathsToTreeFiles_list[i] == pathsToTreeFiles_list[j]:
			continue
		treeB_file = open(pathsToTreeFiles_list[j],'r')
		for line in treeB_file:
			line = re.sub('\n$','',line)
			if re.search('^$|^#',line):
				continue
			if re.search('Yes',sys.argv[2]):
				line = re.sub('_\S+?:',':',line)
			treeB = Tree(line)
		treeB_file.close()
		rf = treeA.robinson_foulds(treeB,unrooted_trees=True)
		rawRFdist = round(rf[0],4); relRFdist = round(rf[0]/rf[1],4)
		print(pathsToTreeFiles_list[i],pathsToTreeFiles_list[j],rawRFdist,relRFdist,sep='\t')
