#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: You input an alignment and .rate file from IQtree as well as the number of fast evolver categories that you want to exclude and it removes from the alignment the positions corresponding to that categories\nInput: 1) .msa (alignment); 2) .rate file produced by Iqtree (run -TEST with the best model + G9); 3) Number of categories that you want to exclude (if 8 and 9; then write 2)\nOutput: the alignment without the fast evolver positions\n" unless @ARGV == 3;

open (Rates, "<$ARGV[1]");

my %positions_category = ();

while (<Rates>) {
	chomp;
	my @line = split ('\t', $_);
	my $position = $line[0]; my $category = $line[2];
	$position --;
	$positions_category{$position} = $category;
}

close Rates;

my %categories_to_exclude = ();
my $category_to_exclude = 9;

for (my $i = $ARGV[2]; $i > 0; $i --) {
	$categories_to_exclude{$category_to_exclude} = 1;
	$category_to_exclude --;
}

my %fasta = (); my $seqname = ();

open (Fasta, "<$ARGV[0]");

while (<Fasta>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$seqname = $1;
	} else {
		$fasta{$seqname} .= "$_";
	}
}

close Fasta;

my %modified_fasta = ();

my %warnings_message = (); my $counter_of_removed_positions = 0; my $counter_of_all_positions = 0; my $counter_of_sequences = 0;

foreach my $seqname (keys %fasta) {
	$counter_of_sequences ++;
	my @seq = split ('', $fasta{$seqname});
	for (my $i = 0; $i < @seq; $i ++) {
		$counter_of_all_positions ++;
		my $current_position_category = $positions_category{$i};
		if (exists $categories_to_exclude{$current_position_category}) {
			$warnings_message{$i} = "position $i removed: category $current_position_category";
			$counter_of_removed_positions ++;
			next;
		} else {
			$modified_fasta{$seqname} .= $seq[$i];
		}
	}
}

foreach my $seqname (keys %modified_fasta) {
	print ">$seqname\n$modified_fasta{$seqname}\n";
}

$counter_of_all_positions = $counter_of_all_positions / $counter_of_sequences;
$counter_of_removed_positions = $counter_of_removed_positions / $counter_of_sequences;
my $current_position_in_the_alignment = $counter_of_all_positions - $counter_of_removed_positions;

warn "\nthe original alignment had $counter_of_all_positions positions; now should have $current_position_in_the_alignment because there were removed $counter_of_removed_positions (see below)\n";

foreach my $removed_position_info (sort {$a <=> $b} (keys %warnings_message)) {
	warn "\t$warnings_message{$removed_position_info}\n";
}

warn "\n";
