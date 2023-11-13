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
  - id: nthreads
    type: int
    default: 1
    # need a default to keep the argument order for the bash script
    inputBinding:
      position: 1
    doc: Number of input/output compression threads to use in addition to main thread [0]

  - id: output_file_name
    type: string
    default: "output.vcf.gz"
    inputBinding:
      position: 2
    doc: Name of the output file in VCF format

  - id: input_files_vcf_gz
    type:
      -
        items: File
        type: array
    inputBinding:
      position: 3
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
