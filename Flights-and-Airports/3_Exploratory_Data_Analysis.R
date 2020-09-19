

library(readr)
library(ggplot2)
library(dplyr)
library(DAAG)
library(ggplot2)
library(reshape2)
library(scales)
library(gplots)
library("car")
#Importando la muestra
muestra_total <- read_csv("muestra_total.csv")
muestra <- data.frame(muestra_total)

##############DETERMINANDO EL OBJETIVO DEL ANALISIS EXPLORATORIO######################
muestra_1 %>% filter(!is.na())
mayores_retrasos  <-data.frame(muestra%>%  filter(!is.na(SecurityDelay)) %>%group_by(Year,Dest) %>% summarise(Retraso_Seguridad = sum(as.numeric(SecurityDelay)))
                             %>% arrange(desc(Retraso_Seguridad)))

Aerolineas_1990 <- data.frame(mayores_retrasos%>% filter(Year ==1990))
Aerolineas_2000 <- data.frame(mayores_retrasos%>% filter(Year ==2000))
Aerolineas_2005 <- data.frame(mayores_retrasos%>% filter(Year ==2005))
Aerolineas_2008 <- data.frame(mayores_retrasos%>% filter(Year ==2008))

Aerolineas_1990_h <- head(Aerolineas_1990,10) 
Aerolineas_2000_h <-head(Aerolineas_2000,10)
Aerolineas_2005_h <-head(Aerolineas_2005,10)
Aerolineas_2008_h <-head(Aerolineas_2008,10)

Aerolineas_mas_retrasadas <- rbind(Aerolineas_1990_h, Aerolineas_2000_h,Aerolineas_2005_h,Aerolineas_2008_h)
ggplot(data=Aerolineas_mas_retrasadas, aes(x=factor(Year), y=Retraso_Seguridad, fill=factor(Dest))) +
  scale_fill_manual(values = c("ATL" = "gray69", "IAH"="navy", "PHX"= "gray","LAS"= "gray","JFK"="gray","MCO"="gray","PHL"="gray",
                                "SLC"="gray","DTW"="gray","LAX"="gray","MSP"="gray","DEN"="gray","SEA"="gray","SFO"= "gray69", "BOS"="gray"))+
  geom_bar(stat="identity", width=0.91, position=position_dodge()) +
  geom_text(aes(y=Retraso_Seguridad,label=prettyNum(round(Retraso_Seguridad,digits=0),big.mark = ",")),  vjust=0.0, color="gray18", size=4.0, fontface="bold", position=position_dodge(0.9)) +
  labs(title="Top 10 de los Aeropuertos de destino más retrasados por Seguridad", subtitle="Por año") +
  xlab(label="Año")+
  labs(caption="No se registraba la variable retraso de seguridad en el 1990 ni en el 2000", fill="Aeropuerto\nde Destino")+
  ylab(label="Retrasos en minutos") +
  theme(plot.title = element_text(size=26),
        plot.subtitle = element_text(size=20),
        axis.title= element_text(size=18),
        plot.caption = element_text(size=18),
        axis.text.y= element_text(size=18, color="black", face="bold"),
        axis.text.x= element_text(size=18, color="black", face="bold")) 


##################################EL AEROPUERTO DE HOUSTON############################
HOUSTON   <-data.frame(muestra%>%  filter(Year %in% c(2005,2008) & Dest=="IAH" & SecurityDelay>=1))
#################################DEPENDE DEL AEROPUERTO DE ORIGEN?####################################
HOUSTON_2005 <- HOUSTON %>% filter(Year==2005)
HOUSTON_2008 <- HOUSTON %>% filter(Year==2008)

#AEROPUERTOS REPETIDOS
Repetidos <- HOUSTON %>% group_by(Origin) %>% summarise(Unique_Elements = n_distinct(Year)) %>% arrange(desc(Unique_Elements))

######ANALISIS En el año 2005###
aeropuerto_origen_2005  <-data.frame(HOUSTON%>%  filter(Year==2005) %>%group_by(Year,Origin) %>% summarise(Retraso_Seguridad = sum(as.numeric(SecurityDelay)))
                                     %>% arrange(desc(Retraso_Seguridad)))

