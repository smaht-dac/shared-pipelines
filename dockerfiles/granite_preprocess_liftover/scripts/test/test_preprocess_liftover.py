#################################################################
#   Libraries
#################################################################

import pytest
import filecmp


preprocess = __import__("preprocess_liftover")


def test_non_standard_chromosomes(tmp_path):
    """
    This test checks if non standard chromosomes are not saved to the output VCF
    """

    # Variables and Run
    args = {
        "inputfile": "test/files/liftover_vcf_non_standard_chrom_in.vcf.gz",
        "outputfile": f"{tmp_path}/output.vcf",
        "sample_names": ["SAMPLE1"],
    }

    preprocess.main(args)
    assert filecmp.cmp(f"{tmp_path}/output.vcf", "test/files/liftover_vcf_correct_out.vcf") == True

def test_missing_chr(tmp_path):
    """
    This test checks if chr prefix is added to a non chr based VCF
    """

    # Variables and Run
    args = {
        "inputfile": "test/files/liftover_vcf_chr_missing_in.vcf.gz",
        "outputfile": f"{tmp_path}/output.vcf",
        "sample_names": ["SAMPLE1"],
    }

    preprocess.main(args)
    assert filecmp.cmp(f"{tmp_path}/output.vcf", "test/files/liftover_vcf_correct_out.vcf") == True


def test_wrong_sample_ids(tmp_path):
    """
    This test checks if the VCF sample identifiers match the expected sample IDs
    """
    # Variables and Run
    args = {
        "inputfile": "test/files/liftover_vcf_chr_missing_in.vcf.gz",
        "outputfile": f"{tmp_path}/output.vcf",
        "sample_names": ["SAMPLE1", "SAMPLE2"],
    }

    with pytest.raises(ValueError) as exc:
        preprocess.main(args)
    
    
    assert "Sample names ['SAMPLE1', 'SAMPLE2'] do not match sample identifires in the VCF ['SAMPLE1']" in str(exc.value)


        
    args = {
        "inputfile": "test/files/liftover_vcf_chr_missing_in.vcf.gz",
        "outputfile": f"{tmp_path}/output.vcf",
        "sample_names": ["SAMPLE2"],
    }


    with pytest.raises(ValueError) as exc:
        preprocess.main(args)
    
    
    assert "Sample names ['SAMPLE2'] do not match sample identifires in the VCF ['SAMPLE1']" in str(exc.value)


    args = {
        "inputfile": "test/files/liftover_vcf_two_samples_in.vcf.gz",
        "outputfile": f"{tmp_path}/output.vcf",
        "sample_names": ["SAMPLE3"],
    }


    with pytest.raises(ValueError) as exc:
        preprocess.main(args)
    
    
    assert "Sample names ['SAMPLE3'] do not match sample identifires in the VCF ['SAMPLE1', 'SAMPLE2']" in str(exc.value)







