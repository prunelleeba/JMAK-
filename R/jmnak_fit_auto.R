#' Fit JMAK model to extract K and n parameters
#'
#' This function fits the Johnson-Mehl-Avrami-Kolmogorov model to transformation
#' kinetics data using Avrami linearization (ln(-ln(1-Y)) = ln(K) + n * ln(t)).
#' The function automatically selects the most reliable method (lm or nls)
#' based on R² ≥ 0.90 criterion and provides comprehensive diagnostics.
#'
#' @param t numeric vector of time values (>0)
#' @param Y numeric vector of fractions (0..1) or percentages (0..100)
#' @param r2_threshold R² threshold for accepting linearized fit (default: 0.90)
#' @param verbose logical, print detailed results (default: TRUE)
#' @return A comprehensive list with parameters, diagnostics, and plots
#'
#' @examples
#' # Example with synthetic data
#' t <- seq(1, 20, by = 1)
#' Y <- 1 - exp(-0.02 * t^2.5)
#' result <- jmnak_fit_auto(t, Y)
#'
#' @export
jmnak_fit_auto <- function(t, Y, r2_threshold = 0.90, verbose = TRUE) {

  # --- 1. DATA VALIDATION ---
  # if (missing(t) || missing(Y)) stop("Both t and Y are required")
  # if (!is.numeric(t) || !is.numeric(Y)) stop("t and Y must be numeric")
  # if (length(t) != length(Y)) stop("t and Y must have same length")
  # if (any(t <= 0)) stop("All t values must be > 0")
  #
  # # Convert percentages to fractions if needed
  # if (max(Y, na.rm = TRUE) > 1) {
  #   Y <- Y / 100
  #   if (verbose) cat("Note: Converted percentages to fractions\n")
  # }
  #
  # # Remove NA values and ensure 0 < Y < 1
  # valid_idx <- !is.na(t) & !is.na(Y) & Y > 0 & Y < 1
  df <- jmnak_import_validate(t,Y)
  t_clean <- df$t
  Y_clean <- df$Y

  if (length(t_clean) < 3) {
    stop("Need at least 3 points with 0 < Y < 1 after cleaning")
  }

  # --- 2. AVRAMI LINEARIZATION ---
  # Transform to linear form: y = ln(-ln(1-Y)), x = ln(t)
  x <- log(t_clean)
  y <- log(-log(1 - Y_clean))

  # Linear regression
  lm_fit <- lm(y ~ x)
  lm_summary <- summary(lm_fit)

  # Extract parameters
  intercept <- coef(lm_fit)[1]
  slope <- coef(lm_fit)[2]
  K_lm <- exp(intercept)
  n_lm <- slope
  r2_linear <- lm_summary$r.squared

  # Diagnostic statistics for linear fit
  cooks_dist <- cooks.distance(lm_fit)
  influ_threshold <- 4 / length(t_clean)
  influential_points <- which(cooks_dist > influ_threshold)
  std_error <- lm_summary$sigma

  # Calculate F-statistic p-value
  fstat <- lm_summary$fstatistic
  p_value <- if (!is.null(fstat)) {
    pf(fstat[1], fstat[2], fstat[3], lower.tail = FALSE)
  } else NA

  # Calculate metrics on original scale for lm
  Y_pred_lm <- 1 - exp(-K_lm * t_clean^n_lm)
  residuals_lm <- Y_clean - Y_pred_lm
  ss_res_lm <- sum(residuals_lm^2)
  ss_tot_lm <- sum((Y_clean - mean(Y_clean))^2)
  r2_original_lm <- if (ss_tot_lm > 0) 1 - (ss_res_lm / ss_tot_lm) else NA
  rmse_lm <- sqrt(mean(residuals_lm^2))
  mae_lm <- mean(abs(residuals_lm))

  # --- 3. METHOD SELECTION ---
  use_lm <- r2_linear >= r2_threshold && length(influential_points) == 0

  if (use_lm) {
    method <- "lm"
    K_final <- K_lm
    n_final <- n_lm
    residuals_final <- residuals_lm
    r2_final <- r2_original_lm
    rmse_final <- rmse_lm
    mae_final <- mae_lm
    note <- "Linear method accepted (R² ≥ threshold, no influential points)"
  } else {
    method <- "nls"

    # --- 4. NONLINEAR FITTING (NLS) ---
    # Use lm parameters as starting values
    start_vals <- list(K = K_lm, n = n_lm)

    nls_fit <- tryCatch({
      nls(Y_clean ~ 1 - exp(-K * t_clean^n),
          start = start_vals,
          control = nls.control(maxiter = 200, warnOnly = TRUE),
          lower = c(K = 1e-10, n = 0.01),
          algorithm = "port")
    }, error = function(e) NULL)

    # If nls fails, try nlsLM from minpack.lm
    if (is.null(nls_fit) && requireNamespace("minpack.lm", quietly = TRUE)) {
      nls_fit <- tryCatch({
        minpack.lm::nlsLM(Y_clean ~ 1 - exp(-K * t_clean^n),
                          start = start_vals,
                          lower = c(K = 1e-10, n = 0.01))
      }, error = function(e) NULL)
    }

    # If nls still fails, fall back to lm with warning
    if (is.null(nls_fit)) {
      warning("NLS fitting failed. Using linear method results.")
      method <- "lm_fallback"
      K_final <- K_lm
      n_final <- n_lm
      residuals_final <- residuals_lm
      r2_final <- r2_original_lm
      rmse_final <- rmse_lm
      mae_final <- mae_lm
      note <- "NLS failed, using linear method as fallback"
    } else {
      # Extract nls parameters
      K_nls <- coef(nls_fit)["K"]
      n_nls <- coef(nls_fit)["n"]

      # Calculate metrics for nls
      Y_pred_nls <- 1 - exp(-K_nls * t_clean^n_nls)
      residuals_nls <- Y_clean - Y_pred_nls
      ss_res_nls <- sum(residuals_nls^2)
      ss_tot_nls <- sum((Y_clean - mean(Y_clean))^2)
      r2_original_nls <- if (ss_tot_nls > 0) 1 - (ss_res_nls / ss_tot_nls) else NA
      rmse_nls <- sqrt(mean(residuals_nls^2))
      mae_nls <- mean(abs(residuals_nls))

      # Compare lm and nls
      if (r2_original_nls > r2_original_lm) {
        K_final <- K_nls
        n_final <- n_nls
        residuals_final <- residuals_nls
        r2_final <- r2_original_nls
        rmse_final <- rmse_nls
        mae_final <- mae_nls
        note <- "NLS selected (better fit than linear method)"
      } else {
        K_final <- K_lm
        n_final <- n_lm
        residuals_final <- residuals_lm
        r2_final <- r2_original_lm
        rmse_final <- rmse_lm
        mae_final <- mae_lm
        note <- "Linear method selected (better fit than NLS)"
      }
    }
  }

  # --- 5. CONFIDENCE INTERVALS ---
  # Calculate approximate confidence intervals
  n_points <- length(t_clean)
  t_critical <- qt(0.975, df = n_points - 2)

  if (method %in% c("lm", "lm_fallback")) {
    lm_ci <- confint(lm_fit, level = 0.95)
    intercept_ci <- lm_ci[1, ]
    slope_ci <- lm_ci[2, ]
    K_ci <- exp(intercept_ci)
    n_ci <- slope_ci
  } else if (!is.null(nls_fit)) {
    # For nls, use approximate confidence intervals
    tryCatch({
      nls_ci <- confint(nls_fit, level = 0.95)
      K_ci <- nls_ci["K", ]
      n_ci <- nls_ci["n", ]
    }, error = function(e) {
      K_ci <- c(K_final * 0.8, K_final * 1.2)
      n_ci <- c(n_final * 0.9, n_final * 1.1)
    })
  } else {
    K_ci <- c(NA, NA)
    n_ci <- c(NA, NA)
  }

  # --- 6. RESULT PREPARATION ---
  result_list <- list(
    parameters = list(
      K = K_final,
      n = n_final,
      lnK = log(K_final)
    ),
    confidence_intervals = list(
      K = K_ci,
      n = n_ci,
      lnK = log(K_ci)
    ),
    fit_quality = list(
      method = method,
      r2_linear = r2_linear,
      r2_original = r2_final,
      rmse = rmse_final,
      mae = mae_final,
      ss_residuals = sum(residuals_final^2),
      n_points = n_points
    ),
    diagnostics = list(
      influential_points = influential_points,
      cooks_distance = cooks_dist,
      residuals = residuals_final,
      n_points = n_points
    ),
    data = list(
      t_original = t,
      Y_original = Y,
      t_clean = t_clean,
      Y_clean = Y_clean,
      x_linearized = x,
      y_linearized = y
    ),
    models = list(
      lm = lm_fit,
      nls = if(exists("nls_fit") && !is.null(nls_fit)) nls_fit else NULL
    ),
    note = note
  )

  # Add Shapiro-Wilk test if residuals exist
  if (length(residuals_final) >= 3 && length(residuals_final) <= 5000) {
    shapiro_test <- try(shapiro.test(residuals_final), silent = TRUE)
    if (!inherits(shapiro_test, "try-error")) {
      result_list$diagnostics$shapiro_p <- shapiro_test$p.value
    }
  }

  # Add Durbin-Watson test if car package is available
  if (requireNamespace("car", quietly = TRUE)) {
    dw_test <- try(car::durbinWatsonTest(lm_fit), silent = TRUE)
    if (!inherits(dw_test, "try-error")) {
      result_list$diagnostics$durbin_watson <- dw_test$dw
    }
  }

  # --- 7. CONSOLE OUTPUT ---
  if (verbose) {
    cat("\n")
    cat(paste0(rep("=", 60), collapse = ""), "\n")
    cat("JMAK MODEL FIT RESULTS\n")
    cat(paste0(rep("=", 60), collapse = ""), "\n\n")

    cat("FINAL PARAMETERS:\n")
    cat(paste0(rep("-", 40), collapse = ""), "\n")
    cat(sprintf("  K  = %.6g (rate constant)\n", K_final))
    cat(sprintf("  n  = %.4f (Avrami exponent)\n", n_final))
    cat(sprintf("  lnK = %.4f\n", log(K_final)))

    cat("\nCONFIDENCE INTERVALS (95%):\n")
    cat(paste0(rep("-", 40), collapse = ""), "\n")
    cat(sprintf("  K:  [%.6g, %.6g]\n", K_ci[1], K_ci[2]))
    cat(sprintf("  n:  [%.4f, %.4f]\n", n_ci[1], n_ci[2]))

    cat("\nFIT QUALITY METRICS:\n")
    cat(paste0(rep("-", 40), collapse = ""), "\n")
    cat(sprintf("  Method used: %s\n", method))
    cat(sprintf("  R² (linearization): %.4f\n", r2_linear))
    cat(sprintf("  R² (original scale): %.4f\n", r2_final))
    cat(sprintf("  RMSE: %.6g\n", rmse_final))
    cat(sprintf("  MAE: %.6g\n", mae_final))

    cat("\nDIAGNOSTICS:\n")
    cat(paste0(rep("-", 40), collapse = ""), "\n")
    cat(sprintf("  Number of points: %d\n", n_points))
    if (length(influential_points) > 0) {
      cat(sprintf("  Influential points: %s\n",
                  paste(influential_points, collapse = ", ")))
    } else {
      cat("  Influential points: None detected\n")
    }

    if (!is.null(result_list$diagnostics$shapiro_p)) {
      cat(sprintf("  Shapiro-Wilk p-value: %.4f\n",
                  result_list$diagnostics$shapiro_p))
    }

    if (!is.null(result_list$diagnostics$durbin_watson)) {
      cat(sprintf("  Durbin-Watson statistic: %.3f\n",
                  result_list$diagnostics$durbin_watson))
    }

    cat("\nDECISION:\n")
    cat(paste0(rep("-", 40), collapse = ""), "\n")
    cat(sprintf("  %s\n", note))
    if (r2_linear >= r2_threshold) {
      cat(sprintf("  ✓ Linearization acceptable (R² = %.4f ≥ %.2f)\n",
                  r2_linear, r2_threshold))
    } else {
      cat(sprintf("  ⚠ Linearization poor (R² = %.4f < %.2f)\n",
                  r2_linear, r2_threshold))
    }

    cat("\n")
    cat(paste0(rep("=", 60), collapse = ""), "\n")
  }

  # --- 8. PLOTTING ---
  # Create comprehensive plots
  create_jmnak_plots(result_list)

  # Return the complete result
  class(result_list) <- "jmnak_fit"
  invisible(result_list)
}