ggplot(HOUSTON_2005, aes(Origin,as.numeric(SecurityDelay), color=Origin)) + geom_boxplot(fill="lightgreen") +labs(title="Grafico de Caja por Aeropuerto de Origen, en el Año 2005") +
  stat_summary(fun.y=mean, geom="line", aes(group=1)) +
  stat_summary(fun.y=mean, geom="point", shape=23, size=4, color="darkblue")+
  scale_fill_hue(l=100, c=100)+
  xlab(label="Aeropuerto de Origen")+
  ylab(label="Retraso de Seguridad")+
  coord_flip() +
  theme_classic() +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=18),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=14),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=13, color="black", face="bold"),
        axis.text.x= element_text(size=13, color="black", face="bold")) 

####MODELACION
model1 <-aov(as.numeric(HOUSTON_2005$SecurityDelay) ~ as.factor(HOUSTON_2005$Origin))
summary.aov(model1)
#GRAFICOS DE DIAGNOSTICO
plot(model1, 1)
plot(model1, 2)
##TEST DE HOMOCEDASTICIDAD
leveneTest(as.numeric(HOUSTON_2005$SecurityDelay) ~ as.factor(HOUSTON_2005$Origin))
##TEST DE NORMALIDAD
aov_residuals <- residuals(object = model1 )
shapiro.test(x = aov_residuals)

#MODELO ALTERNATIVO - KRUSKAL TEST 
kruskal.test(as.numeric(HOUSTON_2005$SecurityDelay) ~ as.factor(HOUSTON_2005$Origin))



######ANALISIS En el año 2008###
aeropuerto_origen_2008 <-data.frame(HOUSTON%>%  filter(Year==2008) %>%group_by(Year,Origin) %>% summarise(Retraso_Seguridad = mean(as.numeric(SecurityDelay)))
                                    %>% arrange(desc(Retraso_Seguridad)))
ggplot(HOUSTON_2008, aes(Origin,as.numeric(SecurityDelay), color=Origin)) + geom_boxplot(fill="lightgreen") +labs(title="Grafico de Caja por Aeropuerto de Origen, en el Año 2008") +
  stat_summary(fun.y=mean, geom="line", aes(group=1)) +
  stat_summary(fun.y=mean, geom="point", shape=23, size=4, color="darkblue")+
  scale_fill_hue(l=100, c=100)+
  xlab(label="Aeropuerto de Origen")+
  ylab(label="Retraso de Seguridad")+
  coord_flip() +
  theme_classic() +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=18),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=14),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=13, color="black", face="bold"),
        axis.text.x= element_text(size=13, color="black", face="bold")) 

####MODELACION
model2 <-aov(as.numeric(HOUSTON_2008$SecurityDelay) ~ as.factor(HOUSTON_2008$Origin))
summary.aov(model2)
#GRAFICOS DE DIAGNOSTICO
plot(model2, 1)
plot(model2, 2)
##TEST DE HOMOCEDASTICIDAD
leveneTest(as.numeric(HOUSTON_2008$SecurityDelay) ~ as.factor(HOUSTON_2008$Origin))
##TEST DE NORMALIDAD
aov_residuals_2 <- residuals(object = model2 )
shapiro.test(x = aov_residuals_2)
hist(as.numeric(HOUSTON_2008$SecurityDelay))
#MODELO ALTERNATIVO - KRUSKAL TEST 
kruskal.test(as.numeric(HOUSTON_2008$SecurityDelay) ~ as.factor(HOUSTON_2008$Origin))
#Al parecer no existe un aeropuerto de origen que sea recurrente en los retrasos de seguridad del aeropuerto destino de Houston

#################################DEPENDE DE LA AEROLINEA?####################################
###ANO  2005
aerolinea_2005  <-data.frame(HOUSTON%>%  filter(Year==2005) %>%group_by(Year,UniqueCarrier) %>% summarise(Retraso_Seguridad = sum(as.numeric(SecurityDelay)))
                             %>% arrange(desc(Retraso_Seguridad)))
