analysis_data <- function() {
  gapminder::gapminder
}

create_plot <- function(data) {
  ggplot(data, aes(x = year, y = lifeExp, group = country)) +
    geom_line() +
    facet_wrap(~continent)
}

fit_model <- function(data) {
  stan_lmer(lifeExp ~ year + scale(gdpPercap) + (1 | continent), data = data)
}

create_posterior_plot <- function(fit) {
  bayesplot::mcmc_dens(fit, c("year", "scale(gdpPercap)"))
}
