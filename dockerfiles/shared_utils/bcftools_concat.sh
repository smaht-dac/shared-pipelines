#!/usr/bin/env bash

# *******************************************
# Script to run bcftools to concatenate multiple VCF files.
# The files must be sorted and listed
# in the correct order by genomic regions
# *******************************************

# Input arguments
nthreads=$1
output_file_name=$2

# Input VCF files
shift 2 # $@ store all the input files

# Concatenate and index the output VCF file
bcftools concat --threads $nthreads -O z -o $output_file_name $@ || exit 1
bcftools index --threads $nthreads --tbi $output_file_name || exit 1
