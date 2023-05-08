#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: DockerRequirement
    dockerPull: ACCOUNT/fastp:VERSION

baseCommand: ['fastp', '--dont_eval_duplication']

inputs:
  - id: input_file_r1_fastq_gz
    type: File
    inputBinding:
      prefix: -i
    doc: Read1 input file name.|
         Expect a compressed FASTQ file

  - id: input_file_r2_fastq_gz
    type: File
    inputBinding:
      prefix: -I
    doc: Read2 input file name. |
         Expect a compressed FASTQ file

  # PolyG trimming NextSeq/NovaSeq
  - id: trim_poly_g
    default: null
    inputBinding:
      prefix: --trim_poly_g
    type: boolean
    doc: Force polyG tail trimming. |
         By default trimming is automatically enabled for Illumina NextSeq/NovaSeq data

  # Adapter trimming
  - id: disable_adapter_trimming
    default: null
    inputBinding:
      prefix: --disable_adapter_trimming
    type: boolean
    doc: Adapter trimming is enabled by default. |
         If this option is specified, adapter trimming is disabled

  - id: detect_adapter_for_pe
    default: null
    inputBinding:
      prefix: --detect_adapter_for_pe
    type: boolean
    doc: By default, the adapter sequence auto-detection is enabled for SE data only. |
         Turn on this option to enable it for PE data.

  # Length filtering
  - id: disable_length_filtering
    default: null
    inputBinding:
      prefix: --disable_length_filtering
    type: boolean
    doc: Length filtering is enabled by default. |
         If this option is specified, length filtering is disabled

  - id: length_required
    default: null
    inputBinding:
      prefix: --length_required
    type: int
    doc: Reads shorter than length_required will be discarded [15]

  - id: length_limit
    default: null
    inputBinding:
      prefix: --length_limit
    type: int
    doc: Reads longer than length_limit will be discarded [0]. |
         0 means no limitation

  # Quality filtering
  - id: disable_quality_filtering
    default: null
    inputBinding:
      prefix: --disable_quality_filtering
    type: boolean
    doc: Quality filtering is enabled by default. |
         If this option is specified, quality filtering is disabled

  - id: qualified_quality_phred
    default: null
    inputBinding:
      prefix: --qualified_quality_phred
    type: int
    doc: The quality value that a base is qualified [15]. |
         Default 15 means phred quality >=Q15 is qualified

  - id: unqualified_percent_limit
    default: null
    inputBinding:
      prefix: --unqualified_percent_limit
    type: int
    doc: How many percents of bases are allowed to be unqualified (0~100) [40]. |
         Default 40 means 40%

  # Others
  - id: nthreads
    type: int
    default: null
    inputBinding:
      prefix: --thread
    doc: Worker thread number [3]

  - id: output_file_r1_name
    type: string
    default: 'out.r1.fastq.gz'
    inputBinding:
      prefix: -o
    doc: Read1 output file name

  - id: output_file_r2_name
    type: string
    default: 'out.r2.fastq.gz'
    inputBinding:
      prefix: -O
    doc: Read2 output file name

  - id: output_summary_name
    type: string
    default: 'out.summary.json'
    inputBinding:
      prefix: --json
    doc: Name for the summary file in JSON format

outputs:
  - id: output_file_r1_fastq_gz
    type: File
    outputBinding:
      glob: $(inputs.output_file_r1_name)

  - id: output_file_r2_fastq_gz
    type: File
    outputBinding:
      glob: $(inputs.output_file_r2_name)

  - id: output_file_json
    type: File
    outputBinding:
      glob: $(inputs.output_summary_name)

doc: |
  Run fastp in paired-end mode
