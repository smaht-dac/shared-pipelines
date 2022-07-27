
cwlVersion: v1.0

class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}

inputs:
  - id: input_vcf
    type: File
    secondaryFiles:
      - .tbi
    doc: expect the path to the vcf gz file

  - id: chain
    type: File
    doc: the liftover chain file

  - id: reference
    type: File
    secondaryFiles:
      - ^.dict
      - .fai
    doc: expect the path to the fa reference file

  - id: sample_names
    type: string
    doc: list of sample IDs

outputs:
  vcf_lifted:
    type: File
    outputSource: vcf_liftover/output

  reject:
    type: File
    outputSource: vcf_liftover/output_reject

steps:
  preprocess:
    run: preprocess_liftover.cwl
    in:
      vcf:
        source: input_vcf
      sample_names:
        source: sample_names
      
    out: [output]

  vcf_liftover:
      run: picard_liftover.cwl
      in:
        vcf:
          source: preprocess/output
        chain:
          source: chain
        reference_sequence:
            source: reference
        
      out: [output, output_reject]


doc: |
  run preprocess_liftover |
  run picard_liftover