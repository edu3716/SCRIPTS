#!/usr/bin/env python3
import sys; import re

if len(sys.argv) == 1:
	sys.exit('INFO: It prints the number of sites of a given multiple sequence alignment (FASTA).\n\nInsert MSA Fasta file')
	
MSAfile = open(sys.argv[1],'r')

characterCounter = 0; MSAsize = 0
for line in MSAfile:
	line = re.sub('\n$','',line)
	if re.search('^>',line):
		characterCounter += 1
		if characterCounter == 2:
			break
	else:
		if characterCounter == 1:
			MSAsize += len(line)
	
MSAfile.close()

print(sys.argv[1],MSAsize,sep='\t')
