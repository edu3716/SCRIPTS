#!/usr/bin/env python3
import sys; import re
import statistics

if len(sys.argv) == 1:
	sys.exit('INFO: It computes the median and std_dev of all distances from the tips to the root of a given Newick file.\nInsert:\n\t1) treefile')
	
speciesTreeFile = open(sys.argv[1],'r')	

from ete3 import Tree
t = ''
for line in speciesTreeFile:
	line = re.sub('\n$','',line)
	t = Tree(line)

speciesTreeFile.close()

	# getting leaves
leaves_list = t.get_leaves()

	# Calculate the midpoint node
R = t.get_midpoint_outgroup()
	# and set it as tree outgroup
t.set_outgroup(R)

	# dist from leaves to node from which the root was defined --> probably wrong, as this is not the root of the tree (?)
#for leaf in leaves_list:
#	distToRoot = leaf.get_distance(R)
#	print(leaf.name,distToRoot)
#	distances_list.append(distToRoot)
	
	# this below is probably ok, seems to compute distance from leaves to the rooted tree, but just in case, I will work with distances between the most distant nodes
####
distances_list = []
for leaf in leaves_list:
	distToRoot = leaf.get_distance(t)
	distances_list.append(distToRoot)
####

print(sys.argv[1],'mean:',statistics.mean(distances_list),'median:',statistics.median(distances_list),'std:',statistics.stdev(distances_list),sep='\t')
