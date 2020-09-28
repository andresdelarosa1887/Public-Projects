

tabPanel("Indicadores SISCOMPRAS vs. SNCCP",
fluidPage(
  headerPanel('Relacion de los indicadores SISCOMPRA con Otras Variables del SNCCP'),
  h3("Resultados 2018"),
  sidebarPanel(
    wellPanel(
      h3("Seleccion de Variables"),
      selectInput(inputId = 'xcol3',
                  label = 'Seleccione la variable X:',
                  choices= names(data_analisis),
                  selected="contratos"),
      selectInput(inputId = 'ycol3',
                  label = 'Seleccione la variable Y:',
                  choices= names(data_analisis),
                  selected="proveedores_distintos")
    ),
    h6(textOutput("nota3")),
    wellPanel(
      h3("Cantidad de Clusteres"),
      numericInput(inputId ='clusters3',
                   label= 'Cantidad:',3,
                   min = 1, max = 9)
    ),
    h3("Descagar Datos:"),
    wellPanel(
      downloadButton("download_data3", "Descargar csv")
    )
  ),
  mainPanel(
    h3("Grafico de Dispersion"),
    plotOutput('plot3', brush="plot_brush"),
    h4(textOutput("description3")),
    br(),
    h3("Tabla de Datos"), 
    DT:: dataTableOutput(outputId= "info3")
  )     
  
         ))