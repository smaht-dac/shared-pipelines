#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
MAINTAINER Michele Berselli (berselli.michele@gmail.com)

#######################################################################
#     General updates & installing necessary Linux components
#       - libncurses-dev, libbz2-dev, liblzma-dev used by samtools
#       - yasm used by cramtools
#       - autoconf, autogen, autotools-dev, automake used by pbgzip
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales \
    tabix \
    libncurses-dev \
    libbz2-dev \
    liblzma-dev \
    yasm \
    autoconf \
    autogen \
    autotools-dev \
    automake

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin

#######################################################################
#     Software
#######################################################################
## samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
    tar -xjf samtools-1.9.tar.bz2 && \
    rm -rf samtools-1.9.tar.bz2 && \
    cd samtools-1.9 && \
    ./configure && \
    make && \
    cd .. && \
    ln -s samtools-1.9 samtools

## cramtools
# the path is coded into cram_to_fastq.sh
RUN git clone https://github.com/enasequence/cramtools && \
    cd cramtools && \
    git checkout 0b5c9ec && \
    cd ..

## pigz
RUN wget https://github.com/madler/pigz/archive/refs/tags/v2.6.tar.gz && \
    tar -xzf v2.6.tar.gz && \
    rm -rf v2.6.tar.gz && \
    cd pigz-2.6 && \
    make && \
    cd .. && \
    ln -s pigz-2.6 pigz

## pbgzip
RUN git clone https://github.com/nh13/pbgzip && \
    mv pbgzip pbgzip-dir && \
    cd pbgzip-dir && \
    git checkout 2b09f97 && \
    cd igzip && \
    make && \
    make install && \
    cd .. && \
    sh autogen.sh && \
    ./configure --enable-igzip && \
    make && \
    make install && \
    cd .. && \
    rm -rf pbgzip-dir

#######################################################################
#     Scripts
#######################################################################
## cram2fastq
COPY scripts/md5_to_fasta.py .

COPY cram_to_fastq.sh .
RUN chmod +x cram_to_fastq.sh

## bam integrity-check
COPY integrity-check.sh .
RUN chmod +x integrity-check.sh

#######################################################################
#     Setting env variables
#######################################################################
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/bin/samtools/:$PATH
ENV PATH=/usr/local/bin/pigz/:$PATH

## Supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
