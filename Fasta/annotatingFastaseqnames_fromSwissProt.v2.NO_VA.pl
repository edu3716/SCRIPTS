#!/usr/bin/perl
use strict; use warnings;

die "Insert: 1) File_to_modify_names; 2) Blastoutput vs SwissProt\n" unless @ARGV == 2;

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

open (Filetomodify, "<$ARGV[0]");

while (<Filetomodify>) {
	chomp; next if $_ =~ /^$|^#/;
	foreach my $original_name (keys %formatted_names) {
		$_ =~ s/$original_name/$formatted_names{$original_name}/g;
	}
	print "$_\n";
}

close Filetomodify;
