#!/usr/bin/perl
use strict; use warnings;

die "INFO: It clean a given multiple sequence alignment FASTA, keeping only the positions of interest.\n\nInsert 1) The MSA [in Fasta]; 2) The .txt with positions to keep [19-30\n40-50...]. If GENIOUS, count -1 -1 in case of adding or substracting" unless @ARGV == 2;
open (Fasta, "<$ARGV[0]");

my %fasta = ();
my $id = ();
my @fasta_sorted = ();

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$/;
	if ($_ =~ />(\S+)/) {
		$id = $1;
		push (@fasta_sorted, $id);
	} else {
		$fasta{$id} .= $_;
	}
}

close Fasta;

open (Ranges_to_keep, "<$ARGV[1]");

my @ranges = ();

while (<Ranges_to_keep>) {
	chomp;
	next if $_ =~ /^$|^#/;
	if ($_ =~ /(\d+-\d+)/) {
		push (@ranges, $1);
	}
}

close Ranges_to_keep;

my @range_sorted = ();
my %sorter = ();

foreach my $range (@ranges) {
	if ($range =~ /(\d+)-\d+/) {
		$sorter{$1} .= $range;
	}
}

foreach my $range (sort {$a <=> $b} (keys %sorter)) {
	push (@range_sorted , $sorter{$range});
}

#### hasta aquí hemos cargado el FASTA del alineamiento y los rangos sorteados

my %selected_fasta = ();

foreach my $range (@range_sorted) {
	my $left = (); my $length = ();
	if ($range =~ /(\d+)-(\d+)/) {
		$left = $1; $length = $2 - $1;	
	}
	foreach my $seq (keys %fasta) {
		$selected_fasta{$seq} .= substr ($fasta{$seq}, $left, $length) or warn "$seq\n";
	}
}

foreach my $seq (@fasta_sorted) {
	print ">$seq\n$selected_fasta{$seq}\n";
}
