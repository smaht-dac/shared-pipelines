#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [samtools_get_readgroups.sh]

inputs:
  - id: input_file_bam
    type:
    # Note: Need to be passed as array of a single file to matche the code around
    #       also if it is a single file
      -
        items: File
        type: array
    inputBinding:
      position: 1
    secondaryFiles:
      - .bai
    doc: Input file in BAM format with corresponding inde file

  - id: header_file_bam
    type: File
    inputBinding:
      position: 2
    doc: Input file in BAM format with the @RG identifiers to extract

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: readgroups.bam
    secondaryFiles:
      - .bai

doc: |
  Extract from input BAM file the alignments for the read groups |
  specified in the header of header BAM file. |
  Create index for the output file
