# targets_example

This is a template project for setting up analysis pipelines using `targets`. The project also includes configurations for running it on the UMass computing cluster.

In this README, code to be run in the shell are prefixed with `>`, and all other commands are to be run in `R`.

To run the pipeline, open an R session in the project root and run:
```
library(targets)
tar_make()
```

You can run the pipeline in parallel on a single computer (using multiple processors or cores) by running:
```
tar_make_future(workers = 2)
```
which will launch 2 worker processes. Each one of those processes can itself be multithreaded, so the total number of cores in use might be higher. In this template, the `fit1` and `fit2` targets will both use 4 cores each to fit the `rstanarm` models.

To check on progress, you can open a separate R session in the project root and run:
```
tar_progress()
```

Alternatively, to see a diagram of the pipeline:
```
tar_visnetwork(TRUE)
```

Finally, you can run a Shiny server that automatically updates to track progress:
```
tar_watch(targets_only = TRUE)
```

# Computing cluster
Below are instructions for getting a computing environment set up on the cluster and for how to run `targets` pipelines in parallel.

I recommend installing packages on a compute node interactively. Request an interactive session on a compute node by running:
```
> bsub -q condo_grid -W 8:00 -R rusage[mem=4096] -Is /bin/bash
```
When the session loads, load `R` and a `g++`:
```
> module load R/4.0.0_gcc
> module load g++/8.1.0
```

Then you can start an R session and install your packages as you normally would.
```
> R
```

## Installing R packages
Installing some R packages require additional steps.
### Installing `rstan`
First install a special version of the `V8` package:
```
Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1)
remotes::install_github("jeroen/V8")
```

Then install `rstan`:
```
install.packages("rstan")
```

### Installing `cmdstanr`
Make sure to load `binutils`:
```
> module load binutils/2.35
```
Then install `cmdstanr`:
```
install.packages("cmdstanr")
cmdstanr::install_cmdstan()
```

## Running
To run your pipeline on the cluster, open an R session in the project root on the login node and run:
```
library(targets)
tar_make_clustermq(workers = 2)
```
Change `workers=2` to be however many compute nodes you want to use.
