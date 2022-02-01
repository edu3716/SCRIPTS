#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: It reads a FASTA file and includes a suffix to a subset of the sequence names\nInsert:\n\t1) FASTA to add the suffix\n\t2) List of seqnames to add the suffix\n\t3) suffix to add (e.g. _potentialcontaminant)\n\n" unless @ARGV == 3;

open (List, "<$ARGV[1]");

my %change_name = ();

while (<List>) {
	chomp;
	next if $_ =~ /^$|^#/;
	$_ =~ s/^>//;
	$change_name{$_} = 1;
}

close List;

open (Fasta, "<$ARGV[0]");

my $name = (); my %fasta = ();

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$|^#/;
	if ($_ =~ />(\S+)/) {
		$name = $1;
	} else {
		$fasta{$name} .= "$_";
	}
}

close Fasta;

my $pattern = $ARGV[2];

foreach my $old_name (keys %fasta) {
	my $new_name = ();
	if (exists $change_name{$old_name}) {
		$new_name = "$old_name"."$pattern";
	} else {
		$new_name = $old_name;
	}
	print ">$new_name\n$fasta{$old_name}\n";
}
