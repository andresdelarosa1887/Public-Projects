rm(list=ls())
getwd()
#Librerias
library(dplyr)
library(Hmisc)
library(reshape2)
library(ggplot2)
library(readr)
muestra_total <- read_csv("muestra_total.csv")
##############################Filtrando el data set por año#############
muestra_1990 <-data.frame(vuelos_ano%>% filter(Year ==1990))
muestra_2000 <-data.frame(vuelos_ano%>% filter(Year ==2000))
muestra_2005 <-data.frame(vuelos_ano%>% filter(Year ==2005))
muestra_2008 <-data.frame(vuelos_ano%>% filter(Year ==2008))


##################Funcion que crea el numero de filas aleatorio basados en la aleatoriedad sistematica (algoritmo tomado de internet) ##########
sys.sample = function(N,n){
  k = ceiling(N/n)
  r = sample(1:k, 1)
  sys.samp = seq(r, r + k*(n-1), k)
}

#el n de cada año se tomo en base a un margen de error del 10% y un nivel de confianza del 95%
############# para el 1990#######################
random_r_1990 <- (sys.sample(5270893, 812378))
seleccion_1990 <-muestra_1990 %>% slice(random_r_1990)
############# para el 2000#######################
random_r_2000 <- (sys.sample(5683047, 821561))
seleccion_2000 <- muestra_2000 %>% slice(random_r_2000)
############# para el 2005#######################
random_r_2005 <- (sys.sample(7140585, 846541))
seleccion_2005 <- muestra_2005 %>% slice(random_r_2005)
############# para el 2008#######################
random_r_2008 <- (sys.sample(7009724, 844672))
seleccion_2008 <- muestra_2008 %>% slice(random_r_2008)
################muestra total###################################
muestra_total <- rbind(seleccion_1990,seleccion_2000, seleccion_2005, seleccion_2008)
library("rio")
export(muestra_total, "muestra_total.csv")

#Parte 1- Replica Documento proyecto_final_1.0 pero con la muestra 
#################################Punto 2 Ejercicio 1- Tomado de la Muestra#########################################################
#Frecuencias relativas y absolutas de 4 variables diferentes 
Num_muestra_total   <-data.frame(muestra_total%>%  filter(!is.na(FlightNum)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(FlightNum)))
Aviones_ano  <-data.frame(muestra_total%>%  filter(!is.na(TailNum)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(TailNum)))
Origen_ano   <-data.frame(muestra_total%>%  filter(!is.na(Origin)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(Origin)))
Destino_ano  <-data.frame(muestra_total%>%  filter(!is.na(Dest)) %>%group_by(Year) %>% summarise(Unique_Elements = n_distinct(Dest)))


#Numero de vuelos por ano
Num_muestra_total$Frecuencia_Relativa <- prop.table(Num_muestra_total$Unique_Elements)
Num_muestra_total$Frecuencia_Acumulada <- cumsum(Num_muestra_total$Unique_Elements)
Num_muestra_total$Frecuencia_Relativa_Acumulada <- cumsum(Num_muestra_total$Frecuencia_Relativa)
Num_muestra_total

ggplot(Num_muestra_total, aes(x=Year, y=Unique_Elements)) + geom_bar(stat = "identity")+
  geom_text(aes(y=as.numeric(Unique_Elements), label=as.numeric(Unique_Elements), vjust=0.0,  size=4.0, fontface="bold")) +
  labs(title="Numero de vuelos distintos por año- Tomado de la Muestra") +
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
  labs(title="Numero de Aviones distintos por Año- Tomado de la Muestra") +
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
  labs(title="Ciudad de Origen distinta- Tomado de la Muestra") +
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
  labs(title="Ciudad de Destino distinta- Tomado de la Muestra") +
  xlab(label="Año")+
  theme_minimal()  +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=16),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=11),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=10, color="black", face="bold")) 











#################################Punto 2 Ejercicio 2 & 3- Tomado de la Muestra ##################################
cant_ano   <-data.frame(muestra_total%>% group_by(Year) %>% dplyr::summarize(Cantidad_Vuelos = n()))
cant_mes  <-data.frame(muestra_total%>%  group_by(Month) %>% dplyr::summarize(Cantidad_Vuelos = n()))
cant_origen <-data.frame(muestra_total%>% group_by(Origin) %>% dplyr::summarize(Cantidad_Vuelos = n()))
cant_destino <-data.frame(muestra_total%>% group_by(Dest) %>% dplyr::summarize(Cantidad_Vuelos = n()))

#Cantidad de vuelos por año
ggplot(cant_ano, aes(x=Year, y=Cantidad_Vuelos)) + geom_bar(stat = "identity", color="blue", group=1, fill="red")+
  geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ","), vjust=0.0,  size=4.0, fontface="bold"))+
  labs(title="Cantidad de Vuelos por Año- Tomado de la Muestra")

