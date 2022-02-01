#!/usr/bin/perl
use strict; use warnings;

die "From a BLAST outfmt6 file, it removes those hits where the query and the subject are the same sequence\n" unless @ARGV == 1;

while (<>) {
	chomp;
	my @line = split ('\t', $_);
	my $query = $line[0];
	my $subject = $line[1];
	unless ($query =~ /$subject/) {
		print "$_\n";
	}
}
