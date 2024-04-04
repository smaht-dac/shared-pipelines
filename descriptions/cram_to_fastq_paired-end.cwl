#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [cram_to_fastq_paired-end.sh]

inputs:
  - id: input_file_cram
    type: File
    inputBinding:
      position: 1
    doc: Input file in CRAM format

  - id: genome_reference_fasta
    type: File
    inputBinding:
      position: 2
    secondaryFiles:
      - ^.dict
      - .fai
    doc: Genome reference in FASTA format with the corresponding index files

  - id: nthreads
    type: int
    default: 0
    inputBinding:
      position: 3
    doc: Number of input/output compression threads to use in addition to main thread [0]

  - id: output_file_prefix
    type: string
    default: "output"
    inputBinding:
      position: 4
    doc: Prefix for the the output files name |
        <output_file_prefix>.1.fastq.gz and <output_file_prefix>.2.fastq.gz

outputs:
  - id: output_file_1_fastq_gz
    type: File
    outputBinding:
      glob: $(inputs.output_file_prefix + ".1.fastq.gz")

  - id: output_file_2_fastq_gz
    type: File
    outputBinding:
      glob: $(inputs.output_file_prefix + ".2.fastq.gz")

doc: |
  Run cram_to_fastq_paired-end.sh to convert a CRAM file for paired-end alignment |
  into two compressed FASTQ files, one for each of the mate reads
