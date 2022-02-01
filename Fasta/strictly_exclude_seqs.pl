#!/usr/bin/perl
use strict; use warnings;

die "Insert 1) Fasta; 2) List of seqs to exclude (1 per line, with or out '>') --> the name to exclude has to be exact! if not, use excludeseqs_from_fasta.pl\n" unless @ARGV == 2;

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

open (Exclude_list, "<$ARGV[1]");

my %exclude_list = ();

while (<Exclude_list>) {
	chomp;
	next if $_ =~ /^#|^$/;
	if ($_ =~ /^>?(\S+)/) {
		my $exclude_seq = $1;
		$exclude_list{$exclude_seq} = 1;
	}
}

close Exclude_list;

foreach my $seq (keys %fasta) {
	unless (exists $exclude_list{$seq}) {
		print ">$seq\n$fasta{$seq}\n";
	}
}
