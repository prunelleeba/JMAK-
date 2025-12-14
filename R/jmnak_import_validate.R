#' The jmnak_import_validate function retrieves the values of the crystallization time t and the proportion Y(t) formed, which have been observed experimentally by experts.
#' then normalizes this data to make it compliant with the format  and returns it as a dataframe.
#'
#' @param t numeric vector times (>0) which corresponds to the time observed by experts during their experiments
#' @param Y numeric vector fractions (0..1) or percents (0..100) which corresponds to the proportion of crystals observed for the times observed
#' @return data.frame with columns t and Y (clamped)
#' @param clamp_low numeric lower clamp for Y (default 1e-6)
#' @param clamp_high numeric upper clamp for Y (default 1 - 1e-6)
#' @examples
#'  # Basic example with fractions (0..1)
#' t1 <- c(1, 2, 5, 10)
#' Y1 <- c(0.02, 0.10, 0.35, 0.80)
#' jmnak_import_validate(t1, Y1)
#'
#' # Example with percentages (0..100) -- function converts to fractions
#' t2 <- c(1, 2, 5, 10)
#' Y2 <- c(2, 10, 35, 80)  # percents
#' jmnak_import_validate(t2, Y2)
#'
#' # Example showing clamping: values <0 become clamp_low, >1 become clamp_high
#' t3 <- c(1, 2, 3)
#' Y3 <- c(-0.1, 0.5, 1.5)   # out-of-range values
#' jmnak_import_validate(t3, Y3)
#'
#' # If you have jmnak_fit_auto available, you can chain them (guarded example)
#' if (exists("jmnak_fit_auto", mode = "function")) {
#'   res <- jmnak_import_validate(c(1,2,3,4,6), c(5,20,45,70,90))
#'   jmnak_fit_auto(res$t, res$Y, plot = FALSE)
#' }
#' @export
jmnak_import_validate <- function(t, Y, clamp_low = 1e-6, clamp_high = 1-1e-6) {
  if (missing(t) || missing(Y)) stop("t and Y required")
  if (!is.numeric(t) || !is.numeric(Y)) stop("t and Y must be numeric")
  if (length(t) != length(Y)) stop("t and Y must have the same length")
  if (any(is.na(t)) || any(is.na(Y))) stop("t and/or Y contains NA")
  if (any(t <= 0)) stop("t must be > 0")
  # convert percent to fraction if necessary
  if (max(Y, na.rm = TRUE) > 1) Y <- Y / 100
  Y <- pmin(pmax(Y, clamp_low), clamp_high)
  data.frame(t = as.numeric(t), Y = as.numeric(Y))
}

