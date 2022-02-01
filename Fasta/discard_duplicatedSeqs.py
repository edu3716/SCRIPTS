#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 2:
	sys.exit('Insert:\n\t1) FASTA file')
	
fastaFile = open(sys.argv[1],'r')

fasta_dict = {}; seqName = ''; alreadyIterated_seqnames = {}
skipControl = 0

for line in fastaFile:
	line = re.sub('\n$','',line)
	s_line = re.split('\t',line);
	if re.search('^>(\S+)',line):
		seqName = re.search('^>(\S+)',line); seqName = seqName.group(1)
		if seqName not in alreadyIterated_seqnames:
			skipControl = 0
			alreadyIterated_seqnames[seqName] = 1
		else:
			skipControl = 1
	else:
		seq = line
		if skipControl == 0:
			if seqName not in fasta_dict:
				fasta_dict[seqName] = ''
			fasta_dict[seqName] += seq	

fastaFile.close()

for seqName in sorted(fasta_dict):
	seq = fasta_dict[seqName]
	print('>',seqName,'\n',seq,sep='')
