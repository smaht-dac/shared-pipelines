#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
LABEL mainainers="Dominika Maziec (dominika.maziec@hms.harvard.edu),  Michele Berselli (berselli.michele@gmail.com)"

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


COPY scripts/preprocess_liftover.py .
RUN chmod +x preprocess_liftover.py

CMD ["bash"]