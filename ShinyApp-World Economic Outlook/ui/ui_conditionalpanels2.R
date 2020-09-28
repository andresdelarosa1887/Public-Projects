box(width=3, status="success", solidHeader=TRUE, 
    title="Select the Categories for the Historical Graph",
    selectizeInput(inputId="WorldRegion",
                   label="Select the Region of the World",
                   choices= c("Advanced Economies"=                                                "ADVANCED_EC",
                              "Euro Area"=                                                         "EURO_AREA",
                              "MAjor Advanced Economies (G7)" =                                    "M_ADVANCED_G7",
                              "Other Advanced (excluding G7 and euro Area)"=                       "OTHER_ADVANCED",    
                              "European Union"=                                                    "EUROPEAN_UNION",
                              "Emerging market and developing economies" =                         "EMERDEVP_EC",      
                              "Commonwealth and Independent States" =                              "COMMWIS",
                              "Emerging and developing Asia" =                                     "EMERDEVP_ASIA",
                              "ASEAN-5"=                                                           "ASEAN_5",
                              "Emerging and developing Europe"=                                    "EMERDEVP_EUROPE",
                              "Latin America and the Caribbean"=                                   "LATIN_AMERICA_CAB",
                              "Middle East, North Africa, Afghanistan, and Pakistan"=              "ME_NA_AF_PAK",
                              "Middle East and North Africa" =                                     "ME_NA",
                              "Sub-Saharan Africa"=                                               "SUBSAHARA_AF",
                              "All Countries"= "ALL"),
                   multiple =TRUE, options = list(maxItems = 1L),
                   selected="LATIN_AMERICA_CAB"),
    conditionalPanel( 
      condition= "input.WorldRegion=='ALL'", 
      selectInput(inputId="countriesbyregion0",
                  label="Select the Countries for the Graph",
                  choices=    levels(as.factor(weo_datos$Country)), 
                  multiple=TRUE, selected="Dominican Republic")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='ADVANCED_EC'", 
      selectInput(inputId="countriesbyregion1",
                  label="Select the Countries for the Graph",
                  choices=    levels(as.factor(weo_advanced$Country)), 
                  multiple=TRUE, selected="United States")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='EURO_AREA'", 
      selectInput(inputId="countriesbyregion2", 
                  label="Select the Countries for the Graph",
                  choices= levels(as.factor(weo_euro$Country)), 
                  multiple=TRUE, selected="Germany")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='M_ADVANCED_G7'", 
      selectInput(inputId="countriesbyregion3", 
                  label="Select the Countries for the Graph",
                  choices= levels(as.factor(weo_advancedg7$Country)), 
                  multiple=TRUE, selected="France")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='OTHER_ADVANCED'", 
      selectInput(inputId="countriesbyregion4", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_otheradvanced$Country)), 
                  multiple=TRUE, selected="Australia")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='EUROPEAN_UNION'", 
      selectInput(inputId="countriesbyregion5", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_eropeanunion$Country)), 
                  multiple=TRUE, selected="Spain")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='EMERDEVP_EC'", 
      selectInput(inputId="countriesbyregion6", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_emergingmarkets$Country)), 
                  multiple=TRUE, selected="China")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='COMMWIS'", 
      selectInput(inputId="countriesbyregion7", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_commonwealth$Country)), 
                  multiple=TRUE, selected="Georgia")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='EMERDEVP_ASIA'", 
      selectInput(inputId="countriesbyregion8", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_emdevpasia$Country)), 
                  multiple=TRUE, selected="India")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='ASEAN_5'", 
      selectInput(inputId="countriesbyregion9", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_ASEAN5$Country)), 
                  multiple=TRUE, selected="Indonesia")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='EMERDEVP_EUROPE'", 
      selectInput(inputId="countriesbyregion10", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_emdeveurope$Country)), 
                  multiple=TRUE, selected="Kosovo")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='LATIN_AMERICA_CAB'", 
      selectInput(inputId="countriesbyregion11", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_latinamerica$Country)), 
                  multiple=TRUE,selected="Dominican Republic")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='ME_NA_AF_PAK'", 
      selectInput(inputId="countriesbyregion12", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_menaafpak$Country)), 
                  multiple=TRUE, selected= "Iraq")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='ME_NA'", 
      selectInput(inputId="countriesbyregion13", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_mena$Country)), 
                  multiple=TRUE, selected="Algeria")),
    
    conditionalPanel( 
      condition= "input.WorldRegion=='SUBSAHARA_AF'", 
      selectInput(inputId="countriesbyregion14", 
                  label="Select the Countries for the Graph",
                  choices=levels(as.factor(weo_subsaharaafrica$Country)), 
                  multiple=TRUE, selected="Chad")),
    selectizeInput(inputId="selvar",  
                   label= "Select the Variables:",
                   choices=c(#Balance of the government
                     "Gross domestic product, current prices, US dollars" =  "NGDPD1",
                     "Gross domestic product per capita, current prices" = "NGDPDPC1",
                     "Gross domestic product, constant prices, percent Change" = "NGDP_RPCH1", 
                     "Gross domestic product, current prices, PPP IUS" = "PPPGDP1",
                     "General government Revenue, percent of GDP" = "GGR_NGDP1",
                     "General government total expenditure, percent of GDP" = "GGX_NGDP1",
                     "General government net lending/borrowing, percent of GDP" = "GGXCNL_NGDP1",
                     "Total Investment, percent of GDP"= "NID_NGDP1",
                     "Gross National Savings, percent of GDP" = "NGSD_NGDP1",
                     "Output Gap, percent of potential GDP"= "NGAP_NPGDP1",
                     #Basic Economic Variables
                     "Employment, Milions" = "LE1",
                     "Population, Millions"= "LP1",
                     "Unemployment rate" = "LUR",
                     #External Sector
                     "Volume of exports of goods and services, percent change" = "TX_RPCH1",
                     "Volume of exports of goods, percent change" ="TXG_RPCH1", 
                     "Volume of imports of goods, percent change" = "TMG_RPCH1", 
                     "Current account balance, US dollars"= "BCA1",
                     "Current account balance, percent of GDP" = "BCA_NGDPD1",
                     #Inflation 
                     "Inflation, average consumer prices, index"= "PCPI1",  
                     "Inflation, average consumer prices, percent change" = "PCPIPCH1",  
                     "Inflation, end of period consumer prices, index" = "PCPIE1", 
                     "Inflation, end of period consumer prices, percent change" = "PCPIEPCH1",  
                     #Conversion Rate
                     "Implied PPP conversion rate, National currency per current international dollar" = "PPPEX1",   
                     "Gross domestic product, current prices, Purchasing power parity; international dollars" = "PPPGDP1",  
                     "Gross domestic product per capita, current prices, Expressed in GDP in PPP dollars per person" = "PPPPC1",  
                     "Gross domestic product based on purchasing-power-parity (PPP) share of world total, percent" = "PPPSH1"),
                   multiple =TRUE, options = list(maxItems = 2L),
                   selected=c("PCPI1","PPPSH1")),
    sliderInput("slider",
                label=h3("Select the Range of Years"),
                min=1980, max=2023,
                value = c(2018, 2022)))