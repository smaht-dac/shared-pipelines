#!/usr/bin/env python3

##################################################################################
#
#       Script to validate input VCF file for the liftover step. 
#       It runs the following steps: 
#       1. Check if sample identifiers in the VCF matches provided sample names 
#       2. Exlcude non standard chromosomes i.e GL000225.1 
#       3. If the VCF is not 'chr' based, add the prefix 
#
##################################################################################


from granite.lib import vcf_parser
import argparse

#list of standard chromosomes
std_chromosomes = list(map(str, list(range(1,23)))) + ["X", "Y"]



################################################
#   Functions
################################################


def main(args):

    output_file = args['outputfile']

    vcf = vcf_parser.Vcf(args['inputfile'])


    # 1. Check if sample names match genotype IDs
    sample_names = args['sample_names']
    vcf_sample_names = vcf.header.IDs_genotypes
    sample_names_err = f"Sample names {sample_names} do not match sample identifies in the VCF {vcf_sample_names}"
    
    if len(sample_names) != len(vcf_sample_names):
        raise ValueError(sample_names_err)
    else:
        for id in vcf_sample_names:
            if id not in args['sample_names']:
                raise ValueError(sample_names_err)
    
    with open(output_file, "w") as output:

        vcf.write_header(output)

        for vnt in vcf.parse_variants():

            # 2. Exclude non standard chromosomes
            if vnt.CHROM in std_chromosomes:

                # 3. Add 'chr' to CHROM if not present
                if vnt.CHROM.startswith("chr") == False:
                    vnt.CHROM = f"chr{vnt.CHROM}"
                
                vcf.write_variant(output, vnt)



    
################################################
#   Main
################################################

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Converts genomic coordinates between two different assemblies using pyliftover.')

    parser.add_argument('-i','--inputfile', help='input VCF file', required=True)
    parser.add_argument('-o','--outputfile', help='output VCF file', required=True)
    parser.add_argument('-s', '--sample_names', help='list of sample IDs that must be present in the input VCF',  nargs='+', required=True)


    args = vars(parser.parse_args())

    main(args)