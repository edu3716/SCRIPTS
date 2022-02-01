#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: you input a FASTA and prints only seqs >= / < than X length\nInput: 1) FASTA; 2) Threshold length; 3) write largerorequal or less\nOutput:1seqline FASTA with seqs >= / < than \$ARGV[1]\n\n" unless @ARGV == 3;

my $threshold = $ARGV[1];

open (Fasta, "<$ARGV[0]");

my %fasta = (); my $seqname = ();

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$|^#/;
	if ($_ =~ />(\S+)/) {
		$seqname = $1;
	} else {
		$fasta{$seqname} .= "$_";
	}
}

close Fasta;

foreach my $seqname (keys %fasta) {
	my $seq = $fasta{$seqname};
	my $length = length $seq;
	if ($ARGV[2] =~ /largerorequal/) {
		if ($length >= $threshold) {
			print ">$seqname\n$seq\n";
		}
	} elsif ($ARGV[2] =~ /less/) {
		if ($length < $threshold) {
			print ">$seqname\n$seq\n";
		}		
	} else {
		die "write include or exclude in \$ARGV[2]\n";
	}
}

