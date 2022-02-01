#!/usr/bin/env python3

import sys; import re

if len(sys.argv) != 2:
	sys.exit("INFO: It converts a given FASTQ file into a FASTA file.\n\nInsert: 1) a FASTQ file")

fasta = open(sys.argv[1],"r")

counter = 0;

for line in fasta:
	line = re.sub("\n$","",line)
	counter = counter + 1
	if (counter == 1):
		print (">",line,sep="")#
	elif (counter == 2):
		print (line)#
	elif (counter == 4):
		counter = 0

fasta.close()