#Cantidad de vuelos por mes 
cant_mes$Month <- as.numeric(cant_mes$Month)
mesi_order <- order(cant_mes$Month)
cant_mes <- cant_mes[mesi_order, ]
ggplot(cant_mes, aes(x=factor(Month), y=Cantidad_Vuelos)) + geom_bar(stat = "identity", color="red", group=1, fill="pink")+
  geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ",")), vjust=0.0,  size=4.0, fontface="bold")+
  labs(title="Cantidad de Vuelos por Mes- Tomado de la Muestra")

#Cantidad  de vuelos por destino Top 6
sumatoria<- order(cant_destino$Cantidad_Vuelos)
cant_destino <- cant_destino[sumatoria, ]
cant_destino <- tail(cant_destino)
cant_destino
ggplot(cant_destino, aes(x=factor(Dest), y=Cantidad_Vuelos)) +
  geom_bar(stat = "identity", color="black", group=1, fill="orange")+
  geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ",")), vjust=0.0,  size=4.0, fontface="bold")+
  labs(title="Cantidad de Vuelos por Destino (Top 6)- Tomado de la Muestra")+
  coord_flip()

#Cantidad  de vuelos por Origen Top 6
sumatoria<- order(cant_origen$Cantidad_Vuelos)
cant_origen <- cant_origen[sumatoria, ]
cant_origen <- tail(cant_origen)
cant_origen
ggplot(cant_origen, aes(x=factor(Origin), y=Cantidad_Vuelos)) +
  geom_bar(stat = "identity", color="orange", group=1, fill="purple")+
  geom_text(aes(y=as.numeric(Cantidad_Vuelos), label=prettyNum(round(Cantidad_Vuelos,digits=0),big.mark = ",")), vjust=0.0,  size=4.0, fontface="bold")+
  labs(title="Cantidad de Vuelos por Origen (Top 6) Tomado de la Muestra")+
  coord_flip()


###########################Punto 2 Ejercicio 4- Tomado de la Muestra###################################
#En que aeropuertos ocurren los mayores retrasos en el despegue
muestra_total$DepDelay[muestra_total$DepDelay == "NA"] <- "0"
datos.delay <- subset(muestra_total, as.numeric(DepDelay)>0)
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
  labs(title="Top 6 de los Aeropuertos  más retrasados en el Despegue", subtitle="Por año- Tomado de la Muestra") +
  xlab(label="Año")+
  labs(caption="Los datos originalmente vienen en minutos, se transformaron a miles de horas", fill="Aeropuerto\nde Origen")+
  ylab(label="Retraso en Miles de Horas") +
  theme(plot.title = element_text(size=16),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=11),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=10, color="black", face="bold")) 



#Parte 2- Replica Documento proyecto_final_2.0 pero con la muestra 
#########Punto 2 Ejercicio 5- Tomado de la Muestra #######################
#Numero 4 del punto 1, En que Dia de la semana ocurren la menor cantidad de retrasos en el aterrizaje 
muestra_total$ArrDelay[muestra_total$ArrDelay == "NA"] <- "0"
datos.arrdelay <- subset(muestra_total, as.numeric(ArrDelay)>0) #Vuelos que se retrasaron 

Delay_llegada_dia  <-data.frame(datos.arrdelay%>%  filter(!is.na(ArrDelay)) %>%group_by(Year,DayOfWeek) %>% dplyr::summarize(Cantidad_Vuelos = n()))

ggplot(Delay_llegada_dia, aes(x=DayOfWeek,y=as.numeric(Cantidad_Vuelos), group=Year))+
  geom_line(aes(color=Year)) +
  labs(title="Cantidad de Vuelos retrasados en el Aterrizaje por Dia", subtitle="Patron anual- Tomado de la Muestra") 

#############Punto 2 Ejercicio 6- Tomado de la Muestra-###################
#Ncuales horario ocurren los mayores retrasos en el despegue (Suma de retrasos agrupado por mes y hora)
muestra_total$DepDelay[muestra_total$DepDelay == "NA"] <- "0"
describe(muestra_total$DepDelay)
horas.delay <- subset(muestra_total, as.numeric(DepDelay)>0) #Que tengan retrasos en el despegue

#Sacando los horarios mas ocupados
horas.delay$Hour <- paste(strrep("0",(4-nchar(horas.delay$CRSDepTime))),horas.delay$CRSDepTime , sep='')
horas.delay$Hour_2 <- substring(horas.delay$Hour, 1, 2)