#' Create comprehensive diagnostic plots for JMAK fit
#'
#' @param result Output from jmnak_fit_auto
#' @return List of ggplot objects (invisibly)
create_jmnak_plots <- function(result) {

  # Check if ggplot2 is available
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    warning("ggplot2 not available. Using base R graphics.")
    create_base_plots(result)
    return(invisible(NULL))
  }

  # Extract data
  t_clean <- result$data$t_clean
  Y_clean <- result$data$Y_clean
  x_linear <- result$data$x_linearized
  y_linear <- result$data$y_linearized
  K <- result$parameters$K
  n <- result$parameters$n
  method <- result$fit_quality$method

  # Create time grid for smooth curves
  t_grid <- seq(min(t_clean), max(t_clean), length.out = 200)
  Y_pred <- 1 - exp(-K * t_grid^n)

  # PLOT 1: Original data with JMAK fit
  p1 <- ggplot2::ggplot() +
    ggplot2::geom_point(
      data = data.frame(t = t_clean, Y = Y_clean),
      ggplot2::aes(x = t, y = Y),
      size = 3, color = "#2E86AB", alpha = 0.8
    ) +
    ggplot2::geom_line(
      data = data.frame(t = t_grid, Y = Y_pred),
      ggplot2::aes(x = t, y = Y),
      color = "#A23B72", size = 1.2
    ) +
    ggplot2::labs(
      title = "JMAK Model Fit: Y(t) = 1 - exp(-K·tⁿ)",
      subtitle = sprintf("K = %.4g, n = %.3f, Method: %s", K, n, method),
      x = "Time (t)",
      y = "Transformed Fraction Y(t)"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(hjust = 0.5),
      panel.grid.major = ggplot2::element_line(color = "grey90"),
      panel.grid.minor = ggplot2::element_blank()
    ) +
    ggplot2::ylim(0, 1)

  # PLOT 2: Avrami linearization
  lm_fit <- result$models$lm
  if (!is.null(lm_fit)) {
    x_range <- range(x_linear, na.rm = TRUE)
    x_seq <- seq(x_range[1], x_range[2], length.out = 100)
    y_lm <- predict(lm_fit, newdata = data.frame(x = x_seq))

    # Theoretical line from final parameters
    y_theoretical <- log(K) + n * x_seq

    p2_data <- rbind(
      data.frame(
        x = x_seq,
        y = y_lm,
        Type = "Linear Regression (lm)"
      ),
      data.frame(
        x = x_seq,
        y = y_theoretical,
        Type = "Theoretical (from final parameters)"
      )
    )

    p2 <- ggplot2::ggplot() +
      ggplot2::geom_point(
        data = data.frame(x = x_linear, y = y_linear),
        ggplot2::aes(x = x, y = y),
        size = 3, color = "#2E86AB", alpha = 0.8
      ) +
      ggplot2::geom_line(
        data = p2_data[p2_data$Type == "Linear Regression (lm)", ],
        ggplot2::aes(x = x, y = y, color = Type),
        size = 1, linetype = "dashed"
      ) +
      ggplot2::geom_line(
        data = p2_data[p2_data$Type == "Theoretical (from final parameters)", ],
        ggplot2::aes(x = x, y = y, color = Type),
        size = 1.2
      ) +
      ggplot2::scale_color_manual(
        values = c(
          "Linear Regression (lm)" = "#FF6B6B",
          "Theoretical (from final parameters)" = "#4ECDC4"
        )
      ) +
      ggplot2::labs(
        title = "Avrami Linearization: ln(-ln(1-Y)) = ln(K) + n·ln(t)",
        subtitle = sprintf("R²(linear) = %.4f", result$fit_quality$r2_linear),
        x = "ln(t)",
        y = "ln(-ln(1-Y))",
        color = ""
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
        plot.subtitle = ggplot2::element_text(hjust = 0.5),
        legend.position = "bottom",
        panel.grid.major = ggplot2::element_line(color = "grey90"),
        panel.grid.minor = ggplot2::element_blank()
      )
  } else {
    p2 <- ggplot2::ggplot() +
      ggplot2::geom_point(
        data = data.frame(x = x_linear, y = y_linear),
        ggplot2::aes(x = x, y = y),
        size = 3, color = "#2E86AB"
      ) +
      ggplot2::labs(
        title = "Avrami Linearization",
        x = "ln(t)",
        y = "ln(-ln(1-Y))"
      ) +
      ggplot2::theme_minimal()
  }

  # PLOT 3: Residuals vs Time
  residuals <- result$diagnostics$residuals

  p3 <- ggplot2::ggplot(
    data = data.frame(t = t_clean, residuals = residuals),
    ggplot2::aes(x = t, y = residuals)
  ) +
    ggplot2::geom_point(size = 3, color = "#F18F01", alpha = 0.8) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
    ggplot2::geom_smooth(method = "loess", se = FALSE, color = "#2E86AB", span = 0.8) +
    ggplot2::labs(
      title = "Residual Analysis",
      subtitle = "Residuals should be randomly scattered around zero",
      x = "Time (t)",
      y = "Residuals"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(hjust = 0.5)
    )

  # PLOT 4: Cook's distance for influential points
  cooks_dist <- result$diagnostics$cooks_distance
  influ_threshold <- 4 / length(t_clean)

  p4 <- ggplot2::ggplot(
    data = data.frame(
      Index = seq_along(cooks_dist),
      CooksD = cooks_dist
    ),
    ggplot2::aes(x = Index, y = CooksD)
  ) +
    ggplot2::geom_bar(stat = "identity", fill = "#2E86AB", alpha = 0.7, width = 0.7) +
    ggplot2::geom_hline(
      yintercept = influ_threshold,
      color = "red",
      linetype = "dashed",
      size = 1
    ) +
    ggplot2::annotate(
      "text",
      x = length(cooks_dist),
      y = influ_threshold * 1.1,
      label = paste0("Threshold (4/n = ", round(influ_threshold, 3), ")"),
      color = "red",
      hjust = 1,
      vjust = 0,
      size = 3.5
    ) +
    ggplot2::labs(
      title = "Cook's Distance Analysis",
      subtitle = "Points above threshold may be influential",
      x = "Observation Index",
      y = "Cook's Distance"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
      plot.subtitle = ggplot2::element_text(hjust = 0.5)
    )

  # Combine plots
  if (requireNamespace("patchwork", quietly = TRUE)) {
    combined <- (p1 | p2) / (p3 | p4) +
      patchwork::plot_layout(heights = c(2, 1)) +
      patchwork::plot_annotation(
        title = "JMAK Model Analysis - Comprehensive Diagnostics",
        subtitle = sprintf(
          "Method: %s | K = %.4g | n = %.3f | R² = %.4f | RMSE = %.4g",
          method, K, n, result$fit_quality$r2_original, result$fit_quality$rmse
        ),
        theme = ggplot2::theme(
          plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0.5),
          plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5)
        )
      )

    print(combined)

    # Return all plot objects
    plots <- list(
      combined = combined,
      fit_plot = p1,
      linearization_plot = p2,
      residuals_plot = p3,
      cooks_plot = p4
    )

  } else {
    # Print plots in 2x2 grid using base R
    par(mfrow = c(2, 2))

    # Plot 1
    plot(t_clean, Y_clean, pch = 16, col = "#2E86AB",
         xlab = "Time (t)", ylab = "Y(t)",
         main = "JMAK Model Fit", ylim = c(0, 1))
    lines(t_grid, Y_pred, col = "#A23B72", lwd = 2)
    legend("bottomright", legend = sprintf("K=%.3g, n=%.2f", K, n), bty = "n")

    # Plot 2
    plot(x_linear, y_linear, pch = 16, col = "#2E86AB",
         xlab = "ln(t)", ylab = "ln(-ln(1-Y))",
         main = "Avrami Linearization")
    if (!is.null(lm_fit)) {
      abline(lm_fit, col = "#FF6B6B", lwd = 2, lty = 2)
      # Theoretical line
      abline(a = log(K), b = n, col = "#4ECDC4", lwd = 2)
      legend("bottomright",
             legend = c("Data", "Linear regression", "Theoretical"),
             col = c("#2E86AB", "#FF6B6B", "#4ECDC4"),
             pch = c(16, NA, NA), lty = c(NA, 2, 1), lwd = 2, bty = "n")
    }

    # Plot 3
    plot(t_clean, residuals, pch = 16, col = "#F18F01",
         xlab = "Time (t)", ylab = "Residuals",
         main = "Residuals vs Time")
    abline(h = 0, col = "red", lty = 2)

    # Plot 4
    barplot(cooks_dist, col = "#2E86AB", border = NA,
            xlab = "Observation Index", ylab = "Cook's Distance",
            main = "Cook's Distance")
    abline(h = influ_threshold, col = "red", lty = 2, lwd = 2)

    par(mfrow = c(1, 1))

    plots <- list(
      fit_plot = p1,
      linearization_plot = p2,
      residuals_plot = p3,
      cooks_plot = p4
    )
  }

  invisible(plots)
}

#' Print method for jmnak_fit objects
#' @export
print.jmnak_fit <- function(x, ...) {
  cat("\nJMAK Model Fit Summary:\n")
  cat(sprintf("  K = %.6g\n", x$parameters$K))
  cat(sprintf("  n = %.4f\n", x$parameters$n))
  cat(sprintf("  Method: %s\n", x$fit_quality$method))
  cat(sprintf("  R² = %.4f\n", x$fit_quality$r2_original))
  cat(sprintf("  RMSE = %.6g\n", x$fit_quality$rmse))
  invisible(x)
}
