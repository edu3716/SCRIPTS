#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: It gets from a BLAST outfmt6 with qlen and slen columns the average_id and coverage of every target per query or of every query per target.\n\nInsert:\n\t1) outfmt6 (performed with -outfmt \"std qlen slen\").\n\t2) query or target if you want for the output the average_id and the coverage of each target per query or of each query per target; respectively.\n\n" unless @ARGV == 2;

if ($ARGV[1] =~ /^query$/) {

	open (Blast, "<$ARGV[0]");

	my %length_storage = (); my %positions = (); my %id_storage = (); my %id_counter = ();

	while (<Blast>) {
		chomp; next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		my $query = $line[0]; my $target = $line[1]; my $qlen = $line[12], my $slen = $line[13]; my $id = $line[2]; my $alig_length = $line[3]; my $qstart = $line[6]; my $qend = $line[7]; my $start_draft = $line[8]; my $send_draft = $line[9]; my $sstart = (); my $send = ();
		$length_storage{$query} = $qlen; $length_storage{$target} = $slen;
		for (my $i = $qstart; $i < $qend; $i ++) {
			$positions{$query}{$target}{$i} ++;
			$id_storage{$query}{$target} += $id;
			$id_counter{$query}{$target} ++;
		}
	}

	close Blast;

print "#Query\tTarget\tAverage_id\tAverage_query_coverage\n";#

foreach my $query (keys %positions) {
	foreach my $target (keys %{$positions{$query}}) {
		my $aligned_positions = keys %{$positions{$query}{$target}}; my $query_covered = 100 * ($aligned_positions / $length_storage{$query}); my $average_id = $id_storage{$query}{$target} / $id_counter{$query}{$target};
		print "$query\t$target\t$average_id\t$query_covered\n";
	}
}

} elsif ($ARGV[1] =~ /^subject$/) {

	open (Blast, "<$ARGV[0]");

	my %length_storage = (); my %positions = (); my %id_storage = (); my %id_counter = ();

	while (<Blast>) {
		chomp; next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		my $query = $line[0]; my $target = $line[1]; my $qlen = $line[12], my $slen = $line[13]; my $id = $line[2]; my $alig_length = $line[3]; my $qstart = $line[6]; my $qend = $line[7]; my $start_draft = $line[8]; my $send_draft = $line[9]; my $sstart = (); my $send = ();
		$length_storage{$query} = $qlen; $length_storage{$target} = $slen;
		if ($start_draft < $send_draft) {
			$sstart = $start_draft; $send = $send_draft;
		} else {
			$sstart = $send_draft; $send = $start_draft;
		}
		for (my $i = $sstart; $i < $send; $i ++) {
			$positions{$target}{$query}{$i} ++;
			$id_storage{$target}{$query} += $id;
			$id_counter{$target}{$query} ++;
		}
	}

	close Blast;

print "#Query\tTarget\tAverage_id\tAverage_target_coverage\n";#

foreach my $target (keys %positions) {
	foreach my $query (keys %{$positions{$target}}) {
		my $aligned_positions = keys %{$positions{$target}{$query}}; my $target_covered = 100 * ($aligned_positions / $length_storage{$target}); my $average_id = $id_storage{$target}{$query} / $id_counter{$target}{$query};
		print "$target\t$query\t$average_id\t$target_covered\n";
	}
}

} else {
	die "write query or subject in \$ARGV[1]\n";
}
