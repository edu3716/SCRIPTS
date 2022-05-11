#!/usr/bin/env python3
import re; import sys

if len(sys.argv) != 3:
	sys.exit("\nInfo: It prints all gene sequences from the genome based on GFF3 annotations.\n\nInsert:\n\t1) The genome (FASTA file);\n\t2) The GFF3 file\n")

Fasta = open(sys.argv[1],"r") # loading genome

fasta = {}; seqname = ""
for line in Fasta:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	if re.search('^>(\S+)',line):
		capture = re.search('^>(\S+)',line)
		seqname = capture.group(1)
		fasta[seqname] = ""
	else:
		fasta[seqname] += line

Fasta.close()

Gff = open(sys.argv[2],"r") # printing exons on the fly

exon_counter = 0;
for line in Gff:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	s_line = re.split('\t',line)
	if re.search('gene',s_line[2]):
		geneName = 'NA'
		if re.search('ID=(\S+);',s_line[8]):
			geneName = re.sub('ID=','',s_line[8]); geneName = re.sub(';.+','',geneName)
		
		strandsense = s_line[6]; leftposition = int(s_line[3]); rightposition = int(s_line[4]); scaffold = s_line[0]

		current_seq = fasta[scaffold][leftposition-1:rightposition]

		if re.search('-', strandsense):
			current_seq = current_seq[::-1]
			transtab = str.maketrans('ATGC','TACG')
			current_seq = current_seq.translate(transtab)
	
		print ('>',geneName,'\n',current_seq,sep='',end='\n')

Gff.close()
