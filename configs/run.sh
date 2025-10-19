#!/usr/bin/env bash
set -e -x

pipeline="$(realpath ../scAtlasTb)"

snakemake \
  --profile .profiles/local \
  --configfile \
    configs/defaults.yaml  \
    configs/qc.yaml  \
    configs/integration_benchmark.yaml  \
  --snakefile $pipeline/workflow/Snakefile \
    $@
