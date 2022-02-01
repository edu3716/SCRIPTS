#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('INFO: From a Newick file, it computes distances between nodes using ETE3 toolkit (must be installed).\n\n\t1) Tree in Newick format (e.g., ~/Desktop/Osmotrophy_project/ALE/SpeciesTreeFromALE/speciesTreeFromALE.nw)\n\t2) Does the tree have internal node names available as annotations? (otherwise, distances between internal nodes are not computed) --> write YES or NOT')


	# Loading species tree ...

speciesTreeFile = open(sys.argv[1],'r')
from ete3 import Tree

t = ''
for line in speciesTreeFile:
	line = re.sub('\n$','',line)
	if re.search('YES',sys.argv[2]):
		t = Tree(line,format=1)
	elif re.search('NOT',sys.argv[2]):
		t = Tree(line,format=0)

speciesTreeFile.close()

	# Getting all nodes of the tree ...
all_nodes = {}

for node in t.traverse("preorder"):
	if not re.search('\S',node.name):
		continue
	all_nodes[node.name] = 1
	
	# ... and all distances between nodes in the tree
nodes_nodalDistances = {}; nodes_branchLengthDistances = {}

for node1 in all_nodes:
	if node1 not in nodes_nodalDistances:
		nodes_nodalDistances[node1] = {}
		nodes_branchLengthDistances[node1] = {}
	for node2 in all_nodes:
		if node1 == node2:
			continue
		nodes_nodalDistances[node1][node2] = t.get_distance(node1,node2,topology_only=True) # nodal distance
		nodes_branchLengthDistances[node1][node2] = t.get_distance(node1,node2) # branch length distance

print('#NodeA\tNodeB\tBranchLengthDist\tInternodalDist')

for node1 in sorted(nodes_branchLengthDistances):
	for node2 in sorted(nodes_branchLengthDistances[node1]):
		print(node1,node2,nodes_branchLengthDistances[node1][node2],nodes_nodalDistances[node1][node2],sep='\t')

