# JMAK Interactive Dashboard
# Shiny Application for Demonstrating JMAK Kinetics Analysis
# Package Version: 1.1

library(shiny)
library(shinyjs)
library(JMAK)
library(ggplot2)
library(gridExtra)

# Define UI
ui <- fluidPage(
  shinyjs::useShinyjs(),
  # CSS styling
  tags$head(
    tags$style(HTML("
      body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        padding: 20px;
      }
      .navbar-brand {
        font-size: 24px;
        font-weight: bold;
        color: #fff !important;
      }
      .navbar {
        background: linear-gradient(90deg, #2d3436 0%, #636e72 100%) !important;
        border-bottom: 3px solid #667eea;
      }
      .container-fluid {
        background: white;
        border-radius: 10px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        padding: 30px;
        margin-top: 20px;
      }
      .nav-tabs {
        border-bottom: 2px solid #667eea;
      }
      .nav-tabs > li.active > a {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white !important;
        border: none;
      }
      .nav-tabs > li > a {
        color: #333;
        border: none;
        border-bottom: 3px solid transparent;
        transition: all 0.3s;
      }
      .nav-tabs > li > a:hover {
        border-bottom: 3px solid #667eea;
        background: #f5f5f5;
      }
      .well {
        background: #f8f9fa;
        border-left: 4px solid #667eea;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      }
      .btn-primary {
        background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        border: none;
        padding: 10px 30px;
        font-weight: bold;
        transition: all 0.3s;
      }
      .btn-primary:hover {
        background: linear-gradient(90deg, #5568d3 0%, #653a8a 100%);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
      }
      .btn-success {
        background: linear-gradient(90deg, #11998e 0%, #38ef7d 100%);
        border: none;
        padding: 10px 30px;
        font-weight: bold;
      }
      .btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(17, 153, 142, 0.4);
      }
      .btn-info {
        background: linear-gradient(90deg, #4facfe 0%, #00f2fe 100%);
        border: none;
        color: white;
      }
      .section-title {
        color: #2d3436;
        font-size: 20px;
        font-weight: bold;
        margin-top: 25px;
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 2px solid #667eea;
      }
      .info-box {
        background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
        border-left: 4px solid #667eea;
        padding: 15px;
        border-radius: 5px;
        margin: 15px 0;
      }
      .success-box {
        background: linear-gradient(135deg, #11998e15 0%, #38ef7d15 100%);
        border-left: 4px solid #38ef7d;
        padding: 15px;
        border-radius: 5px;
        margin: 15px 0;
      }
      .error-box {
        background: linear-gradient(135deg, #ff6b6b15 0%, #ee555515 100%);
        border-left: 4px solid #ff6b6b;
        padding: 15px;
        border-radius: 5px;
        margin: 15px 0;
      }
      .result-panel {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        border: 1px solid #ddd;
        margin-top: 20px;
      }
      .stat-box {
        background: white;
        padding: 20px;
        border-radius: 8px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin: 10px 5px;
      }
      .stat-value {
        font-size: 28px;
        font-weight: bold;
        color: #667eea;
      }
      .stat-label {
        font-size: 14px;
        color: #666;
        margin-top: 10px;
      }
      .header-banner {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 30px;
        border-radius: 10px;
        margin-bottom: 30px;
        text-align: center;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
      }
      .header-banner h1 {
        margin: 0;
        font-size: 36px;
        font-weight: bold;
      }
      .header-banner p {
        margin: 10px 0 0 0;
        font-size: 16px;
        opacity: 0.9;
      }
      .plot-container {
        background: white;
        padding: 20px;
        border-radius: 8px;
        border: 1px solid #ddd;
        margin: 20px 0;
      }
      .code-output {
        background: #f5f5f5;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 15px;
        font-family: 'Courier New', monospace;
        font-size: 12px;
        overflow-x: auto;
        max-height: 300px;
      }
      .table-responsive {
        background: white;
        padding: 20px;
        border-radius: 8px;
        margin: 20px 0;
      }
    "))
  ),
  
  # Navigation Bar
  navbarPage(
    title = "📊 JMAK Crystallization Analysis",
    theme = "cerulean",
    
    # Tab 1: Home / Overview
    tabPanel(
      "🏠 Home",
      div(class = "container-fluid",
        div(class = "header-banner",
          h1("Welcome to JMAK Dashboard"),
          p("Interactive Analysis of Polyethylene Crystallization Kinetics"),
          p("using Johnson-Mehl-Avrami-Kolmogorov Model")
        ),
        
        h2("📌 What is JMAK Model?"),
        p("The Johnson-Mehl-Avrami-Kolmogorov (JMAK) model describes how materials transform over time:"),
        
        div(class = "info-box",
          HTML("<strong>Y(t) = 1 - exp(-K·t<sup>n</sup>)</strong>"),
          p("Where:"),
          tags$ul(
            tags$li("Y(t) = Transformed fraction (0 to 1)"),
            tags$li("K = Kinetic constant (transformation rate)"),
            tags$li("n = Avrami exponent (nucleation/growth mechanism)"),
            tags$li("t = Time")
          )
        ),
        
        h2("🔬 Application: Polyethylene Crystallization"),
        p("This dashboard demonstrates the analysis of polyethylene (PE) crystallization using JMAK kinetics."),
        
        div(class = "info-box",
          HTML("<strong>Key Features:</strong>"),
          tags$ul(
            tags$li("✅ Data import and validation"),
            tags$li("✅ Automatic model fitting"),
            tags$li("✅ Complete diagnostics"),
            tags$li("✅ Predictions and characteristic times"),
            tags$li("✅ Professional visualizations")
          )
        ),
        
        h2("📚 Explore the Dashboard"),
        p("Use the tabs above to:"),
        
        fluidRow(
          column(6,
            div(class = "stat-box",
              div(class = "stat-value", "1️⃣"),
              div(class = "stat-label", "Validate Data"),
              p("Import and clean your experimental data")
            )
          ),
          column(6,
            div(class = "stat-box",
              div(class = "stat-value", "2️⃣"),
              div(class = "stat-label", "Fit Model"),
              p("Automatically fit JMAK to your data")
            )
          )
        ),
        
        fluidRow(
          column(6,
            div(class = "stat-box",
              div(class = "stat-value", "3️⃣"),
              div(class = "stat-label", "Predict"),
              p("Make predictions and find characteristic times")
            )
          ),
          column(6,
            div(class = "stat-box",
              div(class = "stat-value", "4️⃣"),
              div(class = "stat-label", "Compare"),
              p("Compare multiple datasets")
            )
          )
        ),
        
        h2("📊 Package Information"),
        div(class = "result-panel",
          p("JMAK Package v1.1 - 2025"),
          p("Author: EBA NGOLONG Jeanne Chantal"),
          p("Specialized for crystallization kinetics analysis")
        )
      )
    ),
    
    # Tab 2: Data Validation
    tabPanel(
      "📥 Data Validation",
      div(class = "container-fluid",
        h2("Import and Validate Experimental Data"),
        
        div(class = "info-box",
          p("Use this tool to clean and validate your experimental data before fitting the JMAK model."),
          p("The function automatically:"),
          tags$ul(
            tags$li("Converts percentages (0-100) to fractions (0-1)"),
            tags$li("Removes non-physical values"),
            tags$li("Clamps extreme values"),
            tags$li("Prepares data for fitting")
          )
        ),
        
        fluidRow(
          column(4,
            wellPanel(
              h4("Option 1: Use Built-in Dataset"),
              p("Try with the included polyethylene crystallization dataset:"),
              actionButton("load_builtin", "Load Polyethylene Data", class = "btn-success btn-block")
            )
          ),
          column(4,
            wellPanel(
              h4("Option 2: Enter Data Manually"),
              numericInput("n_points", "Number of data points:", value = 5, min = 3, max = 50),
              actionButton("init_manual", "Prepare Input Fields", class = "btn-primary btn-block")
            )
          ),
          column(4,
            wellPanel(
              h4("Option 3: Paste CSV Data"),
              p("Paste your data in format: t,Y"),
              actionButton("show_csv_input", "Show CSV Input", class = "btn-info btn-block")
            )
          )
        ),
        
        # Manual input fields
        div(id = "manual_inputs"),
        
        # CSV input
        conditionalPanel(
          condition = "input.show_csv_input > 0",
          wellPanel(
            h4("Paste CSV Data"),
            p("Format: time (comma) fraction. One pair per line."),
            p("Example:"),
            code("0.5,0.01"),
            code("1,0.05"),
            code("2,0.15"),
            br(),
            textAreaInput("csv_data", "Data:", 
                         value = "t,Y\n1,0.02\n2,0.10\n5,0.35\n10,0.80\n15,0.95",
                         rows = 10, cols = 30),
            actionButton("parse_csv", "Parse CSV Data", class = "btn-primary btn-block")
          )
        ),
        
        br(),
        
        fluidRow(
          column(6,
            actionButton("clear_validation", "🗑️ Clear Results", class = "btn-warning btn-block")
          ),
          column(6,
            p()
          )
        ),
        
        br(),
        
        # Display data table
        h3("📊 Current Data"),
        div(class = "table-responsive",
          tableOutput("validation_table")
        ),
        
        # Validation results
        div(id = "validation_results")
      )
    ),
    
    # Tab 3: Model Fitting
    tabPanel(
      "🔧 Model Fitting",
      div(class = "container-fluid",
        h2("Fit JMAK Model to Your Data"),
        
        div(class = "info-box",
          p("This tool automatically fits the JMAK model to your data using:"),
          tags$ul(
            tags$li("Linear regression (Avrami linearization)"),
            tags$li("Non-linear least squares (NLS)"),
            tags$li("Automatic method selection based on goodness-of-fit")
          )
        ),
        
        fluidRow(
          column(3,
            wellPanel(
              h4("Fitting Parameters"),
              numericInput("r2_threshold", "R² threshold:", value = 0.90, min = 0.5, max = 0.99, step = 0.01),
              p("Minimum R² for accepting linear fit"),
              checkboxInput("verbose_fit", "Verbose output", value = TRUE),
              p("Display detailed fitting results")
            )
          ),
          column(9,
            wellPanel(
              h4("Actions"),
              actionButton("fit_model", "Fit JMAK Model", class = "btn-success btn-lg btn-block"),
              br(),
              actionButton("clear_fit", "Clear Results", class = "btn-warning btn-block")
            )
          )
        ),
        
        br(),
        
        # Fitting results
        div(id = "fitting_results")
      )
    ),
    
    # Tab 4: Predictions
    tabPanel(
      "📈 Predictions & Characteristic Times",
      div(class = "container-fluid",
        h2("Make Predictions and Calculate Characteristic Times"),
        
        div(class = "info-box",
          p("Using fitted parameters K and n, calculate:"),
          tags$ul(
            tags$li("Y(t) = predicted transformation fraction at any time"),
            tags$li("t* = characteristic times for target fractions (e.g., t₅₀, t₉₀)")
          ),
          p("💡 You can use fitted parameters or enter your own K and n values!")
        ),
        
        # Parameters source selection
        wellPanel(
          h4("📊 Parameters Source"),
          radioButtons("param_source", "Choose where to get K and n:",
            choices = list(
              "From fitted model" = "from_fit",
              "Enter manually" = "manual"
            ),
            selected = "from_fit",
            inline = TRUE
          ),
          div(id = "manual_params_inputs")
        ),
        
        br(),
        
        # Prediction mode selection
        wellPanel(
          h4("🎯 Prediction Mode"),
          radioButtons("pred_mode", "What do you want to calculate?",
            choices = list(
              "Predict Y(t) from times" = "predict_y",
              "Find t* from Y values" = "find_t",
              "Both Y(t) and t*" = "both"
            ),
            selected = "both",
            inline = FALSE
          )
        ),
        
        br(),
        
        fluidRow(
          column(4,
            wellPanel(
              h4("⏱️ Time Settings"),
              p("Choose how to enter times:"),
              radioButtons("time_input_mode", "",
                choices = list(
                  "📊 Time grid (min, max, step)" = "grid",
                  "📝 Specific times (comma-separated)" = "custom"
                ),
                selected = "grid",
                inline = FALSE
              ),
              
              # Grid input
              conditionalPanel(
                condition = "input.time_input_mode == 'grid'",
                p(class = "text-muted", "Create a regular time sequence"),
                numericInput("t_min", "Min time:", value = 0.5, min = 0),
                numericInput("t_max", "Max time:", value = 30, min = 1),
                numericInput("t_step", "Step size:", value = 0.5, min = 0.01)
              ),
              
              # Custom times input
              conditionalPanel(
                condition = "input.time_input_mode == 'custom'",
                p(class = "text-muted", "Enter specific times, e.g.: 1, 2, 10"),
                textInput("custom_times", "Times:", placeholder = "e.g., 1, 2, 5, 10, 15, 20")
              ),
              
              div(id = "custom_times_input")
            )
          ),
          column(4,
            wellPanel(
              h4("📈 Target Y Values (Y*) "),
              p("Select default Y values:"),
              checkboxInput("yt_25", "Y = 0.25", value = FALSE),
              checkboxInput("yt_50", "Y = 0.50", value = TRUE),
              checkboxInput("yt_75", "Y = 0.75", value = FALSE),
              checkboxInput("yt_90", "Y = 0.90", value = TRUE),
              br(),
              p("📝 Or enter custom Y values (comma-separated):"),
              p("Use fractions (0.1, 0.5, 0.9) or percentages (10, 50, 90)"),
              textInput("custom_ystar", "Custom Y values:", placeholder = "e.g., 0.1,0.3,0.5 or 10,30,50")
            )
          ),
          column(4,
            wellPanel(
              h4("⚡ Actions"),
              actionButton("predict_model", "Calculate Predictions", class = "btn-success btn-lg btn-block"),
              br(),
              actionButton("clear_predictions", "🗑️ Clear Results", class = "btn-warning btn-block"),
              br(),
              downloadButton("download_predictions", "⬇️ Download CSV", class = "btn-info btn-block")
            )
          )
        ),
        
        br(),
        
        # Prediction results
        div(id = "prediction_results")
      )
    ),
    
    # # Tab 5: Comparison
    # tabPanel(
    #   "📊 Compare Datasets",
    #   div(class = "container-fluid",
    #     h2("Compare Multiple Crystallization Conditions"),
        
    #     div(class = "info-box",
    #       p("Compare fitting parameters across different experimental conditions"),
    #       p("This helps identify how conditions affect crystallization kinetics")
    #     ),
        
    #     fluidRow(
    #       column(6,
    #         wellPanel(
    #           h4("Condition A"),
    #           p("Dataset 1 - Your first dataset"),
    #           actionButton("load_cond_a", "Load Condition A", class = "btn-primary btn-block")
    #         )
    #       ),
    #       column(6,
    #         wellPanel(
    #           h4("Condition B"),
    #           p("Dataset 2 - Your second dataset"),
    #           actionButton("load_cond_b", "Load Condition B", class = "btn-primary btn-block")
    #         )
    #       )
    #     ),
        
    #     br(),
        
    #     wellPanel(
    #       h4("Comparison Options"),
    #       checkboxInput("auto_fit_compare", "Auto-fit both datasets", value = TRUE),
    #       actionButton("run_comparison", "Run Comparison", class = "btn-success btn-lg btn-block")
    #     ),
        
    #     br(),
        
    #     # Comparison results
    #     div(id = "comparison_results")
    #   )
    # ),
    
    # Tab 6: Documentation
    tabPanel(
      "📖 Documentation",
      div(class = "container-fluid",
        h2("JMAK Package Documentation"),
        
        tabsetPanel(
          # Functions
          tabPanel(
            "Functions",
            h3("Main Functions"),
            
            div(class = "result-panel",
              h4("1. jmnak_import_validate(t, Y)"),
              p("Validates and cleans experimental data."),
              p("Converts percentages to fractions, clamps extreme values."),
              code("df <- jmnak_import_validate(c(1,2,5), c(0.02, 0.10, 0.35))")
            ),
            
            div(class = "result-panel",
              h4("2. jmnak_fit_auto(t, Y, r2_threshold, verbose)"),
              p("Automatically fits the JMAK model to data."),
              p("Returns parameters K, n with confidence intervals and diagnostics."),
              code("fit <- jmnak_fit_auto(df$t, df$Y, verbose = TRUE)")
            ),
            
            div(class = "result-panel",
              h4("3. jmnak_predict(t, K, n, Ystar)"),
              p("Makes predictions using fitted parameters."),
              p("Calculates Y(t) and characteristic times t*."),
              code("pred <- jmnak_predict(t = seq(0.5, 30, 0.5), K = 0.02, n = 3.2)")
            ),
            
            div(class = "result-panel",
              h4("4. print.jmnak_fit(x)"),
              p("Displays a summary of fitting results."),
              code("print(fit)")
            )
          ),
          
          # Model
          tabPanel(
            "Model Theory",
            h3("JMAK Model Equation"),
            
            div(class = "info-box",
              HTML("<h4>Y(t) = 1 - exp(-K·t<sup>n</sup>)</h4>"),
              p("or in linearized form:"),
              HTML("<h4>ln(-ln(1-Y)) = ln(K) + n·ln(t)</h4>")
            ),
            
            h3("Parameter Interpretation"),
            
            div(class = "result-panel",
              h4("Avrami Exponent (n)"),
              p("Characterizes the nucleation and growth mechanism:"),
              tags$ul(
                tags$li("n ≈ 1: One-dimensional growth"),
                tags$li("n ≈ 2: Two-dimensional growth"),
                tags$li("n ≈ 3: Three-dimensional growth"),
                tags$li("n ≈ 4: 3D growth with nucleation"),
                tags$li("n > 4: Accelerated nucleation")
              )
            ),
            
            div(class = "result-panel",
              h4("Kinetic Constant (K)"),
              p("Represents the transformation rate."),
              p("Higher K → faster crystallization"),
              p("Temperature-dependent: K increases exponentially with temperature")
            )
          ),
          
          # Polyethylene
          tabPanel(
            "PE Crystallization",
            h3("Polyethylene Crystallization"),
            
            div(class = "info-box",
              p("Polyethylene (PE) is a semi-crystalline polymer."),
              p("Crystallization kinetics are crucial for:"),
              tags$ul(
                tags$li("🏗️ Mechanical properties"),
                tags$li("⚡ Heat resistance"),
                tags$li("💪 Strength and rigidity"),
                tags$li("🌡️ Thermal stability")
              )
            ),
            
            div(class = "success-box",
              h4("Typical PE Crystallization Parameters"),
              p("Low-Density PE (LDPE):"),
              tags$ul(
                tags$li("K ≈ 0.01 - 0.05"),
                tags$li("n ≈ 2.5 - 3.5")
              ),
              p("High-Density PE (HDPE):"),
              tags$ul(
                tags$li("K ≈ 0.02 - 0.10"),
                tags$li("n ≈ 3.0 - 4.0")
              )
            ),
            
            div(class = "result-panel",
              h4("Factors Affecting PE Crystallization"),
              tags$ul(
                tags$li("Temperature: Critical influence on K"),
                tags$li("Cooling rate: Affects crystal structure"),
                tags$li("Molecular weight: Influences crystallization speed"),
                tags$li("Additives: Nucleating agents accelerate crystallization")
              )
            )
          ),
          
          # Examples
          tabPanel(
            "Examples",
            h3("Use Cases"),
            
            div(class = "result-panel",
              h4("Example 1: Simple Analysis"),
              code("library(JMAK)"),
              br(),
              code("data(polymere_cristallisation)"),
              br(),
              code("fit <- jmnak_fit_auto(polymere_cristallisation$t,"),
              br(),
              code("                       polymere_cristallisation$Y)"),
              br(),
              code("print(fit)")
            ),
            
            div(class = "result-panel",
              h4("Example 2: Custom Data"),
              code("t <- c(0.5, 1, 2, 5, 10, 15, 20)"),
              br(),
              code("Y <- c(0.01, 0.05, 0.15, 0.45, 0.75, 0.90, 0.96)"),
              br(),
              code("fit <- jmnak_fit_auto(t, Y, verbose = TRUE)"),
              br(),
              code("pred <- jmnak_predict(t = seq(0.5, 20, 0.5),"),
              br(),
              code("                      K = fit$parameters$K,"),
              br(),
              code("                      n = fit$parameters$n)")
            )
          )
        )
      )
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Reactive values
  rv <- reactiveValues(
    data = NULL,
    fit = NULL,
    predictions = NULL,
    pred_source = "from_fit",
    pred_K = NULL,
    pred_n = NULL,
    cond_a_data = NULL,
    cond_a_fit = NULL,
    cond_b_data = NULL,
    cond_b_fit = NULL
  )
  
  # Helper functions for showing/hiding UI elements
  showElement <- function(id) {
    shinyjs::show(id)
  }
  
  hideElement <- function(id) {
    shinyjs::hide(id)
  }
  
  # ==================== TAB 2: DATA VALIDATION ====================
  
  # Load built-in dataset
  observeEvent(input$load_builtin, {
    tryCatch({
      data(polymere_cristallisation, package = "JMAK")
      rv$data <- polymere_cristallisation
      showNotification("✅ Polyethylene dataset loaded successfully!", type = "message", duration = 3)
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error", duration = 5)
    })
  })
  
  # Initialize manual input fields
  observeEvent(input$init_manual, {
    n_points <- input$n_points
    ui_elements <- lapply(1:n_points, function(i) {
      fluidRow(
        column(6, numericInput(paste0("t_", i), paste("t[", i, "]"), value = i, step = 0.1)),
        column(6, numericInput(paste0("Y_", i), paste("Y[", i, "]"), value = i/n_points, min = 0, max = 1, step = 0.01))
      )
    })
    
    ui_elements[[n_points + 1]] <- br()
    ui_elements[[n_points + 2]] <- actionButton("validate_manual", "Validate Manual Data", class = "btn-success btn-block")
    
    removeUI(selector = "#manual_inputs > *")
    insertUI(selector = "#manual_inputs", where = "beforeEnd", 
             do.call(tagList, ui_elements))
  })
  
  # Validate manual data
  observeEvent(input$validate_manual, {
    n_points <- input$n_points
    t_vals <- sapply(1:n_points, function(i) input[[paste0("t_", i)]])
    Y_vals <- sapply(1:n_points, function(i) input[[paste0("Y_", i)]])
    
    tryCatch({
      rv$data <- jmnak_import_validate(t_vals, Y_vals)
      showNotification("✅ Data validated successfully!", type = "message", duration = 3)
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error", duration = 5)
    })
  })
  
  # Parse CSV data
  observeEvent(input$parse_csv, {
    tryCatch({
      lines <- strsplit(input$csv_data, "\n")[[1]]
      lines <- lines[lines != ""]
      
      # Skip header if present
      if (grepl("[a-zA-Z]", lines[1])) {
        lines <- lines[-1]
      }
      
      data_list <- lapply(lines, function(line) {
        vals <- as.numeric(strsplit(line, ",")[[1]])
        vals
      })
      
      data_matrix <- do.call(rbind, data_list)
      t_vals <- data_matrix[, 1]
      Y_vals <- data_matrix[, 2]
      
      rv$data <- jmnak_import_validate(t_vals, Y_vals)
      showNotification("✅ CSV data parsed and validated!", type = "message", duration = 3)
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error", duration = 5)
    })
  })
  
  # Display validation table
  output$validation_table <- renderTable({
    if (is.null(rv$data)) {
      data.frame(Status = "No data loaded", Message = "Use options above to load or enter data")
    } else {
      rv$data
    }
  })
  
  # Clear validation results
  observeEvent(input$clear_validation, {
    rv$data <- NULL
    removeUI(selector = "#validation_results > *")
    removeUI(selector = "#manual_inputs > *")
    showNotification("🗑️ Data cleared", type = "message", duration = 2)
  })
  
  # ==================== TAB 3: MODEL FITTING ====================
  
  # Fit JMAK model
  observeEvent(input$fit_model, {
    if (is.null(rv$data)) {
      showNotification("❌ No data to fit. Please load or validate data first.", type = "error", duration = 5)
      return()
    }
    
    withProgress(message = "Fitting JMAK model...", value = 0.5, {
      tryCatch({
        rv$fit <- jmnak_fit_auto(
          rv$data$t,
          rv$data$Y,
          r2_threshold = input$r2_threshold,
          verbose = input$verbose_fit
        )
        showNotification("✅ Model fitted successfully!", type = "message", duration = 3)
      }, error = function(e) {
        showNotification(paste("❌ Fitting error:", e$message), type = "error", duration = 5)
      })
    })
  })
  
  # Clear fitting results
  observeEvent(input$clear_fit, {
    rv$fit <- NULL
    removeUI(selector = "#fitting_results > *")
    showNotification("🗑️ Fitting results cleared", type = "message", duration = 2)
  })
  
  # Display fitting results
  observe({
    if (!is.null(rv$fit)) {
      output_ui <- list(
        h3("📊 Fitting Results"),
        
        # Parameter summary
        div(class = "result-panel",
          h4("Fitted Parameters"),
          fluidRow(
            column(4,
              div(class = "stat-box",
                div(class = "stat-value", sprintf("%.6g", rv$fit$parameters$K)),
                div(class = "stat-label", "K (Rate Constant)")
              )
            ),
            column(4,
              div(class = "stat-box",
                div(class = "stat-value", sprintf("%.3f", rv$fit$parameters$n)),
                div(class = "stat-label", "n (Avrami Exponent)")
              )
            ),
            column(4,
              div(class = "stat-box",
                div(class = "stat-value", sprintf("%.4f", rv$fit$fit_quality$r2_original)),
                div(class = "stat-label", "R² (Goodness-of-fit)")
              )
            )
          )
        ),
        
        # Confidence intervals
        div(class = "result-panel",
          h4("95% Confidence Intervals"),
          HTML(sprintf(
            "<p><strong>K:</strong> [%.6g, %.6g]</p>",
            rv$fit$confidence_intervals$K[1],
            rv$fit$confidence_intervals$K[2]
          )),
          HTML(sprintf(
            "<p><strong>n:</strong> [%.4f, %.4f]</p>",
            rv$fit$confidence_intervals$n[1],
            rv$fit$confidence_intervals$n[2]
          ))
        ),
        
        # Fit quality metrics
        div(class = "result-panel",
          h4("Fit Quality Metrics"),
          fluidRow(
            column(6,
              p(HTML(sprintf("<strong>Method:</strong> %s", rv$fit$fit_quality$method))),
              p(HTML(sprintf("<strong>R² (linear):</strong> %.4f", rv$fit$fit_quality$r2_linear))),
              p(HTML(sprintf("<strong>RMSE:</strong> %.6g", rv$fit$fit_quality$rmse)))
            ),
            column(6,
              p(HTML(sprintf("<strong>MAE:</strong> %.6g", rv$fit$fit_quality$mae))),
              p(HTML(sprintf("<strong>Data points:</strong> %d", rv$fit$fit_quality$n_points))),
              p(HTML(sprintf("<strong>Sum of squares:</strong> %.6g", rv$fit$fit_quality$ss_residuals)))
            )
          )
        ),
        
        # Diagnostics
        div(class = "result-panel",
          h4("Diagnostics"),
          if (length(rv$fit$diagnostics$influential_points) > 0) {
            p(HTML(sprintf(
              "<span style='color: #ff6b6b;'><strong>⚠️ Influential points:</strong> %s</span>",
              paste(rv$fit$diagnostics$influential_points, collapse = ", ")
            )))
          } else {
            p(HTML("<span style='color: #38ef7d;'><strong>✅ No influential points detected</strong></span>"))
          },
          if (!is.null(rv$fit$diagnostics$shapiro_p)) {
            p(HTML(sprintf(
              "<strong>Shapiro-Wilk p-value:</strong> %.4f",
              rv$fit$diagnostics$shapiro_p
            )))
          },
          if (!is.null(rv$fit$diagnostics$durbin_watson)) {
            p(HTML(sprintf(
              "<strong>Durbin-Watson:</strong> %.3f",
              rv$fit$diagnostics$durbin_watson
            )))
          }
        ),
        
        # Summary
        div(class = "success-box",
          h4("Summary"),
          p(rv$fit$note)
        )
      )
      
      removeUI(selector = "#fitting_results > *")
      insertUI(selector = "#fitting_results", where = "beforeEnd", do.call(tagList, output_ui))
    }
  })
  
  # ==================== TAB 4: PREDICTIONS ====================
  
  # Show/hide manual parameters inputs
  observe({
    if (input$param_source == "manual") {
      output_ui <- list(
        fluidRow(
          column(6,
            numericInput("manual_K", "K (Kinetic constant):", value = 0.02, min = 0.0001, step = 0.001)
          ),
          column(6,
            numericInput("manual_n", "n (Avrami exponent):", value = 3.0, min = 0.1, step = 0.1)
          )
        )
      )
      
      removeUI(selector = "#manual_params_inputs > *")
      insertUI(selector = "#manual_params_inputs", where = "beforeEnd", do.call(tagList, output_ui))
    } else {
      removeUI(selector = "#manual_params_inputs > *")
    }
  })
  
  # Show/hide custom times input based on prediction mode and time input mode
  observe({
    if (input$pred_mode %in% c("predict_y", "both")) {
      if (input$time_input_mode == "grid") {
        showElement("t_min")
        showElement("t_max")
        showElement("t_step")
      } else {
        hideElement("t_min")
        hideElement("t_max")
        hideElement("t_step")
      }
    } else {
      hideElement("t_min")
      hideElement("t_max")
      hideElement("t_step")
    }
  })
  
  # Calculate predictions
  observeEvent(input$predict_model, {
    # Get K and n values
    if (input$param_source == "from_fit") {
      if (is.null(rv$fit)) {
        showNotification("❌ No model fitted. Please fit the model first or enter manual K and n.", type = "error", duration = 5)
        return()
      }
      K_val <- rv$fit$parameters$K
      n_val <- rv$fit$parameters$n
      source_label <- "from fitted model"
    } else {
      K_val <- input$manual_K
      n_val <- input$manual_n
      source_label <- "manually entered"
    }
    
    # Validate K and n
    if (is.na(K_val) || is.na(n_val) || K_val <= 0 || n_val <= 0) {
      showNotification("❌ K and n must be positive numbers", type = "error", duration = 5)
      return()
    }
    
    # Collect Ystar values
    Ystar_vals <- c()
    
    # First check if custom values are provided
    has_custom <- !is.null(input$custom_ystar) && input$custom_ystar != "" && input$custom_ystar != " " && trimws(input$custom_ystar) != ""
    
    if (has_custom) {
      # Use ONLY custom values if provided
      tryCatch({
        # Split, trim whitespace, convert to numeric
        custom_text <- trimws(input$custom_ystar)
        custom_vals <- as.numeric(trimws(strsplit(custom_text, ",")[[1]]))
        custom_vals <- custom_vals[!is.na(custom_vals)]
        
        # Normalize values: if > 1, divide by 100 (assume percentages)
        custom_vals <- ifelse(custom_vals > 1, custom_vals / 100, custom_vals)
        
        # Keep only valid fractions
        custom_vals <- custom_vals[custom_vals > 0 & custom_vals < 1]
        
        if (length(custom_vals) > 0) {
          Ystar_vals <- sort(unique(custom_vals))
          showNotification(paste("✅ Using custom Y values:", paste(round(Ystar_vals, 3), collapse = ", ")), type = "message", duration = 4)
        } else {
          showNotification("⚠️ No valid Y values found. Use values between 0-1 (or 0-100 for percentages).", type = "warning", duration = 4)
        }
      }, error = function(e) {
        showNotification("❌ Error parsing custom Y values. Format: 0.5,0.9 or 50,90", type = "error", duration = 4)
      })
    } else {
      # Use checkbox values if no custom values
      if (input$yt_25) Ystar_vals <- c(Ystar_vals, 0.25)
      if (input$yt_50) Ystar_vals <- c(Ystar_vals, 0.50)
      if (input$yt_75) Ystar_vals <- c(Ystar_vals, 0.75)
      if (input$yt_90) Ystar_vals <- c(Ystar_vals, 0.90)
      
      if (length(Ystar_vals) > 0) {
        showNotification(paste("✅ Using checkbox Y values:", paste(Ystar_vals, collapse = ", ")), type = "message", duration = 4)
      }
    }
    
    # If no Ystar values provided, use default values
    if (length(Ystar_vals) == 0) {
      Ystar_vals <- c(0.5, 0.9)  # Default values
      showNotification("ℹ️ No Y values selected. Using defaults: 0.5, 0.9", type = "message", duration = 3)
    }
    
    # Determine t grid based on prediction mode and time input mode
    t_grid <- NULL
    if (input$pred_mode %in% c("predict_y", "both")) {
      if (input$time_input_mode == "grid") {
        # Grid mode: create sequence
        t_grid <- seq(input$t_min, input$t_max, by = input$t_step)
        if (length(t_grid) < 2) {
          showNotification("❌ Invalid time grid. Check min, max, and step values.", type = "error", duration = 5)
          return()
        }
        showNotification(paste("⏱️ Using time grid:", input$t_min, "-", input$t_max, "by", input$t_step), type = "message", duration = 3)
      } else {
        # Custom mode: parse specific times
        tryCatch({
          custom_text <- trimws(input$custom_times)
          if (custom_text == "" || is.na(custom_text)) {
            showNotification("❌ Please enter specific times (e.g., 1, 2, 5, 10)", type = "error", duration = 4)
            return()
          }
          t_grid <- as.numeric(trimws(strsplit(custom_text, ",")[[1]]))
          t_grid <- t_grid[!is.na(t_grid) & t_grid > 0]
          
          if (length(t_grid) == 0) {
            showNotification("❌ No valid times found. Enter positive numbers separated by commas.", type = "error", duration = 4)
            return()
          }
          t_grid <- sort(unique(t_grid))
          showNotification(paste("⏱️ Using specific times:", paste(t_grid, collapse = ", ")), type = "message", duration = 4)
        }, error = function(e) {
          showNotification("❌ Error parsing times. Use format: 1, 2, 5, 10", type = "error", duration = 4)
        })
      }
    }
    
    withProgress(message = "Calculating predictions...", value = 0.5, {
      tryCatch({
        rv$predictions <- jmnak_predict(
          t = t_grid,
          K = K_val,
          n = n_val,
          Ystar = Ystar_vals
        )
        rv$pred_source <- source_label
        rv$pred_K <- K_val
        rv$pred_n <- n_val
        showNotification("✅ Predictions calculated!", type = "message", duration = 3)
      }, error = function(e) {
        showNotification(paste("❌ Error:", e$message), type = "error", duration = 5)
      })
    })
  })
  
  # Clear prediction results
  observeEvent(input$clear_predictions, {
    rv$predictions <- NULL
    removeUI(selector = "#prediction_results > *")
    showNotification("🗑️ Predictions cleared", type = "message", duration = 2)
  })
  
  # Display prediction results
  observe({
    if (!is.null(rv$predictions)) {
      output_ui <- list(
        h3("📈 Prediction Results"),
        
        div(class = "info-box",
          p(HTML(sprintf("<strong>Parameters:</strong> K = %.6g (from %s), n = %.4f", 
                         rv$pred_K, rv$pred_source, rv$pred_n)))
        )
      )
      
      # Add characteristic times section if available
      if (!is.null(rv$predictions$tstar) && length(rv$predictions$tstar) > 0) {
        output_ui[[length(output_ui) + 1]] <- div(class = "result-panel",
          h4("⏱️ Characteristic Times (t*)"),
          fluidRow(
            lapply(seq_along(rv$predictions$tstar), function(i) {
              column(3,
                div(class = "stat-box",
                  div(class = "stat-value", sprintf("%.3f", rv$predictions$tstar[i])),
                  div(class = "stat-label", names(rv$predictions$tstar)[i])
                )
              )
            })
          )
        )
      }
      
      # Add prediction table if Y predictions available
      if (!is.null(rv$predictions$Y_pred) && length(rv$predictions$Y_pred) > 0) {
        output_ui[[length(output_ui) + 1]] <- div(class = "table-responsive",
          h4("Predicted Y(t) Values"),
          tableOutput("prediction_table")
        )
        
        output_ui[[length(output_ui) + 1]] <- div(class = "plot-container",
          plotOutput("prediction_plot", height = "500px")
        )
      }
      
      removeUI(selector = "#prediction_results > *")
      insertUI(selector = "#prediction_results", where = "beforeEnd", do.call(tagList, output_ui))
      
      # Render prediction table
      output$prediction_table <- renderTable({
        pred_df <- data.frame(
          Time = rv$predictions$t,
          Y_predicted = rv$predictions$Y_pred
        )
        head(pred_df, 20)
      })
      
      # Render prediction plot
      output$prediction_plot <- renderPlot({
        pred_df <- data.frame(
          Time = rv$predictions$t,
          Y_predicted = rv$predictions$Y_pred
        )
        
        # Create plot with or without original data
        if (!is.null(rv$data)) {
          ggplot() +
            geom_point(data = data.frame(t = rv$data$t, Y = rv$data$Y),
                      aes(x = t, y = Y), size = 4, color = "#2E86AB", alpha = 0.8, name = "Data") +
            geom_line(data = pred_df,
                     aes(x = Time, y = Y_predicted), color = "#A23B72", size = 1.2) +
            geom_vline(xintercept = as.numeric(rv$predictions$tstar), 
                      linetype = "dashed", color = "gray", alpha = 0.6) +
            labs(
              title = "JMAK Model: Predictions",
              subtitle = sprintf("K = %.4g, n = %.3f", rv$pred_K, rv$pred_n),
              x = "Time (t)",
              y = "Transformed Fraction Y(t)"
            ) +
            theme_minimal(base_size = 14) +
            theme(
              plot.title = element_text(face = "bold", hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5)
            ) +
            ylim(0, 1)
        } else {
          ggplot(data = pred_df, aes(x = Time, y = Y_predicted)) +
            geom_line(color = "#A23B72", size = 1.2) +
            geom_vline(xintercept = as.numeric(rv$predictions$tstar), 
                      linetype = "dashed", color = "gray", alpha = 0.6) +
            labs(
              title = "JMAK Model: Predictions",
              subtitle = sprintf("K = %.4g, n = %.3f", rv$pred_K, rv$pred_n),
              x = "Time (t)",
              y = "Transformed Fraction Y(t)"
            ) +
            theme_minimal(base_size = 14) +
            theme(
              plot.title = element_text(face = "bold", hjust = 0.5),
              plot.subtitle = element_text(hjust = 0.5)
            ) +
            ylim(0, 1)
        }
      })
    }
  })
  
  # Download predictions
  output$download_predictions <- downloadHandler(
    filename = function() { "jmak_predictions.csv" },
    content = function(file) {
      if (!is.null(rv$predictions)) {
        if (!is.null(rv$predictions$Y_pred)) {
          pred_df <- data.frame(
            t = rv$predictions$t,
            Y_pred = rv$predictions$Y_pred
          )
        } else {
          pred_df <- data.frame(
            Parameter = names(rv$predictions$tstar),
            CharacteristicTime = as.numeric(rv$predictions$tstar)
          )
        }
        write.csv(pred_df, file, row.names = FALSE)
      }
    }
  )
  
  # ==================== TAB 5: COMPARISON ====================
  
  # Load condition A
  observeEvent(input$load_cond_a, {
    tryCatch({
      data(polymere_cristallisation, package = "JMAK")
      rv$cond_a_data <- polymere_cristallisation
      showNotification("✅ Condition A data loaded", type = "message", duration = 3)
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error", duration = 5)
    })
  })
  
  # Load condition B
  observeEvent(input$load_cond_b, {
    tryCatch({
      # Simulate condition B (faster crystallization)
      data(polymere_cristallisation, package = "JMAK")
      cond_b <- polymere_cristallisation
      cond_b$t <- cond_b$t * 0.7  # Faster
      cond_b$Y <- pmin(cond_b$Y, 0.999)
      rv$cond_b_data <- cond_b
      showNotification("✅ Condition B data loaded", type = "message", duration = 3)
    }, error = function(e) {
      showNotification(paste("❌ Error:", e$message), type = "error", duration = 5)
    })
  })
  
  # Run comparison
  observeEvent(input$run_comparison, {
    if (is.null(rv$cond_a_data) || is.null(rv$cond_b_data)) {
      showNotification("❌ Please load both datasets first", type = "error", duration = 5)
      return()
    }
    
    withProgress(message = "Running comparison...", value = 0.5, {
      tryCatch({
        if (input$auto_fit_compare) {
          rv$cond_a_fit <- jmnak_fit_auto(rv$cond_a_data$t, rv$cond_a_data$Y, verbose = FALSE)
          rv$cond_b_fit <- jmnak_fit_auto(rv$cond_b_data$t, rv$cond_b_data$Y, verbose = FALSE)
        }
        showNotification("✅ Comparison completed!", type = "message", duration = 3)
      }, error = function(e) {
        showNotification(paste("❌ Error:", e$message), type = "error", duration = 5)
      })
    })
  })
  
  # Display comparison results
  observe({
    if (!is.null(rv$cond_a_fit) && !is.null(rv$cond_b_fit)) {
      comparison_df <- data.frame(
        Condition = c("Condition A", "Condition B"),
        K = c(rv$cond_a_fit$parameters$K, rv$cond_b_fit$parameters$K),
        n = c(rv$cond_a_fit$parameters$n, rv$cond_b_fit$parameters$n),
        R2 = c(rv$cond_a_fit$fit_quality$r2_original, rv$cond_b_fit$fit_quality$r2_original),
        RMSE = c(rv$cond_a_fit$fit_quality$rmse, rv$cond_b_fit$fit_quality$rmse)
      )
      
      output_ui <- list(
        h3("📊 Comparison Results"),
        
        div(class = "table-responsive",
          h4("Parameter Comparison"),
          tableOutput("comparison_table")
        ),
        
        div(class = "plot-container",
          plotOutput("comparison_plot", height = "500px")
        ),
        
        div(class = "result-panel",
          h4("Analysis"),
          if (comparison_df$K[1] < comparison_df$K[2]) {
            p(HTML(sprintf(
              "<span style='color: #38ef7d;'>✓ Condition B is <strong>%.1f%% faster</strong> than Condition A</span>",
              ((comparison_df$K[2] - comparison_df$K[1]) / comparison_df$K[1] * 100)
            )))
          } else {
            p(HTML(sprintf(
              "<span style='color: #38ef7d;'>✓ Condition A is <strong>%.1f%% faster</strong> than Condition B</span>",
              ((comparison_df$K[1] - comparison_df$K[2]) / comparison_df$K[2] * 100)
            )))
          }
        )
      )
      
      removeUI(selector = "#comparison_results > *")
      insertUI(selector = "#comparison_results", where = "beforeEnd", do.call(tagList, output_ui))
      
      output$comparison_table <- renderTable({
        comparison_df
      })
      
      output$comparison_plot <- renderPlot({
        t_range <- seq(min(c(rv$cond_a_data$t, rv$cond_b_data$t)),
                      max(c(rv$cond_a_data$t, rv$cond_b_data$t)), length.out = 200)
        
        Y_a <- 1 - exp(-rv$cond_a_fit$parameters$K * t_range^rv$cond_a_fit$parameters$n)
        Y_b <- 1 - exp(-rv$cond_b_fit$parameters$K * t_range^rv$cond_b_fit$parameters$n)
        
        plot_data <- data.frame(
          t = c(t_range, t_range),
          Y = c(Y_a, Y_b),
          Condition = c(rep("Condition A", length(t_range)), rep("Condition B", length(t_range)))
        )
        
        data_points <- rbind(
          data.frame(t = rv$cond_a_data$t, Y = rv$cond_a_data$Y, Condition = "Condition A"),
          data.frame(t = rv$cond_b_data$t, Y = rv$cond_b_data$Y, Condition = "Condition B")
        )
        
        ggplot() +
          geom_line(data = plot_data, aes(x = t, y = Y, color = Condition), size = 1.2) +
          geom_point(data = data_points, aes(x = t, y = Y, color = Condition), size = 3, alpha = 0.8) +
          scale_color_manual(values = c("Condition A" = "#2E86AB", "Condition B" = "#A23B72")) +
          labs(
            title = "Crystallization Kinetics Comparison",
            x = "Time (t)",
            y = "Transformed Fraction Y(t)"
          ) +
          theme_minimal(base_size = 14) +
          theme(
            plot.title = element_text(face = "bold", hjust = 0.5),
            legend.position = "bottom"
          ) +
          ylim(0, 1)
      })
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
