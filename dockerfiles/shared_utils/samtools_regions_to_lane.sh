#!/usr/bin/env bash

# *******************************************
# Collect a list of BAM files sharded by regions
# and extract the alignments for the read groups
# specified in the header input BAM file.
# The list of sharded BAM files to concatenate
# need to be sorted by shards coordinates.
# *******************************************

## Command line arguments
header_bam=$1

# Input BAM files
shift 1 # $@ stores all the input BAM files

## Other settings
nt=$(nproc) # number of threads to use in computation,
            # set to number of cores in the server

# ******************************************
# 1. Generate read groups file.
# ******************************************
samtools view -@ $nt -H $header_bam | grep "@RG" > TMP_READ_GROUPS

py_script="
import sys, os

ID_list = []

with open('TMP_READ_GROUPS') as fi:
  for line in fi:
    for tag in line.rstrip().split():
      if tag.startswith('ID'):
        ID_list.append(tag.split('ID:')[1])
        break

with open('READ_GROUPS', 'w') as fo:
  fo.write('\n'.join(ID_list))
"

python -c "$py_script" || exit 1

# ******************************************
# 2. Filter by read groups.
# $@ stores all the input BAM files to cat together
# in the corret order.
# ******************************************
samtools cat -@ $nt $@ | samtools view -@ $nt --read-group-file READ_GROUPS -h -b -o readgroups.bam - || exit 1

# ******************************************
# 3. Index.
# ******************************************
samtools index -@ $nt readgroups.bam || exit 1

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

check_EOF('readgroups.bam')
"

python -c "$py_script" || exit 1
