#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/pbtk:VERSION

baseCommand: [pbmerge]

inputs:
  - id: input_files_bam
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 2
    doc: List of PacBio input files in BAM format

  - id: output_file_name
    type: string
    default: "out.bam"
    inputBinding:
      position: 1
      prefix: -o
    doc: Name for the output file in BAM format

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)
    secondaryFiles: 
      - .pbi

doc: |
  Merge multiple PacBio input files in BAM format and create a PBI index file
