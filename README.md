<img src="https://github.com/dbmi-bgm/cgap-pipeline/blob/master/docs/images/cgap_logo.png" width="200" align="right">

# CGAP Base Pipeline

This repository contains shared components for CGAP pipelines and general processing pipelines:

  * CWL workflow descriptions
  * CGAP Portal *Workflow* and *MetaWorkflow* objects
  * CGAP Portal *Software*, *FileFormat*, and *FileReference* objects
  * ECR (Docker) source files, which allow for creation of public Docker images (using `docker build`) or private dynamically-generated ECR images (using [*cgap pipeline utils*](https://github.com/dbmi-bgm/cgap-pipeline-utils/) `pipeline_deploy`)

## Pipelines

General Processing:

  - MD5 Hash

Quality Control:

  - ``FastQC``

Format Manipulation:

  - ``cram`` to ``fastq``
  - ``bam`` to ``fastq``

Utilities:

  - ``LiftoverVcf`` (GATK)
  - ``merge`` (BCFtools)

For more details check the [*documentation*](https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Base/index-base.html "base pipeline").

## Other Components

The respository also stores CGAP Portal objects that are shared by multiple pipelines.
