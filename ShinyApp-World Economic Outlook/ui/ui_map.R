

  column(width=3,
         box(title = "Important Considerations:", width = 12, solidHeader = TRUE, background = "olive",
           "write something important"), br(), br(),    
          box(status="warning", solidHeader=TRUE, width=12,
          title="Map of the World",
          leafletOutput("mymap", height="650px"),
          absolutePanel(top=20, left=70, textInput("target_zone", "" , "Latin America")))
)

#height = 1000