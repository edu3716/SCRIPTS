#!/usr/bin/perl
use strict; use warnings;

die "INFO: It converts a multi-line FASTA file into a FASTA file where every sequence is written in a single text line\n\nInsert a FASTA input and will print that FASTA in a 1 line per seq manner\n" unless @ARGV == 1;

my %fasta = ();
my $seq = ();


while (<>) {
	chomp;
	if ($_ =~ />(.+)$/) {
		$seq = $1;
	} else {
		$fasta{$seq} .= $_;
	}
}

foreach my $seq (sort (keys %fasta)) {
	print ">$seq\n$fasta{$seq}\n";
}

=c