#Boxplot
ggplot(HOUSTON_2005, aes(UniqueCarrier,as.numeric(SecurityDelay), color=UniqueCarrier)) + geom_boxplot(fill="lightgreen") +labs(title="Grafico de Caja por Aerolinea, en el Año 2005") +
  stat_summary(fun.y=mean, geom="line", aes(group=1)) +
  stat_summary(fun.y=mean, geom="point", shape=23, size=4, color="darkblue")+
  scale_fill_hue(l=100, c=100)+
  xlab(label="Aerolinea")+
  ylab(label="Retraso de Seguridad")+
  coord_flip() +
  theme_classic() +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=18),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=14),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=13, color="black", face="bold"),
        axis.text.x= element_text(size=13, color="black", face="bold")) 

####MODELACION
model3 <-aov(as.numeric(HOUSTON_2005$SecurityDelay) ~ as.factor(HOUSTON_2005$UniqueCarrier))
summary.aov(model3)
#GRAFICOS DE DIAGNOSTICO
plot(model3, 1)
plot(model3, 2)
##TEST DE HOMOCEDASTICIDAD
leveneTest(as.numeric(HOUSTON_2005$SecurityDelay) ~ as.factor(HOUSTON_2005$UniqueCarrier))
##TEST DE NORMALIDAD
aov_residuals_3 <- residuals(object = model3 )
shapiro.test(x = aov_residuals_3)

#MODELO ALTERNATIVO - KRUSKAL TEST 
kruskal.test(as.numeric(HOUSTON_2005$SecurityDelay) ~ as.factor(HOUSTON_2005$UniqueCarrier))

#ANO  2008
aerolinea_2008 <-data.frame(HOUSTON%>%  filter(Year==2008) %>%group_by(Year,UniqueCarrier) %>% summarise(Retraso_Seguridad = sum(as.numeric(SecurityDelay)))
                            %>% arrange(desc(Retraso_Seguridad)))
#Boxplot
ggplot(HOUSTON_2008, aes(UniqueCarrier,as.numeric(SecurityDelay), color=UniqueCarrier)) + geom_boxplot(fill="lightgreen") +labs(title="Grafico de Caja por Aerolinea, en el Año 2008") +
  stat_summary(fun.y=mean, geom="line", aes(group=1)) +
  stat_summary(fun.y=mean, geom="point", shape=23, size=4, color="darkblue")+
  scale_fill_hue(l=100, c=100)+
  xlab(label="Aerolinea")+
  ylab(label="Retraso de Seguridad")+
  coord_flip() +
  theme_classic() +
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=18),
        plot.subtitle = element_text(size=13),
        axis.title= element_text(size=14),
        plot.caption = element_text(size=11),
        axis.text.y= element_text(size=13, color="black", face="bold"),
        axis.text.x= element_text(size=13, color="black", face="bold")) 


####MODELACION
model4 <-aov(as.numeric(HOUSTON_2008$SecurityDelay) ~ as.factor(HOUSTON_2008$UniqueCarrier))
summary.aov(model4)
#GRAFICOS DE DIAGNOSTICO
plot(model4, 1)
plot(model4, 2)
##TEST DE HOMOCEDASTICIDAD
leveneTest(as.numeric(HOUSTON_2008$SecurityDelay) ~ as.factor(HOUSTON_2008$UniqueCarrier))
##TEST DE NORMALIDAD
aov_residuals_3 <- residuals(object = model4 )
shapiro.test(x = aov_residuals_3)

#MODELO ALTERNATIVO - KRUSKAL TEST 
kruskal.test(as.numeric(HOUSTON_2008$SecurityDelay) ~ as.factor(HOUSTON_2008$UniqueCarrier))

#######################MATRIZ DE CORRELACION- RETRASOS DE SEGURIDAD EN EL AEROPUERTO DE HOUSTON- 2008########################################
#VER SI EXISTE UNA CORRELACION ENTRE LA EL TAMANO DEL DELAY Y LA DISTANCIA 
#No existe una correlacion entre el tamano de delay y la distancia 
plot(HOUSTON$SecurityDelay ~ HOUSTON$Distance)

