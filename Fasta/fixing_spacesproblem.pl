#!/usr/bin/perl;
use strict; use warnings;

while (<>) {
	chomp;
	if ($_ =~ /(\S+)(>\S+)/) {
		print "$1\n$2\n";	#print "$_\n$1\n$2\n";
	} 
	else {
		print "$_\n";
	}
}