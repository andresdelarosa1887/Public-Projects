


#################User Interface#####################
fluidPage(theme = shinytheme("darkly"),
          navbarPage("Intelligent Portfolio Decision", 

                     source("ui/01_stock_analysis/ui_stock_analysis.R", local= TRUE)$value, ##No mover esto de lugar por favor
                     tags$style(type="text/css",
                                ".shiny-output-error { visibility: hidden; }",
                                ".shiny-output-error:before { visibility: hidden; }")
                     # tabPanel("Portfolio Analysis",
                     #          source("ui/02_portfolio_management/ui_portfolio_selection.R", local= TRUE)$value)
                     
                     ))




