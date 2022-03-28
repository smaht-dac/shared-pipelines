#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
MAINTAINER Michele Berselli (berselli.michele@gmail.com)

#######################################################################
#     General updates & installing necessary Linux components
#       - libncurses-dev
#       - default-jdk for nozzle
#######################################################################
RUN apt-get update -y && apt-get install -y \
    libncurses-dev \
    default-jdk

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin

#######################################################################
#     Software
#######################################################################
COPY downloads.sh .
RUN . downloads.sh

#######################################################################
#     Setting env variables
#######################################################################
ENV PATH=/usr/local/bin/FastQC/:$PATH

## Supporting UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

#######################################################################
#     Scripts
#######################################################################
## FastQC run
COPY run.sh .
RUN chmod +x run.sh

CMD ["bash"]
