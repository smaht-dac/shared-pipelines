#!/usr/bin/env bash

# *******************************************
# Script to run bcftools to concatenate multiple VCF files.
# The files must be sorted and listed
# in the correct order by genomic regions
# *******************************************

# Input arguments
output_file_name=$1

# Input VCF files
shift 1 # $@ store all the input files

## Other settings
nt=$(nproc) # number of threads to use in computation,
            # set to number of cores in the server

# Concatenate and index the output VCF file
bcftools concat --threads $nt -a -D -O z -o $output_file_name $@ || exit 1
bcftools index --threads $nt --tbi $output_file_name || exit 1
