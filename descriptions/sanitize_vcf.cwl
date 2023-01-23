#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/granite:VERSION

baseCommand: [python3, /usr/local/bin/sanitize_vcf.py]

inputs:
  - id: input_vcf
    type: File
    inputBinding:
      prefix: -i
    doc: expect a path to the input uncompressed or gzip-compressed vcf

  - id: output_vcf
    type: string
    default: "output.vcf"
    inputBinding:
      prefix: -o
    doc: name of output vcf file

outputs:
  - id: cleaned_vcf
    type: File
    outputBinding:
      glob: $(inputs.output_vcf + ".gz")
    secondaryFiles:
      - .tbi

doc: |
    run sanitize_vcf.py to clean header and annotation relative to INFO field
