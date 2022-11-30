#!/bin/bash

# Input Args
input_bam=$1
nthreads=$2
out_prefix=$3

# Samtools command line
fastq_opt="-0 /dev/null -s /dev/null -n"

samtools collate -@ $nthreads -O $input_bam | samtools fastq -1 $out_prefix.1.fastq -2 $out_prefix.2.fastq -@ $nthreads $fastq_opt - || { echo "Cannot convert bam to fastq."; exit 1; }
