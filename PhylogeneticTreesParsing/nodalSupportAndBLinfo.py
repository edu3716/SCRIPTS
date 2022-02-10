#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('INFO: It reads a Newick tree file including nodal supports (ete3 module is required). From it, it prints a .tsv file with one row per node and five columns per row including information on (i) filename, (ii) nodal support label, (iii) branch length distance to parent node, (iv) rel. branch length distance to parent node, (v) Z-score branch length distance to parent node, (vi) branch length distance to root (midpoint rooting), (vii) rel. branch length distance to root (midpoint rooting), (viii) Z-score branch length distance to root (midpoint rooting), (ix) the universal node identifier (i.e., the set of names from the leaves that descend from the node, printed altogether without whitespaces in the middle and sorted in an alphabetical descending order).\n\nInsert:\n\t1) *treefile\n\t2) Write YES or NOT if nodal supports include or do not include both SH-aLRT and UFBoot values')
	
from ete3 import Tree; import statistics
	
inputFile = open(sys.argv[1],'r')

if re.search('YES',sys.argv[2]):
	print('#FileName\tSH-aLRT Support\tUFBoot Support\tNode Branch Length\tNode relBL\tNode zscore BL\tNode distToRoot\tNode relDistToRoot\tNode zscoreDistToRoot\tNodeId')
else:
	print('#FileName\tNode Support\tNode Branch Length\tNode relBL\tNode zscore BL\tNode distToRoot\tNode relDistToRoot\tNode zscoreDistToRoot\tNodeId')

for treeLine in inputFile:
	treeLine = re.sub('\n$','',treeLine)
		# Laod the tree
	tree = Tree(treeLine,format=1)
		# Calculate the midpoint node ...
	R = tree.get_midpoint_outgroup()
		# ... and set it as tree outgroup
	tree.set_outgroup(R)

	nodeId_support = {}
	nodeId_bl = {}; nodeId_relBl = {}; nodeId_zScoreBl = {}; bl_list = []
	nodeId_distToRoot = {}; nodeId_relDistToRoot = {}; nodeId_zScoreDistToRoot = {}; distToRoot_list = []
	for node in tree.traverse("preorder"):
		leaves_list = node.get_leaves()
		leaves_correctNames_list = []
		for leaf in leaves_list:
			leaves_correctNames_list.append(leaf.name)
		nodeId = ''.join(sorted(leaves_correctNames_list))
		nodeId_support[nodeId] = node.name
		if not re.search('^\d',nodeId_support[nodeId]):
			nodeId_support[nodeId] = "NA"
		bl = node.dist; nodeId_bl[nodeId] = bl; bl_list.append(bl) # computing BL
		distToRoot = leaf.get_distance(tree); nodeId_distToRoot[nodeId] = distToRoot; distToRoot_list.append(distToRoot) # computing dists to root

	# Computing metrics related to BL
	maxBl = max(bl_list); mean = statistics.mean(bl_list); stdev = statistics.stdev(bl_list)
	for nodeId in nodeId_bl:
		if stdev != 0:
			nodeId_relBl[nodeId] = nodeId_bl[nodeId] / maxBl
			nodeId_zScoreBl[nodeId] = (nodeId_bl[nodeId] - mean) / stdev
		else:
			nodeId_relBl[nodeId] = nodeId_bl[nodeId] / maxBl
			nodeId_zScoreBl[nodeId] = "NA"
	# Computing metrics related to dist to outgroup
	maxDistToRoot = max(distToRoot_list); mean = statistics.mean(distToRoot_list); stdev = statistics.stdev(distToRoot_list)
	for nodeId in nodeId_distToRoot:
		if stdev != 0:
			nodeId_relDistToRoot[nodeId] = nodeId_distToRoot[nodeId] / maxDistToRoot
			nodeId_zScoreDistToRoot[nodeId] = (nodeId_distToRoot[nodeId] - mean) / stdev
		else:
			nodeId_relDistToRoot[nodeId] = nodeId_distToRoot[nodeId] / maxDistToRoot
			nodeId_zScoreDistToRoot[nodeId] = "NA"
		if re.search('YES',sys.argv[2]):
			shSupport = "NA"; ufbootSupport = "NA"
			if re.search('/',nodeId_support[nodeId]):
				shSupport,ufbootSupport = re.split('/',nodeId_support[nodeId])
			print(sys.argv[1],shSupport,ufbootSupport,nodeId_bl[nodeId],nodeId_relBl[nodeId],nodeId_zScoreBl[nodeId],nodeId_distToRoot[nodeId],nodeId_relDistToRoot[nodeId],nodeId_zScoreDistToRoot[nodeId],nodeId,sep='\t')		
		else:
			print(sys.argv[1],nodeId_support[nodeId],nodeId_bl[nodeId],nodeId_relBl[nodeId],nodeId_zScoreBl[nodeId],nodeId_distToRoot[nodeId],nodeId_relDistToRoot[nodeId],nodeId_zScoreDistToRoot[nodeId],nodeId,sep='\t')
	
inputFile.close()
