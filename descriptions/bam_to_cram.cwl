#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [samtoolsTagFilterCram.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -i
    secondaryFiles:
      - .bai
    doc: Input BAM file with the corresponding index file. |
         Must be sorted by genomic coordinates

  - id: genome_reference_fasta
    type: File
    inputBinding:
      prefix: -r
    secondaryFiles:
      - ^.dict
      - .fai
    doc: Genome reference in FASTA format with the corresponding index files

  - id: output_file_name
    type: string
    default: "output.cram"
    inputBinding:
      prefix: -o
    doc: Name of the output file in CRAM format

  - id: tags_remove
    type: string
    default: null
    inputBinding:
      prefix: -t
    doc: Comma-separated list of tags to remove (e.g., BI,BD)

  - id: index_output_file
    type: boolean
    default: true
    inputBinding:
      prefix: -x
    doc: Create index for output file

outputs:
  - id: output_file_cram
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)
    secondaryFiles:
      - .crai

doc: |
  Converts a BAM file to CRAM format, removing specified tags if provided.
