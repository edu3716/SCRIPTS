#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: It gets rid of sequenes which in a given multiple sequence alignment FASTA file have less than a certain length.\nInsert: 1) FASTA file. Can be an alignment, in that case, remove gaps. 2) Raw length used as a threshold to discard sequences that are below or equalorgreaterthan. [If below --> seqs below that length are discarded. If equalorgreaterthan --> seqs = or > than that length are discarded. Discarded means not printed]. 3) Write discard_below or discard_equalorgreaterthan\nOutput:1seqline FASTA filtered file.\n\n" unless @ARGV == 3;

open (Fasta, "<$ARGV[0]");

my %fasta = ();
my $seq = ();


while (<Fasta>) {
	chomp;
	next if $_ =~ /^$|^#/;
	$_ =~ s/-//g;
	next if $_ =~ /^\n$/;
	if ($_ =~ /^>(\S+)/) {
		$seq = $1;
	} else {
		$fasta{$seq} .= $_;
	}
}

close Fasta;

my $threshold = ();

if ($ARGV[1] =~ /(\d+)/) {
	$threshold = $1;
} else {
	die "Write a number in \$ARGV[1]\n";
}

if ($ARGV[2] =~ /discard_below/) {

	foreach my $seqname (keys %fasta) {
		my $length = length $fasta{$seqname};
		if ($length >= $threshold) {
			print ">$seqname\n$fasta{$seqname}\n";
		}
	}

} elsif ($ARGV[2] =~ /discard_equalorgreaterthan/) {

	foreach my $seqname (keys %fasta) {
		my $length = length $fasta{$seqname};
		if ($length < $threshold) {
			print ">$seqname\n$fasta{$seqname}\n";
		}
	}

} else {
	warn "Write discard_below or discard_equalorgreaterthan in \$ARGV[2]\n";
}
