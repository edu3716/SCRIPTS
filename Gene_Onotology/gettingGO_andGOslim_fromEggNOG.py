#!/usr/bin/env python3
import sys; import re

	# Note_1: On the reason to use goslim_yeast.obo instead of goslim_generic.obo
		# 0) Pros of using goslim_yeast.obo --> the annotations are thought for a unicellular organism, and hence more representative of what genes are doing in the average eukaryotic cell
		# 1) Cons of using goslim_yeast.obo instead of goslim_generic.obo --> In goslim_generic.obo, the term GO:0005622 intracellular anatomical structure is recognized in the subset of go_slims, whereas not in the goslim_yeast.obo. Therefore, this term would not lead to any post-slim term with _yeast but yes with _generic
		# 2) goslim_yeast.obo is used in the manuscript 'Systematic evaluation of horizontal gene transfer between eukaryotes and viruses; DOI:10.1038/s41564-021-01026-3'
	# Note_2: There are some GO terms which are, as well as their parent nodes, absent at least from the goslim_yeast.obo and goslim_generic.obo and in my opinion they shouldn't be absent. For example: the GO term GO:0006950, response to stress. I'm not going to add them in my manual approach, because then the representation in GOslim may be unbalanced. I will ignore them. The consequence of this is that among the 17378 H.sap protein with GO terms annotated (3676 don't have any GO annotation from eggnog), 311 (<2%) won't have annotations because of this GO slim process. If go.obo is used instead of go-basic.obo, the number is 261 instead of 311. However, go-basic is the one recommended for most GO-based annotation tools
	# Note_3: A total of 332 GOs in Hsap GO term annotations from eggNOG are not in the obo-basic graph
	# Note_4: On considering alternative GO id names:
		# 0) It is very rare for a GO term to have an alternative name among the slim terms when the default name is not among the slim terms
		# 1) In absolute terms, only 1 sequence ended up without any GO Slim term if alternative names are not considered.
		# 2) Among 138005 GO slim terms captured in total when alternative names are also considered, 3739 (2.7%) were captured thanks to considering alternative names
		# 3) Most times what happens is that only the alternative GO term name is not found in the graph, and this alternative name allows to capture the parent nodes of the GO and hence to find the corresponding GO slim. This happened with 20046 GO terms for 6042 Hsap proteins, but as seen in 2), only in very few cases the GO slim term remain uncaptured for a given protein, probably because another GO term whose original name appears in the graph allowed to capture that same GO slim term
		# 4) Overall, the fact of not considering the alternative GO term names wouldn't cause too much of missing data (2.7%)

if len(sys.argv) != 6:
	sys.exit('INFO: It takes the GO annotations from the eggnog output file, and reduces the GO redundancy by collapsing GO terms and leaving only those GO terms found in the desired goslim file. (go.obo and GO slim files can be downloaded from http://geneontology.org/docs/download-ontology/#subsets).\n\nInsert:\n\t1) GO slims [~/SCRIPTS/Gene_Ontology/Files/GO_slims/goslim_yeast.obo . See inside of the script for an explanation of why is "goslim_yeast.obo" prefered over "goslim_generic.obo"]\n\t2) go-basic.obo [~/SCRIPTS/Gene_Ontology/Files/go-basic.obo]\n\t3) Output file from eggNOG, including one column with the seqname and one column with a comma-separated list of the GO terms annotated for that seq\n\t4) Fasta with all seqs to get seqnames [~/Desktop/Osmotrophy_project/Fastas/AllTogether/all.fa]\n\t5) Columns in the eggNOG annotation output file where seqname and GOannotations are find (e.g., 0-6 if seqname is found in the first col and GOannotations are found in the 7th col)\n')

# 0) Lading FASTA to get all seqnames from the study
inputFile = open(sys.argv[4],'r')

all_seqnames = {}
for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^>',line):
		seqname = re.search('^>(\S+)',line); seqname = seqname.group(1); all_seqnames[seqname] = 1
		
inputFile.close()

# 1) Loading go.obo to capture alternative names
inputFile = open(sys.argv[2],'r')

currentGO = ""; altid_dict = {}; current_ontology = {}
for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^$',line):
		continue
	if re.search('^id: ',line):
		capture = re.search(': (\S+)', line)
		currentGO = capture.group(1)
	if re.search('^alt_id: ',line):
		capture = re.search('alt_id: (\S+)$', line)
		current_altid = capture.group(1)
		altid_dict[current_altid] = currentGO

inputFile.close()

# 2) Loading GO slim
inputFile = open(sys.argv[1],'r')

go_slims = {}; currentGO = ""; currentName = ""; name_GOtype = {}
for line in inputFile:
	line = re.sub('\n$','',line)
	if re.search('^$',line):
		continue
	if re.search('^id: ',line):
		capture = re.search(': (\S+)', line)
		currentGO = capture.group(1)
	elif re.search('^name: ',line):
		capture = re.search(': (.+)$', line)
		currentName = capture.group(1)
		go_slims[currentGO] = currentName
	elif re.search('^alt_id: ',line):
		capture = re.search(': (\S+)', line)
		currentGO = capture.group(1)
		go_slims[currentGO] = currentName
	elif re.search('\[Typedef\]',line):
		break
	elif re.search('^namespace: ',line):
		capture = re.search(': (\S+)', line)
		GOtype = capture.group(1)
		name_GOtype[currentName] = GOtype

inputFile.close()

	# Deleting from go_slims all the GOs that correspond to the names "molecular_function", "biological_process", "cellular_compartment". These terms are in go_slims for goslim_yeast.obo but not for goslim_generic.obo. In goslim_yeast.obo they are included in order to represent sequences with missing data for these three GO categories; I'm not interested in that.
