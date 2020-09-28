

function(input, output) {
  
  
  ##Stock Analysis Section######
  ##Selecting the stocks according to the selected categories
  filtered_stocks <- reactive({
    ticker_source %>%
      filter(Category %in% input$sector)
  })
  
  ##Rendering the companies of the selected categories into the user interface
  output$stockssymbols <- renderUI({
    df <- filtered_stocks()
    multiInput(inputId = "symbol",
                 label = strong("Stock Symbol:"),
                 choices= levels(as.factor(df$CompanySymbol)),
               options = list(limit = 2,
                              non_selected_header = "Choose between:",
                              selected_header = "You have selected:"))
      
      })
  
  ##Selecting the ticker symbol that is going to be used to query the data in the API
  stock_data0 <- reactive({
    filtered_stocks() %>% 
      filter(CompanySymbol %in% input$symbol) %>% 
      select(Ticker)
  })
    
  ##Making the query of the selected stocks- This is the principal dataset in this section
stock_data <- eventReactive(
  input$getquery, {
  if (length(stock_data0()$Ticker)==1) {
    stock_data0()$Ticker %>%
      tq_get(get= "stock.prices",from = input$periodo[1],to = input$periodo[2]) 
  } else {
    stock_data0()$Ticker %>%
      tq_get(get= "stock.prices",from = input$periodo[1],to = input$periodo[2]) %>% 
      group_by(symbol)}
  })


####Daily Analysis
xts_daily <- eventReactive(
  input$getquery, { 
  if (length(input$symbol)==1) {
    stock_data() %>%
      select(date,adjusted) %>%
      tk_xts(silent = TRUE)
  } else {
    stock_data() %>%
      select(symbol,date,adjusted) %>%
      spread(symbol,adjusted) %>%
      tk_xts(silent = TRUE)}
})

stocks_daily_returns <- eventReactive(
  input$getquery,{
        stock_data() %>% 
        tq_transmute(select = adjusted,
        mutate_fun = periodReturn,   
        period="daily", 
        type="arithmetic") %>% 
        ungroup()})

xts_daily_returns  <- eventReactive(
  input$getquery,{ 
  if (length(input$symbol)==1) {
    stocks_daily_returns() %>%
      select(date,daily.returns) %>%
      tk_xts(silent = TRUE)
  } else {
    stocks_daily_returns() %>%
      select(symbol,date,daily.returns) %>%
      spread(symbol,daily.returns) %>%
      tk_xts(silent = TRUE)}
})


######Monthly Analysis
##Converting the daily price data to monthly price data
stocks_monthly <- eventReactive(
  input$getquery,{
  stock_data() %>%
  tq_transmute(select = c(adjusted,volume), 
               mutate_fun = to.monthly,     
               indexAt = "lastof") %>%      
    ungroup() %>% mutate(date=as.yearmon(date))})


###Calculating the monthly returns of the prices
stocks_returns <- eventReactive(
  input$getquery,{
  stock_data() %>% 
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,   
               period="monthly", 
               type="arithmetic") %>% 
  ungroup() %>% mutate(date=as.yearmon(date))
  })


##Converting the data into an XTS object and Spreading the data according to the amount of received data
xts_returns <- eventReactive(
  input$getquery,{ 
  if (length(input$symbol)==1) {
  stocks_returns() %>%
    select(date,monthly.returns) %>%
    tk_xts(silent = TRUE)
  } else {
    stocks_returns() %>%
      select(symbol,date,monthly.returns) %>%
      spread(symbol,monthly.returns) %>%
      tk_xts(silent = TRUE)}
  })



#Returns and prices chart and summary tables-
source("server/01_stock_analysis/01_returns_chart.R", local= TRUE) 

##Histogram of returns chart and tables -
source("server/01_stock_analysis/02_histogram_chart.R", local= TRUE) 

##Risk Free Interest Rate Selection and data modifications
source("server/01_stock_analysis/03_risk_free_IR.R", local= TRUE)

##Correlation Analysis tab
source("server/01_stock_analysis/04_correlation_chart.R", local= TRUE)

##Drawdowns Tables
source("server/01_stock_analysis/06_table_of_drawdowns.R", local= TRUE)

##Portolio Management Section####
source("server/02_portfolio_management/01_portfolio_management.R", local= TRUE)

#source("server/04_correlation_chart.R", local= TRUE)
#source("server/04_correlation_chart.R", local= TRUE)

}

