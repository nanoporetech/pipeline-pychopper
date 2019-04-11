![ONT_logo](/ONT_logo.png)
-----------------------------

Utility pipeline for running pychopper, a tool to identify full length cDNA reads
=================================================================================

This simple Snakemake pipeline is running pychopper (a tool to identify full length cDNA reads) on a directory containing fastq files. Check out the pychopper repository for more information on these parameters, [here](https://github.com/nanoporetech/pychopper).

Getting Started
===============

## Input

The input files and parameters are specified in `config.yml`:

- `fastq_dir` - directory with the fastq files. The pipeline will concatenate them into a single input fastq file.
- `primers` - the cDNA primers as a fasta snippet.
- `aln_params` - pychopper alignment parameters.
- `target_length` -  number of bases to scan at each end.
- `sample_size` - number of random samples when calculating score cutoff.
- `score_percentile` - score cutoff percentile.
- `heu_mode` - use heuristic mode if true.
- `heu_stringency` - stringency in heuristic mode.

## Output

- `output/full_length_reads.fastq` - stranded full length reads.
- `output/unclassified_reads.fastq`- unclassified reads.
- `output/pychopper_report.pdf` - report PDF.
- `output/stats.tsv` - classification statistics.
- `output/alignment_scores.tsv` - alignment scores.
- `input/reads.fastq` - concatenated input reads.
- `input/primers.fas` - input cDNA primers.
- `versions.txt` - installed software versions.

## Dependencies

- [miniconda](https://conda.io/miniconda.html) - install it according to the [instructions](https://conda.io/docs/user-guide/install/index.html).
- [snakemake](https://anaconda.org/bioconda/snakemake) install using `conda`.
- The rest of the dependencies are automatically installed using the `conda` feature of `snakemake`.

## Layout

* `README.md`
* `Snakefile`         - master snakefile
* `config.yml`        - YAML configuration file
* `snakelib/`         - snakefiles collection included by the master snakefile
* `lib/`              - python files included by analysis scripts and snakefiles
* `scripts/`          - analysis scripts

## Installation

Clone the repository:

```bash
git clone https://github.com/nanoporetech/pipeline-pychopper
```

## Usage:

Edit `config.yml` to set the input datasets and parameters then issue:

```bash
snakemake --use-conda -j <num_cores> all
```

Help
====

## Licence and Copyright

(c) 2019 Oxford Nanopore Technologies Ltd.

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.

## FAQs and tips

## References and Supporting Information

### Research Release

Research releases are provided as technology demonstrators to provide early access to features or stimulate Community development of tools. Support for this software will be minimal and is only provided directly by the developers. Feature requests, improvements, and discussions are welcome and can be implemented by forking and pull requests. However much as we would like to rectify every issue and piece of feedback users may have, the developers may have limited resource for support of this software. Research releases may be unstable and subject to rapid iteration by Oxford Nanopore Technologies.

