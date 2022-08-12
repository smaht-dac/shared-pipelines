#######################################################################
#     Basic image
#######################################################################
FROM cgap/cgap-ubuntu2004-py-38:0.0.1
LABEL mainainers="Michele Berselli (berselli.michele@gmail.com), Dominika Maziec (dominika.maziec@hms.harvard.edu)"

#######################################################################
#     Setting working env
#######################################################################
WORKDIR /usr/local/bin

#######################################################################
#     Software
#######################################################################

## granite
RUN pip install granite-suite==0.2.0

COPY scripts/preprocess_liftover.py .
RUN chmod +x preprocess_liftover.py

CMD ["bash"]