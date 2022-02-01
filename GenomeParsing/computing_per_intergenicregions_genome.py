#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('INFO: It reads a given genome (FASTA file) and its corresponding GFF3 file and prints information about the fraction of the genome without genes.\n\n\t1) genome\n\t2) gff3')

genomeFile = open(sys.argv[1],'r')

genomeLength = 0

for line in genomeFile:
	line = re.sub('\n$','',line)
	if re.search('^$|^#|^>',line):
		continue
	else:
		genomeLength += len(line)
	
genomeFile.close()

gff3File = open(sys.argv[2],'r')

positionsCounter = 0

for line in gff3File:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	s_line = re.split('\t',line)
	if re.search('^gene$',s_line[2]):
		start_position = int(s_line[3]); end_position = int(s_line[4])
		positionsCounter += end_position - start_position

gff3File.close()


print('Fraction of genome with no genes =',positionsCounter/genomeLength)
print('Length fraction of genome with no genes =',(genomeLength-positionsCounter))
