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

To use the cluster, SSH into a login node (e.g. `ghpcc06.umassrc.org`):
```
> ssh user@ghpcc06.umassrc.org
```

You can run R on the login node by loading the `R/4.0.0_gcc` module:
```
> module load R/4.0.0_gcc
> R
```

The login node is meant only for orchestrating compute jobs, so it has limited memory and computational resources available to it. If you need to do something interactively on a compute node, you can request one like this:
```
> bsub -q condo_grid -W 8:00 -R rusage[mem=4096] -Is /bin/bash
```
which will request a single core with 4GB of memory on the `condo_grid` queue for up to 8:00 hours.

To run your pipeline on the cluster, you need to first set up your R computing environment by installing any packages you need. The next section goes over how to do this.

## Installing R packages
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

## Tips
Below are some tips related to issues you may run into working on the cluster. These issues have been accounted for if you use this template and run the pipeline using `tar_make_clustermq`, but you may run into them if you start running R scripts in other ways.

### Rmarkdown
Building RMarkdown documents on the cluster has some gotchas you may need to be aware of.

First, you will need to use `Cairo` instead of `png` as a graphics device for generating figures. In your `Rmd` file, modify your setup R chunk to use the `CairoPNG` device, and set it as the default for all chunks:
````
```{r setup, include = FALSE, dev="CairoPNG"}
library(targets)
knitr::opts_chunk$set(echo = TRUE, dev="CairoPNG")
options(tidyverse.quiet = TRUE)
```
````

If you are using a node via an interactive shell, you will also need to load the `cairo` and `pandoc` modules:
```
> module load cairo/1.12.16
> R module load pandoc/2.7.2
```

If you are running the pipeline via `tar_make_clustermq`, then this is taken care of for you via the clustermq template file `clustermq.lsf`.
