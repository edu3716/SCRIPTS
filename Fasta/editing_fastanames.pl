#!/usr/bin/perl
use strict; use warnings;

die "Insert 1) Fasta; 2) prefix to add to all fasta names; 3) file with 1 seq per line with seqs desired to add the prefix (alternatively write NOT_FILTER)\n" unless @ARGV == 3;

my $name = ();
my %fasta = ();

open (Fasta, "<$ARGV[0]");

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$/;
	if ($_ =~ /^>(\S+)/) {
		$name = $1;
	} else {
		$fasta{$name} .= $_;
	}
}

close Fasta;

my $prefix = $ARGV[1];

my $desired_seqs = ();

unless ($ARGV[2] =~ /NOT_FILTER/) {
	open (Desired_seqs, "<$ARGV[2]");
	
	while (<Desired_seqs>) {
		chomp;
		next if $_ =~ /^$/;
		$desired_seqs .= "$_";
	}
	
	close Desired_seqs;

	foreach my $name (keys %fasta) {
		my $filtered_name = ();
		if ($name =~ /([A-Z]\S+)$/) {
			$filtered_name = $1;
		}
		if ($desired_seqs =~ /$filtered_name/) {
			print ">".$prefix."_".$name."\n$fasta{$name}\n";	
		} else {
			print ">$name\n$fasta{$name}\n";
		}
	}
} else {
	foreach my $name (keys %fasta) {
		print ">".$prefix."_".$name."\n$fasta{$name}\n";
	}
}