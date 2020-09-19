rm(list=ls())
getwd()
#Librerias
library(RSQLite)
library(dplyr)
library(Hmisc)
library(reshape2)
library(ggplot2)
#Haciendo la conexion con la bases de datos
Conn= dbConnect(SQLite(), dbname="PROYECTO_FINAL.db")
cantidad_registros <- dbGetQuery(Conn, "select * from FINAL_TOTAL")
vuelos_ano <- data.frame(cantidad_registros)
ls(vuelos_ano)
dbDisconnect(Conn)

#VIENDO LAS VARIABLES DEL DATASET
#"ActualElapsedTime" "AirTime"           "ArrDelay"         
# "ArrTime"           "CancellationCode"  "Cancelled"        
# "CarrierDelay"      "CRSArrTime"        "CRSDepTime"       
# "CRSElapsedTime"    "DayofMonth"        "DayOfWeek"        
# "DepDelay"          "DepTime"           "Dest"             
# "Distance"          "Diverted"          "FlightNum"        
# "LateAircraftDelay" "Month"             "NASDelay"         
# "Origin"            "SecurityDelay"     "TailNum"          
# "TaxiIn"            "TaxiOut"           "UniqueCarrier"    
#"WeatherDelay"      "Year"             

#################################Punto 2 Ejercicio 1#########################################################
#Frecuencias relativas y absolutas de 4 variables diferentes 
Num_vuelos_ano   <-data.frame(vuelos_ano%>%  filter(!is.na(FlightNum)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(FlightNum)))
Aviones_ano  <-data.frame(vuelos_ano%>%  filter(!is.na(TailNum)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(TailNum)))
Origen_ano   <-data.frame(vuelos_ano%>%  filter(!is.na(Origin)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(Origin)))
Destino_ano  <-data.frame(vuelos_ano%>%  filter(!is.na(Dest)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(Dest)))


#Numero de vuelos por ano
Num_vuelos_ano$Frecuencia_Relativa <- prop.table(Num_vuelos_ano$Unique_Elements)
Num_vuelos_ano$Frecuencia_Acumulada <- cumsum(Num_vuelos_ano$Unique_Elements)
Num_vuelos_ano$Frecuencia_Relativa_Acumulada <- cumsum(Num_vuelos_ano$Frecuencia_Relativa)
Num_vuelos_ano

ggplot(Num_vuelos_ano, aes(x=Year, y=Unique_Elements)) + geom_bar(stat = "identity")+
geom_text(aes(y=as.numeric(Unique_Elements), label=as.numeric(Unique_Elements), vjust=0.0,  size=4.0, fontface="bold")) +
  labs(title="Numero de vuelos distintos por año") +
  xlab(label="Año")+
  theme(
        plot.title = element_text(size=16),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=11),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=10, color="black", face="bold")) 


#Numero de Aviones por Año 
Avionesdist_ano$Frecuencia_Relativa <- prop.table(Aviones_ano$Unique_Elements)
Avionesdist_ano$Frecuencia_Acumulada <- cumsum(Aviones_ano$Unique_Elements)
Avionesdist_ano$Frecuencia_Relativa_Acumulada <- cumsum(Aviones_ano$Frecuencia_Relativa)
View(Avionesdis_ano)

ggplot(Aviones_ano, aes(x=Year, y=Unique_Elements)) + geom_bar(stat = "identity")+
  geom_text(aes(y=as.numeric(Unique_Elements), label=as.numeric(Unique_Elements), vjust=0.0,  size=4.0, fontface="bold")) +
  labs(title="Numero de Aviones distintos por Año") +
  xlab(label="Año")+
  theme_minimal()  +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=16),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=11),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=10, color="black", face="bold")) 



#Numero de ciudades de Origen por año 
Origen_ano$Frecuencia_Relativa <- prop.table(Origen_ano$Unique_Elements)
Origen_ano$Frecuencia_Acumulada <- cumsum(Origen_ano$Unique_Elements)
Origen_ano$Frecuencia_Relativa_Acumulada <- cumsum(Origen_ano$Frecuencia_Relativa)
Origen_ano

ggplot(Origen_ano, aes(x=Year, y=Unique_Elements)) + geom_bar(stat = "identity")+
  geom_text(aes(y=as.numeric(Unique_Elements), label=as.numeric(Unique_Elements), vjust=0.0,  size=4.0, fontface="bold")) +
  labs(title="Ciudad de Origen distinta") +
  xlab(label="Año")+
  theme_minimal()  +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=16),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=11),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=10, color="black", face="bold")) 


#Numero de ciudades de Destino por año 
Destino_ano$Frecuencia_Relativa <- prop.table(Destino_ano$Unique_Elements)
Destino_ano$Frecuencia_Acumulada <- cumsum(Destino_ano$Unique_Elements)
Destino_ano$Frecuencia_Relativa_Acumulada <- cumsum(Destino_ano$Frecuencia_Relativa)
Destino_ano
hist(Altura$Altura)

ggplot(Destino_ano, aes(x=Year, y=Unique_Elements)) + geom_bar(stat = "identity")+
  geom_text(aes(y=as.numeric(Unique_Elements), label=as.numeric(Unique_Elements), vjust=0.0,  size=4.0, fontface="bold")) +
  labs(title="Ciudad de Origen distinta") +
  xlab(label="Año")+
  theme_minimal()  +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=16),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=11),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=10, color="black", face="bold")) 


