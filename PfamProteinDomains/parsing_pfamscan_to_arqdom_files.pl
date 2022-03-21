#!/usr/bin/perl
use strict; use warnings;

die "Insert the output from pfamscan.pl. It will output a tsv file with the first column including the sequence name, and the second column including all the protein domain found by PfamScan on that sequence.\n" unless @ARGV == 1;

my %container = ();

while (<>) {
	chomp;
	next if $_ =~ /^$|^#/;
	my $line = $_;
	$line =~ s/\s+/\t/g;
	my @splitted_line = split ('\t', $line);
	my $seqname = $splitted_line[0]; my $domain = $splitted_line[6];
	unless (exists $container{$seqname}) {
		$container{$seqname} = $domain;
	} else {
#		unless ($container{$seqname} =~ /$domain/) {
			$container{$seqname} .= " $domain";
#		}
	}
}

foreach my $seqname (sort (keys %container)) {
	print "$seqname\t$container{$seqname}\n";
}
