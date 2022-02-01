#!/usr/bin/perl
use strict; use warnings;

die "Insert 1) Fasta file (the sequences has to be in one line); 2) file with seqs to select (1 seqname per line; e.g. ~/SCRIPTS/Accessory_files/reduced_taxon_sampling_abbreviations.txt). ADVERTENCIA: no usar per trobar + d'1 seq per identificador (ex: si hi ha un id que és Scer i busquem amb fasta amb + d'1 seq amb aquest id, fallarà pq escapa el grep a la q troba la seq\n" unless @ARGV == 2;

open (Seqs_to_select, "<$ARGV[1]");

my @seqs_to_select = ();

while (<Seqs_to_select>) {
	chomp;
	next if $_ =~ /^$|#/;
	my $line = ();
	if ($_ =~ /(\S+)/) {
		$line = $1;
	}
	$line =~ s/^>//;# new
	push (@seqs_to_select, $line);#new
}

close Seqs_to_select;

my $file_path = ();

if ($ARGV[0] =~ /(\S+)/) {
	$file_path = $1;
}

foreach my $seq (@seqs_to_select) {
	my $grep_command = "grep -P \"^>$seq\$\" -A 1 -m 1 $file_path";	#	my $grep_command = "grep -P '>$seq\$' -x -A 1 -m 1 $file_path";
#	my $grep_command = "grep -P \"^>$seq\$|^>$seq \" -A 1 -m 1 $file_path";	#	my $grep_command = "grep -P '>$seq\$' -x -A 1 -m 1 $file_path";#
#	my $grep_command = "grep -P \"^>$seq\" -A 1 -m 1 $file_path";	#	my $grep_command = "grep -P '>$seq\$' -x -A 1 -m 1 $file_path";#
	system $grep_command;
}
