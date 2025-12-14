#' Predict Y(t) from K and n, and compute t* for target Ys
#'
#' @param t numeric vector (times) at which to compute predictions (optional if only tstar requested)
#' @param K numeric fitted K, kinetic constant determined by the jmnak_fit_auto function
#' @param n numeric fitted n, Avrami exponent
#' @param Ystar numeric vector of target fractions in (0,1) for which to return t*
#' @return list with elements: t (grid), Y_pred (if t provided), tstar (named vector for Ystar)
#'
#' @examples
#' # 1) Basic prediction on a time grid
#' pr <- jmnak_predict(t = seq(0.1, 10, by = 0.1), K = 0.02, n = 3, Ystar = c(0.5, 0.9))
#' head(pr$Y_pred)        # first predicted values
#' pr$tstar               # times corresponding to Y = 0.5 and 0.9
#'
#' # 2) Compute only t* (no t grid) for several targets
#' pr2 <- jmnak_predict(K = 0.015, n = 2.5, Ystar = c(0.5, 0.8, 0.9))
#' print(pr2$tstar)
#'
#' # 3) Typical workflow: fit -> predict -> plot
#' # (requires jmnak_fit_auto available in the workspace)
#' if (exists("jmnak_fit_auto", mode = "function")) {
#'   t_obs <- c(1, 2, 3, 5, 8, 13)
#'   Y_obs <- c(0.02, 0.10, 0.35, 0.58, 0.80, 0.95)
#'   fit <- jmnak_fit_auto(t_obs, Y_obs, plot = FALSE)   # fit without plotting
#'   pred <- jmnak_predict(t = seq(min(t_obs), max(t_obs), length.out = 200),
#'                         K = fit$K, n = fit$n, Ystar = c(0.5, 0.9))
#'   # quick comparison plot
#'   plot(t_obs, Y_obs, pch = 16, xlab = "t", ylab = "Y", main = "Data vs JMAK model")
#'   lines(pred$t, pred$Y_pred, lwd = 2)
#'   abline(h = as.numeric(pred$tstar), lty = 3, col = "gray")
#' }
#' pr <- jmnak_predict(t = seq(0.1,10,0.1), K = 0.02, n = 3, Ystar = c(0.5,0.9))
#'
#' @export
jmnak_predict <- function(t = NULL, K, n, Ystar = c(0.5, 0.9)) {
  if (missing(K) || missing(n)) stop("K and n required")
  if (!is.numeric(K) || !is.numeric(n)) stop("K and n must be numeric")
  if (!is.null(t)) {
    if (any(t <= 0)) stop("t must be > 0")
    Y_pred <- 1 - exp(-K * (t ^ n))
  } else {
    Y_pred <- NULL
  }
  # compute t* for each Ystar
  valid_Ystar <- Ystar[Ystar > 0 & Ystar < 1]
  tstar <- setNames(sapply(valid_Ystar, function(Yt) {
    ((-log(1 - Yt))/K)^(1 / n)
  }), paste0("t_for_Y=", valid_Ystar))
  list(t = t, Y_pred = Y_pred, tstar = tstar)
}


