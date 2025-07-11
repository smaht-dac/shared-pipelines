#!/usr/bin/env bash

# *******************************************
# Utility to filter tags and manipulate
# compression for files in BAM/CRAM format.
#
# This script wraps samtools view.
# *******************************************

# *******************************************
# Usage function
# Displays help message and exits.
# *******************************************
usage() {
    cat <<EOF
Usage: $0 -i <input_file> -o <output_file> [-r <reference_fasta>] [-t <tag1,tag2,...>] [-f <fmt>] [-h]

Arguments:
  -i, --input        Input file (.bam or .cram, required)
  -o, --output       Output file (.bam or .cram, required)
  -r, --reference    Reference FASTA file (required for CRAM conversion)
  -t, --tags         Comma-separated list of tags to remove (e.g., BI,BD)
  -f, --fmt          Output format option for samtools view (e.g., level=6)
  -h, --help         Show this help message
EOF
    exit 1
}

# *******************************************
# Variables
# *******************************************
nt=$(nproc) # Will set to use all available cores
output_format_option="level=6" # Set default compression level for output

# Set from command line
input_file=""
output_file=""
reference_fasta=""
tags_list=""

# *******************************************
# Argument parser
# *******************************************
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--input)
            input_file="$2"
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -r|--reference)
            reference_fasta="$2"
            shift 2
            ;;
        -t|--tags)
            tags_list="$2"
            shift 2
            ;;
        -f|--fmt)
            output_format_option="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown argument: $1"
            usage
            ;;
    esac
done

# *******************************************
# Check if samtools is installed
# *******************************************
if ! command -v samtools &> /dev/null; then
    echo "Error: samtools is not installed or not found in PATH"
    exit 1
fi

# *******************************************
# Validate required arguments
# *******************************************
if [[ -z "$input_file" || -z "$output_file" ]]; then
    echo "Error: Input and output files are required"
    usage
fi

# *******************************************
# Infer input and output format
# *******************************************
input_ext="${input_file##*.}"
output_ext="${output_file##*.}"

if [[ "$input_ext" != "bam" && "$input_ext" != "cram" ]]; then
    echo "Error: Input file must end with .bam or .cram"
    usage
elif [[ "$output_ext" != "bam" && "$output_ext" != "cram" ]]; then
    echo "Error: Output file must end with .bam or .cram"
    usage
fi

# *******************************************
# Check if reference FASTA is required
# *******************************************
if [[ "$input_ext" == "cram" || "$output_ext" == "cram" ]]; then
    if [[ -z "$reference_fasta" ]]; then
        echo "Error: Reference FASTA is required for CRAM conversion"
        usage
    fi
fi

# *******************************************
# Set the output format
# *******************************************
if [[ "$output_ext" == "cram" ]]; then
    output_format_flag="--cram"
elif [[ "$output_ext" == "bam" ]]; then
    output_format_flag="--bam"
fi

# *******************************************
# Samtools view command
# *******************************************
# Base command
cmd=(
    samtools view
    --output-fmt-option "$output_format_option"
    --with-header
    -@ "$nt"
    "$output_format_flag"
    --output "$output_file"
)

# Add reference FASTA if CRAM format is used
if [[ "$input_ext" == "cram" || "$output_ext" == "cram" ]]; then
    cmd+=(--reference "$reference_fasta")
fi

# Check if tags need to be removed
if [[ -n "$tags_list" ]]; then
    cmd+=(--remove-tag "$tags_list")
fi

# Add input BAM file to the command
cmd+=("$input_file")

# *******************************************
# Run the command
# *******************************************
echo "Running: ${cmd[*]}"
echo

"${cmd[@]}" || {
    echo "Error: Command failed"
    exit 1
}
