#!/usr/bin/perl
use strict; use warnings;

die "Insert: 1) Fasta; 2) Blastoutput vs SwissProt\n" unless @ARGV == 2;

open (Fasta, "<$ARGV[0]");

my %fasta = (); my $seqname = ();

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$|^#/;
	if ($_ =~ /^>(.+)$/) {
		$seqname = $1;
	} else {
		$fasta{$seqname} .= "$_";
	}
}

close Fasta;

open (Blast, "<$ARGV[1]");

my %formatted_names = ();

while (<Blast>) {
	chomp;
	next if $_ =~ /^$|^#/;
	my @line = split ('\t', $_);
	my $query = $line[0];
	my @subject_line = split ('\|', $line[1]);
	my $annotation = ();
	$subject_line[2] =~ s/_OS.*$//;
	if ($subject_line[2] =~ /^[A-Za-z0-9]+_[A-Za-z0-9]+_(.+)$/) {
		$annotation = $1;
	}
	my $new_subject_name = "$query"."_"."$annotation";
	$formatted_names{$query} = $new_subject_name;
}

close Blast;

foreach my $original_name (keys %fasta) {
	unless (exists $formatted_names{$original_name}) {
		print ">$original_name\n$fasta{$original_name}\n";
	} else {
		print ">$formatted_names{$original_name}\n$fasta{$original_name}\n";
	}
}
