#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('INFO: It allows to fish different subsets of sequences from a FASTA file and print each subset to a distinct FASTA file.\n\nInsert:\n\t1) FASTA file\n\t2) .tsv file with 1 to n rows, each including two columns: col1 --> pattern of text to fish sequences from a FASTA file (e.g., if "Homo_sapiens", all sequences whose name includes this text pattern (e.g., Homo_sapiens_seq1) will be fished); col2 --> path to an output FASTA filename that will be created and where all sequences whose names include the pattern in col1 will be printed')

	# 0) Loading FASTA file	
inputFile = open(sys.argv[1],'r')

seqname = ''; fasta_dict = {}
for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^#',line):
		continue
	if re.search('^>',line):
		seqname = re.search('^>(\S+)',line); seqname = seqname.group(1); fasta_dict[seqname] = ''
	else:
		fasta_dict[seqname] += line

inputFile.close()

	# 1) Loading text patterns and output filenames
inputFile = open(sys.argv[2],'r')

patternToFish_outputFastaName = {}
for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^#',line):
		continue
	s_line = re.split('\t',line); patternToFish = s_line[0]; outputFastaName = s_line[1]
	patternToFish_outputFastaName[patternToFish] = outputFastaName

inputFile.close()

	# 2) Fishing and printing on the fly
for patternToFish in patternToFish_outputFastaName:
	printer = open(patternToFish_outputFastaName[patternToFish],'w')
	
	for seqname in fasta_dict:
		if re.search(patternToFish,seqname):
			printer.write('>'+seqname+'\n'+fasta_dict[seqname]+'\n')
	
	printer.close()
