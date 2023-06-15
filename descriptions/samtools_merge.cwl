#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [samtools, merge]

inputs:
  - id: merge_RG
    type: boolean
    default: true
    inputBinding:
      position: 1
      prefix: -c
    doc: When several input files contain @RG headers with the same ID, |
         emit only one of them (namely, the header line from the first file we find that ID in) |
         to the merged output file. |
         Combining these similar headers is usually the right thing to do |
         when the files being merged originated from the same file

  - id: merge_PG
    type: boolean
    default: true
    inputBinding:
      position: 2
      prefix: -p
    doc: For each @PG ID in the set of files to merge, |
         use the @PG line of the first file we find that ID in |
         rather than adding a suffix to differentiate similar IDs

  - id: create_index
    type: boolean
    default: true
    inputBinding:
      position: 3
      prefix: --write-index
    doc: Automatically index the output file

  - id: nthreads
    type: int
    default: null
    inputBinding:
      position: 4
      prefix: --threads
    doc: Number of input/output compression threads to use in addition to main thread [0]

  - id: output_file_name
    type: string
    default: "out.bam##idx##out.bam.bai"
    # this syntax is necessary to specify the right .bai format for the index file
    #   by default samtools write a .csi index alternatively
    inputBinding:
      position: 5
    doc: Name of the output file in BAM format

  - id: input_files_bam
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 6
    doc: List of input files to merge in BAM format. |
         Input files must be sorted by genomic coordinates

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: out.bam
    secondaryFiles:
      - .bai

doc: |
  Run "samtools merge -@ nthreads --write-index -c -p out.bam##idx##out.bam.bai in1.bam in2.bam ..." |
  Create index for the output file
