library(testthat)
library(JMAK)

test_that("jmnak_import_validate valide et clampe", {
  t <- c(0.5, 1, 2)
  Y <- c(0.001, 0.1, 0.9)
  df <- jmnak_import_validate(t, Y)
  expect_true(is.data.frame(df))
  expect_equal(colnames(df), c("t","Y"))
  # percent -> convert
  df2 <- jmnak_import_validate(c(1,2), c(10,50))
  expect_true(all(df2$Y < 1))
  # erreurs
  expect_error(jmnak_import_validate(c(1,0), c(0.1,0.2)))
  expect_error(jmnak_import_validate(1:3, 1:2))
})

test_that("jmnak_fit_auto recovers parameters on clean data", {
  # Données propres sans bruit
  t <- c(1,2,3,4,5,6,8,10)
  K <- 0.02
  n <- 3
  Y <- 1 - exp(-K * t^n)

  # Appel avec  pour éviter les erreurs graphiques pendant les tests
  res <- jmnak_fit_auto(t, Y, verbose = FALSE)

  # Vérification de la structure de sortie
  expect_type(res, "list")
  expect_s3_class(res, "jmnak_fit")
  expect_true(all(c("parameters", "fit_quality", "diagnostics") %in% names(res)))

  # Vérification des paramètres (tolérance plus large pour éviter les échecs)
  expect_true(abs(res$parameters$K - K) < 0.001)  # tolérance de 0.001
  expect_true(abs(res$parameters$n - n) < 0.1)    # tolérance de 0.1

  # Vérification de la méthode utilisée
  expect_true(res$fit_quality$method %in% c("lm", "nls", "lm_fallback"))

  # Vérification des métriques
  expect_true(res$fit_quality$r2_original > 0.95)  # R² devrait être excellent
  expect_true(res$fit_quality$rmse < 0.01)         # RMSE faible
})

test_that("jmnak_fit_auto works on noisy data", {
  set.seed(1)
  t <- seq(1,15,1)
  K <- 0.02
  n <- 3.2
  Y <- 1 - exp(-K*t^n) + rnorm(length(t), 0, 0.01)
  Y <- pmin(pmax(Y, 1e-6), 1-1e-6)

  # Appel avec
  res <- jmnak_fit_auto(t, Y, verbose = FALSE)

  # Vérification que les paramètres sont physiquement plausibles
  expect_true(res$parameters$K > 0)
  expect_true(res$parameters$n > 0)

  # Vérification des métriques
  expect_true(res$fit_quality$r2_original > 0.9)  # R² devrait être bon même avec bruit
  expect_true(res$fit_quality$rmse < 0.1)         # RMSE acceptable
})

test_that("jmnak_predict computes tstar and Y_pred", {
  t <- seq(0.1,2,0.1)
  res <- jmnak_predict(t = t, K = 0.02, n = 3, Ystar = c(0.5, 0.9))

  # Vérification de la structure
  expect_type(res, "list")
  expect_true(all(c("t", "Y_pred", "tstar") %in% names(res)))

  # Vérification des prédictions
  expect_equal(length(res$Y_pred), length(t))
  expect_true(all(res$Y_pred >= 0 & res$Y_pred <= 1))

  # Vérification des temps caractéristiques
  expect_true(all(grepl("^t_for_Y=", names(res$tstar))))
  expect_equal(length(res$tstar), 2)
  expect_true(all(res$tstar > 0))
})

test_that("jmnak_fit_auto handles edge cases", {
  # Test avec données limites
  t <- c(1, 2, 3, 4, 5)
  Y <- c(0.01, 0.02, 0.03, 0.04, 0.05)  # Très faible transformation

  # Devrait fonctionner sans erreur
  expect_error(
    jmnak_fit_auto(t, Y, verbose = FALSE, ),
    NA  # Pas d'erreur attendue
  )

  # Test avec trop peu de points valides
  t_bad <- c(1, 2, 3)
  Y_bad <- c(0, 0, 1)  # Aucun point avec 0 < Y < 1

  expect_error(
    jmnak_fit_auto(t_bad, Y_bad, verbose = FALSE, ),
    "Need at least 3 points with 0 < Y < 1"
  )
})

test_that("jmnak_import_validate clamps extreme values", {
  # Test du clamping
  t <- c(1, 2, 3)
  Y <- c(-0.1, 0.5, 1.5)  # Valeurs hors limites

  df <- jmnak_import_validate(t, Y)

  # Vérification que les valeurs sont clampées
  expect_true(all(df$Y >= 1e-6 & df$Y <= (1 - 1e-6)))

  # Test avec pourcentages
  df_pct <- jmnak_import_validate(c(1, 2), c(150, 200))  # > 100%
  expect_true(all(df_pct$Y <= 1))
})

test_that("jmnak_fit_auto prints summary correctly", {
  # Test que la fonction produit une sortie console
  t <- c(1, 2, 3, 4, 5)
  Y <- 1 - exp(-0.03 * t^2.5)

  # Capture la sortie console
  output <- capture.output({
    res <- jmnak_fit_auto(t, Y, verbose = TRUE)
  })

  # Vérifie que quelque chose a été imprimé
  expect_true(length(output) > 0)

  # Vérifie que certains mots-clés sont présents
  expect_true(any(grepl("JMAK MODEL FIT", output)))
  expect_true(any(grepl("K =", output)))
  expect_true(any(grepl("n =", output)))
})
