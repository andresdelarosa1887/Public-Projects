

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
                valueBoxOutput("worldGDP"),
                valueBoxOutput("worldInflation"),
                valueBoxOutput("worldOil")),
              fluidRow(
                box(width=12,tabsetPanel(type = "tabs",
                                           tabPanel(title = "Scatter Plot", 
                                                    fluidRow(
                                                    source("ui/ui_scatterplot2.R", local= TRUE)$value,
                                                    box(width=9, status="danger", solidHeader=TRUE,
                                                    highchartOutput(outputId ="scatterplot", height = "650px"))),
                                                    h3("Data Table",align="center"),
                                                    DT::dataTableOutput("table1")),
                                                    tabPanel(title= "Historical View",
                                                    fluidRow(
                                                    source("ui/ui_conditionalpanels2.R", local= TRUE)$value,
                                                    box(width=9, status="primary", solidHeader=TRUE,
                                                    highchartOutput("historicos", height = "650px"))),
                                                    h3("Data Table",align="center"),
                                                    DT::dataTableOutput("table2")
                                                   ))))),
            source("ui/ui_map.R", local= TRUE)$value
            #,
            #source("ui/ui_conditionalpanels.R", local= TRUE)$value
           #,
            #source("ui/ui_scatterplot.R", local= TRUE)$value
            ##put the file with the conditional stuff
            )))
header <- dashboardHeader(title=paste("World Economic Outlook International Monetary Fund- Database as of April 2020"), tags$li(class = "dropdown",
                                      tags$style(".main-header {max-height: 90px}"),
                                      tags$style(".main-header .logo {height: 90px}")),
                          tags$li(a(href = 'https://www.imf.org/external/pubs/ft/weo/2018/02/weodata/index.aspx',
                                    img(src = 'IMF.png',
                                        title = "Pagina de la DGCP", height="60px")),
                                  # style = "padding-top:48px; padding-bottom:48px;"),
                                  class = "dropdown"),
                          titleWidth= "780px")
dashboardPage(skin="blue", header, sidebar, body)

