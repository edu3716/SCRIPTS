#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: Replace FASTA seqnames for names in a file.\n\nInsert:\n\t1) FASTA.\n\t2) Table with old and new names.\n\t3) Column of the table where old name is present (first column is 0).\n\t4) Column of the table where new name is present (first column is 0).\n\n" unless @ARGV == 4;

die "Write number in \$ARGV[2] and \$ARGV[3]\n" unless $ARGV[2] =~ /^\d+$/;
die "Write number in \$ARGV[2] and \$ARGV[3]\n" unless $ARGV[3] =~ /^\d+$/;

open (Table, "<$ARGV[1]");

my %names_oldToNew = ();

while (<Table>) {
	chomp; next if $_ =~ /^$|^#/;
	my @line = split ('\t', $_);
	my $newname = $line[$ARGV[3]]; my $oldname = $line[$ARGV[2]];
	$names_oldToNew{$oldname} = $newname;
}


close Table;

open (Fasta, "<$ARGV[0]");

my $seqname = (); my %fasta = ();

while (<Fasta>) {
	chomp; next if $_ =~ /^$|^#/;
	if ($_ =~ />(\S+)/) {
		if (exists $names_oldToNew{$1}) {
			$seqname = $names_oldToNew{$1};
		} else {
			$seqname = $1;
		}
	} else {
		$fasta{$seqname} .= "$_";
	}
}

close Fasta;

foreach my $seqname (keys %fasta) {
	print ">$seqname\n$fasta{$seqname}\n";
}
