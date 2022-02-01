#!/usr/bin/perl
use strict; use warnings;

die "Insert: 1) GFF3 file post PASA 2nd update; 2) Species abb (e.g. Mvib)\n" unless @ARGV == 2;

open (Gff, "<$ARGV[0]");

while (<Gff>) {
	chomp;
	if ($_ =~ /^#PROT/) {
		my @line = split ('\t', $_);
		my @sub_line = split (' ', $line[0]);
		my $gene_name = $ARGV[1]."_".$sub_line[1];
		my $gene_seq = $line[1];
		print ">$gene_name\n$gene_seq\n";
	}	
}

close Gff;
