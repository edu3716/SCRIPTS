# SCRIPTS
A set of Python and Perl scripts for comparative genomics

MultipleSequenceAlignmentTools

	AAfreqsPerTaxa.py --> It counts the amino acid frequency for every sequence in the alignment
	clean_align.pl --> It clean a given multiple sequence alignment FASTA, keeping only the positions of interest.
	counting_missingDataPerSeqInMSA.py --> It computes statistics from a multiple sequence alignment, including information about missing data (gaps).
	countingMSAsize.py --> It prints the number of sites of a given multiple sequence alignment (FASTA).
	discard_seqs_below_X_length.pl --> It gets rid of sequenes which in a given multiple sequence alignment FASTA file have less than a certain length
	recoding.pl --> It every amino acid state of a given multiple sequence alignment into the corresponding state of the SR4 recoding scheme [https://doi.org/10.1093/molbev/msm144]
	removeSeqsHavingOnlyGaps.py --> It takes a trimmed alignment and prints it after removing seqs containing only gaps, and also removes number of sites in seqname (information added by trimAl
	removing_fast_evolver_positions.pl --> You input an alignment and .rate file from IQtree as well as the number of fast evolver categories that you want to exclude and it removes from the alignment the positions corresponding to that categories
	reportseqs_below_AVERAGE-MEDIAN-length.pl --> You put a FASTA and a threshold between 0-100 and write seqs which length is below the threhsold. That threshold is the % of MEDIAN length.

ParsingBLASTfiles	

	blastToBed.py --> It turns a BLAST file outfmt6 into a BED file, using the queries or the subjects as chromosomes
	calculating_query_coverage_good.pl --> For each query, and considering only those alignments with the best target, calculates \%query_coverage and average \%id between the different alignments between query and the best target
	computing_queryOrTargetCoverage_perTargetOrQuery.pl --> It gets from a BLAST outfmt6 with qlen and slen columns the average_id and coverage of every target per query or of every query per target
	extracted_hitted_translated_seqs_from_tBLASTn.pl --> from a BLAST .outfmt6 file, it extracts subregions from query or subject sequence [i.e. BLASTx or tBLASTn] and then one with the 6 putative frames with less stop codons is written
	filtering_percent_id.pl --> From a BLAST .outfmt6 file, it prints only those lines with a perc_identity greater than the desired threshold
	keeping_BestHit_perQueryTargetPair_scoreCriteria.py --> From a BLAST .outfmt6 file, it keeps one hit per query-target pair, the one with the highest score.
	keepingOrIgnoring_alignmentlines_ofthedesiredqueriesOrTargets.pl --> From a BLAST .outfmt6 file and a list of queries (or subject) sequences to consider (or to ignore), it only keeps (or remove) from .outfmt6 those lines containing hits of the queries/subjects specified.
	parsing_blast_evalue.pl --> It discards hits from a BLAST .outfmt6 file whose E-value scores are lower than a given threshold
	removing_redundance.pl --> From a BLAST outfmt6 file, it removes those hits where the query and the subject are the same sequence
	sortingTargetsByScore.py --> It reads a BLAST outfmt6 file, sorts the hits of every query by the desired numeric alignment metric, and allows to print only a subset of best hits per query if desired.
	
PfamProteinDomains

	substract_PfamRegions_ofProteins.pl --> It takes a given set of FASTA sequences, and prints subregions of that FASTA sequences, one for each Pfam domain detected
	
ParsingFASTAfiles
	adding_lengths_fasta_seqnames.pl --> It reads a given FASTA file and prints sequence length information in the corresponding sequence names.
	add_suffix_to_some_FASTAseqnames.pl --> It reads a FASTA file and includes a suffix to a subset of the sequence names
	changingSeqnamesAccordingToAfile.pl --> Replace FASTA seqnames for names in a file.
	countingNumbSeqsInTheFasta.py --> It counts the number of sequences in a FASTA file.
	discard_duplicatedSeqs.py --> It cleans a given FASTA file from duplicated sequences (based on seqname)
	excludeseqs_from_fasta.pl --> It excludes a subset of sequences from a FASTA file (based on sequence name)
	fasta_splitter.py --> It splits a given FASTA file in a subset of FASTA files.
	fastqToFasta.py --> It converts a given FASTQ file into a FASTA file.
	formatting_fasta.pl --> It converts a multi-line FASTA file into a FASTA file where every sequence is written in a single text line
	reversingProtSeqs.py --> It reads a FASTA file and reverses the sequences
	subPrintingFasta.py --> It selects a subset of sequences from a FASTA file (based on sequence name)

GenomeParsing

	computing_per_intergenicregions_genome.py --> It reads a given genome (FASTA file) and its corresponding GFF3 file and prints information about the fraction of the genome without genes.
	counting_bases.pl --> It counts the number of occurrences of a given nucleotide base and the GC content from a given FASTA file.
	dinucleotide_counter.pl --> It prints the occurrences of every dinucleotide from a given FASTA file.
	extracting_regions.pl --> It substracts regions from a given genome FASTA file.
	
PhylogeneticTreesParsing

	computing_nodalAndBranchLengthDistances_betweenNodes.py --> From a Newick file, it computes distances between nodes using ETE3 toolkit (must be installed).
	computingRFdistance.py --> It computes the RF distance between two phylogenetic trees (Newick format, ETE3 tooklit must be installed).
	distFromRootToTips_medianAndStd.py --> It computes the median and std_dev of all distances from the tips to the root of a given Newick file
	gettingMeanAndMedianNodalSupports --> It computes the mean and median nodal support value of a given Newick file.