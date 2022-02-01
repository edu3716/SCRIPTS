#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 2:
	sys.exit('Insert FASTA file')

fastaFile = open(sys.argv[1],'r')

length_storage = {}; sp = ''; sp_counts = {}

for line in fastaFile:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	if re.search('>',line):
		seqname = re.search('>(\S+)',line); seqname = seqname.group(1); s_seqname = re.split('_',seqname); sp = s_seqname[0]
		if sp not in length_storage:
			length_storage[sp] = 0
			sp_counts[sp] = 0
	else:
		length_storage[sp] += len(line)
		sp_counts[sp] += 1
		
fastaFile.close()

print('Sp\tTotal proteome length (AA)\tNumber of proteins\tAverage protein length (AA)')
for sp in sorted(length_storage,key=length_storage.get, reverse=True):
	print(sp,length_storage[sp],sp_counts[sp],length_storage[sp]/sp_counts[sp],sep='\t')
