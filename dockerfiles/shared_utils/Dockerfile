#######################################################################
#     Basic image
#######################################################################
FROM smaht/ubuntu2204-py38:0.0.1

LABEL maintainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika_maziec@hms.harvard.edu)"

#######################################################################
#     General updates & installing necessary Linux components
#       - libncurses-dev, libbz2-dev, liblzma-dev used by samtools
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales=2.35-0ubuntu3.1 \
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
## Samtools install
RUN wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 && \
    tar -xjf samtools-1.17.tar.bz2 && \
    rm -rf samtools-1.17.tar.bz2

WORKDIR /usr/local/bin/samtools-1.17
RUN ./configure && \
    make

WORKDIR /usr/local/bin/
RUN ln -s samtools-1.17 samtools

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
## bam2fastq
COPY bam_to_fastq.sh .
RUN chmod +x bam_to_fastq.sh

#######################################################################
#     Update env
#######################################################################
ENV PATH=/usr/local/bin/samtools/:$PATH
ENV PATH=/usr/local/bin/pigz/:$PATH

CMD ["bash"]