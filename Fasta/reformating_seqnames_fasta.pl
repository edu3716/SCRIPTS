#!/usr/bin/perl
use strict; use warnings;

my %fasta = ();
my $seq_name = ();

open (Fasta, "<$ARGV[0]");

while (<Fasta>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$seq_name = $1;
	} else {
		$fasta{$seq_name} .= $_;
	}
}
	
close Fasta;

my $organism_name = ();

if ($ARGV[0] =~ /(\w+)\.fasta/) {
	$organism_name = $1;
}

foreach my $protein (keys %fasta) {
	print ">".$organism_name."_".$protein."\n".$fasta{$protein}."\n";
}