#MATRIZ DE CORRELACION
Cor_HOUSTON_2008 <- data.frame(HOUSTON_2008[, c("ActualElapsedTime", "ArrDelay", "ArrTime", "CRSArrTime", "CRSDepTime", "CRSElapsedTime", "DepDelay", 
            "DepTime", "Distance", "SecurityDelay")])
col_names <- names(Cor_HOUSTON_2008)
Cor_HOUSTON_2008 <- data.frame(lapply(Cor_HOUSTON_2008[, col_names], as.numeric))
cormat <-round(cor(Cor_HOUSTON_2008), 2)
melted_cormat <-melt(cormat)
ggplot(data=melted_cormat, aes(x=Var1, y= Var2, fill= value))+ geom_tile()

#Funciones 
get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}  
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}
# Reorder the correlation matrix
cormat <- reorder_cormat(cormat)
upper_tri <- get_upper_tri(cormat)
# Melt the correlation matrix
melted_cormat <- melt(upper_tri, na.rm = TRUE)
# Create a ggheatmap
ggheatmap <- ggplot(melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "#6883AB", high = "#123C7C", mid = "#7F7F7F", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Correlación\nPearson") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 15, vjust = 1, 
                                   size = 9, hjust = 1))+
  coord_fixed()
print(ggheatmap)
ggheatmap + 
  geom_text(aes(Var2, Var1, label = percent(value)), color = "white", size = 3.5) +
  labs(title="Mapa de Calor y Correlaciones\n Buscando Relaciones con el Retraso de Seguridad", subtitle="En el Aeropuerto de Houston en el año 2008") +
  labs(caption="Las Variables Weather Delay y Carrier Delay están vacías para esta muestra")+
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=15),
        plot.subtitle = element_text(size=13),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=8, color="black", face="bold"),
        legend.justification = c(1, 0),
        legend.position = c(0.6, 0.7),
        legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,title.position = "top", title.hjust = 0.5))



#######################MATRIZ DE CORRELACION- RETRASOS DE SEGURIDAD EN EL AEROPUERTO DE HOUSTON- 2005########################################
Cor_HOUSTON_2005 <- data.frame(HOUSTON_2005[, c("ActualElapsedTime", "ArrDelay", "ArrTime", "CRSArrTime", "CRSDepTime", "CRSElapsedTime", "DepDelay", 
                                                "DepTime", "Distance", "SecurityDelay")])
col_names <- names(Cor_HOUSTON_2005)
Cor_HOUSTON_2005 <- data.frame(lapply(Cor_HOUSTON_2005[, col_names], as.numeric))
cormat <-round(cor(Cor_HOUSTON_2005), 2)
melted_cormat <-melt(cormat)
ggplot(data=melted_cormat, aes(x=Var1, y= Var2, fill= value))+ geom_tile()

#Funciones 
get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}  
get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}
# Reorder the correlation matrix
cormat <- reorder_cormat(cormat)
upper_tri <- get_upper_tri(cormat)
# Melt the correlation matrix
melted_cormat <- melt(upper_tri, na.rm = TRUE)
# Create a ggheatmap
ggheatmap <- ggplot(melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "#6883AB", high = "#123C7C", mid = "#7F7F7F", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Correlación\nPearson") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 15, vjust = 1, 
                                   size = 9, hjust = 1))+
  coord_fixed()
print(ggheatmap)
ggheatmap + 
  geom_text(aes(Var2, Var1, label = percent(value)), color = "white", size = 3.5) +
  labs(title="Mapa de Calor y Correlaciones\n Buscando Relaciones con el Retraso de Seguridad", subtitle="En el Aeropuerto de Houston en el año 2005") +
  labs(caption="Las Variables Weather Delay y Carrier Delay están vacías para esta muestra")+
  theme(text = element_text(family = "Palatino"),
        plot.title = element_text(size=15),
        plot.subtitle = element_text(size=13),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_blank(),
        axis.text.y= element_text(size=10, color="black", face="bold"),
        axis.text.x= element_text(size=8, color="black", face="bold"),
        legend.justification = c(1, 0),
        legend.position = c(0.6, 0.7),
        legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,title.position = "top", title.hjust = 0.5))

