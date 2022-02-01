#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 2:
	sys.exit('INFO: It counts the amino acid frequency for every sequence in the alignment\nInsert:\n\t1) .msa file')

genetic_code = {
'D':1,
'E':1,
'R':1,
'H':1,
'K':1,
'A':1,
'C':1,
'G':1,
'I':1,
'L':1,
'M':1,
'F':1,
'P':1,
'W':1,
'V':1,
'N':1,
'Q':1,
'S':1,
'T':1,
'Y':1
}

fastaFile = open(sys.argv[1],'r')

fasta = {}; seqname = ''
for line in fastaFile:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	if re.search('^>',line):
		seqname = re.search('>(\S+)',line); seqname = seqname.group(1)
	else:
		if seqname not in fasta:
			fasta[seqname] = {}
			fasta[seqname] = line
		else:
			fasta[seqname] += line
	
fastaFile.close()

aa_counts = {}; total_aa_counted = {}

for seqname in fasta:
	seq = fasta[seqname]
	aa_counts[seqname] = {}
	total_aa_counted[seqname] = 0
	for letter in seq:
		if letter in genetic_code:
			if letter not in aa_counts[seqname]:
				aa_counts[seqname][letter] = 1
			else:
				aa_counts[seqname][letter] += 1
			total_aa_counted[seqname] += 1

for letter in sorted(genetic_code):
	print('\t',letter,sep='',end='')

print('\n',end='')

for seqname in sorted(aa_counts):
	for letter in aa_counts[seqname]:
		aa_counts[seqname][letter] = aa_counts[seqname][letter] / total_aa_counted[seqname]
	print(seqname,end='')
	for letter in sorted(genetic_code):
		currentCount = 0
		if letter in aa_counts[seqname]:
			currentCount = aa_counts[seqname][letter]
		print('\t',aa_counts[seqname][letter],sep='',end='')
	print('\n',end='')		
