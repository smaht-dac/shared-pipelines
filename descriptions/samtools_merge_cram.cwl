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
    default: false
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

  - id: genome_reference_fasta
    type: File
    inputBinding:
      position: 5
      prefix: --reference
    secondaryFiles:
      - ^.dict
      - .fai
    doc: Genome reference in FASTA format with the corresponding index files

  - id: output_file_name
    type: string
    default: "out.cram"
    inputBinding:
      position: 6
    doc: Name of the output file in CRAM format

  - id: input_files_cram
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 7
    doc: List of input files to merge in CRAM format. |
         Input files must be sorted by genomic coordinates

outputs:
  - id: output_file_cram
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)
    secondaryFiles:
      - .crai

doc: |
  Run "samtools merge [-@ nthreads] --write-index -c -p --reference ref.fa out.cram in1.cram in2.cram ..." |
  Create index for the output file
