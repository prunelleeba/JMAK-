# 📊 JMAK - Johnson-Mehl-Avrami-Kolmogorov Kinetics Tools

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![R](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg)
![Version](https://img.shields.io/badge/Version-1.1-green.svg)

A modern and accessible R package to **model and analyze transformation kinetics** (crystallization, chemical reactions, polymerization, etc.) using the **JMAK/Avrami model**.

---

## 📋 Table of Contents

1. [📌 About](#about)
2. [🚀 Installation](#installation)
3. [⚡ Quick Start](#quick-start)
4. [📖 Complete Guide](#complete-guide)
5. [🔧 Main Functions](#main-functions)
6. [📊 Practical Examples](#practical-examples)
7. [❓ FAQ](#faq)
8. [📞 Support](#support)

---

## 📌 About

### What is the JMAK Model?

The **Johnson-Mehl-Avrami-Kolmogorov (JMAK/Avrami) model** describes how a transformation progresses over time. It is expressed by:

$$Y(t) = 1 - \exp(-K \cdot t^n)$$

Where:
- **Y(t)**: transformed fraction (0 to 1)
- **K**: kinetic constant (transformation rate)
- **n**: Avrami exponent (type of mechanism: nucleation/growth)
- **t**: time

### What is it used for?

✅ **Polymer Crystallization** - Predict crystallization rate  
✅ **Chemical Reactions** - Model reaction kinetics  
✅ **Phase Transformations** - Analyze crystalline transitions  
✅ **Industrial Processes** - Optimize transformation parameters  

### Package Features

| Feature | Description |
|---|---|
| 📥 **Import & Validation** | Automatic cleaning of experimental data |
| 🔧 **Automatic Fitting** | Intelligent selection between linear and nonlinear regression |
| 📊 **Complete Diagnostics** | 10+ quality metrics (R², RMSE, Cook's distance, etc.) |
| 🎨 **Visualizations** | 4 professional diagnostic plots with ggplot2 |
| ⏱️ **Predictions** | Calculate Y(t) and characteristic times (t₅₀, t₉₀, etc.) |
| ✓ **Statistical Tests** | Residual normality, autocorrelation, influential points |

---

## 🚀 Installation

Choose the method that best fits your situation:

### **Method 1: Local Installation (⭐ Recommended for beginners)**

This is the simplest method if you have the source code on your machine.

#### Step 1: Get the source code

**On Windows:**
```cmd
cd C:\Users\YourName\Documents
git clone https://github.com/prunelleeba/JMAK-.git
```

**On Ubuntu/Linux/macOS:**
```bash
cd ~/Documents
git clone https://github.com/prunelleeba/JMAK-.git
```

> ⚠️ **Important**: You must have `git` installed on your machine. If you don't have it:
> - **Windows**: Download from https://git-scm.com/download/win
> - **Ubuntu**: `sudo apt-get install git`
> - **macOS**: `brew install git`

#### Step 2: Open RStudio and install from the local folder

1. Open **RStudio**
2. Go to menu **Tools** → **Install Packages...**
3. In **Install from**, select: **Package Archive File (.tar.gz, .zip)**
4. Click **Browse** and navigate to the `JMAK` folder you just downloaded
5. Select the file `JMAK_1.1.tar.gz`
6. Click **Install**

Wait a few seconds, and you're done! ✅

**Alternative (without RStudio GUI)**:

In the R console:
```r
install.packages("C:/Users/YourName/Documents/JMAK/JMAK_1.1.tar.gz", 
                 repos = NULL, 
                 type = "source")
```

### **Method 2: Installation from source directory (Developers)**

**In the R console, from the project folder:**

```r
# First installation (only once)
install.packages(c("devtools", "ggplot2"))

# Load the package in development mode
devtools::load_all()

# OR install directly
devtools::install()
```

### **Method 3: Command line installation (Terminal/PowerShell)**

**Windows (PowerShell):**
```powershell
cd C:\Users\YourName\Documents\JMAK
R CMD INSTALL JMAK_1.1.tar.gz
```

**Linux/macOS:**
```bash
cd ~/Documents/JMAK
R CMD INSTALL JMAK_1.1.tar.gz
```

---

## ⚡ Quick Start

### Install dependencies (first time)

In the R console:
```r
# Install dependent packages
install.packages(c("ggplot2", "patchwork"))
```

### Basic usage in 5 minutes

```r
# 1. Load the package
library(JMAK)

# 2. Load example data
data(polymere_cristallisation)
head(polymere_cristallisation)

# 3. Fit the JMAK model
fit <- jmnak_fit_auto(
  t = polymere_cristallisation$t,
  Y = polymere_cristallisation$Y,
  verbose = TRUE
)

# 4. Get the parameters
K <- fit$parameters$K
n <- fit$parameters$n
cat("K =", K, ", n =", n, "\n")

# 5. Make predictions
predictions <- jmnak_predict(
  t = seq(0.5, 30, 0.5),
  K = K,
  n = n,
  Ystar = c(0.5, 0.9)
)

# Display characteristic times
print(predictions$tstar)
```

**Expected result:**
```
========================================================
JMAK MODEL FIT RESULTS
========================================================
FINAL PARAMETERS:
  K  = 0.02003 (rate constant)
  n  = 3.1948 (Avrami exponent)

FIT QUALITY METRICS:
  R² (original scale): 0.9856
  RMSE: 0.0189

========================================================
```

---

## 📖 Complete Guide

### Detailed step-by-step installation

#### **For beginners on Windows**

1. **Install Git** (if you don't have it)
   - Go to https://git-scm.com/download/win
   - Download the installer (green, on the right)
   - Double-click and accept the default settings
   - Restart your computer

2. **Download the package code**
   - Open **PowerShell** (Win + X, then select PowerShell)
   - Type:
   ```powershell
   cd C:\Users\YourName\Documents
   git clone https://github.com/prunelleeba/JMAK-.git
   cd JMAK
   dir  # Verify that you see the file JMAK_1.1.tar.gz
   ```

3. **Install the package in R**
   - Open **RStudio**
   - Copy-paste in the console:
   ```r
   install.packages("C:/Users/YourName/Documents/JMAK/JMAK_1.1.tar.gz", 
                    repos = NULL, 
                    type = "source")
   ```
   - Press **Enter** and wait
   - If no error, it's installed ✅

4. **Verify the installation**
   ```r
   library(JMAK)
   data(polymere_cristallisation)
   fit <- jmnak_fit_auto(polymere_cristallisation$t, 
                         polymere_cristallisation$Y, 
                         verbose = FALSE)
   print(fit)
   ```

#### **For beginners on Ubuntu/Linux**

1. **Install Git** (if you don't have it)
   ```bash
   sudo apt-get update
   sudo apt-get install git
   ```

2. **Download the package code**
   ```bash
   cd ~/Documents
   git clone https://github.com/prunelleeba/JMAK-.git
   cd JMAK
   ls  # Verify that you see the file JMAK_1.1.tar.gz
   ```

3. **Install the package in R**
   - Open **RStudio** or run `R` in the terminal
   ```r
   install.packages("~/Documents/JMAK/JMAK_1.1.tar.gz", 
                    repos = NULL, 
                    type = "source")
   ```

4. **Verify the installation**
   ```r
   library(JMAK)
   data(polymere_cristallisation)
   fit <- jmnak_fit_auto(polymere_cristallisation$t, 
                         polymere_cristallisation$Y, 
                         verbose = FALSE)
   print(fit)
   ```

---

## 🔧 Main Functions

### 1️⃣ `jmnak_import_validate()` - Prepare the data

**What does it do?**
Cleans, validates, and normalizes your experimental data.

**Syntax:**
```r
df <- jmnak_import_validate(t, Y, clamp_low = 1e-6, clamp_high = 1-1e-6)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `t` | numeric | Vector of times (must be > 0) |
| `Y` | numeric | Vector of transformed fractions |
| `clamp_low` | numeric | Minimum limit for Y (default 10⁻⁶) |
| `clamp_high` | numeric | Maximum limit for Y (default 1-10⁻⁶) |

**Return:**
Data.frame with columns `t` and `Y` cleaned

**Example:**
```r
# Data in percentages
t <- c(1, 2, 5, 10, 15)
Y <- c(2, 10, 35, 80, 95)  # Percentages

# Automatic cleaning
df <- jmnak_import_validate(t, Y)
print(df)
# t     Y
# 1 0.02
# 2 0.10
# ...
```

**What does this function do?**
- ✅ Converts percentages (0-100) to fractions (0-1)
- ✅ Rejects values ≤ 0 or ≥ 1 (non-physical)
- ✅ "Clamps" extreme values
- ✅ Returns a clean, ready-to-use data.frame

---

### 2️⃣ `jmnak_fit_auto()` - Fit the JMAK model

**What does it do?**
This is the **main function**. It automatically fits the JMAK model to your data and generates complete diagnostics.

**Syntax:**
```r
fit <- jmnak_fit_auto(t, Y, r2_threshold = 0.90, verbose = TRUE)
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `t` | numeric | Vector of times (>0) |
| `Y` | numeric | Vector of fractions (0..1 or 0..100) |
| `r2_threshold` | numeric | R² threshold for accepting linear regression (default: 0.90) |
| `verbose` | logical | Display detailed results? (default: TRUE) |

**Return:**
Object of class `jmnak_fit` containing:
- `$parameters`: K, n, lnK
- `$confidence_intervals`: 95% confidence intervals
- `$fit_quality`: R², RMSE, MAE, etc.
- `$diagnostics`: influential points, residuals, statistical tests
- `$models`: lm and nls models used

**Complete example:**
```r
# Experimental data
t <- c(0.5, 1, 2, 5, 10, 15, 20, 25)
Y <- c(0.01, 0.05, 0.15, 0.45, 0.75, 0.90, 0.96, 0.99)

# Fitting
fit <- jmnak_fit_auto(t, Y, verbose = TRUE)

# Get the parameters
K <- fit$parameters$K
n <- fit$parameters$n
R2 <- fit$fit_quality$r2_original

cat(sprintf("K = %.4g, n = %.3f, R² = %.4f\n", K, n, R2))

# Display summary
print(fit)
```

**How does it work behind the scenes?**

1. **Cleaning**: data is validated with `jmnak_import_validate()`
2. **Linearization**: transformation to log-log space
3. **Linear regression**: parameter extraction by least squares
4. **Selection**: if R² ≥ 0.90 and no influential points → uses lm
5. **Otherwise**: tries nonlinear regression (nls)
6. **Comparison**: if nls converges, compares the two and chooses the best
7. **Diagnostics**: calculates 10+ metrics and statistical tests
8. **Plots**: generates 4 diagnostic plots with ggplot2
9. **Result**: returns the complete object

**Generated plots:**
```
┌─────────────────────────┬──────────────────────────┐
│ JMAK Fit (Y vs t)       │ Avrami Linearization     │
│ Data + fitted curve     │ Log-log space            │
├─────────────────────────┼──────────────────────────┤
│ Residuals vs Time       │ Cook's Distance          │
│ Influential points?     │ Robustness diagnostic    │
└─────────────────────────┴──────────────────────────┘
```

---

### 3️⃣ `jmnak_predict()` - Make predictions

**What does it do?**
Uses the K and n parameters to predict Y(t) and calculate characteristic times.

**Syntax:**
```r
pred <- jmnak_predict(t = NULL, K, n, Ystar = c(0.5, 0.9))
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `t` | numeric | Time grid for predictions (optional) |
| `K` | numeric | Fitted kinetic constant |
| `n` | numeric | Fitted Avrami exponent |
| `Ystar` | numeric | Target fractions (ex: 0.5, 0.9) |

**Return:**
List with:
- `$t`: time grid
- `$Y_pred`: predictions Y(t)
- `$tstar`: characteristic times

**Example:**
```r
# From a fitting
K <- 0.02
n <- 3.2

# Predict Y(t) and times t₅₀, t₉₀
pred <- jmnak_predict(
  t = seq(0.5, 25, by = 0.5),
  K = K,
  n = n,
  Ystar = c(0.5, 0.9)
)

# Characteristic times
print(pred$tstar)
# t_for_Y=0.5  t_for_Y=0.9 
#      3.654      10.295

# Prediction curve
plot(pred$t, pred$Y_pred, type = "l", 
     xlab = "Time", ylab = "Transformed fraction Y(t)")
```

**Calculations performed:**

For each Y* in Ystar, calculate:

$$t^* = \left(\frac{-\ln(1-Y^*)}{K}\right)^{1/n}$$

Example: time for 50% and 90% transformation

---

### 4️⃣ `print.jmnak_fit()` - Display results

**What does it do?**
Displays a compact summary of fitting results.

**Syntax:**
```r
print(fit)
```

**Example output:**
```
JMAK Model Fit Summary:
  K = 0.02003
  n = 3.1948
  Method: lm
  R² = 0.9856
  RMSE = 0.0189
```

---

## 📊 Practical Examples

### Example 1: Simple analysis with included data

```r
library(JMAK)

# Load example data (polymer crystallization)
data(polymere_cristallisation)

# View the data
head(polymere_cristallisation)

# Fit the model
fit <- jmnak_fit_auto(
  polymere_cristallisation$t,
  polymere_cristallisation$Y
)

# Diagnostic plots are displayed automatically
```

### Example 2: Custom data

```r
library(JMAK)

# Your experimental data
time <- c(1, 2, 3, 5, 8, 10, 12, 15, 20)
fraction <- c(0.02, 0.08, 0.18, 0.45, 0.72, 0.85, 0.92, 0.97, 0.99)

# Clean the data
df <- jmnak_import_validate(time, fraction)

# Fit silently (without console output)
fit <- jmnak_fit_auto(df$t, df$Y, verbose = FALSE)

# Get the parameters
K <- fit$parameters$K
n <- fit$parameters$n
R2 <- fit$fit_quality$r2_original

cat(sprintf("K = %.4g, n = %.3f, R² = %.4f\n", K, n, R2))
```

### Example 3: Predictions and analysis

```r
library(JMAK)

# Data
t <- c(0.5, 1, 2, 4, 8, 15, 25)
Y <- 1 - exp(-0.015 * t^2.8) + rnorm(7, 0, 0.02)  # With noise
Y <- pmin(pmax(Y, 0.001), 0.999)

# Fit
fit <- jmnak_fit_auto(t, Y, verbose = FALSE)

# Predict Y(t) on a fine grid and calculate t₅₀, t₉₀
pred <- jmnak_predict(
  t = seq(0.5, 25, 0.1),
  K = fit$parameters$K,
  n = fit$parameters$n,
  Ystar = c(0.25, 0.50, 0.75, 0.90)
)

# Display results
cat("Characteristic times:\n")
print(pred$tstar)

# Create a custom plot
plot(t, Y, pch = 16, col = "blue", 
     xlab = "Time", ylab = "Transformed fraction",
     main = "Data + Fitted JMAK model",
     xlim = c(0, 25), ylim = c(0, 1))
lines(pred$t, pred$Y_pred, col = "red", lwd = 2)
abline(v = pred$tstar, col = "gray", lty = 2)
legend("bottomright", 
       legend = c("Data", "JMAK model"),
       col = c("blue", "red"), pch = c(16, NA), lty = c(NA, 1))
```

### Example 4: Comparing multiple datasets

```r
library(JMAK)

# Two experimental conditions
time_A <- c(1, 2, 3, 5, 8, 12, 18)
Y_A <- c(0.05, 0.15, 0.28, 0.52, 0.78, 0.92, 0.98)

time_B <- c(0.5, 1, 1.5, 2.5, 4, 6, 9)
Y_B <- c(0.01, 0.08, 0.18, 0.35, 0.58, 0.78, 0.93)

# Fit both models
fit_A <- jmnak_fit_auto(time_A, Y_A, verbose = FALSE)
fit_B <- jmnak_fit_auto(time_B, Y_B, verbose = FALSE)

# Compare the parameters
comparison <- data.frame(
  Condition = c("A", "B"),
  K = c(fit_A$parameters$K, fit_B$parameters$K),
  n = c(fit_A$parameters$n, fit_B$parameters$n),
  R2 = c(fit_A$fit_quality$r2_original, fit_B$fit_quality$r2_original),
  RMSE = c(fit_A$fit_quality$rmse, fit_B$fit_quality$rmse)
)

print(comparison)

# Diagnostic plots are displayed for each fit
```

### Example 5: Export results

```r
library(JMAK)

# Fit the model
data(polymere_cristallisation)
fit <- jmnak_fit_auto(polymere_cristallisation$t,
                      polymere_cristallisation$Y,
                      verbose = FALSE)

# Predictions
pred <- jmnak_predict(
  t = seq(0.5, 30, 0.5),
  K = fit$parameters$K,
  n = fit$parameters$n,
  Ystar = seq(0.1, 0.9, 0.1)
)

# Export predictions as CSV
predictions_df <- data.frame(
  t = pred$t,
  Y_pred = pred$Y_pred
)
write.csv(predictions_df, "predictions.csv", row.names = FALSE)

# Export characteristic times
tstar_df <- data.frame(
  Y = as.numeric(sub("t_for_Y=", "", names(pred$tstar))),
  t_star = as.numeric(pred$tstar)
)
write.csv(tstar_df, "characteristic_times.csv", row.names = FALSE)

cat("Exported files:\n")
cat("  - predictions.csv\n")
cat("  - characteristic_times.csv\n")
```

---

## ❓ FAQ

### Q1: I just installed R and don't know anything. Where do I start?

**A:**
1. Install **Git** from https://git-scm.com
2. Install **RStudio** from https://posit.co/download/rstudio-desktop/
3. Follow the steps in the [Detailed Installation for Beginners](#for-beginners-on-windows) section
4. Run the code from the [Quick Start](#⚡-quick-start) section

---

### Q2: I can't install the package. What should I do?

**Try these solutions in order:**

1. **Check dependencies**:
   ```r
   install.packages(c("ggplot2", "patchwork"))
   ```

2. **Reinstall from scratch**:
   ```r
   # Remove old version
   remove.packages("JMAK")
   
   # Reinstall
   install.packages("C:/path/to/JMAK/JMAK_1.1.tar.gz", 
                    repos = NULL, 
                    type = "source")
   ```

3. **If you're on Windows and it fails**:
   - Make sure **R Tools** is installed: https://cran.r-project.org/bin/windows/Rtools/
   - Close all R and RStudio windows
   - Try again

4. **Contact me** with the complete error message

---

### Q3: My data is in percentages. Do I need to convert it?

**No!** The `jmnak_import_validate()` function does it automatically.

```r
# This works:
Y <- c(5, 10, 25, 50, 75, 90)  # Percentages
fit <- jmnak_fit_auto(t, Y)  # Auto conversion
```

---

### Q4: How do I interpret R²?

**R² (coefficient of determination):**
- R² = 1.0: perfect fit
- R² > 0.95: excellent
- R² > 0.90: very good
- R² > 0.80: good
- R² < 0.80: weak fit, check your data

```r
fit <- jmnak_fit_auto(t, Y, verbose = FALSE)
cat("R² =", fit$fit_quality$r2_original, "\n")
```

---

### Q5: What does the exponent n tell me?

The exponent **n** characterizes the **mechanism** of transformation:

| Value of n | Mechanism |
|---|---|
| n ≈ 1 | One-dimensional growth |
| n ≈ 2 | Two-dimensional growth |
| n ≈ 3 | Three-dimensional growth |
| n ≈ 4 | Nucleation and 3D growth |
| n > 4 | Accelerated nucleation |

```r
fit <- jmnak_fit_auto(t, Y, verbose = FALSE)
cat("Exponent n =", fit$parameters$n, "\n")
```

---

### Q6: The plots don't display

**Probable cause:** ggplot2 is not installed

**Solution:**
```r
install.packages("ggplot2")
library(JMAK)
# Try again
fit <- jmnak_fit_auto(t, Y, verbose = TRUE)
```

The package uses base R graphics as a fallback if ggplot2 is not available.

---

### Q7: How do I know if my fit is good?

**Look for these signs:**

1. **R²** > 0.90 ✅
2. **RMSE** low (close to experimental error) ✅
3. **Residuals** scattered randomly around zero ✅
4. **Cook's distance** few or no points above the threshold ✅
5. **Shapiro-Wilk** p-value > 0.05 ✅ (normal residuals)

```r
fit <- jmnak_fit_auto(t, Y, verbose = TRUE)
# All these indices are displayed in the summary
```

---

### Q8: I want to remove an experimental point that looks wrong

```r
library(JMAK)

# Identify the outlier visually or by its Cook's distance
# Then refit without that point

t_clean <- t[-index_outlier]  # Remove element at index
Y_clean <- Y[-index_outlier]

# Refit
fit <- jmnak_fit_auto(t_clean, Y_clean, verbose = TRUE)
```

---

### Q9: Can I use this package on Mac?

**Yes!** The package works on macOS.

First install Homebrew, then:
```bash
brew install git
brew install r
```

Then follow the Linux instructions.

---

### Q10: Where can I report bugs or request features?

Create an **Issue** on GitHub: https://github.com/prunelleeba/JMAK-/issues

---

## 📋 Package Structure

```
JMAK/
│
├── DESCRIPTION              # Package metadata
├── NAMESPACE                # Exported functions
├── README.md                # This file
├── LICENSE                  # MIT License
├── JMAK_1.1.tar.gz          # Compressed package archive
│
├── R/                       # Source code
│   ├── jmnak_fit_auto.R          # Main function (596 lines)
│   ├── jmnak_import_validate.R   # Data validation
│   ├── jmak_model.R              # Predictions
│   ├── data-polymere_cristallisation.R
│   └── zzz-imports.R             # Import declarations
│
├── data/
│   └── polymere_cristallisation.rda  # Example dataset
│
├── data-raw/
│   └── make_data.R                   # Dataset generation script
│
├── man/                     # Function documentation
│   ├── jmnak_fit_auto.Rd
│   ├── jmnak_import_validate.Rd
│   ├── jmnak_predict.Rd
│   ├── print.jmnak_fit.Rd
│   └── polymere_cristallisation.Rd
│
└── tests/
    ├── testthat.R
    └── testthat/
        └── test-jmak.R     # Unit tests (137 lines)
```

---

## 💻 Supported Operating Systems

| OS | Version | Status |
|---------|---------|--------|
| **Windows** | 10, 11 | ✅ Full support |
| **Ubuntu/Linux** | 18.04+ | ✅ Full support |
| **macOS** | 10.14+ | ✅ Full support |

---

## 📦 Dependencies

### Required
- **R** ≥ 4.0.0
- **ggplot2**: for plots
- **stats**: already included in R

### Optional (with automatic fallback)
- **patchwork**: advanced plot layout
- **minpack.lm**: alternative NLS algorithm
- **car**: Durbin-Watson test

```r
# Install everything at once:
install.packages(c("ggplot2", "patchwork", "minpack.lm", "car"))
```

---

## 🔬 Included Data

### `polymere_cristallisation`

Simulated **polymer crystallization** dataset:
- **60 observations**
- **Columns**: `t` (time), `Y` (transformed fraction)
- **True parameters**: K = 0.02, n = 3.2
- **Noise**: Gaussian (std dev 0.02)

**Usage:**
```r
library(JMAK)
data(polymere_cristallisation)
head(polymere_cristallisation)
summary(polymere_cristallisation)
```

---

## ✅ Tests

The package includes **7 unit tests** covering:
- Data validation and cleaning
- Parameter recovery
- Robustness on noisy data
- Prediction calculations
- Edge cases
- Value clamping
- Console summary generation

**Run tests:**
```r
devtools::test()
# or
testthat::test_dir("tests/")
```

---

## 📖 Complete Documentation

For documentation of each function:

```r
?jmnak_fit_auto
?jmnak_import_validate
?jmnak_predict
?polymere_cristallisation
```

---

## 📞 Support and Contact

### Installation questions?
Report errors at: https://github.com/prunelleeba/JMAK-/issues

### Feedback, suggestions, or bugs?
Create a new **Issue** with:
1. Description of the problem
2. Code that reproduces the error
3. Complete error message
4. Your OS and R version

```r
sessionInfo()  # Use this to send your system info
```

### Author
**EBA NGOLONG Jeanne Chantal**  
Email: jeanne.eba@facsciences-uy1.cm

---

## 📜 License

This package is distributed under the **MIT License**.  
See the `LICENSE` file for details.

---

## 🚀 Next Steps

Now that you've installed JMAK:

1. ✅ Follow the [Quick Start](#⚡-quick-start)
2. ✅ Explore the [Practical Examples](#📊-practical-examples)
3. ✅ Check function help with `?function_name`
4. ✅ Adapt the code to your data
5. ✅ Generate your analysis reports

---

## 🎓 Learn more about the JMAK Model

### Scientific References
- Avrami, M. (1939). "Kinetics of phase change. I" Journal of Chemical Physics
- Johnson, W. A., & Mehl, R. F. (1939). "Reaction kinetics in processes of nucleation and growth"

### Online Resources
- [JMAK model - Wikipedia](https://en.wikipedia.org/wiki/Johnson%E2%80%93Mehl%E2%80%93Avrami%E2%80%93Kolmogorov_nucleation)
- University chemical kinetics courses

---

**Last update**: December 14, 2025  
**Package version**: 1.1

---

<div align="center">

### ⭐ If this package was useful to you, please give it a ⭐ on GitHub!

[📍 https://github.com/prunelleeba/JMAK-](https://github.com/prunelleeba/JMAK-)

</div>
