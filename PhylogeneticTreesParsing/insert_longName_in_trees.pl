#!/usr/bin/perl
use strict; use warnings;

die "INFO: It reads a phylogenetic tree in Newick format and replaces sequence label names (e.g., from species abbreviations to full species names).\n\nInsert:\n\t1) Phylogenetic tree (Newick file)\n\t2) A tabular file with two columns per row: col_1: new name (will replace the old one, e.g., Homo_sapiens). col_2: old name (will be replaced by the new one, e.g., Hsap)" unless @ARGV == 2;

open (LongName, "<$ARGV[1]");

my %fourToLong = ();

while (<LongName>) {
	chomp;
	next if $_ =~ /^$|^#/;
	my @line = split('\t',$_);
	$fourToLong{$line[1]} = $line[0];
}

close LongName;

open (Tree, "<$ARGV[0]");

while (<Tree>) {
	chomp;
	foreach my $fourName (keys %fourToLong) {
		my $longName = $fourToLong{$fourName};
		$_ =~ s/$fourName/$longName/g;
	}
	print "$_\n";
}

close Tree;
