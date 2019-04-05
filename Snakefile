
import os
from os import path

if not workflow.overwrite_configfile:
    configfile: "config.yml"
workdir: path.join(config["workdir_top"], config["pipeline"])

if(config["heu_mode"]):
    config["heu_mode"] = "true"

WORKDIR = path.join(config["workdir_top"], config["pipeline"])
SNAKEDIR = path.dirname(workflow.snakefile)

include: "snakelib/utils.snake"


rule dump_versions:
    output:
        ver = "versions.txt"
    conda: "env.yml"
    shell:"""
    command -v conda > /dev/null && conda list > {output.ver}
    """

rule make_fastq:
    input:
        fqd = config["fastq_dir"]
    output:
        fastq = "input/reads.fastq"
    conda: "env.yml"
    shell:"""
    find -L {input.fqd} -maxdepth 1 -type f  -name "*.fastq" -exec cat {{}} \; > {output.fastq} 
    """

rule run_pychopper:
    input:
        fastq = rules.make_fastq.output.fastq
    output:
        out_fastq = "output/full_length_reads.fastq",
        unclass_fastq = "output/unclassified_reads.fastq",
        stats = "output/stats.tsv",
        scores = "output/alignment_scores.tsv",
        pdf = "output/pychopper_report.pdf",
    params:
        primers = config["primers"],
        aln_params = config["aln_params"],
        target_length = config["target_length"],
        sample_size = config["sample_size"],
        score_percentile = config["score_percentile"],
        heu_mode = config["heu_mode"],
        heu_stringency = config["heu_stringency"],
    threads: config["threads"]
    conda: "env.yml"
    shell: """
    X=""
    if [ {params.heu_mode} == "true" ];
    then
        X="-x"
    fi

    echo '{params.primers}' > input/primers.fas

    cdna_classifier.py -b input/primers.fas -g {params.aln_params} -t {params.target_length} \
    -n {params.sample_size} -s {params.score_percentile} -r {output.pdf} -u {output.unclass_fastq} -S {output.stats} \
    -A {output.scores} $X -l {params.heu_stringency} -T {threads} {input.fastq} {output.out_fastq}
    """

rule all:
    input:
        ver = rules.dump_versions.output.ver, 
        fastq = rules.make_fastq.output.fastq,
        out_fastq = rules.run_pychopper.output.out_fastq,
        unclass_fastq = rules.run_pychopper.output.unclass_fastq,
        stats = rules.run_pychopper.output.stats,
        scores = rules.run_pychopper.output.scores,
        pdf = rules.run_pychopper.output.pdf,
