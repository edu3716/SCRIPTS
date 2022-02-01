#!/usr/bin/env python3
import sys; import re

if len(sys.argv) < 3:
	sys.exit("\nINFO: You pass a 1seqline FASTA and the interval of seqs that you want to print (e.g. from 5 to 15, 5-15, both included, etc.).\nInsert:\n\t1) FASTA file 1seqline;\n\t2) From which seq to which seq do you want to print (e.g. 1-10 will print from the first seq to the 10 seq, both included)\n")


(n1,n2) = (0,0)

if re.search("\d+-\d+",sys.argv[2]):
	capture = re.search("(\d+)-(\d+)",sys.argv[2]); (n1,n2) = (int(capture.group(1)),int(capture.group(2)))
else:
	sys.exit("Write an interval in 2), like 1-10")

fasta = open(sys.argv[1],"r")

counter = 0
controler = 0

for line in fasta:
	line = re.sub("\n$","",line)
	if re.search("^$|^#",line):
		continue
	if re.search("^>",line):
		counter = counter + 1
	if counter == n1:
		controler = 1
	if counter > n2:
		controler = 2
	if controler == 1:
		print (line)
	if controler == 2:
		break	

fasta.close()
