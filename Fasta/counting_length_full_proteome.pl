#!/usr/bin/perl
use strict; use warnings;

die "INFO: fiques proteoma i et dóna diferents dades de counting (com num de prots, average prot length, total proteome length, etc)\nInsert a Fasta file with a name: speciesabb.fa (e.g. Scer.fa)\n
OUTPUT: species_abb\taverage_protein_length\ttotal_num_prots\ttotal_length_proteome\n" unless @ARGV == 1;
my $species_abb = ();

if ($ARGV[0] =~ /([A-Za-z]{4}).fa/) {
	$species_abb = $1;
}

my $gene = ();
my %fasta = ();

while (<>) {
	chomp;
	next if $_ =~ /^$/;
	if ($_ =~ />(\S+)/) {
		$gene = $1;
	} else {
		$fasta{$gene} .= $_;
	}	
}

my $total_number_prots = scalar (keys %fasta);

my $total_length_proteome = ();

foreach my $gene (keys %fasta) {
	my $current_length = length ($fasta{$gene});
	$total_length_proteome += $current_length;
}

my $average_protein_length = $total_length_proteome / $total_number_prots;

print "$species_abb\t$average_protein_length\t$total_number_prots\t$total_length_proteome\n";
