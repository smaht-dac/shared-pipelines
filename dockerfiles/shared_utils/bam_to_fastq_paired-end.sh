#!/usr/bin/env bash

# Input arguments
input_file_bam=$1
nthreads=$2
output_file_prefix=$3

# Command line options
fastq_opt="-0 /dev/null -s /dev/null -n"

# Run
samtools collate -@ $nthreads -O $input_file_bam | samtools fastq -1 $output_file_prefix.1.fastq.gz -2 $output_file_prefix.2.fastq.gz -@ $nthreads $fastq_opt - || { echo "Cannot convert BAM to FASTQs"; exit 1; }

# # Compress FASTQs
# pigz $output_file_prefix.1.fastq || { echo "Cannot compress $output_file_prefix.1.fastq"; exit 1; }
# pigz $output_file_prefix.2.fastq || { echo "Cannot compress $output_file_prefix.2.fastq"; exit 1; }
