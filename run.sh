#!/usr/bin/env bash
set -e -x

pipeline="$(realpath ../scAtlasTb)"

snakemake \
  --profile .profiles/local \
  --configfile \
    .profiles/czbiohub/cluster_config.yaml \
    configs/defaults.yaml  \
    configs/gene_sets.yaml  \
    configs/qc.yaml  \
    configs/integration_benchmark.yaml  \
  --snakefile $pipeline/workflow/Snakefile \
    $@
