#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: strictly extract seqs from a FASTA with multiple greps at the same time [accepts >].\nInsert: 1) FASTA; 2) List to select; 3) Nº o threads; 4) Output_name\nOutput: a FASTA file with the seqs to select.\n\n" unless @ARGV == 4;

open (List, "<$ARGV[1]");

my @list = ();
my %seqnames_to_keep = ();#

while (<List>) {
	chomp;
	next if $_ =~ /^$|^#/;
	my $seqname = ();
	if ($_ =~ /(\S+)/) {
		$seqname = $1;
		$seqname =~ s/>//;
		push (@list, $seqname);
		$seqnames_to_keep{$seqname} = 1;#
	}
}

close List;

my $threads = $ARGV[2];

my $num_of_seqs = @list;

my $seqs_per_file = $num_of_seqs / $threads;

my $int = (int ($seqs_per_file)) - 1;

my $counter_1 = 1; my $counter_2 = 0;


for (my $i = 1; $i <= $num_of_seqs; $i ++) {
	if ($i <= ($int * $threads)) {
		if ($counter_2 == 0) {	
			open (Printer, ">$counter_1.temp.list");
		}
		print Printer "$list[$i - 1]\n";
		$counter_2 ++;

		if ($counter_2 == $int) {	
			close Printer;
			$counter_2 = 0;
			$counter_1 ++;
		}
	} else {
		open (Printer, ">>$threads.temp.list");
			print Printer "$list[$i - 1]\n";
		close Printer;
	}
}

my $fasta_path = $ARGV[0];

for (my $i = 1; $i < $threads; $i ++) {
	system "perl ~/SCRIPTS/Fasta/strictly_selecting_seqs.pl $fasta_path $i.temp.list > $i.temp.fa &";
}

system "perl ~/SCRIPTS/Fasta/strictly_selecting_seqs.pl $fasta_path $threads.temp.list > $threads.temp.fa";

my $output_name = $ARGV[3];

my $sleep = 5;

if (@list < 10) {
	$sleep = 10;
}

system "sleep $sleep";	# para dar tiempo a que acaben todos

my $iteration = 0;

while (1) {
	$iteration ++;
	my $counted_seqs = 0; 
	system "cat *temp.fa > $output_name";
	open (File, "<$output_name");
	
	while (<File>) {
		chomp;
		if ($_ =~ />/) {
			$counted_seqs ++;
		}
	}

	close File;

	if ($counted_seqs == $num_of_seqs) {
		warn "COOL. iteration $iteration: FASTA file have the expected num of seqs\n";
		last;
	} else {
		warn "BAD. iteration $iteration: FASTA file have $counted_seqs seqs and not $num_of_seqs\n";
		last if $iteration == 10;
		system "sleep $sleep";
		$sleep += $sleep;#
	}
}

my %seqnames_captured = ();

open (File, "<$output_name");

while (<File>) {
	chomp;
	next unless $_ =~ />/;
	$_ =~ s/>//;
	$seqnames_captured{$_} = 1;
}

close File;

foreach my $captured_seqname (keys %seqnames_captured) {
	unless (exists $seqnames_to_keep{$captured_seqname}) {
		warn "$captured_seqname captured but was not in the ones to capture\n";
	}
}

foreach my $seqnames_to_keep (keys %seqnames_to_keep) {
	unless (exists $seqnames_captured{$seqnames_to_keep}) {
		warn "$seqnames_to_keep not captured\n";
	}
}

##

system "rm *temp.list *temp.fa";
