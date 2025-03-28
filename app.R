
library(shiny)
library(tidyverse)
library(usethis)
library(janitor)
library(shinythemes)
library(shinyjs)
library(DT)
library(shinyWidgets)
library(sismar)

# Define UI for application
ui <- fluidPage(
  useShinyjs(),
  theme = shinytheme("flatly"),
  
  # load google fonts
  tags$link(href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;700&family=Lato:wght@300;400;700&display=swap", rel="stylesheet"),
  
  tags$head(
    tags$script(HTML("
      $(document).on('shiny:value', function(e) {
        setTimeout(function() {
          $('.irs-grid-text').each(function() {
            var val = parseInt($(this).text());
            if ([2020, 2025, 2030, 2035, 2040].includes(val)) {
              $(this).css({'color': '#333', 'font-weight': 'bold'});
            } else {
              $(this).css({'color': '#ccc', 'font-weight': 'normal'});
            }
          });
        }, 200);
      });
    ")),
        
    tags$style(HTML("
      body {
        font-family: 'Montserrat', sans-serif;
        padding-top: 110px;
        margin-left: 15px;
        margin-right: 15px;
        @media (max-width: 991px) {
        .no-stack > .col-sm-6 {
          float: left;
          width: 50%;
        }
        }
      }
      
      /* Hide the default radio */
      input[type='radio'] {
        appearance: none;
        -webkit-appearance: none;
        background-color: #fff;
        margin: 0 5px 0 0;
        font: inherit;
        color: currentColor;
        width: 16px;
        height: 16px;
        border: 2px solid #999;
        border-radius: 50%;
        display: inline-block;
        position: relative;
        top: 3px;
        cursor: pointer;
        vertical-align: middle;
        transition: border 0.2s ease;
      }

      /* Selected state (yellow border) */
      input[type='radio']:checked {
        border-color: #007268;
      }

      /* Inner dot when selected */
      input[type='radio']:checked::before {
        content: '';
        width: 8px;
        height: 8px;
        background-color: #007268;
        border-radius: 50%;
        position: absolute;
        top: 2px;
        left: 2px;
      }
      

      h1, h2, h3, h4, h5, h6, .intro-heading {
        font-family: 'Lato', sans-serif;
      }

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

      .banner-text {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 47px;
      }

      .banner-logo {
        height: 60px;
        vertical-align: middle;
      }

      .sub-banner {
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #d5d417;
        color: white;
        font-size: 18px;
        height: 2px;
        width: 100vw;
        position: fixed;
        top: 70px;
        left: 0;
        z-index: 999;
      }

      .nav-tabs > li > a {
        font-size: 13px !important;
        color: #95a5a6 !important;
        font-weight: normal !important;
        background-color: white !important;
        border: 1px solid #d9dddc !important;
        border-bottom: 1px solid #d9dddc !important;
      }

      .nav-tabs > li.active > a,
      .nav-tabs > li.active > a:hover {
        color: #333333 !important;
        font-weight: bold !important;
        background-color: white !important;
        border: 1px solid #d9dddc !important;
        border-bottom: none !important;
      }

      .nav-tabs > li > a:hover {
        color: #005a50 !important;
      }

      .tab-content {
        margin-top: 25px !important;
        padding-left: 10px !important;
        padding-right: 10px !important;
      }
      
      .side-by-side-wrapper {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        gap: 40px;
        margin-top: 10px;
      }
      
      .left-panel, .right-panel {
        flex: 1;
        min-width: 400;
        padding: 10px;
        background-color: white;
        min-height: 400px; /* Ensures divider has height */
      }
      
      .divider {
        width: 1px;
        background-color: #d9dddc;
        align-self: stretch;
        flex-shrink: 0;
      }

      .intro-heading {
        font-size: 15px;
        font-weight: bold;
      }

      /* Default for all intro-text */
      .intro-text {
        font-size: 14px;
      }

      /* Scoped fix for Processamento tab only */
      #processamento-panel .intro-text {
        padding-right: 10px !important;
        width: 100%;
        overflow-x: auto;
        box-sizing: border-box;
      }

      .intro-text a {
        color: #306cc9 !important;
        text-decoration: none;
      }

      .intro-text a:hover {
        color: #306cc9 !important;
        text-decoration: underline;
      }

      .shiny-file-input-progress {
        height: 10px !important;
      }

      .shiny-input-container > label {
        font-family: 'Montserrat', sans-serif !important;
        font-size: 14px !important;
        color: #333 !important;
      }

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
      
      .custom-top-controls {
        display: flex;
        justify-content: start;
        align-items: center;
        gap: 20px;
        flex-wrap: wrap;
      }

      /* Customize slider color */
      .irs-bar {
        background-color: #007268 !important;  /* Your green for selected range */
        height: 4px !important;
      }
      
      /* Customize unselected slider color */
      .irs-line {
        background: #ccc !important;
        height: 4px !important;
        border: none !important;
        border-radius: 2px !important;
      }
      
      /* Customize slider tick label */
      .irs-grid-text {
        background: none !important;
        padding: 2px 5px;
        border-radius: 3px;
        font-weight: normal;
        color: #999 !important;  
      }
      
      /* Customize vertical tick lines */
      .irs-grid-pol {
        background-color: #ccc !important;
      }
      
      /* Customize label above the left handle of a range slider */
      .irs-from {
        font-size: 10px !important;
        background-color: #007268 !important;
        border-color: #007268 !important;
        color: white !important;
      }
      
      /* Customize label above the right handle of a range slider */
      .irs-to {
        font-size: 10px !important;
        background-color: #007268 !important;
        border-color: #007268 !important;
        color: white !important;
      }
      
      /* Customize draggable handle on the slider */
      .irs-slider {
        background-color: #007268 !important;
        border-color: #007268 !important;
      }
      
      /* Customize slider circular handles */
      .irs-handle {
        width: 14px !important;
        height: 14px !important;
        top: 20px !important;
        background: white !important;
        border: 2px solid #007268 !important;
      }
      
      /* Customize data preview visual box */
      #preview-wrapper {
        padding: 10px;
        background-color: #ffffff;
        border-top: 1px solid #d9dddc;
        margin-top: 30px;
      }

      /* Customize the main content area */
      .dataTable tbody tr {
        height: 20px !important;
        line-height: 1 !important;
      }
      
    ")),
    
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    )
    
  ),
  
  div(class = "banner",
      div(class = "banner-text",
          img(src = "apple-touch-icon-180x180.png", class = "banner-logo"),
          span("sismar::")
      )
  ),
  
  div(class = "sub-banner"),
  
  tabsetPanel(
    tabPanel("Informação",
             fluidRow(
               column(12,
                      p("Automatização com o 'sismar'", class = "intro-heading"),
                      p("Análise eficiente de dados exportados dos sistemas de informação do Ministério da Saúde (MISAU) normalmente requer acções de processamento como a pivotagem, a eliminação/combinação de variáveis e a engenharia de dimensões úteis para análise. O pacote 'sismar' (desenvolvido na linguagem R de programação) automatiza essas acções de transformação, facilitando assim a exploração e análise de dados.  Este portal web fornece uma interface visual para aceder às ferramentas do 'sismar' e transformar ficheiros providenciados pelo utilizador.", class = "intro-text"),
                      
                      p("Complementaridade ao SISMA", class = "intro-heading"), 
                      p("O pacote “sismar” foi desenvolvido como ferramenta complementar destinada a funcionar no âmbito mais alargado dos sistemas de informação do MISAU. A sua existência confere mais valor aos sistemas de base como o SISMA, fornecendo ferramentas que permitem uma análise mais fácil das estatísticas geradas por esses sistemas. O diagrama abaixo ilustra a relação entre o SISMA e a funcionalidade do pacote 'sismar'.", class = "intro-text")
               )
             ),
             fluidRow(
               column(12, 
                      div(style = "text-align: center; margin-top: 20px; margin-bottom: 20px;",
                          img(src = "diagrama_dados.png", width = "650px", height = "199px")
                      )
               )
             ),
             fluidRow(
               column(12,
                      p("Documentação Completa do 'sismar'", class = "intro-heading"),
                      p("A documentação completa sobre o “sismar”, incluindo o código-fonte do pacote, pode ser encontrada no ",
                        a("Github", href = "https://github.com/usaid-mozambique/sismar", target = "_blank"),
                        ". Além disso, é possível aceder a artigos de ajuda que demonstram casos de utilização do pacote (por exemplo, como gerar e descarregar ficheiros de exportação SISMA compatíveis) através da página de ",
                        a("documentação", href = "https://usaid-mozambique.github.io/sismar/index.html", target = "_blank"),
                        "de referência do pacote em linha.", class = "intro-text"),
               )
             )
    ),
    
    tabPanel("Processamento SISMA",
             div(id = "processamento-panel",
                 
                 # Side-by-side panels
                 div(class = "side-by-side-wrapper",
                     
                     # Left Panel
                     div(class = "left-panel",
                         div(style = "padding-top: 15px;",
                             p(HTML("<i class='fa fa-broom'></i> Arrumação de Exportações SISMA"), class = "intro-heading"),
                             p("Utilize os controlos abaixo para 1) carregar o seu relatório padrão do SIMSA; 2) processar o mesmo num formato amigável para análise; e 3) descarregar o ficheiro processado ao seu disco local. Para mais informações sobre a extração de ficheiros SISMA compatíveis com este aplicativo, consulte este ",
                               a("artigo de ajuda.", href = "https://usaid-mozambique.github.io/sismar/articles/export-sisma.html", target = "_blank"),
                               class = "intro-text")
                         ),
                         div(style = "margin-top: 25px;",
                             id = "csv_file_wrapper",
                             fileInput("csv_file", "Escolha ficheiro .csv", accept = ".csv")
                         ),
                         div(class = "btn-container",
                             actionButton("process", "Processar", class = "btn btn-primary"),
                             downloadButton("download", "Descarregar", class = "btn btn-secondary")
                         )
                     ),
                     
                     # Divider
                     div(class = "divider"),
                     
                     # Right Panel
                     div(class = "right-panel",
                         div(style = "padding-top: 15px;",
                             p(HTML("<i class='fa fa-layer-group'></i> Compilação de Ficheiros Processados"), class = "intro-heading"),
                             p("As vezes, é útil compilar ficheiros processados para vários programas (por exemplo, TARV, ANC e CCR) ou períodos (por exemplo, anos 2023, 2024 e 2025).  Selecione vários ficheiros processados com os controlos abaixo. Note que, utilizando o botão “Procurar”, pode-se selecionar múltiplos ficheiros .csv ou .txt.", class = "intro-text")
                         ),
                         div(style = "margin-top: 25px;",
                             id = "multi_csv_file_wrapper",
                             fileInput("multi_csv_file", "Escolha ficheiros .csv ou .txt", accept = c(".csv", ".txt"), multiple = TRUE),
                             uiOutput("multi_filenames")
                         ),
                         div(class = "btn-container",
                             actionButton("process_multi", "Compilar", class = "btn btn-primary"),
                             downloadButton("download_multi", "Descarregar", class = "btn btn-secondary")
                         )
                     )
                 ),
                 
                 
                 div(id = "preview-wrapper",
                     style = "display: none; margin-top: 25px;",
                     
                     uiOutput("preview_header"),
                     
                     div(id = "preview-container", dataTableOutput("preview")),
                     div(id = "multi-preview-container", dataTableOutput("multi_preview"))
                 )
                 
             )
    ),
    
    tabPanel("Processamento Pop.",
             div(id = "pop-panel",
                 div(style = "padding-top: 22px;",
                     p(HTML("<i class='fa fa-people-group'></i> Processamento de Projecções Demográficas do INE"), class = "intro-heading"),
                     p("Use esta aba para carregar ficheiros populacionais do INE (.xlsx), selecionar os anos/sheets para análise, definir o nível de idade, e descarregar um ficheiro arrumado e consolidado.", class = "intro-text")
                 ),
                 fileInput("pop_files", "Escolha ficheiros .xlsx", multiple = TRUE, accept = ".xlsx"),
                 uiOutput("pop_sheet_selector"),
                 radioButtons("pop_age_level", "Nível de Idade:",
                              choices = c("Exato" = "Exact", "Agrupado" = "Grouped"),
                              selected = "Exact", inline = TRUE),
                 actionButton("process_pop", "Processar", class = "btn btn-primary"),
                 downloadButton("download_pop", "Descarregar", class = "btn btn-secondary"),
                 dataTableOutput("pop_preview")
             )
      ),
    
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

# Server logic
server <- function(input, output, session) {
  options(shiny.maxRequestSize = 100*1024^2)
  
  
  last_used <- reactiveVal(NULL)
  processed_data <- reactiveVal(NULL)
  pop_processed_data <- reactiveVal(NULL)
  
  
  observeEvent(input$process, {
    req(input$csv_file)
    processed <- process_sisma_export(input$csv_file$datapath)
    processed_data(processed)
    
    shinyjs::reset("multi_csv_file_wrapper")
    
    hide("multi-preview-container")
    show("preview-wrapper")
    show("preview-container")
    
    last_used("arrumacao")
    
  })
  
  
  output$preview <- renderDataTable({
    req(processed_data())
    datatable(
      processed_data(),
      options = list(
        dom = '<"custom-top-controls"lf>rtip'
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
  
  # Reactive for multi-file processing
  multi_processed_data <- reactiveVal(NULL)
  
  observeEvent(input$process_multi, {
    req(input$multi_csv_file)
    
    shinyjs::reset("csv_file_wrapper")
    
    files <- input$multi_csv_file
    
    tryCatch({
      all_data <- map2(files$datapath, files$name, function(path, name) {
        if (grepl("\\.txt$", name, ignore.case = TRUE)) {
          read_delim(path, delim = "\t", show_col_types = FALSE)
        } else {
          read_csv(path, show_col_types = FALSE)
        }
      }) %>% bind_rows()
      
      multi_processed_data(all_data)
      
      last_used("compilacao")
      
      hide("preview-container")
      show("preview-wrapper")
      show("multi-preview-container")
      
    }, error = function(e) {
      showModal(modalDialog(
        title = "Erro ao ler ficheiros",
        paste("Erro ao processar os ficheiros:", e$message),
        easyClose = TRUE
      ))
    })
  })
  
  
  output$multi_preview <- renderDataTable({
    req(multi_processed_data())
    datatable(
      multi_processed_data(),
      options = list(
        dom = '<"custom-top-controls"lf>rtip'
      )
    )
  })
  
  output$download_multi <- downloadHandler(
    filename = function() { "compilado.csv" },
    content = function(file) {
      req(multi_processed_data())
      write_csv(multi_processed_data(), file)
    }
  )
  
  output$preview_header <- renderUI({
    if (last_used() == "arrumacao" && !is.null(input$csv_file)) {
      tags$p(
        class = "intro-text",
        tags$strong(HTML("<i class='fa fa-broom'></i> Ficheiro processado: ")),
        input$csv_file$name
      )
    } else if (last_used() == "compilacao" && !is.null(input$multi_csv_file)) {
      tags$p(
        class = "intro-text",
        tags$strong(HTML("<i class='fa fa-layer-group'></i> Ficheiros compilados: ")),
        paste(input$multi_csv_file$name, collapse = ", ")
      )
    }
  })
  
  
  # Reactive to store the processed demographic data
  processed_pop_data <- reactiveVal(NULL)
  
  observeEvent(input$process_pop, {
    req(input$pop_files)
    req(input$pop_years_range)
    
    selected_years <- input$pop_years_range
    
    tryCatch({
      processed <- sismar::process_pop_ine(
        file_inventory = input$pop_files$datapath,
        input_sheets = selected_years,
        age_level = input$pop_age_level
      )
      pop_processed_data(processed)
    }, error = function(e) {
      showModal(modalDialog(
        title = "Erro",
        paste("Erro ao processar os ficheiros:", e$message),
        easyClose = TRUE
      ))
    })
  })
  
  pop_sheet_choices <- reactive({
    req(input$pop_files)
    
    # Read all sheet names from all uploaded files
    unique(unlist(lapply(input$pop_files$datapath, readxl::excel_sheets)))
  })

  output$pop_sheet_selector <- renderUI({
    req(input$pop_files)
    sheet_names <- unique(unlist(lapply(input$pop_files$datapath, readxl::excel_sheets)))
    numeric_sheets <- suppressWarnings(as.numeric(sheet_names))
    valid_years <- sort(na.omit(numeric_sheets))
    
    major_ticks <- seq(2020, 2100, by = 5)
    choices <- as.character(valid_years)
    selected <- c(min(choices), max(choices))
    
    sliderTextInput(
      inputId = "pop_years_range",
      label = "Selecione o intervalo de anos:",
      choices = choices,
      selected = selected,
      grid = TRUE
    )
  })
  
  # Render DataTable for preview
  output$pop_preview <- renderDataTable({
    req(pop_processed_data())
    datatable(pop_processed_data(), options = list(pageLength = 10))
  })
  
  output$download_pop <- downloadHandler(
    filename = function() { "projecoes_processadas.csv" },
    content = function(file) {
      write_csv(pop_processed_data(), file)
    }
  )
}
  
shinyApp(ui = ui, server = server)
