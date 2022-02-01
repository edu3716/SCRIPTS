#!/usr/bin/perl
use strict; use warnings;

die "Insert: 1) Fasta\nOutput: the same fasta but adding len=X in seqnames\n" unless @ARGV == 1;

my ($contig, %fasta);

while (<>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$contig = $1;
	} else {
		$fasta{$contig} = $_;
	}
}

my (%length);

foreach my $contig (keys %fasta) {
	my $length = length $fasta{$contig};
	$length{$contig} = $length;
}

foreach my $contig (keys %fasta) {
	print ">$contig\tlen=$length{$contig}\n$fasta{$contig}\n";
}
