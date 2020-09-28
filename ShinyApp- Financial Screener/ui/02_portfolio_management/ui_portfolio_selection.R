


##Three tables 

##Sector Selection
##Stock selection 
fluidPage(
  headerPanel('Portfolio Selection'),
  fluidRow(   
    column(width =12,
           h2("Select the Portfolio:"),
           selectizeInput(inputId = "sector77", label = strong("Company Sector:"),
                          choices = levels(as.factor(ticker_source$Category)),
                          multiple = TRUE, 
                          selected = c("Energy", "Technology", "Capital Goods"),
                          options = list(maxItems = 25)),
           uiOutput("stockssymbols77"),
           h6("Selected Ticks:"),
           textOutput("PortfolioSelection")
           )))