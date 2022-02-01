#!/usr/bin/perl
use strict; use warnings;

die "Insert a FASTA input and will print that FASTA in a 1 line per seq manner\n" unless @ARGV == 1;

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
