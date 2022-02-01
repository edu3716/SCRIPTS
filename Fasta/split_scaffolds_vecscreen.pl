#!/usr/bin/perl
use strict; use warnings;

die "\n\nInsert a FASTA and a .tsv file with seqname_leftposition_rightposition (post VecScreen acquired info). Warning: only one cut per sequence.\n\tInput:\n\t\t1) FASTA\n\t\t2) tsv file with seqname_leftposition_rightposition\n\tOuput:\n\t\tFASTA file with splitted scaffolds. Now splitted scaffolds are renamed as ScaffoldX_1 and ScaffoldX_2, for example.\n\n" unless @ARGV == 2;

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

open (Outfmt6, "<$ARGV[1]");

my %left_positions = (); my %right_positions = ();

while (<Outfmt6>) {
	chomp;
	next if $_ =~ /^$|^#/;
	my @line = split ('\t', $_);
	my $query = $line[0]; my $position_1 = $line[1] - 1; my $position_2 = $line[2] - 1;
	if ($position_1 < $position_2) {
		$left_positions{$query} = $position_1;
		$right_positions{$query} = $position_2;
	} else {
		$left_positions{$query} = $position_2;
		$right_positions{$query} = $position_1;
	}
}

close Outfmt6;

foreach my $query (keys %fasta) {
	if (exists $right_positions{$query}) {
		my $left = $left_positions{$query}; my $right = $right_positions{$query};
		my $full_seq = $fasta{$query};
		my $full_length = length $full_seq;
		my $left_seq = substr ($full_seq, 0, $left);
#		$left_seq = length $left_seq;
		print ">$query\_1\n$left_seq\n";
		my $right_seq = substr ($full_seq, $right, $full_length - $right);
#		$right_seq = length $right_seq;
		print ">$query\_2\n$right_seq\n";
	} else {
		print ">$query\n$fasta{$query}\n";
	}
}
