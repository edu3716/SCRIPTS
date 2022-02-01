#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: you pass a FASTA and .arqdom file and it prints in the seqnames the domain architectures.\n\nInsert:\n\t1) Fasta;\n\t2) Arqdom;\n\t3) Write UP or DOWN [domain architecture upstream or downstream seqname?]\n\n" unless @ARGV == 3;

open (Fasta, "<$ARGV[0]");

my %fasta = (); my $seqname = ();

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$|^#/;
	if ($_ =~ />(\S+)/) {
		$seqname = $1;
	} else {
		$fasta{$seqname} .= $_;
	}
}

close Fasta;


open (Arqdom, "<$ARGV[1]");

my %arqdom = ();

while (<Arqdom>) {
	chomp;
	my @line = split ('\t', $_);
	$line[1] =~ s/ /;/g;
	$arqdom{$line[0]} = $line[1];
}

close Arqdom;

foreach my $seq (keys %fasta) {
	my $dom = ();
	if (exists $arqdom{$seq}) {
		$dom = $arqdom{$seq};
	} else {
		$dom = "nodom";
	}
	my $seqname = ();
	if ($ARGV[2] =~ /^UP$/) {
		$seqname = "dom_$dom"."_seq_$seq";
	} elsif ($ARGV[2] =~ /^DOWN$/) {
		$seqname = "seq_$seq"."_dom_$dom";
	} else {
		die "Print UP or DOWN in \$ARGV[2].\n";
	}
	print ">$seqname\n$fasta{$seq}\n";
}
