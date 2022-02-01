#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 2:
	sys.exit('Info: You pass a FASTA file and it reverse the sequences (thought to "Head or tails").\nInsert:\n\t1) Fasta file')

fastaFile = open(sys.argv[1],'r')

fasta = {}; seqname = ''
for line in fastaFile:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	if re.search('^>(\S+)',line):
		seqname = re.search('^>(\S+)',line); seqname = seqname.group(1)
	else:
		if seqname not in fasta:
			fasta[seqname] = ''
		fasta[seqname] += line			

fastaFile.close()

reverse_fasta = {}

for seqname in fasta:
#	print(seqname)#
	sequence = fasta[seqname]
	reverseSequence = sequence[::-1]
	reverse_fasta[seqname] = reverseSequence

for seqname in reverse_fasta:
	reverseSeq = reverse_fasta[seqname]
	print('>',seqname,'\n',reverseSeq,sep='')
