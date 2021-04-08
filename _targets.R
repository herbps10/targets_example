library(targets)
library(tarchetypes)
library(here)
library(clustermq)

source("R/functions.R")

tar_option_set(
  packages = c("gapminder", "ggplot2", "rstanarm"),
  resources = list(memory = "4G", walltime = "1:00", cores = 4)
)

options(
  clustermq.scheduler = "lsf", 
  clustermq.template = here("clustermq.lsf")
)

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
