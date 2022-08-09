#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/gatk_liftover_vcf:VERSION

baseCommand: [gatk, LiftoverVcf]

inputs:
  - id: vcf
    type: File
    inputBinding:
      prefix: -I

    doc: expect the path to the input vcf

  - id: reference_sequence
    type: File
    inputBinding:
        prefix: -R
    
    secondaryFiles:
      - ^.dict
      - .fai    
    doc: the reference sequence for the target genome build
  
  - id: reject
    type: string
    default: "reject.vcf.gz"
    inputBinding:
        prefix: --REJECT
    
    doc: file to which to write rejected records

  - id: output_vcf 
    type: string
    default: "output.vcf.gz"
    inputBinding:
      prefix: -O

    doc: base name of output vcf file

  - id: chain
    type: File
    inputBinding:
        prefix: -C
    doc:  the liftover chain file


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

    run picard liftover vcf

