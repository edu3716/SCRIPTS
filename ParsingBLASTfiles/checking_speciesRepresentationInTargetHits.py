#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 4:
	sys.exit('INFO: It parses a tabular BLAST output file to find the relative representation of each species in the database among the top hits of the sequences from each species in the query set. Species abbreviations must be indicated at the beginning of each sequence name, separated with a "_" character from the rest of the sequence name (e.g., Hsap will be the sequence name retrieved for a sequence named Hsap_1541241).\n\nInsert:\n\t1) BLAST tabular output file\n\t2) Whether to ignore self-hits or not [YES or NOT, in theory they should be always ignored]\n\t3) How many hits to be considered for each query sequence (e.g., 3 would be equivalent to max_target_hits 3, but after having ignored self-hits if "YES" has been input at 2))')

	# Loading parameters	
numbHitsToConsider = int(sys.argv[3]); ignoreSelfHitsControl = 1
if re.search('NOT',sys.argv[2]):
	ignoreSelfHitsControl = 0
	
	# Parsing BLAST outfmt 6 file
inputFile = open(sys.argv[1],'r')

queries_toIgnore = {}; counter = 0; qSp_q_sps = {}
for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^$',line):
		continue
	s_line = re.split('\t',line); q = s_line[0]; t = s_line[1]; qSp = re.sub('_.+$','',s_line[0]); tSp = re.sub('_.+$','',s_line[1])
	if q in queries_toIgnore:
		continue
	if ignoreSelfHitsControl == 1:
		if qSp == tSp:
			continue
	if qSp not in qSp_q_sps:
		qSp_q_sps[qSp] = {}
	if q not in qSp_q_sps[qSp]:
		qSp_q_sps[qSp][q] = {}
	qSp_q_sps[qSp][q][tSp] = 1
	counter += 1
	if counter == numbHitsToConsider:
		queries_toIgnore[q] = 1
		counter = 0

inputFile.close()

	# Counting number of times every target species had a hit against the query species ...
qSp_sps = {}
for sp in qSp_q_sps:
	qSp_sps[sp] = {}
	for q in qSp_q_sps[sp]:
		for tSp in qSp_q_sps[sp][q]:
			if tSp not in qSp_sps[sp]:
				qSp_sps[sp][tSp] = 0
			qSp_sps[sp][tSp] += 1
			
	# ... and then normalizing by dividing it against the number of query sequences of each query species
for sp in qSp_sps:
	for tSp in qSp_sps[sp]:
		qSp_sps[sp][tSp] = qSp_sps[sp][tSp] / len(qSp_q_sps[sp])
		
	# Printing
for sp in sorted(qSp_sps):
	for tSp in sorted(qSp_sps[sp],key=qSp_sps[sp].get,reverse=True):
		print(sp+'\t'+tSp+'\t'+str(round(qSp_sps[sp][tSp],4)))
