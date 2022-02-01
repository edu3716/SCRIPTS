#!/usr/bin/perl
use strict; use warnings;

die "Insert 1) Fasta (exclude GAPS); 2) Number of desired blocks (e.g. 10, if max length is 700, first block 1-70, etc)\n" unless @ARGV == 2;

open (Fasta, "<$ARGV[0]");

my %fasta = ();
my $seq = ();

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$/;
	if ($_ =~ /^>(\S+)/) {
		$seq = $1;
	} else {
		$fasta{$seq} .= $_;
	}
}

close Fasta;

#
#foreach my $seq (keys %fasta) {print ">$seq\n$fasta{$seq}\n";}
#
my $block = ();

if ($ARGV[1] =~ /(\d+)/) {
	$block = $1;
}

my $max_length = 0;
my $total_seqs = ();

foreach my $seq (keys %fasta) {
	$total_seqs ++;
	my $current_length = length ($fasta{$seq});
	if ($current_length > $max_length) {
		$max_length = $current_length;
	}
}

my $threshold = $max_length / $block;

my @threshold_boundaries = ();

for (my $i = $max_length; $i >= 0; $i -= $threshold) {
	push (@threshold_boundaries, $i);
}

push (@threshold_boundaries, 0);

my %blocks_counter = ();
my %seqs_per_block = ();

my @sorted_threshold_boundaries = sort {$a <=> $b} (@threshold_boundaries);

my $counter = 0;

foreach my $boundary (@sorted_threshold_boundaries) {
	if ($boundary != $max_length) {
		my $left = $sorted_threshold_boundaries[$counter]; my $right = $sorted_threshold_boundaries[$counter + 1];
		my $key_name = "$left";
		foreach my $seq (keys %fasta) {
			my $length = length ($fasta{$seq});
			if ($length > $left && $length <= $right) {
				unless (exists $blocks_counter{$key_name}) {
					$blocks_counter{$key_name} = 1;
				} else {
					$blocks_counter{$key_name} ++;
				}
				unless (exists $seqs_per_block{$key_name}) {
					$seqs_per_block{$key_name} = "$seq\n";
				} else {
					$seqs_per_block{$key_name} .= "$seq\n";
				}
			}
		}
		$counter ++;
	}
}

foreach my $block (sort {$a <=> $b} (keys %blocks_counter)) {
	print "$block --> $blocks_counter{$block}\n";
}

foreach my $block (sort {$a <=> $b} (keys %seqs_per_block)) {
	print "$block\n$seqs_per_block{$block}\n";
}
