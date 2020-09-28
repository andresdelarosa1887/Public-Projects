

#Other version of the sidebar
# sidebar <- dashboardSidebar(
#   collapsed = TRUE, sidebarMenu(
#     menuItem("World Economic Outlook data", tabName = "worldeconomicoutlook", icon=icon("money")), 
#     menuItem("Central Bank", tabname="centralbank", icon= icon("building"))
#   ))
#Disabeling the sidebar
sidebar <- dashboardSidebar(disable = TRUE)
#Better UI

body<-dashboardBody <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
  tags$style(".fa-chart-line {color:#E87722}"),
  tags$style(".fa-chart-bar {color:#D3D3D3}"),
  tabItem("worldeconomicoutlook",
          fluidRow(
            tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: gray;  color:black}
    .tabbable > .nav > li > a[data-value='t1'] {background-color: red;   color:white}
    .tabbable > .nav > li > a[data-value='t2'] {background-color: blue;  color:white}
    .tabbable > .nav > li > a[data-value='t3'] {background-color: green; color:white}
    .tabbable > .nav > li[class=active]    > a {background-color: black; color:white}")),
            theme=shinytheme("readable"),
            column(
              width=9,
              fluidRow(
                valueBoxOutput("adjudicaciones"),
                valueBoxOutput("contratos"),
                valueBoxOutput("valorpromedio")
                ),
              fluidRow(
                box(width=12,tabsetPanel(type = "tabs",
                                         tabPanel(title = "Datos Históricos", 
                                                  fluidRow(
                                                    box(width=12, status="danger", solidHeader=TRUE,
                                                        highchartOutput(outputId ="plot2", height = "325px"),
                                                        highchartOutput(outputId ="plot3", height = "325px"))),
                                                  h3("Búsqueda de Contratos",align="center"),
                                                  dateRangeInput(inputId = 'periodo33',
                                                                 label = 'Periodo de la Búsqueda de Contratos',
                                                                 start= '2018-01-01', 
                                                                 end= max(datos$APROBACION),
                                                                 min= min(datos$APROBACION), 
                                                                 max= max(datos$APROBACION), 
                                                                 format= "dd/mm/yy",
                                                                 separator= " - "),
                                                  DT::dataTableOutput("table1")),
                                         tabPanel(title= "Componentes de la Estimación",
                                                  fluidRow(
                                                    box(width=12, status="primary", solidHeader=TRUE,
                                                        plotOutput("plot1", height = "750px"))),
                                                  h3("Búsqueda de Contratos",align="center")
                                         ))))),
              box(width=3, status="info", solidHeader=TRUE, 
              title="Parámetros de la Estimación",
              h3("Transformaciones"),
              radioButtons(inputId="periodicidad",
                 label="Periodicidad:", 
                 choices= c("Trimestral"= "trimestral",
                            "Mensual"="mensual",
                            "Diaria"= "diaria")),
             h3("Escala:"),
        radioButtons(inputId="escalalog",
                 label= "Escala Logarítmica",
                 choices= c("Aplicar Logaritmo"= "si",
                            "Serie Original"= "no"),
                 selected= "no"),
        h3("Parámetros"),
        selectInput(inputId = 'modalidad',
                label = 'Modalidad de Compra:',
                choices= levels(as.factor(datos$MODALIDAD_2)),
                selected="contratos"),
        dateRangeInput(inputId = 'periodo',
                   label = 'Periodo de Entrenamiento de la Proyección',
                   start= '2018-01-01', 
                   end= max(datos$APROBACION),
                   min= min(datos$APROBACION), 
                   max= max(datos$APROBACION), 
                   format= "dd/mm/yy",
                   separator= " - "),
       sliderInput(inputId= "numeroperiodos", 
                label= "Periodos a Proyectar",
                min=1, 
                max=7,
                value=1),
       highchartOutput(outputId ="grafico_pie", height = "325px")
       ))))

header <- dashboardHeader(title=paste("Sistema de Proyecciones"), tags$li(class = "dropdown",
                                                                                  tags$style(".main-header {max-height: 90px}"),
                                                                                  tags$style(".main-header .logo {height: 90px}")),
                          tags$li(a(href = 'https://www.imf.org/external/pubs/ft/weo/2018/02/weodata/index.aspx',
                                    img(src = 'DGCP.png',
                                        title = "imf", height="60px")),
                                  # style = "padding-top:48px; padding-bottom:48px;"),
                                  class = "dropdown",
                          titleWidth= "600px"
                          ))
dashboardPage(skin="blue", header, sidebar, body)