gosToDelete = ['GO:0008150','GO:0000004','GO:0007582','GO:0044699','GO:0003674','GO:0005554','GO:0005575','GO:0008372']
for go in gosToDelete:
	if go in go_slims:
		del go_slims[go]

# 3) Loading eggnog and compressing GO information according to GO slim
inputFile = open(sys.argv[3],'r')

import networkx; import obonet
url='http://purl.obolibrary.org/obo/go/go-basic.obo'
if not re.search('basic',sys.argv[2]):
	url='http://purl.obolibrary.org/obo/go/go.obo'
graph = obonet.read_obo(url) # is a directed acyclic graph https://networkx.github.io/documentation/networkx-1.10/reference/algorithms.dag.html
colName,colGO = re.split('-',sys.argv[5]); colName = int(colName); colGO = int(colGO)

seq_GOs = {}; seq_GOslims = {}
for line in inputFile:
	line = re.sub('\n$','',line); s_line = re.split('\t',line)
	if re.search('^$',line):
		continue
	if not re.search('GO',s_line[colGO]):
		continue
	seqname = s_line[colName]; go_list = re.split(',',s_line[colGO]); seq_GOs[seqname] = {}; seq_GOslims[seqname] = {}
	for go in go_list:
		seq_GOs[seqname][go] = 1
		if graph.has_node(go):# 332 out of 22222 from Hsap's Eggnog annotations are not in the graph
			gos_toInspect = []; gos_toInspect.append(go)
			descendants = networkx.algorithms.dag.descendants(graph,go)
			for goToInspect in descendants:
				gos_toInspect.append(goToInspect)
			for goToInspect in gos_toInspect:
				if goToInspect in go_slims:
					seq_GOslims[seqname][goToInspect] = go_slims[goToInspect]
				elif goToInspect in altid_dict:# --> this does not seem to occur
					altgoToInspect = altid_dict[goToInspect]
					if altgoToInspect in go_slims:# --> the upper condition does not seem to occur
						seq_GOslims[seqname][goToInspect] = go_slims[goToInspect] # I store the GO as it is in the slim file, i.e., I change the alternative name for the original name
#						print('1',seqname,'GO:',go,'altGO:',altgoToInspect,'within GO slim')#D
#					else:#D --> this does not seem to occur
#						print('1',seqname,'GO:',go,'altGO:',altgoToInspect,'is not within GO slim')#D
		elif go in altid_dict:
			altgo = altid_dict[go]
			if graph.has_node(altgo):
				gos_toInspect = []; gos_toInspect.append(altgo); gos_toInspect.append(go) # go is also appended because there are 20 GO terms that are in go_slim but in the graph (because they have alternative names)
				descendants = networkx.algorithms.dag.descendants(graph,altgo)
				for goToInspect in descendants:
					gos_toInspect.append(goToInspect)
				for goToInspect in gos_toInspect:
					if goToInspect in go_slims:# --> this occurs with quite a high frequency
						seq_GOslims[seqname][goToInspect] = go_slims[goToInspect]
#						print('2',seqname,'GO:',go,'altGO:',altgo,'goToInspect:',goToInspect,'within GO slim')#D
					elif goToInspect in altid_dict:
						altgoToInspect = altid_dict[goToInspect]
						if altgoToInspect in go_slims: # this does not seem to occur
							seq_GOslims[seqname][goToInspect] = go_slims[goToInspect] # I store the GO as it is in the slim file, i.e., I change the alternative name for the original name
#							print('2',seqname,'GO:',go,'altGO:',altgo,'goToInspect:',goToInspect,'altgoToInspect:',altgoToInspect,'within GO slim')#D
#			else:#D --> this seems to occur only very few times
#				print('2',seqname,'GO:',go,'altGO:',altgoToInspect,'is not within the graph')#D

inputFile.close()

# 4) Printing
print("#Seqname\tSeq_allGOs\tSeq_allGOslims\tSeq_allGOslimsNamesBiologicalProcess\tSeq_allGOslimsNamesCellularComponent\tSeq_allGOslimsNamesMolecularFunction")
for seqname in all_seqnames:
	seq_allGOs = "NA"; seq_allGOslims = "NA"
	if seqname in seq_GOs:
		seq_allGOs = ','.join(seq_GOs[seqname]); seq_allGOslims = ','.join(seq_GOslims[seqname])
	seq_allGOslimsNamesBiologicalProcess = "NA"; seq_allGOslimsNamesCellularComponent = "NA"; seq_allGOslimsNamesMolecularFunction = "NA"
	seq_GOslims_GOtype = {}; seq_GOslims_GOtype["biological_process"] = []; seq_GOslims_GOtype["cellular_component"] = []; seq_GOslims_GOtype["molecular_function"] = []
	if seqname in seq_GOslims:
		for go in seq_GOslims[seqname]:
			GOtype = name_GOtype[go_slims[go]]
			seq_GOslims_GOtype[GOtype].append(seq_GOslims[seqname][go])
	if len(seq_GOslims_GOtype["biological_process"]) > 0:
		seq_allGOslimsNamesBiologicalProcess = ','.join(seq_GOslims_GOtype["biological_process"])
	if len(seq_GOslims_GOtype["cellular_component"]) > 0:
		seq_allGOslimsNamesCellularComponent = ','.join(seq_GOslims_GOtype["cellular_component"])
	if len(seq_GOslims_GOtype["molecular_function"]) > 0:
		seq_allGOslimsNamesMolecularFunction = ','.join(seq_GOslims_GOtype["molecular_function"])
	print(seqname,seq_allGOs,seq_allGOslims,seq_allGOslimsNamesBiologicalProcess,seq_allGOslimsNamesCellularComponent,seq_allGOslimsNamesMolecularFunction,sep='\t')
