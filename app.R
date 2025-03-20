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
        font-size: 15px;
        font-weight: bold;
      }

      .intro-text {
        padding-right: 50px !important;
        font-size: 14px;
        width: 95vw;
      }

      .intro-text a {
        color: #306cc9 !important; /* Change to your desired color */
        text-decoration: none; /* Remove underline */
      }
      
      /* Change link color on hover */
      .intro-text a:hover {
        color: #306cc9 !important; /* Darker color when hovering */
        text-decoration: underline; /* Add underline on hover */
      }

      .shiny-file-input-progress {
        height: 10px !important;
      }

      .shiny-input-container > label {
        font-family: 'Montserrat', sans-serif !important;
        font-size: 14px !important;
        color: #333 !important;
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

  tabsetPanel(
    # INFORMAÇÃO TAB
    tabPanel("Informação",
             fluidRow(
               column(6,
                      p("Automatização com o 'sismar'", class = "intro-heading"),
                      p("Análise eficiente de dados exportados dos sistemas de informação do Ministério da Saúde (MISAU) normalmente requer acções de processamento como a pivotagem, a eliminação/combinação de variáveis e a engenharia de dimensões úteis para análise. O pacote 'sismar' (desenvolvido na linguagem R de programação) automatiza essas acções de transformação, facilitando assim a exploração e análise de dados.  Este portal web fornece uma interface visual para aceder às ferramentas do 'sismar' e transformar ficheiros providenciados pelo utilizador.", class = "intro-text"),
                      
                      p("Complementaridade ao SISMA", class = "intro-heading"), 
                      p("O pacote “sismar” foi desenvolvido como ferramenta complementar destinada a funcionar no âmbito mais alargado dos sistemas de informação do MISAU. A sua existência confere mais valor aos sistemas de base como o SISMA, fornecendo ferramentas que permitem uma análise mais fácil das estatísticas geradas por esses sistemas. O diagrama abaixo ilustra a relação entre o SISMA e a funcionalidade do pacote 'sismar'.", class = "intro-text")
               )
             ),
             # Separate row for the image
             fluidRow(
               column(12, 
                      div(style = "text-align: center; margin-top: 20px; margin-bottom: 20px;",
                          img(src = "diagrama_dados.png", width = "650px", height = "199px")
                      )
               )
             ),
             fluidRow(
               column(6,
                      p("Documentação Completa do 'sismar'", class = "intro-heading"),
                      p("A documentação completa sobre o “sismar”, incluindo o código-fonte do pacote, pode ser encontrada no Github.  Além disso, é possível aceder a artigos de ajuda que demonstram casos de utilização do pacote (por exemplo, como gerar e descarregar ficheiros de exportação SISMA compatíveis) através da página de documentação de referência do pacote em linha.", class = "intro-text")
               )
             ),
    ),
    
    # ARRUMAÇÃO TAB
    tabPanel("Arrumação",
             fluidRow(
               column(6,
                      p("Arrumação de Exportações SISMA", class = "intro-heading"),
                      p("Utilize os controlos abaixo para 1) carregar o seu relatório padrão do SIMSA; 2) processar o mesmo num formato amigável para análise; e 3) descarregar o ficheiro processado ao seu disco local. Para mais informações sobre a extração de ficheiros SISMA compatíveis com este aplicativo, consulte este ",
                        a("artigo de ajuda", href = "https://usaid-mozambique.github.io/sismar/articles/export-sisma.html", target = "_blank"),
                        ".", class = "intro-text")
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
                      p("Compilação de Ficheiros Processados", class = "intro-heading"),
                      p("Selecione abaixo múltiplos ficheiros já processados para a compilação deles.", class = "intro-text")
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
    show("preview-container")
  })
  
  output$preview <- renderDataTable({
    req(processed_data())
    datatable(processed_data(), options = list(dom = '<"top-container"l f>rtip'))
  })
  
  output$download <- downloadHandler(
    filename = function() { "processed_file.csv" },
    content = function(file) {
      req(processed_data())
      write_csv(processed_data(), file)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)