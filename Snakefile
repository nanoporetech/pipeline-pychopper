
import os
from os import path

if not workflow.overwrite_configfile:
    configfile: "config.yml"
workdir: path.join(config["workdir_top"], config["pipeline"])

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
    find {input.fqd} -maxdepth 1 -type f -name "*.fastq" -exec cat {{}} \; > {output.fastq} 
    """

rule all:
    input:
        ver = rules.dump_versions.output.ver, 
        fastq = rules.make_fastq.output.fastq,
