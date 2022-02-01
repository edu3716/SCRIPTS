#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: From a BLAST .outfmt6 file and a list of queries (or subject) sequences to consider (or to ignore), it only keeps (or remove) from .outfmt6 those lines containing hits of the queries/subjects specified.\nInsert:\n\t1) List of queries to keep in the .outfmt6 output\n\t2) .outfmt6\n\t3) query | subject\n\t4) ignore | keep\n\n" unless @ARGV == 4;

open (List, "<$ARGV[0]");

my %keep = ();

while (<List>) {
	chomp;
	next if $_ =~ /^$|^#/;
	$keep{$_} = 1;
}

close List;

open (Outfmt6, "<$ARGV[1]");

if ($ARGV[3] =~ /ignore/) {

	while (<Outfmt6>) {
		chomp;
		next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		if ($ARGV[2] =~ /query/) {
			next if exists $keep{$line[0]};
			print "$_\n";
		} elsif ($ARGV[2] =~ /subject/) {
			next if exists $keep{$line[1]};
			print "$_\n";
		} else {
			die "Write query or subject in \$ARGV[2]\n";
		}
	}

} elsif ($ARGV[3] =~ /keep/) {

	while (<Outfmt6>) {
		chomp;
		next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		if ($ARGV[2] =~ /query/) {
			next unless exists $keep{$line[0]};
			print "$_\n";
		} elsif ($ARGV[2] =~ /subject/) {
			next unless exists $keep{$line[1]};
			print "$_\n";
		} else {
			die "Write query or subject in \$ARGV[2]\n";
		}
	}

} else {
	die "Write ignore or keep in \$ARGV[3]\n";
}

close Outfmt6;
