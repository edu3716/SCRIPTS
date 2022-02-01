#!/usr/bin/perl
use strict; use warnings;

die "Insert 1) Fasta; 2) List of seqs to exclude (1 per line, without '>')\n" unless @ARGV == 2;

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

my @exclude_list = ();

while (<Exclude_list>) {
	chomp;
	next if $_ =~ /^#|^$/;
	if ($_ =~ /^>?(\S+)/) {
		my $exclude_seq = $1;
		push (@exclude_list, $_);
	}
}

close Exclude_list;


my %excluded_seqs = ();

foreach my $seq (keys %fasta) {
	foreach my $excluded_seq (@exclude_list) {
		if ($seq =~ /$excluded_seq/) {
			$excluded_seqs{$seq} = 1;
		}
	}
}

foreach my $seq (keys %fasta) {
	unless (exists $excluded_seqs{$seq}) {
		print ">$seq\n$fasta{$seq}\n";
	}
}

warn "Excluded seqs:";

foreach my $excluded_seq (keys %excluded_seqs) {
	warn "$excluded_seq";
}

print "\n";