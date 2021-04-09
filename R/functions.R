clean_data <- function() {
  gapminder::gapminder
}

eda_plot <- function(data) {
  ggplot(data, aes(x = year, y = lifeExp, group = country)) +
    geom_line() +
    facet_wrap(~continent)
}

fit_model1 <- function(data) {
  options(mc.cores = 4)
  stan_lmer(lifeExp ~ year + log10(gdpPercap) + log10(pop) + (1 | continent), data = data)
}

fit_model2 <- function(data) {
  options(mc.cores = 4)
  stan_lmer(lifeExp ~ year + scale(gdpPercap) + scale(pop) + (1 | continent), data = data)
}

posterior_plot <- function(fit) {
  bayesplot::mcmc_dens(fit, regex_pars = c("year", "gdpPercap", "pop"))
}
