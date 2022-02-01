#!/usr/bin/env python3

import sys
import os

if len(sys.argv) != 3:
	sys.exit("\nInfo: you pass a FASTA and it creates an ~arqdom file but with eggnog annotations instead\n\n\t1) FASTA input to eggnog\n\t2) Current path\n\n")

fasta_name = sys.argv[1]
current_path = sys.argv[2]

args = ['cp',fasta_name,'/media/3r_disk/Programes/eggnog-mapper-1.0.3']
args_line = ' '.join(args)
os.system(args_line)

os.chdir("/media/3r_disk/Programes/eggnog-mapper-1.0.3")

args = ['python emapper.py -i',fasta_name,'--output PREFIX -m diamond --cpu 10 --override']
args_line = ' '.join(args)
os.system(args_line)

args = ['cut -f1,13 PREFIX.emapper.annotations | grep -v -P "^#" | perl -pe "s/[,\(|\) ]/_/g" > ',current_path,'/',fasta_name,'.arqdom']
args_line = ''.join(args)
os.system(args_line)

os.chdir(current_path)
