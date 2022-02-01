#!/usr/bin/perl
use strict; use warnings;

die "Insert a FASTA input and will print that FASTA ¡¡¡¡¡in a 1 line per seq manner!!!!!. ADVANCED: avoid the problem of those repeated seqs!!!!\n" unless @ARGV == 1;

my %fasta = ();
my $seq = ();
my $old_seq = ();
my %duplicater = ();

while (<>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$seq = $1;
	} else {
		unless (exists $duplicater{$seq} or $seq !~ /$old_seq/) {
			$fasta{$seq} .= $_;
			$duplicater{$seq} = 1;
		}
	}
	$old_seq = $seq;
}

foreach my $seq (keys %fasta) {
	print ">$seq\n$fasta{$seq}\n";
}

=c
