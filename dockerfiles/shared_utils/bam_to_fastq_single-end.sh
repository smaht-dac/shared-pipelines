#!/usr/bin/env bash

# Input arguments
input_file_bam=$1
nthreads=$2
output_file_prefix=$3

# Run
samtools fastq -n -@ $nthreads $input_file_bam | \
bgzip -@ $nthreads > ${output_file_prefix}.fastq.gz || { echo "Cannot convert BAM to FASTQ"; exit 1; }
