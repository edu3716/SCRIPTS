#!/usr/bin/perl -w
use strict;

my ($genome, $head, $tail);
my (%mono_nt, %di_nt);

$/ = ">";
open my $fasta, '<', $ARGV[0] or die $!;
while (<$fasta>) {
    chomp; s/\r//g; s/^\s*|\s*$//;
    if (/.+?\n(.+)/s) {
        (my $seq = $1) =~ s/\n//g;
        $genome .= uc $seq;
        $head = uc substr($seq, 0, 1);
        $di_nt{"$tail$head"}-- if $tail;
        $tail = uc substr($seq, -1);
    }
}
close $fasta;

my $len = length $genome;
for my $i (0..$len-2) {
    my $each_mono_nt = substr($genome, $i, 1);
    my $each_di_nt   = substr($genome, $i, 2);
    $mono_nt{$each_mono_nt}++;
    $di_nt{$each_di_nt}++;
}
$mono_nt{$tail}++;

print "-"x30, "\nSingle nucleotide frequency:\n";
for my $nt (sort keys %mono_nt) {print "$nt\t", $mono_nt{$nt} / $len, "\n";}

print "\n", "-"x30, "\nDinucleotide frequency:\nDinucleotide\tObs. freq.\tExp. freq.\n";
for my $nt_pair (sort keys %di_nt) {
    my ($first_nt, $second_nt) = split //, $nt_pair;
    print "$nt_pair\t", $di_nt{$nt_pair} / ($len-1), "\t",
        $mono_nt{$first_nt} * $mono_nt{$second_nt} /$len /$len, "\n";
}
