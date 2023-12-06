#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/shared_utils:VERSION

baseCommand: [bcftools_concat.sh]

inputs:
  - id: output_file_name
    type: string
    default: "output.vcf.gz"
    inputBinding:
      position: 1
    doc: Name of the output file in VCF format

  - id: input_files_vcf_gz
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 2
    secondaryFiles:
      - .tbi
    doc: List of input files to concatenate in VCF format. |
         Input files must be listed and sorted by genomic coordinates

outputs:
  - id: output_file_vcf_gz
    type: File
    outputBinding:
      glob: $(inputs.output_file_name)
    secondaryFiles:
      - .tbi

doc: |
  Run "bcftools concat" to concatenate multiple input files in VCF format. |
  Create index for the output file
