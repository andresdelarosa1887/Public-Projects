

#################User Interface#####################
fluidPage(
  tags$style(HTML("
    .tabbable > .nav > li > a                  {background-color: gray;  color:black}
    .tabbable > .nav > li > a[data-value='t1'] {background-color: red;   color:white}
    .tabbable > .nav > li > a[data-value='t2'] {background-color: blue;  color:white}
    .tabbable > .nav > li > a[data-value='t3'] {background-color: green; color:white}
    .tabbable > .nav > li[class=active]    > a {background-color: black; color:white}")),
  tags$head(tags$style(HTML("
                              .shiny-split-layout > div {
                                overflow: visible;
                              }
                              "))),
  theme = shinytheme("flatly"),
navbarPage("Monitoreo Ciudadano- Unidades de Compra", 
  source("ui/01_ui_unidades_general.R", local= TRUE, encoding = "UTF-8")$value ##No mover esto de lugar por favor
#  , tabPanel("Comportamiento General Relativo",
#           fluidPage(
#   headerPanel('Unidades de Compra- Comportamiento Variables SNCCP'),
#   sidebarPanel(
#     wellPanel(
#       h3("Selección de Indicadores"),
#       selectInput(inputId = 'periodo6033',
#                   label = 'Periodo',
#                   choices= levels(as.factor(segmentacion_unidad2$gestion)),
#                   selected="contratos"),
#       selectInput(inputId = 'xcol',
#                   label = 'Variable X',
#                   choices= names(segmentacion_unidad2)[3:11],
#                   selected="contratos"),
#       selectInput(inputId = 'ycol',
#                   label = 'Variable Y',
#                   choices= names(segmentacion_unidad2)[3:11],
#                   selected="proveedores_distintos")
#     ),
#     h6(textOutput("nota")),
#     wellPanel(
#       h3("Cantidad de Agrupaciones"),
#       numericInput(inputId ='clusters',
#                    label= 'Cantidad:',3,
#                    min = 1, max = 9)
#     )),
#   mainPanel(
#     h3("Gráfico de Dispersión"),
#     plotOutput('plot1', brush="plot_brush"),
#     #h4(textOutput("description")),
#     h3("Tabla de Datos"), 
#     DT:: dataTableOutput(outputId= "info")
#   ))
# )

))

