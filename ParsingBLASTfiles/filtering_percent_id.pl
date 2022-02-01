#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: From a BLAST .outfmt6 file, it prints only those lines with a perc_identity greater than the desired threshold.\nINSERT:\n\t1) .outfmt6\n\t2) column with percentage id info (normally in 2, starting counting from 0)\n\t3) percentage identity threhsold (from 0-100). Will print only lines containing values greater than it\n\n" unless @ARGV == 3;

open (Outfmt6, "<$ARGV[0]");

die "write a number in \$ARGV[1]\n" if $ARGV[1] !~ /^\d+$/;
die "write a number between 0-100 in \$ARGV[2]\n" if $ARGV[2] !~ /^\d+$/;

while (<Outfmt6>) {
	chomp;
	next if $_ =~ /^$|^#/;
	my @line = split ('\t', $_);
	my $id = $line[$ARGV[1]];
	next if $id < $ARGV[2];
	print "$_\n";
}

close Outfmt6;
