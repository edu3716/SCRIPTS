#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('Insert:\n\t1) Fasta\n\t2) Max number of seqs that you want per file (if e.g., 1000, and the number of seqs in the input fasta is 1300, it will create 2 files, one of 1000 and another of 300)')
	
fastaFile = open(sys.argv[1],'r')

fasta = {}; seqName = ''

for line in fastaFile:
	line = re.sub('\n$','',line)
	if re.search('^>',line):
		seqName = re.search('>(\S+)',line); seqName = seqName.group(1)
		fasta[seqName] = ''
	else:
		fasta[seqName] += line

fastaFile.close()

seqsPerFile = int(sys.argv[2])

printerCounter = 0; seqCounter = 0

for seqName in fasta:
	printerCounter +=1
	seqCounter += 1
	if seqCounter == 1:
		printer = open(sys.argv[1]+'.from'+str(seqCounter),'w') 
	printer.write('>'+seqName+'\n'+fasta[seqName]+'\n')
	if printerCounter == seqsPerFile:
		printer.close()
		printer = open(sys.argv[1]+'.from'+str(seqCounter),'w')
		printerCounter = 0
		
printer.close()
