

function(input, output) {
## Periodicidad del tiempo
  datos66 <- reactive({
    datos %>% filter(periodicidad %in% input$periodicidad)
  })
##Decision de la Escala
  datos77 <- reactive({ 
    if(input$escalalog=="si")
      datos66() %>% mutate(TOTAL_CONTRATADO= log(TOTAL_CONTRATADO))
    else{
      datos66() %>% select(APROBACION, MODALIDAD_2, TOTAL_CONTRATADO)}
    })
##Filtro de las modalidades y del tiempo de entrenamiento 
  datos2 <- reactive({ 
    datos77() %>% filter(MODALIDAD_2==input$modalidad & APROBACION > input$periodo[1] & APROBACION <= input$periodo[2]) 
  })
##Cambiando los nombres para que funcionen en fbprophet
  datos3 <- reactive({ 
    datos2() %>% select(ds= APROBACION, y= TOTAL_CONTRATADO)
    })
#Creando el objeto de prophet y realizando las proyecciones de acuerdo a la periodicidad seleccionada
   datos4 <- reactive({ 
     prophet(datos3())
     })
##Definiendo la periodicidad de la proyeccion
   future <- reactive({ 
     forecastperiodicity <-  switch(input$periodicidad, 
            "trimestral"="quarter",
            "mensual"="month",
            "diaria"="day")
     make_future_dataframe(datos4(), periods = input$numeroperiodos, freq = forecastperiodicity)
     })
##Haciendo la prediccion
   forecast <- reactive({
     predict(datos4(), future())
   })
#####Graficos#####
##Grafico 1
  forecast2 <- reactive({ 
     forecast() %>% select(ds, yhat, yhat_lower, yhat_upper)
     })
  # output$plot1 <- renderPlot({
  # plot(datos4(), forecast2())
  # })
##Grafico de los componentes
  output$plot1 <- renderPlot({
    m <- datos4()
    datos <- forecast()
    prophet_plot_components(m, datos)
  })
##Grafico 2
graphdata <- reactive({
  forecast() %>% select(ds, yhat)
})
##Datos originales del diccionario de prophet
prophetdic <- reactive({ 
  datos4()$history
  })
prophetdic2 <- reactive({ 
  prophetdic() %>% select(ds, y)
  })
##Uniendo la Y y su predicción
graphdata2 <- reactive({
  left_join(graphdata(), prophetdic2())
  })
##Convirtiendo la variable en un objeto de tiempo
graphdata3 <- reactive({
    testdata <- graphdata2()
    testdata$ds <- as.character(testdata$ds)
    testdata
})
graphdatatime <- reactive({ 
    testdata <- graphdata3()
    testdata2 <- xts(x=testdata[,-1], order.by= as.POSIXct(testdata$ds))
    testdata2
 })
#Graficando en highcharter el grafico 
output$plot3 <- renderHighchart({
    df <- graphdatatime()
    highchart(type="stock") %>%
    hc_add_series(df$y, type="line", name= "Valor Adjudicado") %>%
    hc_add_series(df$yhat, type="line", name="Proyección") %>%
    hc_tooltip(pointformat= '{point.x: %Y-%m-%d}
                           {point.y: .0f}') %>%
    hc_add_theme(hc_theme_sandsignika()) %>%
    hc_title(text=paste("Contratos Transados por el Portal Transaccional -",input$modalidad)) %>%
    hc_subtitle(text = paste("Monto Contratado-Periodicidad:",
                             ifelse(input$periodicidad=="trimestral","Trimestral",
                                    ifelse(input$periodicidad=="mensual", "Mensual", "Diaria")), "- Escala:",
                             ifelse(input$escalalog=="si", "Logaritmica", "Datos originales"))) %>%
    hc_yAxis(title= "Periodo de Adjudicación")
})


##Grafico General
##Tabla de los datos 
## Periodicidad del tiempo
datos668 <- reactive({
  datos766 %>% filter(periodicidad %in% input$periodicidad)
})
##Decision de la Escala
datos778 <- reactive({ 
  if(input$escalalog=="si")
    datos668() %>% mutate(TOTAL_CONTRATADO= log(TOTAL_CONTRATADO)) %>% select(APROBACION, TOTAL_CONTRATADO)
  else{
    datos668() %>% select(APROBACION, TOTAL_CONTRATADO)}
})
##Tiempo a Mostrar
datos2986 <- reactive({ 
  datos778() %>% filter(APROBACION >= input$periodo[1] & APROBACION <= input$periodo[2]) 
})


##Convirtiendo la variable en un objeto de tiempo
graphdata3999 <- reactive({
  testdata <- datos2986()
  testdata$APROBACION <- as.character(testdata$APROBACION)
  testdata
})

graphdatatime89898 <- reactive({ 
  testdata <- graphdata3999()
  testdata2 <- xts(x=testdata[,-1], order.by= as.POSIXct(testdata$APROBACION))
  testdata2
})

output$plot2 <- renderHighchart({
  df <- graphdatatime89898()
  highchart(type="stock") %>%
    hc_add_series(df, type="line", name= "Valor Adjudicado") %>%
    hc_tooltip(pointformat= '{point.x: %Y-%m-%d}
                           {point.y: .0f}') %>%
    hc_add_theme(hc_theme_sandsignika()) %>%
    hc_title(text=paste("Contratos Transados por el Portal Transaccional")) %>%
    hc_subtitle(text = paste("Periodicidad:",
                             ifelse(input$periodicidad=="trimestral","Trimestral",
                                    ifelse(input$periodicidad=="mensual", "Mensual", "Diaria")), "- Escala:",
                             ifelse(input$escalalog=="si", "Logaritmica", "Datos originales"))) %>%
    hc_yAxis(title= "Periodo de Adjudicación")
})


##Cajas de informacion
##Datos para las cajas de informacion 
datoscaja1 <- reactive({
  datos668() %>%
    filter(APROBACION >= input$periodo[1] & APROBACION <= input$periodo[2]) %>%
    select(periodicidad,TOTAL_CONTRATADO, CONTRATOS) %>%
    group_by(periodicidad) %>%
    summarise(total_contratado= sum(TOTAL_CONTRATADO), cantidad_contratos= sum(CONTRATOS), 
              contrato_promedio= (sum(TOTAL_CONTRATADO)/sum(CONTRATOS)))
})

output$adjudicaciones <- renderValueBox({
  valueBox(value=h3("Monto total Adjudicado", style="font-size: 120%;"),
           subtitle= paste("RD$",format(round(datoscaja1()$total_contratado,0), big.mark = ",")),
           icon = icon("money"),
           color = "blue")
})

output$contratos <- renderValueBox({
  valueBox(value=h3("Cantidad de Contratos", style="font-size: 120%;"),
           subtitle= format(round(as.numeric(datoscaja1()$cantidad_contratos),0), big.mark = ","),
           icon = icon("file"),
           color ="red")
})

output$valorpromedio <- renderValueBox({
  valueBox(value=h3("Contrato Promedio", style="font-size: 120%;"),
           subtitle= paste("RD$",format(round(datoscaja1()$contrato_promedio,0), big.mark = ",")),
           icon = icon("group"),
           color = "purple")
})

##Tabla de los datos 
datos_tabla <- reactive({
  datos21 %>%
    filter(FechaAprobacion > input$periodo33[1] & FechaAprobacion <= input$periodo33[2])
})

output$table1 <- DT::renderDataTable({
  datatable(datos_tabla(), options=list(pageLength=15), extensions="Responsive") %>%
    formatCurrency(c('ValorContratado'), "RD$", mark=",", digits=0)  
})




datos_pie <- reactive({
  datos_tabla() %>%
    select(Modalidad, ValorContratado) %>% 
    group_by(Modalidad) %>% 
    summarise(TotalContratado= sum(ValorContratado))%>%
        mutate(Participacion= ((TotalContratado/ sum(TotalContratado))*100))
  
})



output$grafico_pie <- renderHighchart({
  df2<- datos_pie()
  hc <- hchart(df2, "pie", hcaes(name = Modalidad, y = Participacion)) %>%
    hc_title(text=paste("Participación de lo Transado por Modalidad de Compra")) %>%
    hc_plotOptions(pie = list(colorByPoint = TRUE, size = 250, dataLabels = list(enabled = FALSE))) %>%
    hc_add_theme(hc_theme_sandsignika()) %>%
    hc_tooltip(pointFormat = '{point.y:.0f}%')
  hc
})





}















