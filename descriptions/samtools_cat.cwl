#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [samtools_cat.sh]

inputs:
  - id: input_files_bam
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 1
    secondaryFiles:
      - .bai
    doc: List of sharded input files in BAM format to concatenate. |
         Input files must be sorted by genomic coordinates. |
         The list need to be sorted by shards coordinates

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: cat.bam

doc: |
  Collect a list of BAM files sharded by regions |
  and concatenate them together. |
  Create index for the output file
