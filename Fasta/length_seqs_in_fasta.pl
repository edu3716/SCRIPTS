#!/usr/bin/perl
use strict; use warnings;

die "Insert a FASTA file and will print the length for each seq\n" unless @ARGV == 1;

open (Fasta, "<$ARGV[0]");

my %fasta = ();
my $seq_name = ();

while (<Fasta>) {
	chomp;
	next if ($_ =~ /^$/);
	if ($_ =~ />(\S+)/) {
		$seq_name = $1;
	} else {
		$fasta{$seq_name} .= $_;
	}
}

close Fasta;

foreach my $seq_name (keys %fasta) {
	my $length = length ($fasta{$seq_name});
	print "$seq_name	$length\n";
}
