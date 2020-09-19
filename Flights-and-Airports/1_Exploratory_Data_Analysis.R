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

#Parte 2 
#########Punto 2 Ejercicio 5 #######################
#Numero 4 del punto 1, En que Dia de la semana ocurren la menor cantidad de retrasos en el aterrizaje 
vuelos_ano$ArrDelay[vuelos_ano$ArrDelay == "NA"] <- "0"
datos.arrdelay <- subset(vuelos_ano, as.numeric(ArrDelay)>0) #Vuelos que se retrasaron 

Delay_llegada_dia  <-data.frame(datos.arrdelay%>%  filter(!is.na(ArrDelay)) %>%group_by(Year,DayOfWeek) %>% dplyr::summarize(Cantidad_Vuelos = n()))

ggplot(Delay_llegada_dia, aes(x=DayOfWeek,y=as.numeric(Cantidad_Vuelos), group=Year))+
  geom_line(aes(color=Year)) +
labs(title="Cantidad de Vuelos retrasados en el Aterrizaje por Dia", subtitle="Patron anual") 

#############Punto 2 Ejercicio 6- ###################
#En cuales horario ocurren los mayores retrasos en el despegue (Suma de retrasos agrupado por mes y hora)
vuelos_ano$DepDelay[vuelos_ano$DepDelay == "NA"] <- "0"
describe(vuelos_ano$DepDelay)
horas.delay <- subset(vuelos_ano, as.numeric(DepDelay)>0) #Que tengan retrasos en el despegue

#Sacando los horarios mas ocupados
horas.delay$Hour <- paste(strrep("0",(4-nchar(horas.delay$CRSDepTime))),horas.delay$CRSDepTime , sep='')
horas.delay$Hour_2 <- substring(horas.delay$Hour, 1, 2)

datos.Delay_hora <-data.frame(horas.delay %>%group_by(Month, Hour_2) %>% dplyr::summarize(Suma_Retrasos = sum(as.numeric(DepDelay), na.rm=TRUE))
                              %>% arrange(desc(Suma_Retrasos)))
ggplot(datos.Delay_hora, aes(x=Hour_2,y=as.numeric(Suma_Retrasos), group=Month))+
geom_line(aes(color=Month)) +
labs(title="Mayores retrasos en el Despegue por Hora", subtitle="Patron mensual") 


#############Punto 2 Ejercicio 7#################
#Numero 7 del punto, En cuales meses ocurren los mayores retrasos
vuelos_ano$DepDelay[vuelos_ano$DepDelay == "NA"] <- "0"
describe(vuelos_ano$DepDelay)
meses.delay <- subset(vuelos_ano, as.numeric(DepDelay)>0)
describe(datos.delay$DepDelay) #Vuelos que se retrasarion (con el depdelay mayor a 1)

mes_Delay <-data.frame(meses.delay%>%  filter(!is.na(DepDelay)) %>%group_by(Year, Month) %>% dplyr::summarize(Suma_Retrasos = sum(as.numeric(DepDelay), na.rm=TRUE))
                       %>% arrange(desc(Suma_Retrasos), .by_group= TRUE))
mes_Delay$Month <- as.numeric(mes_Delay$Month)
meses <- order(mes_Delay$Month)
mes_Delay[meses, ]
ggplot(mes_Delay, aes(x=as.factor(Month),y=as.numeric(Suma_Retrasos), group=Year))+
  geom_line(aes(color=Year)) +
  labs(title="Mayores retrasos en el Despegue por Mes", subtitle="Patron anual")


################Punto 2 Ejercicio 8###############
#Dentro de los meses con mas retrasos ver los dias que tienen mas retraso 
mes_Delay_2 <-data.frame(meses.delay%>%  filter(!is.na(DepDelay)) %>%group_by(Month) %>% dplyr::summarize(Suma_Retrasos = sum(as.numeric(DepDelay), na.rm=TRUE))
                         %>% arrange(desc(Suma_Retrasos)))
#Los 5 meses con mas retraso- diciembre, julio, junio, agosto, marzo
#Descartar el 1990 
meses_Delay_2 <-data.frame(meses.delay %>% filter(Month %in% c("12", "7","6", "8", "3")))
mesi_Delay_2 <-data.frame(meses_Delay_2%>%  filter(!is.na(DepDelay)) %>%group_by(Month, DayofMonth) %>% dplyr::summarize(Suma_Retrasos = sum(as.numeric(DepDelay), na.rm=TRUE))
                          %>% arrange(desc(Suma_Retrasos)))  

mesi_Delay_2$DayofMonth <- as.numeric(mesi_Delay_2$DayofMonth)
dias <- order(mesi_Delay_2$DayofMonth)
mesi_Delay_2[dias, ]

ggplot(mesi_Delay_2, aes(x=as.factor(DayofMonth),y=as.numeric(Suma_Retrasos), group=Month))+
  geom_line(aes(color=Month)) +
  labs(title="Mayores retrasos en el Despegue por dia del mes\nEn los meses con mayor retraso", subtitle="Patron anual")

################Punto 2 Ejercicio 9.1#####################
#Trabajando con los cancelados, de los meses mas retrasados tambien cuales son los dias con mayor retraso 
cancelados <-data.frame(vuelos_ano %>% filter(Cancelled == 1))
meses_cancelados <-data.frame(cancelados %>% filter(Month %in% c("12", "7","6", "8", "3")))
meses_cancelados_2 <-data.frame(meses_cancelados %>% group_by(DayofMonth, CancellationCode) %>% dplyr::summarize(Cantidad_Cancelacion = n(), na.rm=TRUE))
                                  
meses_cancelados_2$DayofMonth <- as.numeric(meses_cancelados_2$DayofMonth)
dias_c <- order(meses_cancelados_2$DayofMonth)
meses_cancelados_2[dias_c, ]

ggplot(meses_cancelados_2, aes(x=as.factor(DayofMonth),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por dia\nEn los meses con mayor retraso", subtitle="Patron Codigo Cancelacion")

#############Punto 2 Ejercicio 9.2####################
#Haciendolo por tipo de cancelacion

patron_cancelaciones <-data.frame(vuelos_ano %>% group_by(Year,Month, Cancelled,CancellationCode) %>% dplyr::summarize(Cantidad_Cancelacion = n(), na.rm=TRUE))
head(patron_cancelaciones)
cancelados_66 <-data.frame(patron_cancelaciones %>% filter(Cancelled == 1))

cancelados_66$Month <- as.numeric(cancelados_66$Month)
cancelados_order <- order(cancelados_66$Month)
cancelados_66[cancelados_order, ]

#En el Año 1990 por tipo de cancelacion
cancelados_1990 <-data.frame(cancelados_66%>% filter(Year ==1990))
ggplot(cancelados_1990, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses  en el Año 1990", subtitle="Patron Codigo Cancelacion")

#En el Año 1990 por tipo de cancelacion
cancelados_2000 <-data.frame(cancelados_66%>% filter(Year ==2000))
ggplot(cancelados_2000, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses en el Año 2000", subtitle="Patron Codigo Cancelacion")


#En el año 2005 por tipo de cancelacion
cancelados_2005 <-data.frame(cancelados_66%>% filter(Year ==2005))
ggplot(cancelados_2005, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses en el Año 2005", subtitle="Patron Codigo Cancelacion")

#En el año 2008 por tipo de cancelacion
cancelados_2008 <-data.frame(cancelados_66%>% filter(Year ==2008))
ggplot(cancelados_2008, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses en el Año 2008", subtitle="Patron Codigo Cancelacion")




