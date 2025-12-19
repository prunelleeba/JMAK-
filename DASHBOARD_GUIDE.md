# 🚀 JMAK Interactive Dashboard - Installation & Usage Guide

## 📋 Quick Start

### 1️⃣ Installation (One-time setup)

```r
# Install required packages if not already installed
install.packages(c("shiny", "ggplot2", "gridExtra","shinyjs"))

# Install JMAK package (if not already done)
install.packages("path/to/JMAK_1.1.tar.gz", repos = NULL, type = "source")
```

### 2️⃣ Launch the Dashboard

**Option A: From RStudio**
```r
# Set working directory to JMAK folder
setwd("path/to/JMAK")

# Run the app
shiny::runApp("app.R")
```

**Option B: Direct command**
```r
shiny::runApp("/path/to/JMAK/app.R")
```

**Option C: From terminal (R)**
```bash
Rscript -e 'shiny::runApp("/path/to/JMAK/app.R")'
```

### 3️⃣ Access the Dashboard

Once running, open your browser and go to:
```
http://localhost:3838
```

---

## 🎯 Dashboard Features

### 📊 5 Main Tabs

#### **1. 🏠 Home**
- Overview of JMAK model
- Polyethylene crystallization introduction
- Quick navigation guide

#### **2. 📥 Data Validation**
Three ways to input data:
- **Built-in Dataset**: Load example polyethylene data
- **Manual Entry**: Enter data points one by one
- **CSV Import**: Paste your own data

Automatically:
- ✅ Converts percentages to fractions
- ✅ Removes invalid values
- ✅ Clamps extreme values
- ✅ Displays cleaned data

#### **3. 🔧 Model Fitting**
Fits JMAK model with:
- Automatic method selection (linear/NLS)
- R² threshold adjustment
- Fitted parameters (K, n)
- Confidence intervals (95%)
- Comprehensive diagnostics
- Fit quality metrics
- Influential point detection

**Output includes:**
- K (rate constant)
- n (Avrami exponent)
- R² (goodness-of-fit)
- RMSE, MAE, residual statistics
- Statistical tests (Shapiro-Wilk, Durbin-Watson)

#### **4. 📈 Predictions & Characteristic Times**
Calculate:
- Y(t) for any time grid
- Characteristic times: t₂₅, t₅₀, t₇₅, t₉₀
- Professional prediction plots
- Download results as CSV

#### **5. 📊 Compare Datasets**
Compare two crystallization conditions:
- Load multiple datasets
- Fit both automatically
- Compare K and n values
- Visualize side-by-side
- Identify fastest/slowest conditions
- Percentage differences

#### **6. 📖 Documentation**
Built-in help with:
- Function descriptions
- Model theory
- PE crystallization information
- Practical examples

---

## 💻 System Requirements

| Component | Requirement |
|-----------|------------|
| **R** | ≥ 4.0.0 |
| **RStudio** | (Optional but recommended) |
| **RAM** | ≥ 2 GB |
| **Internet** | Only for package installation |

---

## 📦 Dependencies

### Required
```r
install.packages(c("shiny", "ggplot2", "gridExtra"))
```

### JMAK Package
```r
install.packages("path/to/JMAK_1.1.tar.gz", repos = NULL, type = "source")
```

---

## 🎨 User Interface Features

### Modern Design
- Gradient backgrounds
- Responsive layout
- Intuitive navigation
- Professional color scheme
- Clear sections and panels

### Interactive Elements
- Real-time validation
- Progress indicators
- Success/error notifications
- Automatic plot generation
- CSV export functionality

### Accessibility
- Clear labels and instructions
- Helpful tooltips
- Example data included
- Non-technical language

---


## 🚨 Troubleshooting

### Issue: "Package 'shiny' not found"
```r
install.packages("shiny")
```

### Issue: "App won't launch"
```r
# Check if JMAK package is installed
library(JMAK)

# Try running from correct directory
setwd("path/to/JMAK")
shiny::runApp("app.R")
```

### Issue: "Plots not displaying"
```r
# Reinstall ggplot2
install.packages("ggplot2", force = TRUE)

# Restart R
# Ctrl+Shift+F10 in RStudio
```

### Issue: "Data won't validate"
- Check that times (t) are positive
- Check that fractions (Y) are between 0 and 1 (or 0-100 for percentages)
- Ensure equal number of t and Y values

---

## 📁 File Structure

```
JMAK/
├── app.R                    # Main Shiny application
├── run_app.R               # Helper script to launch app
├── README.md               # Package documentation
├── JMAK_1.1.tar.gz        # Package archive
└── R/
    ├── jmnak_fit_auto.R
    ├── jmnak_import_validate.R
    ├── jmak_model.R
    └── ...
```

---


## 🔗 Workflow Example

```
Input Data (t, Y)
         ↓
    Validation ← Built-in data / Manual / CSV
         ↓
   Fit JMAK Model ← Linear/NLS/Auto-select
         ↓
   Check Diagnostics ← R², RMSE, influential points
         ↓
   Make Predictions ← Y(t), t*, characteristic times
         ↓
   Export Results ← CSV download
         ↓
   Generate Report ← Plot + parameters + metrics
```

---

## 📊 Example Results Display

The dashboard shows:

**For Fitted Model:**
```
K = 0.02003
n = 3.1948
R² = 0.9856
RMSE = 0.0189

95% Confidence Intervals:
K: [0.0185, 0.0220]
n: [3.05, 3.34]
```

**For Predictions:**
```
t_for_Y=0.50 = 3.654
t_for_Y=0.90 = 10.295

(+ interactive plot showing data, fit, and characteristic times)
```

---

## 📞 Support

For issues or questions:
1. Check the **Documentation** tab in the app
2. Review this guide
3. Contact: jeanne.eba@facsciences-uy1.cm

---

---

*JMAK Dashboard v1.1 - 2025*  
*For polyethylene crystallization kinetics analysis*
