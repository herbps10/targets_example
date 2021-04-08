library(targets)
library(tarchetypes)

source("R/functions.R")

tar_option_set(packages = c("gapminder", "tidyverse", "rstanarm", "bayesplot"))

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
    fit_model(analysis_dataset)
  ),
  
  tar_target(
    posterior_plot,
    create_posterior_plot(fit)
  ),
  
  tar_render(report, "report.Rmd")
)