datos.Delay_hora <-data.frame(horas.delay %>%group_by(Month, Hour_2) %>% dplyr::summarize(Suma_Retrasos = sum(as.numeric(DepDelay), na.rm=TRUE))
                              %>% arrange(desc(Suma_Retrasos)))
ggplot(datos.Delay_hora, aes(x=Hour_2,y=as.numeric(Suma_Retrasos), group=Month))+
  geom_line(aes(color=Month)) +
  labs(title="Mayores retrasos en el Despegue por Hora Tomado de la Muestra", subtitle="Patron mensual") 


#############Punto 2 Ejercicio 7- Tomado de la Muestra#################
#Numero 7 del punto, En cuales meses ocurren los mayores retrasos
muestra_total$DepDelay[muestra_total$DepDelay == "NA"] <- "0"
describe(muestra_total$DepDelay)
meses.delay <- subset(muestra_total, as.numeric(DepDelay)>0)
describe(datos.delay$DepDelay) #Vuelos que se retrasarion (con el depdelay mayor a 1)

mes_Delay <-data.frame(meses.delay%>%  filter(!is.na(DepDelay)) %>%group_by(Year, Month) %>% dplyr::summarize(Suma_Retrasos = sum(as.numeric(DepDelay), na.rm=TRUE))
                       %>% arrange(desc(Suma_Retrasos), .by_group= TRUE))
mes_Delay$Month <- as.numeric(mes_Delay$Month)
meses <- order(mes_Delay$Month)
mes_Delay[meses, ]
ggplot(mes_Delay, aes(x=as.factor(Month),y=as.numeric(Suma_Retrasos), group=Year))+
  geom_line(aes(color=Year)) +
  labs(title="Mayores retrasos en el Despegue por Mes- Tomado de la Muestra", subtitle="Patron anual")


################Punto 2 Ejercicio 8- Tomado de la Muestra###############
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

################Punto 2 Ejercicio 9.1- Tomado de la Muestra#####################
#Trabajando con los cancelados, de los meses mas retrasados tambien cuales son los dias con mayor retraso 
cancelados <-data.frame(muestra_total %>% filter(Cancelled == 1))
meses_cancelados <-data.frame(cancelados %>% filter(Month %in% c("12", "7","6", "8", "3")))
meses_cancelados_2 <-data.frame(meses_cancelados %>% group_by(DayofMonth, CancellationCode) %>% dplyr::summarize(Cantidad_Cancelacion = n(), na.rm=TRUE))

meses_cancelados_2$DayofMonth <- as.numeric(meses_cancelados_2$DayofMonth)
dias_c <- order(meses_cancelados_2$DayofMonth)
meses_cancelados_2[dias_c, ]

ggplot(meses_cancelados_2, aes(x=as.factor(DayofMonth),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por dia\nEn los meses con mayor retraso", subtitle="Patron Codigo Cancelacion- Tomado de la Muestra")

#############Punto 2 Ejercicio 9.2- Tomado de la Muestra####################
#Haciendolo por tipo de cancelacion

patron_cancelaciones <-data.frame(muestra_total %>% group_by(Year,Month, Cancelled,CancellationCode) %>% dplyr::summarize(Cantidad_Cancelacion = n(), na.rm=TRUE))
head(patron_cancelaciones)
cancelados_66 <-data.frame(patron_cancelaciones %>% filter(Cancelled == 1))

cancelados_66$Month <- as.numeric(cancelados_66$Month)
cancelados_order <- order(cancelados_66$Month)
cancelados_66[cancelados_order, ]

#En el Año 1990 por tipo de cancelacion
cancelados_1990 <-data.frame(cancelados_66%>% filter(Year ==1990))
ggplot(cancelados_1990, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses  en el Año 1990", subtitle="Patron Codigo Cancelacion- Tomado de la Muestra")

#En el Año 1990 por tipo de cancelacion
cancelados_2000 <-data.frame(cancelados_66%>% filter(Year ==2000))
ggplot(cancelados_2000, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses en el Año 2000", subtitle="Patron Codigo Cancelacion- Tomado de la Muestra")


#En el año 2005 por tipo de cancelacion
cancelados_2005 <-data.frame(cancelados_66%>% filter(Year ==2005))
ggplot(cancelados_2005, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses en el Año 2005", subtitle="Patron Codigo Cancelacion- Tomado de la Muestra")

#En el año 2008 por tipo de cancelacion
cancelados_2008 <-data.frame(cancelados_66%>% filter(Year ==2008))
ggplot(cancelados_2008, aes(x=as.factor(Month),y=as.numeric(Cantidad_Cancelacion), group=CancellationCode))+
  geom_line(aes(color=CancellationCode)) +
  labs(title="Cantidad de Cancelaciones por mes\nEn los meses en el Año 2008", subtitle="Patron Codigo Cancelacion- Tomado de la Muestra")
