#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: you pass the typical FASTA with seqnames with prefix of the orthogroup like e.g. >orc1_Hsap and prints a second column with the name without the prefix (e.g. from >orc1_Hsap to >Hsap)\n\nInsert:\n\t1) Insert a or FASTA file (wihtout gaps).\n\n" unless @ARGV == 1;

while (<>) {
	chomp; next if $_ =~ /^$|^#/;
	print "$_";
	$_ =~ s/>?^\S+?_//;
	print "\t$_\n";
}
