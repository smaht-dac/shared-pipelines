#!/bin/bash

# Input Args
input_bam=$1
nthreads=$2
out_prefix=$3

# Samtools command line
fastq_opt="-0 /dev/null -s /dev/null -n"

samtools collate -@ $nthreads -O $input_bam | samtools fastq -1 $out_prefix.1.fastq -2 $out_prefix.2.fastq -@ $nthreads $fastq_opt - || { echo "Cannot convert bam to fastq."; exit 1; }

# Save space
rm -rf $input_bam

# Compress fastqs
pigz $out_prefix.1.fastq || { echo "Cannot compress $out_prefix.1.fastq"; exit 1; }
pigz $out_prefix.2.fastq || { echo "Cannot compress $out_prefix.2.fastq"; exit 1; }
