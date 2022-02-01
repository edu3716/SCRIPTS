#NEW

#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: For each query, and considering only those alignments with the best target, calculates \%query_coverage and average \%id between the different alignments between query and the best target\nInput: 1) Outfmt6; 2) File with scaffold_name<tab>length or write the number in which qlen is expected in -outfmt6 (normally I add it at 13, starting from 1); 3) \%global_query_coverage threshold [between 0-100; if lower, info for that scaffold won't be printed]; 4) \%current_normalized_weighted_id [between 0-100; if lower, info for that scaffold won't be printed].\nOutput: query_name, subject_name, average_id%, query_coverage\n\n" unless @ARGV == 4;

die "write a number in \$ARGV[2] and \$ARGV[3]\n" unless $ARGV[2] =~ /^\d+$/;
die "write a number in \$ARGV[2] and \$ARGV[3]\n" unless $ARGV[3] =~ /^\d+$/;

my %scaffold_lengths = ();

if ($ARGV[1] =~ /[A-Za-z\.]/) {

	open (Lengths, "<$ARGV[1]") or die "file doesn't exist!\n";

	while (<Lengths>) {
		chomp;
		my @line = split ('\t', $_);
		$scaffold_lengths{$line[0]} = $line[1];
	}

	close Lengths;
	
} elsif ($ARGV[1] =~ /^(\d+)$/) {

	my $column = $1 - 1;

	open (Outfmt6, "<$ARGV[0]");

	while (<Outfmt6>) {
		chomp;
		my @line = split ('\t', $_);
		$scaffold_lengths{$line[0]} = $line[$column];
	}

	close Outfmt6;

} else {die "put a existing file or a number of column in \$ARGV[1]\n";}

open (Outfmt6, "<$ARGV[0]");

my %query_subject = ();

my %total_window_length_per_scaffold = ();
my %accumulated_weighted_id = ();

my %counting_positions_scaffold = ();
my %avoid_repeating_positions = ();

my %total_identity = ();

while (<Outfmt6>) {
	chomp;
	my @line = split ('\t', $_);
	my $scaffold = $line[0]; my $subject = $line[1];
	unless (exists $query_subject{$scaffold}) {
		$query_subject{$scaffold} = $subject;
	} else {
		unless ($query_subject{$scaffold} =~ /^$subject$/) {# así aseguro el mts_1 aunque no lo haya especificado en el blast
			next;
		}
	}	
	my $identity = $line[2]; my $current_window_length = abs ($line[7] - $line[6]);
	my $left = (); my $right = ();
	if ($line[7] > $line[6]) {
		$left = $line[6]; $right = $line[7];
	} else {
		$left = $line[7]; $right = $line[6];
	}		
	for (my $i = $left; $i <= $right; $i++) {
		unless (exists $avoid_repeating_positions{$scaffold}{$i}) {
			$avoid_repeating_positions{$scaffold}{$i} = $identity;
			$total_identity{$scaffold} += $identity;
			$counting_positions_scaffold{$scaffold} += 1;
		} elsif ($identity > $avoid_repeating_positions{$scaffold}{$i}) {
			$total_identity{$scaffold} = $total_identity{$scaffold} - $avoid_repeating_positions{$scaffold}{$i}; 
			$total_identity{$scaffold} += $identity;
			$avoid_repeating_positions{$scaffold}{$i} = $identity;
		}
	}		
}

close Outfmt6;

print "#query\ttarget\tav_coverage\tav_identity\n";

foreach my $scaffold (keys %scaffold_lengths) {
	next unless (exists $query_subject{$scaffold});
	my $target = $query_subject{$scaffold};
	my $current_length = $scaffold_lengths{$scaffold};
	my $covered_positions_scaffold = $counting_positions_scaffold{$scaffold};
	my $query_coverage = 100 * ($covered_positions_scaffold / $current_length);
	my $current_identity = $total_identity{$scaffold} / $counting_positions_scaffold{$scaffold};
	next unless $query_coverage > $ARGV[2]; next unless $current_identity > $ARGV[3];
	print "$scaffold\t$target\t$query_coverage\t$current_identity\n";
}
