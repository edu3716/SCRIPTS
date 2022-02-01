#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('Info1: It takes a trimmed alignment and prints it after removing seqs containing only gaps, and also removes number of sites in seqname (information added by trimAl).\n\nInfo2: Alignments where all the seqs are without gaps wont be printed\n\nInfo3: Files are not printed to stdout but a file is created with the desired name.\n\nInsert:\n\t1) trimmed MSA (thought for trimAl, but should work for any), and it doesnt have to be 1 seqline\n\t2) write the desired output name')
	
msaFile = open(sys.argv[1],'r')

fasta_dict = {}; seqName = ''; fasta_dict_withoutGaps = {}; seqsOrder_list = []

for line in msaFile:
	line = re.sub('\n$','',line)
	if re.search('^>',line):
		seqName = re.sub('>','',line); seqName = re.sub(' .+$','',seqName)
		fasta_dict[seqName] = ''; fasta_dict_withoutGaps[seqName] = ''
		seqsOrder_list.append(seqName)
	else:
		fasta_dict[seqName] += line
		lineWithoutGaps = re.sub('-','',line); fasta_dict_withoutGaps[seqName] += lineWithoutGaps

msaFile.close()

printFileControl = 0
for seqName in seqsOrder_list:
	if len(fasta_dict_withoutGaps[seqName]) > 0:
		printFileControl = 1; break		

if printFileControl == 0:
	sys.exit(sys.argv[1]+' has not sequences')

printer = open(sys.argv[2],'w')

for seqName in seqsOrder_list:
	if len(fasta_dict_withoutGaps[seqName]) > 0:
		printer.write('>'+seqName+'\n'+fasta_dict[seqName]+'\n')
		
printer.close()
