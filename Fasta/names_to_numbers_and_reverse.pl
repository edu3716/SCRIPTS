#!/usr/bin/perl
use strict; use warnings;

die "INFO: you pass a FASTA and it converts the seqnames to numbers, leaving a dictionary with the equivalences. Is able to do the opposite.\n\nInput:\n\t1) from_names_to_numbers / dictionary_path [if from_numbers_to_names is desired]\n\t2) FASTA input\n\nOutput\n\t: if from_names_to_numbers --> FASTA with names changed to numbers and the dictionary with the equivalences.\n\tif dictionary_path [i.e. from_numbers_to_names] --> a FASTA with the correct names using the dictionary.\n\n" unless @ARGV == 2;

if ($ARGV[0] =~ /from_names_to_numbers/) {

	my %equi = ();
	my $counter = 0;
	my $seqname = ();
	my %fasta = ();

	open (Fasta, "<$ARGV[1]");

	while (<Fasta>) {
		chomp;
		next if $_ =~ /^$|^#/;
		if ($_ =~ />(.+)/) {
		        $seqname = $1;
		        $counter ++;
		        $equi{$counter} = $seqname;
		        $seqname = $counter;
		} else {
		        $fasta{$seqname} .= "$_";
		}
	}

	close Fasta;

	open (Fasta_printer, ">$ARGV[1].names_in_numbers");

	foreach my $seqname (sort {$a <=> $b} (keys %fasta)) {
		print Fasta_printer ">$seqname\n$fasta{$seqname}\n";
	}

	close Fasta_printer;

	open (Dict_printer, ">$ARGV[1].dict");

	foreach my $number (sort {$a <=> $b} (keys %equi)) {
		my $original_name = $equi{$number};
		print Dict_printer "$number\t$original_name\n";
	}

	close Dict_printer;

} else {

	open (Dict, "<$ARGV[0]");

	my %dict = ();

	while (<Dict>) {
		chomp;
		next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_); my $number = $line[0]; my $original_name = $line[1];
		$dict{$number}	= $original_name;
	}

	close Dict;

	open (Fasta, "<$ARGV[1]");

	my $seqname = ();
	my %fasta = ();

	my $output_fastaname = $ARGV[1];
	$output_fastaname =~ s/names_in_numbers/correct_names/;

	open (Fasta_oknames, ">$output_fastaname");

	while (<Fasta>) {
		chomp;
		next if $_ =~ /^$|^#/;
		if ($_ =~ />(.+)/) {
			print Fasta_oknames ">$dict{$1}\n";
		} else {
			print Fasta_oknames "$_\n";
		}
	}

	close Fasta;

	close Fasta_oknames;
}

