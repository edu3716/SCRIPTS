	#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit('\nINFO: You give a tsv file with OG<tab>seqs of classified as that OG (separated by white spaces) and it prints a table with the OG content per species.\nInsert:\n\t1) classification file (e.g. 1 orthogroup per line, first column orthogroup name, second columna list of all the prots classified within that orthogroup (the same should be Cowc_190...; and not NRT2-Cowc_190...);\n\t2) FASTA file that includes the sequence of all/some seqnames.\n')

classFile = open(sys.argv[1],'r')

og_sp_counter = {}; all_sp_names = {}; old_to_new_name = {}; new_names = {}

for line in classFile:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	s_line = re.split('\t',line); og = s_line[0]; seqs_list = re.split(' ',s_line[1])
	if og not in og_sp_counter:
		og_sp_counter[og] = {}
	for seq in seqs_list:
		sp = re.search('^(\S+?)_',seq)
		sp = sp.group(1)
		all_sp_names[sp] = 1
		old_to_new_name[seq] = og + '-' + seq; new_names[og + '-' + seq] = 1
		if sp not in og_sp_counter[og]:
			og_sp_counter[og][sp] = []
		og_sp_counter[og][sp].append(seq)

classFile.close()

all_og = '\t'.join(sorted(og_sp_counter.keys()))
print ('\t',all_og,sep='')#

all_sp = '\n'.join(sorted(all_sp_names.keys()))

for sp in sorted(all_sp_names):
	og_sp_toprint = []
	print(sp,sep='',end='\t')
	for og in sorted(og_sp_counter):
		if sp not in og_sp_counter[og]:
			og_sp_counter[og][sp] = 0
			og_sp_toprint.append(0)
		else:
			num_og_current_sp = len(og_sp_counter[og][sp])
			og_sp_counter[og][sp] = str(num_og_current_sp) + ' (' + ' '.join(og_sp_counter[og][sp]) + ')'
			og_sp_toprint.append(og_sp_counter[og][sp])
	for i in range(0,len(og_sp_toprint)):
		print(og_sp_toprint[i],end='\t')
	print()

# 2) Getting seqs from FASTA

fastaFile = open(sys.argv[2],'r')

fasta = {}; seqname = ''

for line in fastaFile:
	line = re.sub('\n$','',line)
	if re.search('^$|^#',line):
		continue
	if re.search('>',line):
		seqname = re.sub('>','',line)
		if seqname in old_to_new_name:
			seqname = old_to_new_name[seqname]
	else:
		if seqname not in fasta:
			fasta[seqname] = line
		else:
			fasta[seqname] += line	

fastaFile.close()

fastaPrinter = open('orthologs.fa','w')

for seqname in sorted(fasta):
	if seqname in new_names:
		fastaPrinter.write('>' + seqname + '\n' + fasta[seqname] + '\n')
