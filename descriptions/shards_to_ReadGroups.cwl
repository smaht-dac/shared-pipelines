#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [shards_to_ReadGroups.sh]

inputs:
  - id: header_file_bam
    type: File
    inputBinding:
      position: 1
    doc: Input file in BAM format with the @RG identifiers to extract from the header

  - id: input_files_bam
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 2
    secondaryFiles:
      - .bai
    doc: List of sharded input files in BAM format to concatenate. |
         Input files must be sorted by genomic coordinates. |
         The list need to be sorted by shards coordinates

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: readgroups.bam
    secondaryFiles:
      - .bai

doc: |
  Collect a list of BAM files sharded by regions |
  and extract the alignments for the read groups |
  in the header of the input BAM file specified as header file. |
  Create index for the output file
