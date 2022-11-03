#!/usr/bin/env python3

##################################################################################
#
#   Script to clean input VCF file
#       - clean tag in INFO column and corresponding headers
#       - compress and tabix index the output VCF file
#
##################################################################################

# LIBRARIES
import sys, os
import argparse
import subprocess
from granite.lib import vcf_parser

# COSTANTS
tag_to_keep = [
               # SNV
               'AC', 'AF', 'AN', 'BaseQRankSum', 'ClippingRankSum', 'DP',
               'DS', 'END', 'ExcessHet', 'FS', 'HaplotypeScore',
               'InbreedingCoeff', 'MLEAC', 'MLEAF', 'MQ', 'MQRankSum', 'QD'
               'RAW_MQ', 'ReadPosRankSum', 'SOR',
               # SV
               'SVLEN', 'SVTYPE']

# SNV
##INFO=<ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes, for each ALT allele, in the same order as listed">
##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency, for each ALT allele, in the same order as listed">
##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">
##INFO=<ID=BaseQRankSum,Number=1,Type=Float,Description="Z-score from Wilcoxon rank sum test of Alt Vs. Ref base qualities">
##INFO=<ID=ClippingRankSum,Number=1,Type=Float,Description="Z-score From Wilcoxon rank sum test of Alt vs. Ref number of hard clipped bases">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth; some reads may have been filtered">
##INFO=<ID=DS,Number=0,Type=Flag,Description="Were any of the samples downsampled?">
##INFO=<ID=END,Number=1,Type=Integer,Description="Stop position of the interval">
##INFO=<ID=ExcessHet,Number=1,Type=Float,Description="Phred-scaled p-value for exact test of excess heterozygosity">
##INFO=<ID=FS,Number=1,Type=Float,Description="Phred-scaled p-value using Fisher's exact test to detect strand bias">
##INFO=<ID=HaplotypeScore,Number=1,Type=Float,Description="Consistency of the site with at most two segregating haplotypes">
##INFO=<ID=InbreedingCoeff,Number=1,Type=Float,Description="Inbreeding coefficient as estimated from the genotype likelihoods per-sample when compared against the Hardy-Weinberg expectation">
##INFO=<ID=MLEAC,Number=A,Type=Integer,Description="Maximum likelihood expectation (MLE) for the allele counts (not necessarily the same as the AC), for each ALT allele, in the same order as listed">
##INFO=<ID=MLEAF,Number=A,Type=Float,Description="Maximum likelihood expectation (MLE) for the allele frequency (not necessarily the same as the AF), for each ALT allele, in the same order as listed">
##INFO=<ID=MQ,Number=1,Type=Float,Description="RMS Mapping Quality">
##INFO=<ID=MQRankSum,Number=1,Type=Float,Description="Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities">
##INFO=<ID=QD,Number=1,Type=Float,Description="Variant Confidence/Quality by Depth">
##INFO=<ID=RAW_MQ,Number=1,Type=Float,Description="Raw data for RMS Mapping Quality">
##INFO=<ID=ReadPosRankSum,Number=1,Type=Float,Description="Z-score from Wilcoxon rank sum test of Alt vs. Ref read position bias">
##INFO=<ID=SOR,Number=1,Type=Float,Description="Symmetric Odds Ratio of 2x2 contingency table to detect strand bias">

