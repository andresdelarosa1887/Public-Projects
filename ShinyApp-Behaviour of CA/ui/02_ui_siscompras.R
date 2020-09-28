

tabPanel("Indicadores SISCOMPRAS",
fluidPage(
  headerPanel('Relacion de las Ponderaciones del Indicador SISCOMPRAS'),
  h3("Resultados 2018"),
  sidebarPanel(
    wellPanel(
      h3("Seleccion de Variables"),
      selectInput(inputId = 'xcol2',
                  label = 'Seleccione la variable X:',
                  choices= names(data_sismap_2),
                  selected="ResultadoFinal2_T2"),
      selectInput(inputId = 'ycol2',
                  label = 'Seleccione la variable Y:',
                  choices= names(data_sismap_2),
                  selected="ResultadoFinal_T3")
    ),
    h6(textOutput("nota2")),
    wellPanel(
      h3("Cantidad de Clusteres"),
      numericInput(inputId ='clusters2',
                   label= 'Cantidad:',2,
                   min = 1, max = 9)
    ),
    h3("Descagar Datos:"),
    wellPanel(
      downloadButton("download_data2", "Descargar csv")
    )
  ),
  mainPanel(
    h3("Grafico de Dispersion"),
    plotOutput('plot22', brush="plot_brush"),
    h4(textOutput("description2")),
    br(),
    h3("Tabla de Datos"), 
    DT:: dataTableOutput(outputId= "info2")
  )
))
