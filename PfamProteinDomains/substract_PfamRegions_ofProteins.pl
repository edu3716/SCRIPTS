#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: It takes a given set of FASTA sequences, and prints subregions of that FASTA sequences, one for each Pfam domain detected.\n\nInsert: 1) FASTA; 2) PfamScan Output (in .pfamscan); 3) List of PfamDomains to ignore\n\n" unless @ARGV == 3;

open (ToIgnore, "<$ARGV[2]");

my %toignore = ();

while (<ToIgnore>) {
	chomp; next if $_ =~ /^$|^#/;
	$toignore{$_} = 1;
}

close ToIgnore;

open (Fasta, "<$ARGV[0]");

my %fasta = (); my $seqname = ();

while (<Fasta>) {
	chomp; next if $_ =~ /^$|^#/;
	if ($_ =~ /^>(\S+)/) {
		$seqname = $1;
	} else {
		$fasta{$seqname} .= "$_";
	}
}

close Fasta;

open (PfamScan, "<$ARGV[1]");

my %counter = ();

while (<PfamScan>) {
	chomp; next if $_ =~ /^$|^#/;
	$_ =~ s/\s+/\t/g;
	my @line = split ('\t', $_); my $seqname = $line[0]; my $domain = $line[6]; my $left = $line[1]; my $right = $line[2];
	next if exists $toignore{$domain};
	my $sequence = substr ($fasta{$seqname}, $left, $right - $left);
	$counter{$seqname}{$domain} ++;
	print ">$seqname\_$domain\-$counter{$seqname}{$domain}\n$sequence\n";
}

close PfamScan;
