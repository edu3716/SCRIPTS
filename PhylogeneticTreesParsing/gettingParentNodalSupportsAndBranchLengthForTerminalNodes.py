#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('INFO: It reads a Newick tree file including nodal supports (ete3 module is required). From it, it prints a .tsv file with one row per leaf and 6 columns per row including information on (i) filename, (ii) support for the parent node in the tree, (iii) branch length distance to parent node, (iv) rel. branch length distance to parent node, (v) Z-score branch length distance to parent node, (vi) branch name.\n\nInsert:\n\t1) *treefile\n\t2) Write YES or NOT if nodal supports include or do not include both SH-aLRT and UFBoot values')
	
from ete3 import Tree; import statistics
	
inputFile = open(sys.argv[1],'r')

if re.search('YES',sys.argv[2]):
	print('#FileName\tSH-aLRT Support\tUFBoot Support\tNode Branch Length\tNode relBL\tNode zscore BL\tLeafName')
else:
	print('#FileName\tNode Support\tNode Branch Length\tNode relBL\tNode zscore BL\tLeafName')

for treeLine in inputFile:
	treeLine = re.sub('\n$','',treeLine)
		# Load the tree
	tree = Tree(treeLine,format=1)

	leaf_parentNodeSupport = {}
	leaf_bl = {}; leaf_relBl = {}; leaf_zScoreBl = {}; bl_list = []
	for node in tree.traverse("preorder"):
		if not node.is_leaf():
			continue
		leaf = node.name; parentNode = node.up
		leaf_parentNodeSupport[leaf] = parentNode.name
		bl = node.dist; leaf_bl[leaf] = bl; bl_list.append(bl) # computing BL
	# Computing metrics related to BL
	maxBl = max(bl_list); mean = statistics.mean(bl_list); stdev = statistics.stdev(bl_list)
	for leaf in leaf_bl:
		if stdev != 0:
			leaf_relBl[leaf] = leaf_bl[leaf] / maxBl
			leaf_zScoreBl[leaf] = (leaf_bl[leaf] - mean) / stdev
		else:
			leaf_relBl[leaf] = leaf_bl[leaf] / maxBl
			leaf_zScoreBl[leaf] = "NA"
		if re.search('YES',sys.argv[2]):
			shSupport = "NA"; ufbootSupport = "NA"
			if re.search('/',leaf_parentNodeSupport[leaf]):
				shSupport,ufbootSupport = re.split('/',leaf_parentNodeSupport[leaf])
			print(sys.argv[1],shSupport,ufbootSupport,leaf_bl[leaf],leaf_relBl[leaf],leaf_zScoreBl[leaf],leaf,sep='\t')		
		else:
			print(sys.argv[1],leaf_parentNodeSupport[leaf],leaf_bl[leaf],leaf_relBl[leaf],leaf_zScoreBl[leaf],leaf,sep='\t')
	
inputFile.close()
