#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 2:
	sys.exit('INFO: It computes statistics from a multiple sequence alignment, including information about missing data (gaps).\n\nInsert:\n\t1) MSA')
	
inputFile = open(sys.argv[1],'r')

fasta = {}; seqname = ''

for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^>',line):
		seqname = re.sub('^>','',line); fasta[seqname] = ''
	else:
		fasta[seqname] += line

inputFile.close()

from statistics import mean
from statistics import median
seqname_percGaps = {}; all_percGaps = []; numb_residues = {}

for seqname in fasta:
	seq = fasta[seqname]
	numbGaps = seq.count("-"); numbPositions = len(seq); percGaps = round(100*(numbGaps/numbPositions),2)
	seqname_percGaps[seqname] = percGaps
	all_percGaps.append(percGaps)
	numb_residues[numbPositions] = 1
	print(seqname,'\t',numbPositions,'\t',percGaps,'%',sep='')#

print('')
print('Numb seqs: ',len(fasta.keys()),sep='')	
print('Mean gap percentage: ',round(mean(all_percGaps),2),'%',sep='')
print('Median gap percentage: ',round(median(all_percGaps),2),'%',sep='')
print('Numb residues:',list(numb_residues.keys())[0])
