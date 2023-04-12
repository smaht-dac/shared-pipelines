#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [bam_to_fastq.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      position: 1
    doc: Input file in BAM format

  - id: nthreads
    type: int
    default: 0
    inputBinding:
      position: 2
    doc: Number of input/output compression threads to use in addition to main thread [0]

  - id: output_file_prefix
    type: string
    default: "output"
    inputBinding:
      position: 3
    doc: Prefix for the the output files name |
        <output_file_prefix>.1.fastq.gz and <output_file_prefix>.2.fastq.gz

outputs:
  - id: output_file_1_fastq
    type: File
    outputBinding:
      glob: $(inputs.output_file_prefix + ".1.fastq.gz")

  - id: output_file_2_fastq
    type: File
    outputBinding:
      glob: $(inputs.output_file_prefix + ".2.fastq.gz")

doc: |
  Run bam_to_fastq.sh to convert a BAM file for paired-end alignment |
  into two FASTQ files, one for each of the mate reads
