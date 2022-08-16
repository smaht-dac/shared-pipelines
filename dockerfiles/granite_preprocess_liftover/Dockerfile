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
## granite, pytest
RUN pip install granite-suite==0.2.0 pytest==7.1.2

#######################################################################
#     Scripts
#######################################################################
## preprocess_liftover
COPY scripts/preprocess_liftover.py .
RUN chmod +x preprocess_liftover.py

#######################################################################
#     Setting env variables
#######################################################################
## Supporting UTF-8
RUN locale-gen "en_US.UTF-8" && update-locale LC_ALL="en_US.UTF-8"
ENV LC_ALL=en_US.UTF-8

CMD ["bash"]
