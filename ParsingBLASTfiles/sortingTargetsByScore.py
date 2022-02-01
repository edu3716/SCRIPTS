#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 4:
	sys.exit('INFO: It reads a BLAST outfmt6 file, sorts the hits of every query by the desired numeric alignment metric, and allows to print only a subset of best hits per query if desired.\n\nInsert:\n\t1) *outfmt6\n\t2) col to choose as a metric to sort (e.g., BLAST score by default 11)\n\t3) num targets to keep per query (write 0 if no limit)')
	
metricCol = int(sys.argv[2])

maxNumbOfTargets = int(sys.argv[3])

blastFile = open(sys.argv[1],'r')

q_s_score = {}

for line in blastFile:
	line = re.sub('\n$','',line); s_line = re.split('\t',line)
	q = s_line[0]; s = s_line[1]; filterCol = float(s_line[metricCol])
	if q not in q_s_score:
		q_s_score[q] = {}
	q_s_score[q][s] = filterCol
	
blastFile.close()

for q in sorted(q_s_score):
	counter = 0
	for s in sorted(q_s_score[q],key=q_s_score[q].get,reverse=True):
#		print(q,s)#
		counter += 1
		print(q,s,q_s_score[q][s],sep='\t')
		if counter == maxNumbOfTargets:
			if maxNumbOfTargets == 0:
				continue
			break
