# scAtlasTb Tutorial

This tutorial provides an example of a full integration workflow from data download to downstream analysis using the [scAtlasTb](https://github.com/HCA-integration/scAtlasTb).
There are two workflows defined under `configs/` that use the [Hrovatin et al. (2023)](https://doi.org/10.1038/s42255-023-00876-x) datasets.

* `configs/qc.yaml`: Quality control workflow including doublet detection.
* `configs/integration_benchmark.yaml`: Full integration benchmark workflow using multiple integration methods and evaluating integration performance using a variety of metrics.

## Prerequisites

The workflow has been built for Linux distributions and relies on Conda for environment management.
Please ensure you have either [Miniforge](https://github.com/conda-forge/miniforge), [Conda](https://docs.conda.io/en/latest/) or [Miniconda](https://docs.conda.io/en/latest/miniconda.html) installed.
The toolbox has also been tested on macOS, but hardware acceleration may not be available.

## Getting started

Clone this repository as well as the scAtlasTb and make sure that both are in the same parent directory:

```bash
git clone https://github.com/lueckenlab/scAtlasTb_Tutorial.git
git clone https://github.com/HCA-integration/scAtlasTb.git
```

### Set up conda environments

> Note: This can take some time, so make sure you prepare this ahead of time. If you have already set up scAtlasTb and have the conda environments installed, you can skip this step.

Set up the conda environments from `scAtlasTb/envs` as described in the [scAtlasTb documentation](https://scatlastb.readthedocs.io/en/latest/getting_started/installation.html#option-2-env-mode-local).
For this tutorial we recommend you use the `local` environment mode.
You will need the following environments:

- `snakemake`: for running the workflow
- `qc`: for the doublet computation and quality control workflow
- `scvi-tools`: for integration with scVI-based methods
- `harmony_cpu`: for Harmony integration (or `rapids_singlecell` or `harmony_pytorch` for GPU-based Harmony)
- `drvi` (optional): for DRVI integration
- `scarches` (optional): for scPoli integration
- `rapids_singlecell` (optional): for GPU-accelerated scanpy operations

The only exception is `scanpy`, which you should install from this repository (scAtlasTb_Tutorial) to ensure compatibility with the downstream analysis example.
You can find the environment file under `scAtlasTb_Tutorial/envs/scanpy.yaml`, as well as instructions under `scAtlasTb_Tutorial/envs/README.md`.

### Set up Jupyter Lab (optional)

If you don't have Jupyter Lab installed yet, you can set it up in a separate conda environment:

```bash
conda env create -f envs/jupyterlab.yaml
```

Please refer to the README in the `envs` folder for more details.

## Prepare the input data

The tutorial uses publicly available datasets from [Hrovatin et al. (2023)](https://doi.org/10.1038/s42255-023-00876-x) as example data for the integration benchmark.
Use the provided notebook under `notebooks/Hrovatin_2023.ipynb` to download and prepare the data.

The dataset used by the tutorial will be stored in `data/Hrovatin_2023.zarr`.

## Running the workflow

Since this tutorial is already set up with functioning configuration files, you can directly run the workflow after setting up the conda environments.
Activate the `snakemake` environment before running the workflow:

```bash
conda activate snakemake
```

Then, you can run the workflow with the following command:

```bash
bash configs/run.sh <target> -nq
```

The target can be anything defined by the pipeline that is input to the `configs/run.sh` script.
The flag `-n` will enable dry-run mode, which allows you to see what jobs would be executed without actually running them, while `-q` suppresses the output of Snakemake to only show a summary of the workflow.
You should always run the workflow first in dry-run mode to ensure everything is set up correctly.

> Note: Please refer to the [documentation](https://scatlastb.readthedocs.io/en/latest/getting_started/call_pipeline.html#list-all-available-rules) for more details on available targets and how to run the workflow with different options.

### QC workflow

To run the QC workflow, use the following command:

```bash
bash configs/run.sh qc_all -nq
```

which should give you the following output:

```
Building DAG of jobs...
Error: Directory cannot be locked. This usually means that another Snakemake instance is running on this directory. Another possibility is that a previous run exited unexpectedly.
Job stats:
job                       count
----------------------  -------
doublets_collect              9
doublets_split_batches        9
qc_all                        1
qc_autoqc                     9
qc_get_thresholds             9
qc_merge_thresholds           1
qc_plot_joint                 9
qc_plot_removed               9
split_data_link               9
split_data_split              1
total                        66
```

You can ignore any warnings that appear before the yellow Snakemake log.
Inspect the config file under `configs/qc.yaml` to see which steps are included in the workflow and how they match with the dry-run output.
Consider adjusting the workflow in the config e.g. if you have limited resources and want to simplify the workflow.

If the dry-run works as expected, you can run the actual workflow with multiple cores:

```bash
bash configs/run.sh qc_all -c3
```

Be mindful of your computational resources and avoid using all cores available on your machine, especially if you have limited memory.
When in doubt, use a single core (`-c1`).

Once the workflow has finished, you can inspect the output under `data/images/qc/`.
Refer to the [scAtlasTb documentation](https://scatlastb.readthedocs.io/en/latest/workflows/qc.html) for more details on the output files.

### Integration benchmark workflow

The integration benchmark workflow is a lot more complex than the QC workflow and may take a long time to run depending on your hardware.
Look into the config file under `configs/integration_benchmark.yaml` to see which steps are included in the workflow and consider adjusting the workflow in the config e.g. by removing some integration methods if resources are limited.

Since the workflow contains many more options that are re-used by different steps, much of the defaults are configured under `configs/defaults.yaml`.
Read about defaults in the [scAtlasTb documentation](https://scatlastb.readthedocs.io/en/latest/advanced_configuration/advanced.html#set-defaults).

Check the dry-run output first:

```bash
bash configs/run.sh integration_all metrics_all -nq
```

You can specify any target that is defined in one of the input maps in the config files.

Call the actual integration workflow with multiple cores:

```bash
bash configs/run.sh integration_all -c3
```

If any methods fail or the workflow takes too long and you just want a proof-of-concept, consider adjusting the workflow in the config e.g. by removing some integration methods.

If the workflow has finished successfully, you can inspect the integration UMAPs under `data/images/integration/umap/`.

Continue with the metrics to complete the benchmark:

```bash
bash configs/run.sh metrics_all -c3
```

The metrics plots will be stored under `data/images/metrics/`.

### Postprocessing of integrations

There are additional post-processing steps defined in the benchmark workflow.
They contain splitting by cell type, clustering, label transfer and marker gene computation.
The `collect` step collects the different integration outputs and combines them into a single AnnData file for easier downstream analysis.
Finally, the `majority_voting` step computes consensus labels based on the label transfer results from the different integration methods.

```bash
bash configs/run.sh clustering_all majority_voting_all -c3
```

The final output will be stored under `data/pipeline/majority_voting/dataset~integration_benchmark_beta/`.

## Downstream analysis

Follow the notebook under `notebooks/Evaluate_integrations.ipynb` for an example of downstream analysis using the integrated data and consensus labels from the benchmark workflow.
