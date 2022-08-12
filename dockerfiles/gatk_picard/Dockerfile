#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
LABEL mainainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika.maziec@hms.harvard.edu)"

#######################################################################
#     General updates & installing necessary Linux components
#######################################################################
RUN apt-get update -y && apt-get install -y \
    locales \
    tabix

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin

#######################################################################
#     Software
#######################################################################
## conda install
RUN conda install -c bioconda -y gatk4==4.2.6.1 picard==2.26.11 && \
    conda clean -a -y -f

#######################################################################
#     Setting env variables
#######################################################################
## Supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
