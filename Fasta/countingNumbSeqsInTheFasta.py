#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 2:
	sys.exit('Insert:\n\t1) FASTA file')

fastaFile = open(sys.argv[1],'r')

counter = 0

for line in fastaFile:
	if re.search('^>',line):
		counter += 1

fastaFile.close()

print(sys.argv[1],counter,sep='\t')
