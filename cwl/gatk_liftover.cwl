#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/gatk_picard:VERSION

baseCommand: [gatk, LiftoverVcf]

inputs:
  - id: vcf
    type: File
    inputBinding:
      prefix: -I
    doc: expect a path to the input uncompressed or gzip-compressed vcf

  - id: reference_sequence
    type: File
    inputBinding:
        prefix: -R
    secondaryFiles:
      - ^.dict
      - .fai    
    doc: reference sequence for the target genome build
  
  - id: reject
    type: string
    default: "reject.vcf.gz"
    inputBinding:
        prefix: --REJECT
    doc: file to write variants that failed liftover

  - id: output_vcf 
    type: string
    default: "output.vcf.gz"
    inputBinding:
      prefix: -O
    doc: name of output vcf file, compressed

  - id: chain
    type: File
    inputBinding:
        prefix: -C
    doc: liftover chain file

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.output_vcf)
    secondaryFiles:
      - .tbi

  - id: output_reject
    type: File
    outputBinding:
      glob: $(inputs.reject)
    secondaryFiles:
      - .tbi

doc: |
    run picard LiftoverVcf

