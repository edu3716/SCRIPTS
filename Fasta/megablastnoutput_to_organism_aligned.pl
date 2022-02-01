#!/usr/bin/perl
use strict; use warnings;

# INFO: you pass the output from megablastn against NT db and it reformattes the output adding in the subject column taxonomic info of that subject sequence

die "Insert: 1) MegablastN output (max_target_seqs 1!); 2) Nucl_2_acc [/media/Second_disk/NCBI_things/Taxonomy_browser/Accesion2taxid/Nucleotide/nucl_gb.accession2taxid] or Prot_2_acc [/media/Second_disk/NCBI_things/Taxonomy_browser/Accesion2taxid/Proteins/prot.accession2taxid]; 3) Taxonomy_dictionary [/media/Second_disk/NCBI_things/Taxonomy_browser/Dictionary_TaxonomyNCBI/dictionary_taxonomyNCBI.dict]\n" unless @ARGV == 3;

open (Megablastn_output, "<$ARGV[0]");

my %hits_to_search = ();

while (<Megablastn_output>) {
	chomp; next if $_ =~ /^$/;
	my @line = split ('\t', $_);
	my $acc_id = $line[1];
	$hits_to_search{$acc_id} = 1;
}

close Megablastn_output;

open (Nucl_2acc, "<$ARGV[1]");

my %taxid_tosearch = (); my %acc_id_tosearch_storage = ();

while (<Nucl_2acc>) {
	chomp;
	next if $_ =~ /^$/;
	my @line = split ('\t', $_); my $acc_id = $line[1]; my $tax_id = $line[2];
	if (exists $hits_to_search{$acc_id}) {
		push (@{$taxid_tosearch{$tax_id}}, $acc_id);
		$acc_id_tosearch_storage{$acc_id} = 1;
	}
}

close Nucl_2acc;

system "touch accid_togrep.tmp";

foreach my $acc_id (keys %hits_to_search) {
	next if exists $acc_id_tosearch_storage{$acc_id};
	$acc_id =~ s/\|/\\|/g;
	system "grep -P \"\t$acc_id\t\" $ARGV[1] >> accid_togrep.tmp";
}

open (Temp_to_grep, "<accid_togrep.tmp");

while (<Temp_to_grep>) {
	chomp;
	my @line = split ('\t', $_);
	my $acc_id = $line[1]; my $tax_id = $line[2];
	if (exists $hits_to_search{$acc_id}) {
		$taxid_tosearch{$tax_id} = $acc_id;
	}
}

close Temp_to_grep;

system "rm accid_togrep.tmp";

open (TaxDict, "<$ARGV[2]");

%hits_to_search = ();

while (<TaxDict>) {
	chomp;
	my @line = split ('\t', $_);
	my $tax_id = $line[0]; my $tax_info = $line[1];
	if (exists $taxid_tosearch{$tax_id}) {
		foreach my $acc_id (@{$taxid_tosearch{$tax_id}}) {
			$hits_to_search{$acc_id} = $tax_info;
		}
	}
}

close TaxDict;

open (Megablastn_output, "<$ARGV[0]");

while (<Megablastn_output>) {
	chomp; next if $_ =~ /^$/;
	my @line = split ('\t', $_);
	if (exists $hits_to_search{$line[1]}) {
		$_ =~ s/$line[1]/$line[1] \[$hits_to_search{$line[1]}\]/; print "$_\n";
	} else {
		print "$_\n";
	}
}

close Megablastn_output;