# SV
##INFO=<ID=BND_DEPTH,Number=1,Type=Integer,Description="Read depth at local translocation breakend">
##INFO=<ID=CIEND,Number=2,Type=Integer,Description="Confidence interval around END">
##INFO=<ID=CIGAR,Number=A,Type=String,Description="CIGAR alignment for each alternate indel allele">
##INFO=<ID=CIPOS,Number=2,Type=Integer,Description="Confidence interval around POS">
##INFO=<ID=END,Number=1,Type=Integer,Description="End position of the variant described in this record">
##INFO=<ID=EVENT,Number=1,Type=String,Description="ID of event associated to breakend">
##INFO=<ID=HOMLEN,Number=.,Type=Integer,Description="Length of base pair identical homology at event breakpoints">
##INFO=<ID=HOMSEQ,Number=.,Type=String,Description="Sequence of base pair identical homology at event breakpoints">
##INFO=<ID=IMPRECISE,Number=0,Type=Flag,Description="Imprecise structural variation">
##INFO=<ID=INV3,Number=0,Type=Flag,Description="Inversion breakends open 3' of reported location">
##INFO=<ID=INV5,Number=0,Type=Flag,Description="Inversion breakends open 5' of reported location">
##INFO=<ID=JUNCTION_QUAL,Number=1,Type=Integer,Description="If the SV junction is part of an EVENT (ie. a multi-adjacency variant), this field provides the QUAL value for the adjacency in question only">
##INFO=<ID=LEFT_SVINSSEQ,Number=.,Type=String,Description="Known left side of insertion for an insertion of unknown length">
##INFO=<ID=MATEID,Number=.,Type=String,Description="ID of mate breakend">
##INFO=<ID=MATE_BND_DEPTH,Number=1,Type=Integer,Description="Read depth at remote translocation mate breakend">
##INFO=<ID=RIGHT_SVINSSEQ,Number=.,Type=String,Description="Known right side of insertion for an insertion of unknown length">
##INFO=<ID=ReverseComplementedAlleles,Number=0,Type=Flag,Description="The REF and the ALT alleles have been reverse complemented in liftover since the mapping from the previous reference to the current one was on the negative strand.">
##INFO=<ID=SVINSLEN,Number=.,Type=Integer,Description="Length of insertion">
##INFO=<ID=SVINSSEQ,Number=.,Type=String,Description="Sequence of insertion">
##INFO=<ID=SVLEN,Number=.,Type=Integer,Description="Difference in length between REF and ALT alleles">
##INFO=<ID=SVTYPE,Number=1,Type=String,Description="Type of structural variant">
##INFO=<ID=SwappedAlleles,Number=0,Type=Flag,Description="The REF and the ALT alleles have been swapped in liftover due to changes in the reference. It is possible that not all INFO annotations reflect this swap, and in the genotypes, only the GT, PL, and AD fields have been modified. You should check the TAGS_TO_REVERSE parameter that was used during the LiftOver to be sure.">

################################################
#   FUNCTIONS
################################################
def filter_header(definitions):
    """
    """
    new_definitions = ''
    for line in definitions.split('\n')[:-1]:
        if line.startswith('##INFO=<ID='):
            if line.split(',')[0].split('<ID=')[1] in tag_to_keep:
                new_definitions += f'{line}\n'
            else: continue
        else:
            new_definitions += f'{line}\n'

    return new_definitions

def filter_INFO(INFO, sep=';'):
    """
    """
    new_INFO = []
    for tag in INFO.split(sep):
        if tag.split('=')[0] in tag_to_keep:
            new_INFO.append(tag)

    return sep.join(new_INFO)

def main(args):
    """
    """

    outputfile = args["outputfile"]
    vcf = vcf_parser.Vcf(args["inputfile"])

    vcf.header.definitions = filter_header(vcf.header.definitions)

    with open(outputfile, "w") as output:
        vcf.write_header(output)

        for vnt in vcf.parse_variants():
            vnt.INFO = filter_INFO(vnt.INFO)

            vcf.write_variant(output, vnt)

    subprocess.run(['bgzip', f'{outputfile}'])
    subprocess.run(['tabix', '-p', 'vcf', f'{outputfile}.gz'])

################################################
#   MAIN
################################################
if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Script to clean input VCF file")

    parser.add_argument("-i", "--inputfile", help="input VCF file", required=True)
    parser.add_argument("-o", "--outputfile", help="output VCF file", required=True)

    args = vars(parser.parse_args())

    main(args)
