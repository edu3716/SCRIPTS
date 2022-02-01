#!/usr/bin/env python3

import sys
import re

if len(sys.argv) != 2:
	sys.exit("\nInfo: You pass a FASTA file and converts it in 1seqline, removing also repeated sequences\n\nInput:\n\t1) allSeqsUsed.fa\n")

fasta = open(sys.argv[1],"r")
temp = open("temp.temp","w")

for line in fasta:
	if not re.search(">", line):
		line = re.sub('\n$','',line)
		temp.write (line)#
	else:
		line_to_print = "\n" + line;
		temp.write (line_to_print)
		
fasta.close()
temp.close()

temp_reading = open("temp.temp","r")

seqname = (); fasta = {}

for line in temp_reading:
	line = re.sub("\n$",'',line)
	if re.search("^$|^#",line):
		continue
	if re.search(">(\S+)",line):
		seqname = re.sub(">","",line)
	else:
		fasta[seqname] = line
	

temp_reading.close()

for seqname in sorted(fasta):
	print (">",seqname,"\n",fasta[seqname],"\n",sep="",end="")

import os

os.remove("temp.temp")
