<img src="https://github.com/dbmi-bgm/cgap-pipeline/blob/master/docs/images/cgap_logo.png" width="200" align="right">

# CGAP Base Pipeline

This repository contains base components for CGAP pipeline:

  * CWL workflows
  * CGAP Portal Workflows and MetaWorkflows objects
  * ECR (Docker) source files, which allow for creation of public Docker images (using `docker build`) or private dynamically-generated ECR images (using [*cgap pipeline utils*](https://github.com/dbmi-bgm/cgap-pipeline-utils/) `deploy_pipeline`)

## Components

General:

  - md5
  - FastQC

Format manipulation:

  - cram2fastq

For more details check the [*documentation*](https://cgap-pipeline-main.readthedocs.io/en/latest/Pipelines/Base/index-base.html "base pipeline").

### Version Updates

#### v1.0.0
* v27 -> v1.0.0, we are starting a new more comprehensive versioning system
* Added some change in metaworkflows to accomodate the changes in foursight

#### v27
* This repo starts from the v26 release of [*cgap-pipeline*](https://github.com/dbmi-bgm/cgap-pipeline) and contains basic utilities steps and the steps to manipulate formats
* Changes in repo structure to allow for compatibility with new pipeline organization
