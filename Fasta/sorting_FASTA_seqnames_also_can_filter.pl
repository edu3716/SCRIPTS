#!/usr/bin/perl
use strict; use warnings;

die "\n\nInfo: You pass a FASTA prints that FASTA (or only the seqnames) sorted according to their length, in increasing or decreasing order. Also, you can (i) remove from the output sequences below certain length threshold and (ii) remove from the output all the sequences except those present in a List file\nInput:\n\t1) Fasta\n\t2) Decreasing / Increasing [order of printing]\n\t3) Length threshold to exclude [less than X are not printed. If no threshold desired, write 0]\n\t4) List of seqs to consider or NOT [if wants to consider all the seqs in the FASTA, write NOT]\n\t5) Write seqs or names [seqs --> FASTA output style; names --> only print seqnames]\n\n" unless @ARGV == 5;

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

my %list_of_seqs = ();

unless ($ARGV[3] =~ /^NOT$/) {
	
	open (List, "<$ARGV[3]") or die "\$ARGV[3] do not exists!\n";

	while (<List>) {
		chomp;
		next if $_ =~ /^$|^#/;
		$list_of_seqs{$_} = 1;
	}

	close List;
	
} else {
	%list_of_seqs = %fasta;
}

my %length_storage = ();

foreach my $name (keys %list_of_seqs) {
	my $current_length = length $fasta{$name};
	unless (exists $length_storage{$current_length}) {
		$length_storage{$current_length} = $name;
	} else {
		$length_storage{$current_length} .= "\t$name";
	}
}

if ($ARGV[1] =~ /Decreasing/) {

	foreach my $current_length (sort {$b <=> $a} (keys %length_storage)) {
		next if $current_length < $ARGV[2];
		my @current_seqs = split ('\t', $length_storage{$current_length});
		foreach my $current_seq (@current_seqs) {
			if ($ARGV[4] =~ /^seqs$/) {
				print ">$current_seq\n$fasta{$current_seq}\n";
			} else {
				print "$current_seq\n";
			}
		}
	}

} elsif ($ARGV[1] =~ /Increasing/) {

	foreach my $current_length (sort {$a <=> $b} (keys %length_storage)) {
		next if $current_length < $ARGV[2];
		my @current_seqs = split ('\t', $length_storage{$current_length});
		foreach my $current_seq (@current_seqs) {
			if ($ARGV[4] =~ /^seqs$/) {
				print ">$current_seq\n$fasta{$current_seq}\n";
			} else {
				print "$current_seq\n";
			}
		}
	}

} else {
	warn "Write Decreasing or Increasing in \$ARGV[2].\n";
}
