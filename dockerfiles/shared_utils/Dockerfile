#######################################################################
#     Basic image
#######################################################################
FROM public.ecr.aws/smaht-dac/base-ubuntu2204-py38:0.0.1

LABEL maintainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)"

#######################################################################
#     General updates & installing necessary Linux components
#       - libncurses-dev, libbz2-dev, liblzma-dev used by samtools
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales \
    tabix=1.13+ds-2build1 \
    libncurses-dev=6.3-2 \
    libbz2-dev=1.0.8-5build1 \
    liblzma-dev=5.2.5-2ubuntu1 \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#######################################################################
#     Setting env
#######################################################################
## Set working directory
WORKDIR /usr/local/bin

## Supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

#######################################################################
#     Software
#######################################################################
## Conda install
#- pysam required by AddReadGroups.py
RUN conda install -c bioconda -y pysam==0.21.0 && \
    conda clean -a -y -f

## Samtools install
RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    tar -xjf samtools-1.17.tar.bz2 && \
    rm -rf samtools-1.17.tar.bz2

WORKDIR /usr/local/bin/samtools-1.17
RUN ./configure && \
    make

WORKDIR /usr/local/bin/
RUN ln -s samtools-1.17 samtools

## Bcftools install
RUN wget https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2 && \
    tar -xjf bcftools-1.17.tar.bz2 && \
    rm -rf bcftools-1.17.tar.bz2

WORKDIR /usr/local/bin/bcftools-1.17
RUN ./configure && \
    make

WORKDIR /usr/local/bin/
RUN ln -s bcftools-1.17 bcftools

## AddReadGroups install
RUN git clone https://github.com/smaht-dac/pipelines-scripts.git

WORKDIR pipelines-scripts
RUN git checkout e379584 && \
    chmod +x processing_scripts/AddReadGroups.py && \
    chmod +x processing_scripts/ReplaceReadGroups.sh

WORKDIR /usr/local/bin/

## pigz install
RUN wget https://github.com/madler/pigz/archive/refs/tags/v2.7.tar.gz && \
    tar -xzf v2.7.tar.gz && \
    rm -rf v2.7.tar.gz

WORKDIR /usr/local/bin/pigz-2.7
RUN make

WORKDIR /usr/local/bin/
RUN ln -s pigz-2.7 pigz

#######################################################################
#     Scripts
#######################################################################
## bam_to_fastq_paired-end
COPY bam_to_fastq_paired-end.sh .
RUN chmod +x bam_to_fastq_paired-end.sh

## bam_to_fastq_single-end
COPY bam_to_fastq_single-end.sh .
RUN chmod +x bam_to_fastq_single-end.sh

## shards_to_ReadGroups
COPY shards_to_ReadGroups.sh .
RUN chmod +x shards_to_ReadGroups.sh

## bcftools_concat
COPY bcftools_concat.sh .
RUN chmod +x bcftools_concat.sh

## cram_to_fastq_paired-end
COPY cram_to_fastq_paired-end.sh .
RUN chmod +x cram_to_fastq_paired-end.sh

#######################################################################
#     Update env
#######################################################################
ENV PATH=/usr/local/bin/samtools/:$PATH
ENV PATH=/usr/local/bin/bcftools/:$PATH
ENV PATH=/usr/local/bin/pigz/:$PATH
ENV PATH=/usr/local/bin/pipelines-scripts/processing_scripts/:$PATH

CMD ["bash"]
