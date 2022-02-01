#!/usr/bin/perl

use strict; use warnings;

die "Insert a Fasta file (with p-orc1 or without) and will print, sorted, the diff species abb per line\n" unless @ARGV == 1;

my %keeping_species = ();

while (<>) {
	chomp;
	if ($_ =~ /[_|>]([A-Z][a-z]{3})/) {
		$keeping_species{$1} = $1;
	}
}

foreach my $species (sort (keys %keeping_species)) {
	print "$species\n";
}