############################Punto 2 Ejercicio 2 & 3 ##################################
cant_ano   <-data.frame(vuelos_ano%>% group_by(Year) %>% dplyr::summarize(Cantidad_Vuelos = n()))
cant_ano
cant_mes  <-data.frame(vuelos_ano%>%  group_by(Month) %>% dplyr::summarize(Cantidad_Vuelos = n()))
cant_origen <-data.frame(vuelos_ano%>% group_by(Origin) %>% dplyr::summarize(Cantidad_Vuelos = n()))
cant_destino <-data.frame(vuelos_ano%>% group_by(Dest) %>% dplyr::summarize(Cantidad_Vuelos = n()))
cant_destino

#Cantidad de vuelos por año
ggplot(cant_ano, aes(x=Year, y=Cantidad_Vuelos)) + geom_bar(stat = "identity", color="blue", group=1, fill="red")+
geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ","), vjust=0.0,  size=4.0, fontface="bold"))+
labs(title="Cantidad de Vuelos por Año")

#Cantidad de vuelos por mes 
cant_mes$Month <- as.numeric(cant_mes$Month)
mesi_order <- order(cant_mes$Month)
cant_mes <- cant_mes[mesi_order, ]
ggplot(cant_mes, aes(x=factor(Month), y=Cantidad_Vuelos)) + geom_bar(stat = "identity", color="red", group=1, fill="pink")+
geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ",")), vjust=0.0,  size=4.0, fontface="bold")+
labs(title="Cantidad de Vuelos por Mes")

#Cantidad  de vuelos por destino Top 6
sumatoria<- order(cant_destino$Cantidad_Vuelos)
cant_destino <- cant_destino[sumatoria, ]
cant_destino <- tail(cant_destino)
cant_destino
ggplot(cant_destino, aes(x=factor(Dest), y=Cantidad_Vuelos)) +
  geom_bar(stat = "identity", color="black", group=1, fill="orange")+
  geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ",")), vjust=0.0,  size=4.0, fontface="bold")+
  labs(title="Cantidad de Vuelos por Destino (Top 6)")+
  coord_flip()

#Cantidad  de vuelos por Origen Top 6
sumatoria<- order(cant_origen$Cantidad_Vuelos)
cant_origen <- cant_origen[sumatoria, ]
cant_origen <- tail(cant_origen)
cant_origen
ggplot(cant_origen, aes(x=factor(Origin), y=Cantidad_Vuelos)) +
  geom_bar(stat = "identity", color="orange", group=1, fill="purple")+
  geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ",")), vjust=0.0,  size=4.0, fontface="bold")+
  labs(title="Cantidad de Vuelos por Origen (Top 6)")+
  coord_flip()


###########################Punto 2 Ejercicio 4 ###################################
#En que aeropuertos ocurren los mayores retrasos en el despegue
vuelos_ano$DepDelay[vuelos_ano$DepDelay == "NA"] <- "0"
datos.delay <- subset(vuelos_ano, as.numeric(DepDelay)>0)
 # se buscan los Vuelos que se retrasarion (con el depdelay mayor a 1)

#Viendo la suma del del delay de cada aeropuerto Historico  a ver que aeropuerto historicamente tiene el mayor (de los que tienen un delay mayor a 0)
Aviones_Delay <-data.frame(datos.delay%>%  filter(!is.na(DepDelay)) %>%group_by(Origin) %>% dplyr::summarize(Suma_Retrasos = sum(as.numeric(DepDelay), na.rm=TRUE))
                           %>% arrange(desc(Suma_Retrasos)))

#Si se filtra esta tabla por ano se puede ver cual tiene el delay promedio por ano mas grande
Aviones_ano  <-data.frame(datos.delay%>%  filter(!is.na(DepDelay)) %>%group_by(Year, Origin) %>% dplyr::summarize(Retraso = sum(as.numeric(DepDelay), na.rm=TRUE)) 
                          %>% arrange(desc(Retraso)))

#5 Aerolineas cada ano 
Aerolineas_1990 <- data.frame(Aviones_ano%>% filter(Year ==1990))
Aerolineas_2000 <- data.frame(Aviones_ano%>% filter(Year ==2000))
Aerolineas_2005 <- data.frame(Aviones_ano%>% filter(Year ==2005))
Aerolineas_2008 <- data.frame(Aviones_ano%>% filter(Year ==2008))

Aerolineas_1990_h <- head(Aerolineas_1990) 
Aerolineas_2000_h <-head(Aerolineas_2000)
Aerolineas_2005_h <-head(Aerolineas_2005)
Aerolineas_2008_h <-head(Aerolineas_2008)

Aerolineas_mas_retrasadas <- rbind(Aerolineas_1990_h, Aerolineas_2000_h,Aerolineas_2005_h,Aerolineas_2008_h)
Aerolineas_mas_retrasadas
Aerolineas_mas_retrasadas$Horas <- Aerolineas_mas_retrasadas$Retraso/60000

#Grafico del Top 6 de Aerolineas mas retrasadas en el despegue
ggplot(data=Aerolineas_mas_retrasadas, aes(x=factor(Year), y=Horas, fill=factor(Origin))) +
  geom_bar(stat="identity", width=0.91, position=position_dodge()) +
  geom_text(aes(y=Horas,label=prettyNum(round(Horas,digits=0),big.mark = ",")),  vjust=0.0, color="gray18", size=4.0, fontface="bold", position=position_dodge(0.9)) +
  labs(title="Top 6 de los Aeropuertos  más retrasados en el Despegue", subtitle="Por año") +
  xlab(label="Año")+
  labs(caption="Los datos originalmente vienen en minutos, se transformaron a miles de horas", fill="Aeropuerto\nde Origen")+
  ylab(label="Retraso en Miles de Horas") +
  theme(plot.title = element_text(size=16),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=11),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=10, color="black", face="bold")) 


