#!/usr/bin/perl
use strict; use warnings;

die "\nINFO: You put a FASTA and a threshold between 0-100 and write seqs which length is below the threhsold. That threshold is the % of MEDIAN length.\nInsert: 1) FASTA file (los gaps se eliminarán); 2) Threshold value: seqname is wrote if its sequence is less the % of that threshold respect the median of the distribution of sequence lengths (excluding gaps). Should be between 1-100.\nOutput: seqs which length is below the threshold\nOutput: Write seqnames which length is below [0-100]% of the MEDIAN length\n" unless @ARGV == 2;

open (Fasta, "<$ARGV[0]");

my %fasta = ();
my $seq = ();

#my %all_gene = (); my %all_organism = ();

while (<Fasta>) {
	chomp;
	next if $_ =~ /^$|^#/;
	next if $_ =~ /^\n$/;
	if ($_ =~ /^>(\S+)/) {
		$seq = $1;
	} else {
		$_ =~ s/-//g;
		$fasta{$seq} .= $_;
	}
}

close Fasta;

my @lengths = (); my $num_of_seqs = 0;

foreach my $seqname (keys %fasta) {
	$num_of_seqs ++;
	push (@lengths, length $fasta{$seqname});
}

my @sorted_lengths = sort ({$a <=> $b} @lengths);

my $median_value = int ($num_of_seqs / 2);
my $median_length = $sorted_lengths[$median_value];

my $threshold = $ARGV[1];

my $threshold_value = ($threshold * $median_length ) / 100;

warn "num_of_seqs:$num_of_seqs\t$median_value\tmedian_length:$median_length\t$threshold\tlength_threshold:$threshold_value\n";

foreach my $seqname (keys %fasta) {
	my $current_length = length $fasta{$seqname};
	if ($current_length < $threshold_value) {
		print "$seqname\n";	
	}
}

=c

my $max_length = 0;

foreach my $seq (keys %fasta) {
	my $current_length = length ($fasta{$seq});
	if ($current_length > $max_length) {
		$max_length = $current_length;
	}
}

my $threshold = ();

if ($ARGV[1] =~ /(\d+)/) {
	$threshold = $1;
}

my @excluded_seqs = ();

my $total_num_seqs = ();

foreach my $seq (keys %fasta) {
	$total_num_seqs ++;
	my $current_length = length ($fasta{$seq});
	my $covered_max_length = 100 * ($current_length / $max_length);
	if ($covered_max_length >= $threshold) {
		print ">$seq\n$fasta{$seq}\n";
	} else {
		push (@excluded_seqs, $seq);
	}
}

my %gene_excluded = (); my %organism_excluded = ();

my $total_excluded_seqs = ();

foreach my $seq (@excluded_seqs) {
	$total_excluded_seqs ++;
	my ($gene, $organism) = ();
	if ($seq =~ /^p-(\w+|\d+)_([A-Z][a-z]{3})_\S+|-{+}/) {
		$gene = $1; $organism = $2;
	}
	unless (exists $gene_excluded{$gene}) {
		$gene_excluded{$gene} = 1;
	} else {
		$gene_excluded{$gene} ++;
	}
	unless (exists $organism_excluded{$organism}) {
		$organism_excluded{$organism} = 1;
	} else {
		$organism_excluded{$organism} ++;
	}
}
#ok
my (%sorter_gene_excluded, %sorter_organism_excluded) = ();

foreach my $gene (keys %gene_excluded) {
	my $number = $gene_excluded{$gene};
	unless (exists $sorter_gene_excluded{$number}) {
		$sorter_gene_excluded{$number} = $gene;
	} else {
		$sorter_gene_excluded{$number} .= "\t$gene";
	}
}


foreach my $organism (keys %organism_excluded) {
	my $number = $organism_excluded{$organism};
	unless (exists $sorter_organism_excluded{$number}) {
		$sorter_organism_excluded{$number} = $organism;
	} else {
		$sorter_organism_excluded{$number} .= "\t$organism";
	}
}

my $average_excluded_seqs = sprintf("%.2f", 100 * ($total_excluded_seqs / $total_num_seqs));

print STDERR "\nNumber of excluded seqs: $average_excluded_seqs% ($total_num_seqs total seqs)\n\n";
print STDERR "List of excluded seqs: @excluded_seqs\n\n";

print STDERR "Number of excluded seqs per ortholog group: ";
foreach my $number (sort {$b <=> $a} (keys %sorter_gene_excluded)) {
	my $list_genes = $sorter_gene_excluded{$number};
	if ($list_genes =~ /\t/) {
		my @genes = split ('\t', $list_genes);
		foreach my $gene (@genes) {
			my $total_number = $all_gene{$gene};
			my $average = 100 * ($number / $total_number);
			my $average_redondeado = sprintf ("%.2f", $average);
			print STDERR "$gene:$number\[$average_redondeado%]\t";
		}
	} else {
		my $gene = $sorter_gene_excluded{$number};
		my $total_number = $all_gene{$gene};
		my $average = 100 * ($number / $total_number);
		my $average_redondeado = sprintf ("%.2f", $average);
		print STDERR "$gene:$number\[$average_redondeado%]\t";
	}
}
print STDERR "\n";

print STDERR "\nNumber of excluded seqs per organism: ";
foreach my $number (sort {$b <=> $a} (keys %sorter_organism_excluded)) {
	my $list_organisms = $sorter_organism_excluded{$number};
	if ($list_organisms =~ /\t/) {
		my @organisms = split ('\t', $list_organisms);
		foreach my $organism (@organisms) {
			my $total_number = $all_organism{$organism};
			my $average = 100 * ($number / $total_number);
			my $average_redondeado = sprintf ("%.2f", $average);
			print STDERR "$organism:$number\[$average_redondeado%]\t";
		}
	} else {
		my $organism = $sorter_organism_excluded{$number};
		my $total_number = $all_organism{$organism};
		my $average = 100 * ($number / $total_number);
		my $average_redondeado = sprintf ("%.2f", $average);
		print STDERR "$organism:$number\[$average_redondeado%]\t";
	}
}
print STDERR "\n\n";
