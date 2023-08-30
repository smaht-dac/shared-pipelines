#!/usr/bin/env bash

# *******************************************
# Collect a list of BAM files sharded by regions
# and concatenate them together.
# The list of sharded BAM files to concatenate
# need to be sorted by shards coordinates.
# Input files must be sorted by genomic coordinates.
# *******************************************

# Input BAM files
# $@ stores all the input BAM files

## Other settings
nt=$(nproc) # number of threads to use in computation,
            # set to number of cores in the server

# ******************************************
# 1. cat files.
# $@ stores all the input BAM files to cat together
# in the corret order.
# ******************************************
samtools cat -@ $nt -o cat.bam $@

# ******************************************
# 3. Index.
# ******************************************
samtools index -@ $nt cat.bam || exit 1

# ******************************************
# 4. Check deduped BAM integrity.
# ******************************************
py_script="
import sys, os

def check_EOF(filename):
    EOF_hex = b'\x1f\x8b\x08\x04\x00\x00\x00\x00\x00\xff\x06\x00\x42\x43\x02\x00\x1b\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00'
    size = os.path.getsize(filename)
    fb = open(filename, 'rb')
    fb.seek(size - 28)
    EOF = fb.read(28)
    fb.close()
    if EOF != EOF_hex:
        sys.stderr.write('EOF is missing\n')
        sys.exit(1)
    else:
        sys.stderr.write('EOF is present\n')

check_EOF('cat.bam')
"

python -c "$py_script" || exit 1
