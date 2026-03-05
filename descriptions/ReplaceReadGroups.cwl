#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [ReplaceReadGroups.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      prefix: -i
    doc: Input file in BAM format. |
         Must be sorted by genomic coordinates. |
         CRAM format is also supported if a genome reference is provided

  - id: sample_name
    type: string
    inputBinding:
      prefix: -s
    doc: Name of the sample

  - id: library_id
    type: string
    default: null
    inputBinding:
      prefix: -l
    doc: Identifier for the sequencing library preparation

  - id: genome_reference_fasta
    type: File
    default: null
    inputBinding:
      prefix: -r
    secondaryFiles:
      - ^.dict
      - .fai
    doc: Genome reference in FASTA format with the corresponding index files. |
         Required for input files in CRAM format

  - id: output_prefix
    type: string
    default: "outfile"
    inputBinding:
      prefix: -o

outputs:
  - id: output_file_bam
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + ".bam")
    secondaryFiles:
      - .bai

doc: |
  Replace "SM" or "SM" and "LB" tags in read group ("@RG") definitions. |
  Create associated index file. |
  Input file must be sorted by genomic coordinates
