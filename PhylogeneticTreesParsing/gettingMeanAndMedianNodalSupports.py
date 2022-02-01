#!/usr/bin/env python3
import sys; import re

if len(sys.argv) == 1:
	sys.exit('INFO: It computes the mean and median nodal support value of a given Newick file.\n\nInsert *.treefile')
	
treeFile = open(sys.argv[1],'r')

ufboot_list = []

for line in treeFile:
	line = re.sub('\n$','',line)
	s_line = re.split('\)',line)
	for i in range(0,len(s_line)):
		if re.search('^[\d|\.]+:',s_line[i]):
			numb = float(re.sub(':.+$','',s_line[i]))
			ufboot_list.append(numb)

treeFile.close()

import statistics

if len(ufboot_list) >= 2:
	print(sys.argv[1],'mean:',statistics.mean(ufboot_list),'median:',statistics.median(ufboot_list),'std:',statistics.stdev(ufboot_list),sep='\t')
else:
	print(sys.argv[1],'mean:',statistics.mean(ufboot_list),'median:',statistics.median(ufboot_list),'std:\tNA',sep='\t')
