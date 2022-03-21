# SCRIPTS
A set of Python and Perl scripts to perform modifications or analyses of FASTA files, MSA files and BLAST results

**Gene_Ontology:** This directory includes scripts to work with Gene Ontology terms

	gettingGO_andGOslim_fromEggNOG.py --> It takes the GO annotations from the eggnog output file, and reduces the GO redundancy by collapsing GO terms and leaving only those GO terms found in the desired goslim file (go.obo and GO slim files can be downloaded from http://geneontology.org/docs/download-ontology/#subsets)

**MultipleSequenceAlignmentTools:** This directory includes scripts to perform modifications or analyses of Multiple Sequence Alignment files in FASTA format.

	AAfreqsPerTaxa.py --> It counts the amino acid frequency for every sequence in the alignment
	clean_align.pl --> It clean a given multiple sequence alignment FASTA, keeping only the positions of interest.
	counting_missingDataPerSeqInMSA.py --> It computes statistics from a multiple sequence alignment, including information about missing data (gaps).
	countingMSAsize.py --> It prints the number of sites of a given multiple sequence alignment (FASTA).
	discard_seqs_below_X_length.pl --> It gets rid of sequenes which in a given multiple sequence alignment FASTA file have less than a certain length
	recoding.pl --> It every amino acid state of a given multiple sequence alignment into the corresponding state of the SR4 recoding scheme [https://doi.org/10.1093/molbev/msm144]
	removeSeqsHavingOnlyGaps.py --> It takes a trimmed alignment and prints it after removing seqs containing only gaps, and also removes number of sites in seqname (information added by trimAl
	removing_fast_evolver_positions.pl --> You input an alignment and .rate file from IQtree as well as the number of fast evolver categories that you want to exclude and it removes from the alignment the positions corresponding to that categories
	reportseqs_below_AVERAGE-MEDIAN-length.pl --> You put a FASTA and a threshold between 0-100 and write seqs which length is below the threhsold. That threshold is the % of MEDIAN length.

**ParsingBLASTfiles:** This directory includes scripts to perform modifications or analyses of BLAST tabular output files (i.e., results from BLAST alignments produced with the command -outfmt 6. It can include extra columns, and some scripts doesn't require the default column order).

	blastToBed.py --> It turns a BLAST file outfmt6 into a BED file, using the queries or the subjects as chromosomes
	calculating_query_coverage_good.pl --> For each query, and considering only those alignments with the best target, calculates \%query_coverage and average \%id between the different alignments between query and the best target
	checking_speciesRepresentationInTargetHits.py --> It parses a tabular BLAST output file to find the relative representation of each species in the database among the top hits of the sequences from each species in the query set.
	computing_queryOrTargetCoverage_perTargetOrQuery.pl --> It gets from a BLAST outfmt6 with qlen and slen columns the average_id and coverage of every target per query or of every query per target
	extracted_hitted_translated_seqs_from_tBLASTn.pl --> from a BLAST .outfmt6 file, it extracts subregions from query or subject sequence [i.e. BLASTx or tBLASTn] and then one with the 6 putative frames with less stop codons is written
	filtering_percent_id.pl --> From a BLAST .outfmt6 file, it prints only those lines with a perc_identity greater than the desired threshold
	keeping_BestHit_perQueryTargetPair_scoreCriteria.py --> From a BLAST .outfmt6 file, it keeps one hit per query-target pair, the one with the highest score.
	keepingOrIgnoring_alignmentlines_ofthedesiredqueriesOrTargets.pl --> From a BLAST .outfmt6 file and a list of queries (or subject) sequences to consider (or to ignore), it only keeps (or remove) from .outfmt6 those lines containing hits of the queries/subjects specified.
	parsing_blast_evalue.pl --> It discards hits from a BLAST .outfmt6 file whose E-value scores are lower than a given threshold
	removing_redundance.pl --> From a BLAST outfmt6 file, it removes those hits where the query and the subject are the same sequence
	sortingTargetsByScore.py --> It reads a BLAST outfmt6 file, sorts the hits of every query by the desired numeric alignment metric, and allows to print only a subset of best hits per query if desired.
	
**PfamProteinDomains:** This directory includes scripts to perform modifications or analyses of sequence protein domain information from PfamScan.


	parsing_pfamscan_to_arqdom_files.pl --> Insert the output from pfamscan.pl. It will output a tsv file with the first column including the sequence name, and the second column including all the protein domain found by PfamScan on that sequence
	substract_PfamRegions_ofProteins.pl --> It takes a given set of FASTA sequences, and prints subregions of that FASTA sequences, one for each Pfam domain detected
	
**ParsingFASTAfiles:** This directory includes scripts to perform modifications or analyses of FASTA files.

	adding_lengths_fasta_seqnames.pl --> It reads a given FASTA file and prints sequence length information in the corresponding sequence names.
	add_suffix_to_some_FASTAseqnames.pl --> It reads a FASTA file and includes a suffix to a subset of the sequence names
	changingSeqnamesAccordingToAfile.pl --> Replace FASTA seqnames for names in a file.
	countingNumbSeqsInTheFasta.py --> It counts the number of sequences in a FASTA file.
	discard_duplicatedSeqs.py --> It cleans a given FASTA file from duplicated sequences (based on seqname)
	excludeseqs_from_fasta.pl --> It excludes a subset of sequences from a FASTA file (based on sequence name)
	fasta_splitter.py --> It splits a given FASTA file in a subset of FASTA files.
	fastqToFasta.py --> It converts a given FASTQ file into a FASTA file.
	fishingSeqsFromFASTA_andPrintingToDiffFiles.py --> It allows to fish different subsets of sequences from a FASTA file and print each subset to a distinct FASTA file.
	formatting_fasta.pl --> It converts a multi-line FASTA file into a FASTA file where every sequence is written in a single text line
	reversingProtSeqs.py --> It reads a FASTA file and reverses the sequences
	subPrintingFasta.py --> It selects a subset of sequences from a FASTA file (based on sequence name)

**GenomeParsing:** This directory includes scripts to perform modifications or analyses of genome FASTA files.

	computing_per_intergenicregions_genome.py --> It reads a given genome (FASTA file) and its corresponding GFF3 file and prints information about the fraction of the genome without genes.
	counting_bases.pl --> It counts the number of occurrences of a given nucleotide base and the GC content from a given FASTA file.
	dinucleotide_counter.pl --> It prints the occurrences of every dinucleotide from a given FASTA file.
	extracting_regions.pl --> It substracts regions from a given genome FASTA file.
	
**PhylogeneticTreesParsing:** This directory includes scripts to perform modifications or analyses of phylogenetic trees in Newick format.

	computing_nodalAndBranchLengthDistances_betweenNodes.py --> From a Newick file, it computes distances between nodes using ETE3 toolkit (must be installed).
	computingRFdistance.py --> It computes the RF distance between two phylogenetic trees (Newick format, ETE3 tooklit must be installed).
	computingRFdistance.allVsAll.py --> It computes the RF distance between a list of phylogenetic trees (Newick format, ETE3 tooklit must be installed). They can be species trees or gene trees
	distFromRootToTips_medianAndStd.py --> It computes the median and std_dev of all distances from the tips to the root of a given Newick file
	gettingMeanAndMedianNodalSupports.py --> It computes the mean and median nodal support value of a given Newick file.
	gettingParentNodalSupportsAndBranchLengthForTerminalNodes.py --> It reads a Newick tree file including nodal supports (ete3 module is required). From it, it prints a .tsv file with one row per leaf and 6 columns per row including information on (i) filename, (ii) support for the parent node in the tree, (iii) branch length distance to parent node, (iv) rel. branch length distance to parent node, (v) Z-score branch length distance to parent node, (vi) branch name.
	insert_longName_in_trees.pl --> It reads a phylogenetic tree in Newick format and updates sequence label names (e.g., from species abbreviations -Hsap- to full species names -Homo_sapiens-).
	nodalSupportAndBLinfo.py --> It reads a Newick tree file including nodal supports (ete3 module is required). From it, it prints a .tsv file with one row per node and 9 columns per row including information on (i) filename, (ii) nodal support label, (iii) branch length distance to parent node, (iv) rel. branch length distance to parent node, (v) Z-score branch length distance to parent node, (vi) branch length distance to root (midpoint rooting), (vii) rel. branch length distance to root (midpoint rooting), (viii) Z-score branch length distance to root (midpoint rooting), (ix) the universal node identifier (i.e., the set of names from the leaves that descend from the node, printed altogether without whitespaces in the middle and sorted in an alphabetical descending order).
