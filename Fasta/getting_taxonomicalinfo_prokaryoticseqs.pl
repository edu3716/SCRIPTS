#!/usr/bin/perl
use strict; use warnings;

die "\n\nINFO: you put a FASTA with UP (prokaryotic) seqs and it searches the equivalent sequences in NR and then modifies the name of that sequences [in a Nexus tree or in a FASTA] adding info of genus (or species if genus is void) as well as of phylum (or other higher level taxonomical category if phylum is void).\nINPUT:1) Fasta (with UP seqs, aka prokaryotic seqs) or .outfmt6 output against NCBI (and then skip blast step, must contain '.outfmt6' or '.vs.' in the name); 2) Kind of file to modify [write Fasta or Tree; aka .fa 1 seqperline or .nexus from RAxML or Iqtree]; 3) Filename to modify; 4) Nº threads; 5) OutputName\nOUTPUT: Fasta or NexusTree with modified names.\n\n" unless @ARGV == 5;

unless ($ARGV[0] =~ /\.outfmt6|\.vs\./) {

	open (Fasta, "<$ARGV[0]");

	my %fasta = (); my $seqname = ();

	while (<Fasta>) {
		chomp;
		next if $_ =~ /^$|^#/;
		if ($_ =~ />(\S+)/) {
			$seqname = $1;
		} else {
			$fasta{$seqname} .= "$_";
		}
	}

	close Fasta;

	my $tempSeqName = ();

	if ($ARGV[0] =~ /([A-Za-z0-9\.]+)$/) {
		$tempSeqName = $1;
	}


	open (Fasta_output1, ">$tempSeqName.to_blastpfast.temp");

	foreach my $seq (keys %fasta) {
		if ($seq =~ /^UP/) {
			print Fasta_output1 ">$seq\n$fasta{$seq}\n";
		}
	}

	close Fasta_output1;

	my $num_threads = $ARGV[3];

	system "blastp -task blastp-fast -num_threads $num_threads -query $tempSeqName.to_blastpfast.temp -db /media/Second_disk/NCBI_things/nr_Proteins/nr -max_target_seqs 1 -outfmt \"6 std qlen slen\" -out $tempSeqName.to_blastpfast.vs.nr.temp";

	system "perl ~/SCRIPTS/Blast/calculating_query_coverage_good.pl $tempSeqName.to_blastpfast.vs.nr.temp 13 99 99 > $tempSeqName.keepingonlyidentical.temp";

	open (nr_assig_table, "<$tempSeqName.keepingonlyidentical.temp");

	my %assignation_table = (); my %reverse_assignation_table = ();

	while (<nr_assig_table>) {
		chomp;
		next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		$assignation_table{$line[0]} = $line[1];
		$reverse_assignation_table{$line[1]} = $line[0];
	}

	close nr_assig_table;

	open (Prot_2_acc, "</media/Second_disk/NCBI_things/Taxonomy_browser/Accesion2taxid/Proteins/prot.accession2taxid") or die "/media/Second_disk/NCBI_things/Taxonomy_browser/Accesion2taxid/Proteins/prot.accession2taxid do not exist!!!!\n";

	my %accession_to_search = ();
	my %name_to_taxonomy = ();

	while (<Prot_2_acc>) {
		chomp;
		my @line = split ('\t', $_);	
		my $subject = $line[1];
		my $taxonomy_number = $line[2];
		if (exists $reverse_assignation_table{$subject}) {
			$name_to_taxonomy{$reverse_assignation_table{$subject}} = $subject;
			push (@{$accession_to_search{$taxonomy_number}}, $subject);
		}
	}

	close Prot_2_acc;

	open (Tax_dictio, "</media/Second_disk/NCBI_things/Taxonomy_browser/Dictionary_TaxonomyNCBI/dictionary_taxonomyNCBI.dict") or die "/media/Second_disk/NCBI_things/Taxonomy_browser/Dictionary_TaxonomyNCBI/dictionary_taxonomyNCBI.dict do not exist!!!!\n";

	my %subjects_taxonomy = ();

	while (<Tax_dictio>) {
		chomp;
		my @line = split ('\t', $_);
		my $taxonomy_number = $line[0];
		my $taxonomy_info = $line[1];
		if (exists $accession_to_search{$taxonomy_number}) {
			# modificar aquí el taxonomy_info
			$taxonomy_info =~ s/ /_/g;
			my @sub_taxonomy_info = split (';', $taxonomy_info);
			$sub_taxonomy_info[1] =~ s/:/-/;
			unless ($sub_taxonomy_info[1] =~ /no_rank/) {
				$taxonomy_info = "$sub_taxonomy_info[1]";
			} else {
				$sub_taxonomy_info[0] =~ s/:/-/;
				$taxonomy_info = "$sub_taxonomy_info[0]";
			}
			@sub_taxonomy_info = reverse @sub_taxonomy_info;
			$sub_taxonomy_info[3] =~ s/:/-/;
			$taxonomy_info .= "_$sub_taxonomy_info[3]";
			$taxonomy_info =~ s/,|\(|\)/-/g;
			$taxonomy_info =~ s/-+/-/g;
			# modificar aquí el taxonomy_info
			foreach my $subject (@{$accession_to_search{$taxonomy_number}}) {
				$subjects_taxonomy{$reverse_assignation_table{$subject}} = $taxonomy_info;
			}
		}
	}

	close Tax_dictio;

	open (OutputPrinter, ">$ARGV[4]");

	if ($ARGV[1] =~ /Fasta/) {

		open (Fasta_to_modify, "<$ARGV[2]");

		while (<Fasta_to_modify>) {
			chomp;
			next if $_ =~ /^$|^#/;
			if ($_ =~ />(\S+)/) {
				my $seqname = $1;
				if (exists $subjects_taxonomy{$seqname}) {
					print OutputPrinter ">$seqname\_$subjects_taxonomy{$1}\n";
				} else {
					print OutputPrinter "$_\n";
				}
			} else {
				print OutputPrinter "$_\n";
			}
		}

		close Fasta_to_modify;


	} elsif ($ARGV[1] =~ /Tree/) {

		open (Tree, "<$ARGV[2]");

		while (<Tree>) {
			foreach my $subject (keys %subjects_taxonomy) {
				my $taxonomy_info = $subjects_taxonomy{$subject};
				$_ =~ s/$subject\n/$subject\_$taxonomy_info\n/g;
				$_ =~ s/$subject:/$subject\_$taxonomy_info:/g;
			}
			print OutputPrinter "$_";
		}

		close Tree;

	} else {
		die "Write Fasta or Tree in \$ARGV[1]!!\n";
	}

	close OutputPrinter;

} else {	# es decir, si es el output del blast against NR directamente:

	my $tempSeqName = ();

	if ($ARGV[0] =~ /([A-Za-z0-9\.]+)$/) {
		$tempSeqName = $1;
	}

	system "perl ~/SCRIPTS/Blast/calculating_query_coverage_good.pl $ARGV[0] 13 99 99 > $tempSeqName.keepingonlyidentical.temp";

	open (nr_assig_table, "<$tempSeqName.keepingonlyidentical.temp");

	my %assignation_table = (); my %reverse_assignation_table = ();

	while (<nr_assig_table>) {
		chomp;
		next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		$assignation_table{$line[0]} = $line[1];
		$reverse_assignation_table{$line[1]} = $line[0];
	}

	close nr_assig_table;

	open (Prot_2_acc, "</media/Second_disk/NCBI_things/Taxonomy_browser/Accesion2taxid/Proteins/prot.accession2taxid") or die "/media/Second_disk/NCBI_things/Taxonomy_browser/Accesion2taxid/Proteins/prot.accession2taxid do not exist!!!!\n";

	my %accession_to_search = ();
	my %name_to_taxonomy = ();

	while (<Prot_2_acc>) {
		chomp;
		my @line = split ('\t', $_);	
		my $subject = $line[1];
		my $taxonomy_number = $line[2];
		if (exists $reverse_assignation_table{$subject}) {
			$name_to_taxonomy{$reverse_assignation_table{$subject}} = $subject;
			push (@{$accession_to_search{$taxonomy_number}}, $subject);
		}
	}

	close Prot_2_acc;

	open (Tax_dictio, "</media/Second_disk/NCBI_things/Taxonomy_browser/Dictionary_TaxonomyNCBI/dictionary_taxonomyNCBI.dict") or die "/media/Second_disk/NCBI_things/Taxonomy_browser/Dictionary_TaxonomyNCBI/dictionary_taxonomyNCBI.dict do not exist!!!!\n";

	my %subjects_taxonomy = ();

	while (<Tax_dictio>) {
		chomp;
		my @line = split ('\t', $_);
		my $taxonomy_number = $line[0];
		my $taxonomy_info = $line[1];
		if (exists $accession_to_search{$taxonomy_number}) {
			# modificar aquí el taxonomy_info
			$taxonomy_info =~ s/ /_/g;
			my @sub_taxonomy_info = split (';', $taxonomy_info);
			$sub_taxonomy_info[1] =~ s/:/-/;
			unless ($sub_taxonomy_info[1] =~ /no_rank/) {
				$taxonomy_info = "$sub_taxonomy_info[1]";
			} else {
				$sub_taxonomy_info[0] =~ s/:/-/;
				$taxonomy_info = "$sub_taxonomy_info[0]";
			}
			@sub_taxonomy_info = reverse @sub_taxonomy_info;
			$sub_taxonomy_info[3] =~ s/:/-/;
			$taxonomy_info .= "_$sub_taxonomy_info[3]";
			$taxonomy_info =~ s/,|\(|\)/-/g;
			$taxonomy_info =~ s/-+/-/g;
			# modificar aquí el taxonomy_info
			foreach my $subject (@{$accession_to_search{$taxonomy_number}}) {
				$subjects_taxonomy{$reverse_assignation_table{$subject}} = $taxonomy_info;
			}
		}
	}

	close Tax_dictio;

	open (OutputPrinter, ">$ARGV[4]");

	if ($ARGV[1] =~ /Fasta/) {

		open (Fasta_to_modify, "<$ARGV[2]");

		while (<Fasta_to_modify>) {
			chomp;
			next if $_ =~ /^$|^#/;
			if ($_ =~ />(\S+)/) {
				my $seqname = $1;
				if (exists $subjects_taxonomy{$seqname}) {
					print OutputPrinter ">$seqname\_$subjects_taxonomy{$1}\n";
				} else {
					print OutputPrinter "$_\n";
				}
			} else {
				print OutputPrinter "$_\n";
			}
		}

		close Fasta_to_modify;


	} elsif ($ARGV[1] =~ /Tree/) {

		open (Tree, "<$ARGV[2]");

		while (<Tree>) {
			foreach my $subject (keys %subjects_taxonomy) {
				my $taxonomy_info = $subjects_taxonomy{$subject};
				$_ =~ s/$subject\n/$subject\_$taxonomy_info\n/g;
				$_ =~ s/$subject:/$subject\_$taxonomy_info:/g;
			}
			print OutputPrinter "$_";
		}

		close Tree;

	} else {
		die "Write Fasta or Tree in \$ARGV[1]!!\n";
	}

	close OutputPrinter;

}
