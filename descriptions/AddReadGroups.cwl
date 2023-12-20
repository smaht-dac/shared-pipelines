#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [AddReadGroups.py]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      position: 1
      prefix: -i
    doc: Input file in BAM format.
         Must be sorted by genomic coordinates

  - id: sample_name
    type: string
    inputBinding:
      position: 2
      prefix: -s
    doc: Name of the sample

  - id: library_id
    type: string
    default: null
    inputBinding:
      position: 3
      prefix: -l
    doc: Identifier for the sequencing library preparation [LIBRARY]

  - id: platform
    type: string
    default: null
    inputBinding:
      position: 4
      prefix: -p
    doc: Name of the sequencing platform [ILLUMINA]

  - id: nthreads
    type: int
    default: null
    inputBinding:
      position: 5
      prefix: -t
    doc: Number of additional threads to use for compression/decompression [1]

  - id: create_index
    type: boolean
    default: true
    inputBinding:
      position: 6
      prefix: --index
    doc: Create index for the output file

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: $(inputs.input_file_bam.nameroot + "_rg.bam")
    secondaryFiles:
      - .bai

doc: |
  Run AddReadGroups.py to mark and assign reads from input file in BAM format to new read groups. |
  Create associated index file. |
  Input file must be sorted by genomic coordinates. |
  The script expect standard illumina read names to extract information to build the read groups
