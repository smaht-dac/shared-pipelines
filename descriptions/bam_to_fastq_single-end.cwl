#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [bam_to_fastq_single-end.sh]

inputs:
  - id: input_file_bam
    type: File
    inputBinding:
      position: 1
    doc: Input file in BAM format

  - id: nthreads
    type: int
    default: 1
    inputBinding:
      position: 2
    doc: Number of input/output compression threads to use in addition to main thread [1]

  - id: output_file_prefix
    type: string
    default: "output"
    inputBinding:
      position: 3
    doc: Prefix for the the output file name |
        <output_file_prefix>.fastq.gz

outputs:
  - id: output_file_fastq_gz
    type: File
    outputBinding:
      glob: $(inputs.output_file_prefix + ".fastq.gz")

doc: |
  Run bam_to_fastq_single-end.sh to convert a BAM file for single-end alignment |
  into a compressed FASTQ file
