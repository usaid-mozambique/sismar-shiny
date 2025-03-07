library(shiny)
library(tidyverse)
library(sismar)
library(janitor)
library(shinythemes)
library(shinyjs)
library(DT)

# Define UI for application
ui <- fluidPage(

  useShinyjs(),
  theme = shinytheme("flatly"),

  tags$head(
    # Load Google Fonts
    tags$link(href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;700&family=Lato:wght@300;400;700&display=swap", rel="stylesheet"),

    tags$style(HTML("
      /* Apply Montserrat as the base font */
      body {
        font-family: 'Montserrat', sans-serif;
        padding-top: 110px;
        margin-left: 15px;
        margin-right: 15px;
      }

      /* Apply Lato for headings */
      h1, h2, h3, h4, h5, h6, .intro-heading {
        font-family: 'Lato', sans-serif;
      }

      /* Full-width fixed banner */
      .banner {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #007268;
        color: #d5d417;
        padding: 10px 25px;
        font-size: 60px;
        font-weight: bold;
        width: 100vw;
        height: 70px;
        position: fixed;
        top: 0;
        left: 0;
        z-index: 1000;
      }

      /* Center logo and text together */
      .banner-text {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 47px;
      }

      /* Adjust logo size and vertical alignment */
      .banner-logo {
        height: 60px;
        vertical-align: middle;
      }

      /* Secondary banner below the main banner */
      .sub-banner {
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #d5d417;
        color: white;
        font-size: 18px;
        height: 3px;
        width: 100vw;
        position: fixed;
        top: 70px;
        left: 0;
        z-index: 999;
      }

      /* Default (Inactive) Tab Styling */
      .nav-tabs > li > a {
        font-size: 13px !important;
        color: #95a5a6 !important;
        font-weight: normal !important;
        background-color: white !important;
        border: 1px solid #d9dddc !important;
        border-bottom: 1px solid #d9dddc !important;
      }

      /* Active (Selected) Tab Styling */
      .nav-tabs > li.active > a,
      .nav-tabs > li.active > a:hover {
        color: #333333 !important;
        font-weight: bold !important;
        background-color: white !important;
        border: 1px solid #d9dddc !important;
        border-bottom: none !important;
      }

      /* Hover Effect */
      .nav-tabs > li > a:hover {
        color: #005a50 !important;
      }

      /* Add margin space (indentation) to tabset content */
      .tab-content {
        margin-top: 25px !important;
        padding-left: 10px !important;
        padding-right: 10px !important;
      }

      .intro-heading {
        font-size: 14px;
        font-weight: bold;
      }

      .intro-text {
        padding-right: 50px !important;
        font-size: 12px;
        width: 95vw;
      }

      .shiny-file-input-progress {
        height: 10px !important;
      }

      /* Change the progress bar color */
      .shiny-file-input-progress .progress-bar {
        height: 10;
        background-color: #007268 !important;
      }

      .btn-primary {
        width: 145px;
        background-color: #007268 !important;
        border-color: #007268 !important;
        color: white !important;
        font-size: 14px;
      }

      .btn-primary:hover {
        background-color: #005a50 !important;
        border-color: #005a50 !important;
      }

      .btn-secondary {
        width: 145px;
        font-size: 14px;
      }

      .dataTables_wrapper {
        background-color: white !important;
        padding-top: 20px;
        border-radius: 0px;
        font-size: 65% !important;
      }

      .dataTable {
        background-color: white !important;
      }

      /* Adjust table row height (thickness) */
      .dataTable tbody tr {
        height: 20px !important;
        line-height: 1 !important;
      }
    "))
  ),

  # Full-width fixed banner with logo + text + menu
  div(class = "banner",
      div(class = "banner-text",
          img(src = "apple-touch-icon-180x180.png", class = "banner-logo"),
          span("sismar::")
      )
  ),

  # Secondary banner
  div(class = "sub-banner", span("")),

  # Tabset Panel
  tabsetPanel(
    # ARRUMAÇÃO TAB
    tabPanel("Arrumação",
             fluidRow(
               column(6,
                      p("Arrumação de dados SISMA", class = "intro-heading"),
                      p("Utilize os controlos abaixo para carregar o seu relatório padrão .csv do SIMSA, para processar num formato mais amigável para analisar, e para descarregar o seu ficheiro final.", class = "intro-text")
               )
             ),
             fluidRow(
               column(6,
                      fileInput("csv_file", "Escolha ficheiro .csv", accept = ".csv"),
                      div(class = "btn-container",
                          actionButton("process", "Processar", class = "btn btn-primary"),
                          downloadButton("download", "Descarregar", class = "btn btn-secondary")
                      )
               )
             ),
             fluidRow(
               column(10,
                      div(id = "preview-container", style = "display: none;",
                          dataTableOutput("preview")
                      )
               )
             )
    ),

    # COMPILAÇÃO TAB (Multi-file processing)
    tabPanel("Compilação",
             fluidRow(
               column(6,
                      p("Compilação de ficheiros processados", class = "intro-heading"),
                      p("Selecione abaixo múltiplos ficheiros .csv para a compilação deles. Estes ficheiros devem já estar processados através da folha 'arrumação'.", class = "intro-text")
               )
             ),
             fluidRow(
               column(6,
                      fileInput("multi_csv_file", "Escolha ficheiros .csv", accept = ".csv", multiple = TRUE),
                      div(class = "btn-container",
                          actionButton("process_multi", "Compilar", class = "btn btn-primary"),
                          downloadButton("download_multi", "Descarregar", class = "btn btn-secondary")
                      )
               )
             ),
             fluidRow(
               column(10,
                      div(id = "multi-preview-container", style = "display: none;",
                          dataTableOutput("multi_preview")
                      )
               )
             )
    ),

    # METADADOS TAB
    tabPanel("Metadados",
             fluidRow(
               column(6,
                      p("Anexar Metadados", class = "intro-heading"),
                      p("Funcionalidade pendente", class = "intro-text")
               )
             )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Increase max upload size to 100MB (adjust as needed)
  options(shiny.maxRequestSize = 100*1024^2)
  
  # ARRUMAÇÃO PROCESSING
  processed_data <- reactiveVal(NULL)
  
  observeEvent(input$process, {
    req(input$csv_file)
    processed <- process_sisma_export(input$csv_file$datapath)
    processed_data(processed)
    
    # Show preview container when data is available
    show("preview-container")
  })
  
  output$preview <- renderDataTable({
    req(processed_data())
    datatable(
      processed_data(),
      options = list(
        dom = '<"top-container"l f>rtip'
      )
    )
  })
  
  output$download <- downloadHandler(
    filename = function() { "processed_file.csv" },
    content = function(file) {
      req(processed_data())
      write_csv(processed_data(), file)
    }
  )
  
  # COMPILAÇÃO PROCESSING (Multiple file merging)
  compiled_data <- reactiveVal(NULL)
  
  observeEvent(input$process_multi, {
    req(input$multi_csv_file)
    
    # Read and merge files without adding "source_file" column
    compiled <- map_dfr(input$multi_csv_file$datapath, read_csv) 
    
    compiled_data(compiled)  # Save compiled data without "source_file"
    show("multi-preview-container")
  })
  
  output$multi_preview <- renderDataTable({
    req(compiled_data())
    datatable(
      compiled_data(),
      options = list(
        dom = '<"top-container"l f>rtip'
      )
    )
  })
  
  output$download_multi <- downloadHandler(
    filename = function() { "compiled_file.csv" },
    content = function(file) {
      req(compiled_data())
      write_csv(compiled_data(), file)
    }
  )
  
  # Toggle menu visibility when clicking the menu button
  observeEvent(input$menu_button, {
    session$sendCustomMessage("toggleMenu", "menu_dropdown")
  })
}


shinyApp(ui = ui, server = server)
