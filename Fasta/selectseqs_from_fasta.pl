#!/usr/bin/perl
use strict; use warnings;

die "Usage: 1) Fasta; 2) List with seqs to select (e.g. ~/SCRIPTS/Accessory_files/reduced_taxon_sampling_abbreviations.txt; begin each line with one pattern that identifies some of the seqs that you want to include; lines starting with # are ignored)\n" unless @ARGV == 2;

open (Fasta, "<$ARGV[0]");

my $seq_name = ();
my %fasta = ();

while (<Fasta>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$seq_name = $1;
	} else {
		$fasta{$seq_name} .= $_;
	}
}

close Fasta;

open (Select_list, "<$ARGV[1]");

my %select_dict = ();

while (<Select_list>) {
	chomp;
	next if $_ =~ /^#|^$/;
	if ($_ =~ /^>?(\S+)/) {
		my $select_seq = $1;
		$select_seq =~ s/^>//;
		$select_dict{$select_seq} = 1;
	}
}

close Select_list;

my %selected_seqs = ();

#foreach my $seq (keys %fasta) {
#	foreach my $select_seq (@select_list) {
#		if ($seq =~ /$select_seq/) {
#			print ">$seq\n$fasta{$seq}\n";
#			unless (exists $selected_seqs{$select_seq}) {
#				$selected_seqs{$select_seq} = $seq;
#			} else {
#				$selected_seqs{$select_seq} .= "\t$seq";
#			}
#		}
#	}
#}

foreach my $seq (keys %fasta) {
	if (exists $select_dict{$seq}) {
		print ">$seq\n$fasta{$seq}\n";
	}
}

