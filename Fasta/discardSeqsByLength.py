#!/usr/bin/env python3

import sys
import re

if len(sys.argv) != 3:
	sys.exit("\nInfo: You pass a FASTA and a minimal length threshold and prits that FASTA, except those sequnces with < length than the threshold\nInput:\n\t1) FASTA file\n\t2) Minimal length threshold\n")

Fasta = open (sys.argv[1], "r")

fasta = {}; seqname = ()

for line in Fasta:
	line = re.sub("\n$","",line)
	if re.search("^$",line):
		continue
	if re.search("^>",line):
		capture = re.search("^>(\S+)",line)
		seqname = capture.group(1)
	else:
		if seqname not in fasta:
			fasta[seqname] = line
		else:
			fasta[seqname] = fasta[seqname] + line

threshold = int(sys.argv[2])

for seqname in fasta:
	seq = fasta[seqname]
	if len(seq) >= threshold:
		print(">",seqname,"\n",seq,"\n",sep="",end="")

		
