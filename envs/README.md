# Conda environments

Make sure you have an instance of `conda` installed (e.g. via `miniconda` or `miniforge`).
If you don't have any pre-existing conda installation, we recommend using [miniforge](https://github.com/conda-forge/miniforge).

For faster installs, make sure you use the [`libmamba-solver`](https://www.anaconda.com/blog/a-faster-conda-for-a-growing-community) if you're using `miniconda` or `anaconda`.
For `miniforge`, `libmamba-solver` is already the default.

## Install conda environments

Here are some conda environments that you can use out-of-the-box for your project.
Start by installing the `scanpy` environment, which will be useful for most of your work.

```
conda env create -f envs/scanpy.yaml
```

You can also rename the environment to something more meaningful for your project, if you don't like the default name `scanpy` or already have another environment under the same name.
Just edit the `name` field in the `envs/scanpy.yaml` file to your liking.

### R environment

If you need to use R, you can also install the `scanpy_r` environment.

```
conda env create -f envs/scanpy_r.yaml
```

This environment contains the `r-irkernel` package, which allows you to run R code in Jupyter notebooks.

Feel free to add any additional R packages you need to the `envs/scanpy_r.yaml` file.
Whenver possible, use pre-compiled binaries from conda to avoid long compilation times and only install packages from CRAN if they are not available on conda, AFTER all conda packages have been installed.

### Updating environments

Whenever you add new dependencies to your existing environments, it is good practice to update the environment files in the `envs` folder first and then update the environments.

```
conda env update -f envs/scanpy.yaml
```

That way, you can keep track of the changes in the environment files and make sure that your environments are always up-to-date.

### Adding new environments

Some tools can cause dependency conflicts with the existing environments.
If you need to install a new tool that is not compatible with the existing environments, you can create a new environment from scratch.
Just copy one of the existing environment files and update it to your new dependencies.


## Get started with Jupyter Lab

We have also provided a `jupyterlab` environment that you can use to run Jupyter Lab with the `scanpy` and `scanpy_r` environments.
If you have

```
mamba env create -f envs/jupyterlab.yaml
conda activate jupyterlab
jupyter lab
```

As long as environments have `ipykernel` and/or `r-irkernel` installed, you can access the environments from the jupyter lab interface.

You should be able to see the environment kernels in the Jupyter Lab interface.
If not, read on to see how to add them manually.

## Adding kernels to Jupyter Lab

In order for jupyter lab to recognize the environments, you need to install ensure that the `ipykernel` package is installed in the environment you want to use.

```
conda activate [name of environment]
conda install ipykernel  # if not already installed
```

Furthermore, you may need to install the kernel manually into the environment of choice.

```
# make sure the correct environment is activated!
ipython kernel install --user --name=[name of kernel to show in jupyter lab]
```