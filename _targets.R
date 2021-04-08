library(targets)
library(tarchetypes)
library(here)
#library(future)
#library(future.batchtools)
library(clustermq)

source("R/functions.R")
tar_option_set(
  packages = c("gapminder", "ggplot2", "rstanarm"),
  resources = list(queue = "condo_uma_leontine_alkema", walltime = 60 * 60 * 60, memory = "4G")
)

options(
  clustermq.scheduler = "lsf", 
  clustermq.template = here("clustermq.lsf")
)

#options(future.batchtools.expiration.tail = 1000)
#options(future.wait.interval = 20)

#plan(batchtools_lsf, template = here("lsf.tmpl"))

list(
  tar_target(
    analysis_dataset,
    analysis_data()
  ),
  
  tar_target(
    life_exp_plot,
    create_plot(analysis_dataset)
  ),
   
  tar_target(
    fit,
    fit_model(analysis_dataset),
    resources = list(cores = 4)
  ),
   
  tar_target(
    posterior_plot,
    create_posterior_plot(fit)
  ),
   
  tar_render(report, "report.Rmd")
)
