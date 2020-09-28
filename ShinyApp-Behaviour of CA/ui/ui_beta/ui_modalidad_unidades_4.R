

fluidRow(selectInput(inputId="unidad747",
                     label=NULL,
                     choices=levels(as.factor(data_modalidadv2$UNIDAD_COMPRA2)),
                     multiple =FALSE,
                     selected="DIRECCION GENERAL DE COMUNICACION"),
         selectInput(inputId="periodoanalisis",
                     label= NULL, 
                     choices = levels(as.factor(data_modalidadv2$gestion)),
                     selected= "2019"), 
         highchartOutput(outputId ="modalidad_desglose9898"), 
         br(),
         h3("Tabla de Datos"), 
         DT::dataTableOutput("tabla666"))




