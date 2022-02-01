#!/usr/bin/perl
use strict; use warnings;

die "\nInfo: from a BLAST .outfmt6 file, it extracts subregions from query or subject sequence [i.e. BLASTx or tBLASTn] and then one with the 6 putative frames with less stop codons is written\nInput: 1) gDNA; 2) outfmt6; 3) name for both output files; 4) write subject [if tBLASTn] or query [if BLASTx] (which should be translated)\nOutput: 1) file with info from the alignment hits that were used to extrat the sequences [\$ARGV[2].info]; 2) FASTA with the less stop codon frame from each hit [\$ARGV[2].fa]\n\n" unless @ARGV == 4;

my %genetic_code = (
    'TCA' => 'S',    # Serine
    'TCC' => 'S',    # Serine
    'TCG' => 'S',    # Serine
    'TCT' => 'S',    # Serine
    'TTC' => 'F',    # Phenylalanine
    'TTT' => 'F',    # Phenylalanine
    'TTA' => 'L',    # Leucine
    'TTG' => 'L',    # Leucine
    'TAC' => 'Y',    # Tyrosine
    'TAT' => 'Y',    # Tyrosine
    'TAA' => 'X',    # Stop
    'TAG' => 'X',    # Stop
    'TGC' => 'C',    # Cysteine
    'TGT' => 'C',    # Cysteine
    'TGA' => 'X',    # Stop
    'TGG' => 'W',    # Tryptophan
    'CTA' => 'L',    # Leucine
    'CTC' => 'L',    # Leucine
    'CTG' => 'L',    # Leucine
    'CTT' => 'L',    # Leucine
    'CCA' => 'P',    # Proline
    'CCC' => 'P',    # Proline
    'CCG' => 'P',    # Proline
    'CCT' => 'P',    # Proline
    'CAC' => 'H',    # Histidine
    'CAT' => 'H',    # Histidine
    'CAA' => 'Q',    # Glutamine
    'CAG' => 'Q',    # Glutamine
    'CGA' => 'R',    # Arginine
    'CGC' => 'R',    # Arginine
    'CGG' => 'R',    # Arginine
    'CGT' => 'R',    # Arginine
    'ATA' => 'I',    # Isoleucine
    'ATC' => 'I',    # Isoleucine
    'ATT' => 'I',    # Isoleucine
    'ATG' => 'M',    # Methionine
    'ACA' => 'T',    # Threonine
    'ACC' => 'T',    # Threonine
    'ACG' => 'T',    # Threonine
    'ACT' => 'T',    # Threonine
    'AAC' => 'N',    # Asparagine
    'AAT' => 'N',    # Asparagine
    'AAA' => 'K',    # Lysine
    'AAG' => 'K',    # Lysine
    'AGC' => 'S',    # Serine
    'AGT' => 'S',    # Serine
    'AGA' => 'R',    # Arginine
    'AGG' => 'R',    # Arginine
    'GTA' => 'V',    # Valine
    'GTC' => 'V',    # Valine
    'GTG' => 'V',    # Valine
    'GTT' => 'V',    # Valine
    'GCA' => 'A',    # Alanine
    'GCC' => 'A',    # Alanine
    'GCG' => 'A',    # Alanine
    'GCT' => 'A',    # Alanine
    'GAC' => 'D',    # Aspartic Acid
    'GAT' => 'D',    # Aspartic Acid
    'GAA' => 'E',    # Glutamic Acid
    'GAG' => 'E',    # Glutamic Acid
    'GGA' => 'G',    # Glycine
    'GGC' => 'G',    # Glycine
    'GGG' => 'G',    # Glycine
    'GGT' => 'G',    # Glycine
);

open (Fasta, "<$ARGV[0]");

my %fasta = (); my $seqname = ();

while (<Fasta>) {
	chomp;
	if ($_ =~ />(\S+)/) {
		$seqname = $1;
	} else {
		$fasta{$seqname} .= "$_";
	}
}

close Fasta;

open (Outfmt6, "<$ARGV[1]");

open (Printer_fasta, ">$ARGV[2].translated_bestalignedseqs.fa"); open (Printer_info, ">$ARGV[2].translated_bestalignedseqs.info");

print Printer_info "#current_seqname\t#subject\t#query\t#left\t#right\t#best_frame\t#number_of_stops\n";

