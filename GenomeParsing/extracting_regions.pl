#!/usr/bin/perl
use strict; use warnings;

die "INFO: It substracts regions from a given genome FASTA file.\n\nInsert: 1) Fasta file; 2) Scaffold name; 3) Initial position; 4) Final position; 5) Forward/Reverse strand [i.e. + or -]; 6) name of output sequence (without '>')\n" unless @ARGV == 6;

open (Fasta, "<$ARGV[0]");

my %fasta = ();
my $scaffold = ();

while (<Fasta>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$scaffold = $1;
	} else {
		$fasta{$scaffold} .= "$_";
	}

}

close Fasta;

my $sequence_scaffold = $fasta{$ARGV[1]};

my $sequence_to_print = ();

if ($ARGV[4] =~ /\+/) {
	$sequence_to_print = substr ($fasta{$ARGV[1]}, $ARGV[2], ($ARGV[3] - $ARGV[2]));
} elsif ($ARGV[4] =~ /-/) {
	$sequence_to_print = substr ($fasta{$ARGV[1]}, $ARGV[2], ($ARGV[3] - $ARGV[2]));
	my $reverse_seq = reverse $sequence_to_print;
	$reverse_seq =~ tr/ATGCatgc/TACGtagc/;
	$sequence_to_print = $reverse_seq;
}

print ">$ARGV[5]\n$sequence_to_print\n";
