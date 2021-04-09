library(targets)
library(tarchetypes)
library(here)

source("R/functions.R")

tar_option_set(
  packages = c("gapminder", "ggplot2", "rstanarm"),
  resources = list(memory = "4G", walltime = "1:00", cores = 4)
)

#
# Parallelization setup for running on multiple cores of one computer
# run tar_make_future(workers = 2)
#
library(future)
plan(multisession)

#
# Parallelization setup for UMass cluster
# from login node, run tar_make_clustermq(workers = 2)
#
# library(clustermq)
# options(
#   clustermq.scheduler = "lsf", 
#   clustermq.template = here("clustermq.lsf")
# )

#
# Pipeline
#

list(
  # Dataset
  tar_target(
    analysis_dataset,
    clean_data()
  ),
  
  # EDA
  tar_target(
    life_exp_plot,
    eda_plot(analysis_dataset)
  ),
   
  # Modeling
  tar_target(
    fit1,
    fit_model1(analysis_dataset)
  ),
  
  tar_target(
    fit2,
    fit_model2(analysis_dataset)
  ),
   
  # Model interpretation
  tar_target(
    posterior_plot1,
    posterior_plot(fit1)
  ),
  
  tar_target(
    posterior_plot2,
    posterior_plot(fit2)
  ),
   
  tar_render(report, "report.Rmd")
)
