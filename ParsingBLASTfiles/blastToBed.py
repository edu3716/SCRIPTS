#!/usr/bin/env python3
import sys; import re

if len(sys.argv) != 3:
	sys.exit("\nInfo: You pass a BLAST file outfmt6 file and it transforms it to a BED file, using the queries or the subjects as chromosomes\n\n\t1) Outfmt6 file\n\t2) query or subject\n\n")

queryOrsubject = ""

if re.search("query",sys.argv[2]):
	queryOrsubject = "query"
elif re.search("subject",sys.argv[2]):
	queryOrsubject = "subject"
else:
	sys.exit ("Write query or subject in 2)")

outfmt6 = open (sys.argv[1], "r")

covpositions_storage = {}

if re.search("query",queryOrsubject):

	for line in outfmt6:
		line = re.sub("\n$","",line)
		if re.search("^$|^#",line):
			continue
		s_line = re.split('\t',line); query = s_line[0]; qs = int(s_line[6]); qe = int(s_line[7])
		if query not in covpositions_storage:
			covpositions_storage[query] = {}
		for i in range(qs,qe):
			covpositions_storage[query][i] = 1

elif re.search("subject",queryOrsubject):

	for line in outfmt6:
		line = re.sub("\n$","",line)
		if re.search("^$|^#",line):
			continue
		s_line = re.split('\t',line); subject = s_line[1]; s1 = int(s_line[8]); s2 = int(s_line[9])
		ss = 0; se= 0	# sometimes subjects -but not queries- are aligned in reverse, fix it
		if s1 < s2:
			ss = s1; se = s2
		else:
			ss = s2; se = s1
		if subject not in covpositions_storage:
			covpositions_storage[subject] = {}
		for i in range(ss,se):
			covpositions_storage[subject][i] = 1

outfmt6.close()


for seq in covpositions_storage:
	current_positions = []
	for position in covpositions_storage[seq]: #current_positions.sort(key=int)
		current_positions.append(position)
	current_positions = sorted(current_positions, key=int)
	oldnum = 0; currentnum = 0; leftancora = 0
	for i in range(0,len(current_positions)):
		currentnum = current_positions[i]
		if (i + 1) == len(current_positions):
			print(seq,leftancora,currentnum,sep="\t")
			break
		elif oldnum == 0:
			leftancora = currentnum
			oldnum = currentnum
		elif oldnum == (currentnum - 1):
			oldnum = currentnum
		else:
#			print(seq,leftancora,currentnum,sep="\t")
			print(seq,leftancora,oldnum,sep="\t")
			oldnum = 0

