#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/base:VERSION

baseCommand: [bcftools, merge]

arguments: ["--merge", "none", "-o", "merged.vcf.gz",
            "-O", "z"]

inputs:
  - id: input_vcfs
    type: File[]
    inputBinding:
      position: 2
    secondaryFiles:
      - .tbi
    doc: list of vcf.gz files to merge

  - id: nthreads
    type: int
    inputBinding:
      position: 1
      prefix: --threads
    doc: number of threads used to run parallel

outputs:
  - id: merged_vcf
    type: File
    outputBinding:
      glob: merged.vcf.gz

doc: |
  run bcftools merge
