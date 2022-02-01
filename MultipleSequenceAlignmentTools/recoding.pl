#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: It every amino acid state of a given multiple sequence alignment into the corresponding state of the SR4 recoding scheme [https://doi.org/10.1093/molbev/msm144]\nInput: alignment in FASTA file\nOutput: recoded alignment\n\n" unless @ARGV == 1;

#https://groups.google.com/forum/#!topic/iqtree/c7HZ9UxqwG0
# the sr4 recoding is the following:
#	A,G,N,P,S,T = A;
#	C,H,W,Y = C;
#	D,E,K,Q,R = G;
#	F,I,L,M,V = T 


my %fasta = (); my $seqname = ();

while (<>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$seqname = $1;
	} else {
		$fasta{$seqname} .= $_;
	}
}

my %formatted_fasta = ();

foreach my $seqname (keys %fasta) {
	my @sequence = split ('', $fasta{$seqname});
	foreach my $letter (@sequence) {
		if ($letter =~ /A|G|N|P|S|T/) {
			$formatted_fasta{$seqname} .= "A";
		} elsif ($letter =~ /C|H|W|Y/) {
			$formatted_fasta{$seqname} .= "C";
		} elsif ($letter =~ /D|E|K|Q|R/) {
			$formatted_fasta{$seqname} .= "G";
		} elsif ($letter =~ /F|I|L|M|V/) {
			$formatted_fasta{$seqname} .= "T";
		} else {
			$formatted_fasta{$seqname} .= "-";
		}
	}
}

foreach my $seqname (keys %formatted_fasta) {
	print ">$seqname\n$formatted_fasta{$seqname}\n";
}

