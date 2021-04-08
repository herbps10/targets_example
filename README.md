# targets_example

This is a template project for setting up analysis pipelines using `targets`. The project also includes configurations for running it on the UMass computing cluster.

To run the pipeline, open an R session in the project root and run:
```
library(targets)
tar_make()
```

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
Instructions for getting a computing environment set up on the cluster and how to run `targets` pipelines in parallel.

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
