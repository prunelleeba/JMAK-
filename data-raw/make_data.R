# data-raw/make_data.R

set.seed(123)

t <- seq(0.5, 30, by = 0.5)
true_K <- 0.02
true_n <- 3.2

Y_true <- 1 - exp(-true_K * t^true_n)

Y_obs <- pmin(pmax(Y_true + rnorm(length(t), 0, 0.02), 0.001), 0.999)

polymere_cristallisation <- data.frame(
  t = t,
  Y = Y_obs
)

# Enregistrer la donnée dans data/
usethis::use_data(polymere_cristallisation, overwrite = TRUE)
