FROM 4dndcic/ubuntu16.04-miniconda-python36:v1
MAINTAINER Soo Lee (duplexa@gmail.com), Michele Berselli (berselli.michele@gmail.com)

# general updates & installing necessary Linux components
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    gcc \
    g++ \
    git \
    less \
    libncurses-dev \
    make \
    time \
    zip \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    liblz4-tool \
    libbz2-dev \
    liblzma-dev \
    locales \
    parallel \
    autoconf \
    autogen \
    autotools-dev \
    automake \
    pkg-config \
    tabix \
    yasm \
    libdbi-perl \
    libmodule-build-perl \
    libarchive-zip-perl \
    libmysqlclient-dev \
    libpng-dev \
    libexpat1-dev

WORKDIR /usr/local/bin

# conda & python libraries
RUN conda install -c bioconda -y python=3.6.8 openjdk==8.0.152 && \
    conda clean -a -y -f

# samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
    tar -xjf samtools-1.9.tar.bz2 && \
    rm -rf samtools-1.9.tar.bz2 && \
    cd samtools-1.9 && \
    ./configure && \
    make && \
    cd .. && \
    ln -s samtools-1.9 samtools

# cramtools
# the path is coded into cram_to_fastq.sh
RUN git clone https://github.com/enasequence/cramtools && \
    cd cramtools && \
    git checkout 0b5c9ec && \
    cd ..

# pigz
RUN wget https://zlib.net/pigz/pigz-2.6.tar.gz && \
    tar -xzf pigz-2.6.tar.gz && \
    rm -rf pigz-2.6.tar.gz && \
    cd pigz-2.6 && \
    make && \
    cd .. && \
    ln -s pigz-2.6 pigz

# pbgzip
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

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# cram2fastq scripts
COPY scripts/md5_to_fasta.py .

COPY cram_to_fastq.sh .
RUN chmod +x cram_to_fastq.sh

# bam integrity check script
COPY integrity-check.sh .
RUN chmod +x integrity-check.sh

# env paths
ENV PATH=/usr/local/bin/samtools/:$PATH
ENV PATH=/usr/local/bin/pigz/:$PATH

# supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
