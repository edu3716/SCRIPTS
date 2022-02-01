#!/usr/bin/perl
use strict; use warnings;

die "INFO: It counts the number of occurrences of a given nucleotide base and the GC content from a given FASTA file.\n" unless @ARGV == 1;

my $seqs_counter = 0;
my ($A, $G, $C, $T, $N) = 0;
my $total_letters = 0;

while (<>) {
	chomp;
	if ($_ =~ />/) {
		$seqs_counter ++;
	}
	next if $_ =~ />/;
	my @letters = split ('', $_);
	foreach my $letter (@letters) {
		$total_letters ++;
		if ($letter =~ /A/i) {
			$A ++;
		} elsif ($letter =~ /G/i) {
			$G ++;
		} elsif ($letter =~ /C/i) {
			$C ++;
		} elsif ($letter =~ /T/i) {
			$T ++;
		} else {
			$N ++;
		}
	}
}

my $av_A = $A / $total_letters * 100;
my $av_G = $G / $total_letters * 100;
my $av_C = $C / $total_letters * 100;
my $av_T = $T / $total_letters * 100;
my $av_N = $N / $total_letters * 100;

my $gc_content = $av_G + $av_C;

print "total_letter: $total_letters\ngc_content_in_%: $gc_content; A: $av_A; G: $av_G; C: $av_C; T: $av_T; N: $av_N\ncounts_in_absoulute_numbers: A: $A; G: $G; C: $C; T: $T; N: $N\n";