if ($ARGV[3] =~ /subject/) {

	while (<Outfmt6>) {
		chomp;
		next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		my $query = $line[0]; my $subject = $line[1]; my $position_1 = $line[8]; my $position_2 = $line[9]; my $left = (); my $right = ();
		next if $position_1 == $position_2;
		if ($position_1 > $position_2) {
			$left = $position_2; $right = $position_1;
		} else {
			$left = $position_1; $right = $position_2;
		}
		$left = $left - 1; $right = $right - 1;#
		my $current_seq = substr ($fasta{$subject}, $left, $right - $left);
		my %putative_translations = ();

		my $length = length $current_seq;
		#ahora la forward
		my $seq = uc ($current_seq);
		my %stop_codon_counter = ();
		for (my $i = 0; $i < ($length - 2); $i += 3) {
			my $codon = substr ($seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame1"} .= "X";
				$stop_codon_counter{"frame1"} ++;
			}
			else {
				$putative_translations{"frame1"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame1"} ++;}
			}
		}
		for (my $i = 1; $i < ($length - 2); $i += 3) {
			my $codon = substr ($seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame2"} .= "X";
				$stop_codon_counter{"frame2"} ++;
			}
			else {
				$putative_translations{"frame2"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame2"} ++;}
			}
		}
		for (my $i = 2; $i < ($length - 2); $i += 3) {
			my $codon = substr ($seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame3"} .= "X";
				$stop_codon_counter{"frame3"} ++;
			}
			else {
				$putative_translations{"frame3"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame3"} ++;}
			}
		}
		#ahora la reverse
		my $rev_seq = reverse uc $seq;
		$rev_seq =~ tr/ATGC/TACG/;
		for (my $i = 0; $i < ($length - 2); $i += 3) {
			my $codon = substr ($rev_seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame4"} .= "X";
				$stop_codon_counter{"frame4"} ++;
			}
			else {
				$putative_translations{"frame4"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame4"} ++;}
			}
		}
		for (my $i = 1; $i < ($length - 2); $i += 3) {
			my $codon = substr ($rev_seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame5"} .= "X";
				$stop_codon_counter{"frame5"} ++;
			}
			else {
				$putative_translations{"frame5"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame5"} ++;}
			}
		}
		for (my $i = 2; $i < ($length - 2); $i += 3) {
			my $codon = substr ($rev_seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame6"} .= "X";
				$stop_codon_counter{"frame6"} ++;
			}
			else {
				$putative_translations{"frame6"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame6"} ++;}
			}
		}
		my $best_frame = (); my $best_frameseq = (); my $number_of_stops = 0;
		if (scalar (keys %stop_codon_counter) < 6) {
			unless (exists $stop_codon_counter{"frame6"}) {$best_frame = "frame6"; $best_frameseq = $putative_translations{"frame6"};}
			unless (exists $stop_codon_counter{"frame5"}) {$best_frame = "frame5"; $best_frameseq = $putative_translations{"frame5"};}
			unless (exists $stop_codon_counter{"frame4"}) {$best_frame = "frame4"; $best_frameseq = $putative_translations{"frame4"};}
			unless (exists $stop_codon_counter{"frame3"}) {$best_frame = "frame3"; $best_frameseq = $putative_translations{"frame3"};}
			unless (exists $stop_codon_counter{"frame2"}) {$best_frame = "frame2"; $best_frameseq = $putative_translations{"frame2"};}
			unless (exists $stop_codon_counter{"frame1"}) {$best_frame = "frame1"; $best_frameseq = $putative_translations{"frame1"};}
		} else {
			$best_frame = "frame1"; $best_frameseq = $putative_translations{"frame1"}; # le asigno un frame al azar y si hay uno mejor ya lo sustituiré por ese mejor
			my $current_less_codon_count = $stop_codon_counter{"frame1"};	
			foreach my $current_frame (keys %stop_codon_counter) {
				next if $current_less_codon_count =~ /frame1/;
				next if $putative_translations{$current_frame} !~ /M/;#
				my $framestop_count = $stop_codon_counter{$current_frame};
				if ($framestop_count < $current_less_codon_count) {
					$best_frame = $current_frame;
					$best_frameseq = $putative_translations{$current_frame};
					$current_less_codon_count = $framestop_count;
					$number_of_stops = $framestop_count;
				}
			}
		}

		my $current_seqname = "$subject"."_$left"."-$right"."_$best_frame"."_$number_of_stops"."-codonstops";

		print Printer_fasta ">$current_seqname\n$best_frameseq\n";
		print Printer_info "$current_seqname\t$subject\t$query\t$left\t$right\t$best_frame\t$number_of_stops\n";
	}

} elsif ($ARGV[3] =~ /query/) {

	while (<Outfmt6>) {
		chomp;
		next if $_ =~ /^$|^#/;
		my @line = split ('\t', $_);
		my $query = $line[0]; my $subject = $line[1]; my $position_1 = $line[6]; my $position_2 = $line[7]; my $left = (); my $right = ();
		next if $position_1 == $position_2;
		if ($position_1 > $position_2) {
			$left = $position_2; $right = $position_1;
		} else {
			$left = $position_1; $right = $position_2;
		}
		$left = $left - 1; $right = $right - 1;#
		my $current_seq = substr ($fasta{$query}, $left, $right - $left);
		my %putative_translations = ();

		my $length = length $current_seq;
		#ahora la forward
		my $seq = uc ($current_seq);
		my %stop_codon_counter = ();
		for (my $i = 0; $i < ($length - 2); $i += 3) {
			my $codon = substr ($seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame1"} .= "X";
				$stop_codon_counter{"frame1"} ++;
			}
			else {
				$putative_translations{"frame1"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame1"} ++;}
			}
		}
		for (my $i = 1; $i < ($length - 2); $i += 3) {
			my $codon = substr ($seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame2"} .= "X";
				$stop_codon_counter{"frame2"} ++;
			}
			else {
				$putative_translations{"frame2"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame2"} ++;}
			}
		}
		for (my $i = 2; $i < ($length - 2); $i += 3) {
			my $codon = substr ($seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame3"} .= "X";
				$stop_codon_counter{"frame3"} ++;
			}
			else {
				$putative_translations{"frame3"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame3"} ++;}
			}
		}
		#ahora la reverse
		my $rev_seq = reverse uc $seq;
		$rev_seq =~ tr/ATGC/TACG/;
		for (my $i = 0; $i < ($length - 2); $i += 3) {
			my $codon = substr ($rev_seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame4"} .= "X";
				$stop_codon_counter{"frame4"} ++;
			}
			else {
				$putative_translations{"frame4"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame4"} ++;}
			}
		}
		for (my $i = 1; $i < ($length - 2); $i += 3) {
			my $codon = substr ($rev_seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame5"} .= "X";
				$stop_codon_counter{"frame5"} ++;
			}
			else {
				$putative_translations{"frame5"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame5"} ++;}
			}
		}
		for (my $i = 2; $i < ($length - 2); $i += 3) {
			my $codon = substr ($rev_seq, $i, 3);
			if ($codon =~ /N/){
				$putative_translations{"frame6"} .= "X";
				$stop_codon_counter{"frame6"} ++;
			}
			else {
				$putative_translations{"frame6"} .= $genetic_code{$codon};
				if ($genetic_code{$codon} =~ /X/) {$stop_codon_counter{"frame6"} ++;}
			}
		}
		my $best_frame = (); my $best_frameseq = (); my $number_of_stops = 0;
		if (scalar (keys %stop_codon_counter) < 6) {
			unless (exists $stop_codon_counter{"frame6"}) {$best_frame = "frame6"; $best_frameseq = $putative_translations{"frame6"};}
			unless (exists $stop_codon_counter{"frame5"}) {$best_frame = "frame5"; $best_frameseq = $putative_translations{"frame5"};}
			unless (exists $stop_codon_counter{"frame4"}) {$best_frame = "frame4"; $best_frameseq = $putative_translations{"frame4"};}
			unless (exists $stop_codon_counter{"frame3"}) {$best_frame = "frame3"; $best_frameseq = $putative_translations{"frame3"};}
			unless (exists $stop_codon_counter{"frame2"}) {$best_frame = "frame2"; $best_frameseq = $putative_translations{"frame2"};}
			unless (exists $stop_codon_counter{"frame1"}) {$best_frame = "frame1"; $best_frameseq = $putative_translations{"frame1"};}
		} else {
			$best_frame = "frame1"; $best_frameseq = $putative_translations{"frame1"}; # le asigno un frame al azar y si hay uno mejor ya lo sustituiré por ese mejor
			my $current_less_codon_count = $stop_codon_counter{"frame1"};	
			foreach my $current_frame (keys %stop_codon_counter) {
				next if $current_less_codon_count =~ /frame1/;
				next if $putative_translations{$current_frame} !~ /M/;#
				my $framestop_count = $stop_codon_counter{$current_frame};
				if ($framestop_count < $current_less_codon_count) {
					$best_frame = $current_frame;
					$best_frameseq = $putative_translations{$current_frame};
					$current_less_codon_count = $framestop_count;
					$number_of_stops = $framestop_count;
				}
			}
		}

		my $current_seqname = "$query"."_$left"."-$right"."_$best_frame"."_$number_of_stops"."-codonstops";

		print Printer_fasta ">$current_seqname\n$best_frameseq\n";
		print Printer_info "$current_seqname\t$subject\t$query\t$left\t$right\t$best_frame\t$number_of_stops\n";
	}

} else {
	die "write query or subject in \$ARGV[3]\n";
}


close Outfmt6;

close Printer_fasta; close Printer_info;
