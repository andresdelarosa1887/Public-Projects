/* Label: Importacion */
libname analisis "/folders/myfolders/proyecto_sargazo";

*Importacion de los datos crudos y creacion del data set origianal;
 %web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/proyecto_sargazo/datos/MATRIZ-DATOS-SARGAZO 2 (1).xlsx';
PROC IMPORT DATAFILE=REFFILE
    DBMS=XLSX
    OUT=WORK.IMPORT;
    sheet = "Formulario 1";
    GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);


data analisis.sargazo_raw;
set work.import; 
run;

proc contents data=analisis.sargazo_raw; 
run; 

/*Crear una tabla con el nombre completo de las variables, analizar los niveles de las variables categoricas .
de cada una de las variables y ver como se puede modificar para lograr las agrupaciones

Ir pensando en como graficar algunas relaciones importantes entre las variables, como matriz de correlaciones entre
las variables que van de 1 a 5. 

proc print data=work.import (obs=1);
run; 



/* Label: Datos sobre Pesca en RD */
libname analisis "/folders/myfolders/proyecto_sargazo/datos"; 

data analisis.datos_pesca_1;
set work.import;
run; 

data analisis.datos_pesca_2;
set work.import1; 
run; 

title1 height=14pt "Datos sobre la Pesca en la República Dominicana"; 
title2 height=12pt "Para los años 1996, 2006 y 2015";
proc sgplot data=analisis.datos_pesca_1;
vbar ano/ response=Valor group=Variable groupdisplay=cluster datalabel
datalabelattrs=(size=10); 
format valor comma9.; 
xaxis label="Año"; 
footnote "Origen: Datos tomados de la Tercera Comunicación Nacional de República Dominicana para la Convención Marco de las Naciones Unidas Sobre el Cambio Climático";
run; 


title1 height=14pt "Datos sobre la Pesca en la República Dominicana"; 
title2 height=12pt "Basada en datos CODOPESCA, 2015";
ods graphics on / width=700 pt height=700 pt;
proc sgplot data=analisis.datos_pesca_2;
hbar provincia_pesquera/ response=Valor group=Variable groupdisplay=cluster datalabel DATALABELFITPOLICY=NONE 
datalabelattrs=(size=7) categoryorder=respdesc; 
where variable NE "sitios_desembarco";
format valor comma9.; 
xaxis label="Valor";
yaxis label="Provincia Pesquera";  
footnote "Origen: Datos tomados de la Tercera Comunicación Nacional de República Dominicana para la Convención Marco de las Naciones Unidas Sobre el Cambio Climático";
run; 
ods graphics off;


/* Label: Intervalos de Confianza */
libname analisis "/folders/myfolders/proyecto_sargazo";

proc print data=analisis.sargazo_raw20 (obs=1); run; 

proc contents data=analisis.sargazo_raw20;run; 

*Para la variable ingresos del pescador;
proc means data=analisis.sargazo_raw20 n mean clm; 
var ingresos;
run; 

*Para la variable costo por viaje; 
proc means data=analisis.sargazo_raw20 n mean  clm; 
var costo_de_viaje2; 
run; 


*Para la variable de edad;
proc means data=analisis.sargazo_raw20 n mean  clm; 
var Edad; 
run; 


/* Label: Actividad Pesquera Encuestados */
libname analisis "/folders/myfolders/proyecto_sargazo";

*Este script contiene la limpieza de datos de las variables que
 representan la actividad pesquera de los encuestados; 
/*
VAR12 - ¿La embarcación en la que pesca y es suya ?
VAR13 -  ¿Es usted dueño de los equipos de pesca que utiliza?
VAR14 - ¿De no ser asi, quien se los suministra?
VAR15 - ¿cuántas personas le acompañan en la jornada?
__El_producto_lo_vende_directame - ¿El producto lo vende directamente al público?
VAR17 - ¿El cuánto estimaría el costo total en que incurre en cada viaje?
VAR18 - ¿Cuál es la ganancia promedio en cada salida para usted? RD$
VAR19 - ¿Usualmente cuáles son las artes de pesca que utiliza?
VAR20 - ¿Cuál es el sitio donde pesca?
*ideas;
*Relacion de las ganancias con el sitio donde pesca, personas que lo acompañan,
cantidad de artes de pesca que utiliza si el producto lo vende directamente al publico, 
ver si existen diferencias estadisticamente significativas entre esto, realizar comparaciones con vbox; 

*/

*VAR12 - ¿La embarcación en la que pesca y es suya ?; 
proc freq data=analisis.sargazo_raw11; 
table var12/ out=dueno_embarcacion;
where var12 NE "N/C"; 
run; 

data dueno_embarcacion; 
set dueno_embarcacion; 
percent2=percent/100; 
run; 

proc sgplot data=dueno_embarcacion; 
title "Es Dueño de la Embarcación"; 
title2 "Para una muestra de 129 Pescadores";  
vbar var12/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
yaxis label="Participación en la muestra";
format percent2 percent8.2; 
xaxis label="Respuesta"; 
footnote1 "Nota: 1 persona no respondió a esta pregunta"; 
run; 



*VAR13 -  ¿Es usted dueño de los equipos de pesca que utiliza?;
proc freq data=analisis.sargazo_raw11; 
table var13/ out=dueno_equipos;
where var13 NE "N/E"; 
run; 

data dueno_equipos; 
set dueno_equipos; 
percent2=percent/100; 
run; 

proc sgplot data=dueno_equipos; 
title "Es Dueño de los Equipos que Utiliza para Pescar"; 
title2 "Para una muestra de 129 Pescadores";  
vbar var13/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
yaxis label="Participación en la muestra";
format percent2 percent8.2; 
xaxis label="Respuesta"; 
footnote1 "Nota: 1 persona no respondió a esta pregunta"; 
run; 

*VAR14 - ¿De no ser asi, quien se los suministra?; 
data analisis.sargazo_raw12;
length suministro_equipos $32;
set analisis.sargazo_raw11; 
if var14="Alquilado" then suministro_equipos="Alquilado";
else if var14="De un Amigo" then suministro_equipos="Amigo";
else if var14="Asociación" or var14="Socio de la Asociación" then suministro_equipos="Asociación";
else if var14="Compañero" or var14="Compañero de Pesca" then suministro_equipos="Compañero de Pesca";
else if var14="Cooperativa" then suministro_equipos="Cooperativa";
else if var14="El Pescador" or var14="Ellos Mismo" or var14="Los Pescadores" then suministro_equipos="El mismo";
else if var14="Intermediario" then suministro_equipos="Intermediario";
else if var14="N/A" or var14="N/a" or var14="N/C" then suministro_equipos="N/C";
else if var14="Patron" or var14="Al Empresario" or var14="Empresario" then suministro_equipos="Patrón";
else if var14="Dueño de la Pescaderia" or var14="El dueño de la pescaderia" or
 var14="Pescaderia" or var14="Propietario de Pescaderia" then suministro_equipos="Patrón";
else if var14="Empresa Pesquera" or var14="Pesquera" or
 var14="Pesqueria" or var14="Pesquero" then suministro_equipos="Pesquera";
run; 


proc freq data=analisis.sargazo_raw12; 
table suministro_equipos/ out=suministro_equipos;
where suministro_equipos NE "N/C"; 
run; 

data suministro_equipos;
set suministro_equipos;
percent2= percent/100;
run;

proc sgplot data=suministro_equipos; 
title "Origen de los Equipos que Utiliza el Pescador"; 
title2 "Para una muestra de 129 Pescadores";  
hbar suministro_equipos/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
xaxis label="Participación en la muestra";
format percent2 percent8.2; 
yaxis label="Respuesta"; 
footnote1 "Nota: 47 personas no respondieron a esta pregunta"; 
footnote2 "Ver Anexos para detalles sobre estas agrupaciones"; 
run; 


*VAR15 - ¿cuántas personas le acompañan en la jornada?;
 data analisis.sargazo_raw13; 
set analisis.sargazo_raw12;
length acompanantes 8.; 
if var15="N/C" then acompanantes="."; else acompanantes=var15;
run;

proc freq data=analisis.sargazo_raw13; 
table acompanantes/ out=acompanantes;
run;

data acompanantes; 
set acompanantes;
percent2=percent/100;
run; 

proc sgplot data=acompanantes; 
title "Distribución de la Cantidad de Acompañantes de los Pescadores"; 
title2 "Para una muestra de 129 Pescadores";  
vbar acompanantes/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black);
yaxis label="Participación en la muestra";
format percent2 percent8.2; 
xaxis label="Cantidad de Acompañantes"; 
footnote "11 personas no respondieron a esta pregunta"; 
run; 


*__El_producto_lo_vende_directame - ¿El producto lo vende directamente al público?;
proc freq data=analisis.sargazo_raw13; 
table __El_producto_lo_vende_directame;
run;

data analisis.sargazo_raw14;
length venta_a_publico $ 5;
set analisis.sargazo_raw13;
if __El_producto_lo_vende_directame="Asociación"
 or __El_producto_lo_vende_directame="Intermediario"
 or __El_producto_lo_vende_directame="No"
 then venta_a_publico="No"; 
else if __El_producto_lo_vende_directame="2500"
or __El_producto_lo_vende_directame="N/C" then venta_a_publico="N/C"; 
 else if __El_producto_lo_vende_directame="Sí" then venta_a_publico="Si";
 run;
 
 proc freq data=analisis.sargazo_raw14; 
 where venta_a_publico NE "N/C";
table venta_a_publico/ out=venta_a_publico;
run;

data venta_a_publico;
set venta_a_publico;
percent2= percent/100;
run; 
 
 
 proc sgplot data=venta_a_publico; 
title "El Pescador Vende Directamente al Público"; 
title2 "Para una muestra de 129 Pescadores";  
vbar venta_a_publico/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
yaxis label="Participación en la muestra";
format percent2 percent8.2; 
xaxis label="Respuesta"; 
footnote1 "Nota: 11 personas no respondieron a esta pregunta"; 
run; 




/* Label: Caracteristicas de los Encuestados */
libname analisis "/folders/myfolders/proyecto_sargazo";

*Este script contiene la limpieza de datos de las variables que representan las caracteristicas de los 
encuestados y el tiempo percibido de duracion del sargazo; 

/* 
Enfoque a las variables que representan las caracteristicas de los
encuestados que son las siguientes variables
Observacion
Edad
Estado_Civil
Nivel_Escolar
No__de_hijos
Tenencia_de_la_vivienda
Localidad
Fecha 
Ingresos_mensuales
*/ 

/* Verificar el sentido de estas preguntas
Variables que representan el tiempo percibido de sargazo 
El_sargazo_llega_desde
El_sargazo_llega_para
*/ 
*Transformaciones importantes a los datos;
*Convirtiendo las variables que se suponen que son numericas de caracter;

*Edad;
data analisis.sargazo_raw2;
set analisis.sargazo_raw; 
Edad1= input(Edad, 8.); 
drop Edad;
rename Edad1=Edad;
run; 

data analisis.sargazo_raw3; 
length rango_edad $ 8; 
set analisis.sargazo_raw2; 
if edad>=14 and edad<=21 then rango_edad="14-21"; 
else if edad>=22 and edad<=29 then rango_edad="22-29";
else if edad>=30 and edad <=37 then rango_edad="30-38";
else if edad>=38 and edad <=45 then rango_edad="39-45";
else if edad>=46 and edad <=53 then rango_edad="46-53"; 
else if edad>=54 and edad <=61 then rango_edad="54-61";
else if edad>=62 and edad <=69 then rango_edad="62-69"; 
else if edad>=70 and edad <=77 then rango_edad="70-77"; 
else if edad>=78 and edad <=81 then rango_edad="78-85"; 
else rango_edad=edad; 
run; 


proc freq data=analisis.sargazo_raw3;
where edad>10; 
table rango_edad/ out=rangoedad; 
run; 

data rangoedad;
set rangoedad; 
percent2= percent/100;
run; 

proc sgplot data=rangoedad;
title "Distribución de Edad de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores"; 
footnote "Nota: 4 personas no respondieron a esta pregunta"; 
vbar rango_edad/response=percent2 datalabel BARWIDTH=1 datalabelattrs=(size=10 weight=bold) 
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
xaxis label="Rango de Edad de los Encuestados";
yaxis label="Participación"; 
format percent2 percent9.2; 
run;
title;
footnote;

*Estado Civil;
proc freq data=analisis.sargazo_raw3; 
table  estado_civil/ out=estadoc;
run; 

data estadoc;
set estadoc;
percent2=percent/100;
run; 

proc sgplot data=estadoc; 
title "Estado Civil de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores";  
hbar estado_civil/response=percent2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
 categoryorder=respdesc
 fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
yaxis label="Estado Civil";
xaxis label="Participación"; 
format percent2 percent8.2;
run; 

*Nivel  Escolar;
data analisis.sargazo_raw4;
length educacion $ 32;
set analisis.sargazo_raw3;
*Primario;
if nivel_escolar="1ro de Primaria" then educacion="1-6 primaria";
else if nivel_escolar="2do de Primaria" then educacion="1-6 primaria";
else if nivel_escolar="2do de Primario" then educacion="1-6 primaria";
else if nivel_escolar="3ro de Primaria"  then educacion="1-6 primaria";
else if nivel_escolar="4to Primaria" or nivel_escolar="4to de Primaria" then educacion="1-6 primaria";
else if nivel_escolar="5to de Primaria" then educacion="1-6 primaria";
else if nivel_escolar="6to primaria inocompleta" then educacion="1-6 primaria";
else if nivel_escolar="Primaria" then educacion="Primaria Concluida";
*intermedio;
else if nivel_escolar="7mo de intermedia" then educacion="7-8 intermedia";
else if nivel_escolar="8vo de intermedia" then educacion="7-8 intermedia";
 *Bachiller; 
else if nivel_escolar="1ro de Bachiller" then educacion="1-2 bachiller";
else if nivel_escolar="2do de Bachiller" then educacion="1-2 bachiller";    
else if nivel_escolar="3ro de Bachiller" then educacion="3-4 bachiller";
else if nivel_escolar="4to Bachiller" then educacion="3-4 bachiller";
else if nivel_escolar="4to de Bachiller" then educacion="3-4 bachiller";
else if nivel_escolar="Bachiller concluido" then educacion="Bachiller Concluido";
*Universitario;
else if nivel_escolar="Ingeniero" or nivel_escolar="Universitario" then educacion="Universitario";
*Ningun nivel; 
else if nivel_escolar="Ninguno" or nivel_escolar="Universitario" then educacion="Ninguno";
else educacion=nivel_escolar;  
run; 

proc freq data=analisis.sargazo_raw4;
where educacion NE "N/C"; 
table educacion/ out=educacion;
run; 

data educacion;
set educacion; 
percent2= percent/100;
run; 


proc sgplot data=educacion; 
title "Nivel Escolar de los Encuestados"; 
where educacion  NE "N/C"; 
title2 "Para una muestra de 129 Pescadores";  
hbar educacion/response=percent2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
 categoryorder=respdesc
 fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
yaxis label="Nivel Educativo";
xaxis label="Participación"; 
footnote1 "Nota: 7 personas no respondieron a esta pregunta"; 
footnote2 "Nota: Se crearon categorías para los niveles educativos ver anexo"; 
format percent2 percent8.2;
run; 


*Cantidad de Hijos;
data analisis.sargazo_raw5;
length cantidad_hijos 8.;
set analisis.sargazo_raw4;
if No__de_hijos="Ninguno" then cantidad_hijos=0;
else cantidad_hijos= No__de_hijos;
run; 

proc freq data=analisis.sargazo_raw5; 
table cantidad_hijos/ out=hijos;
run; 

data hijos; 
set hijos;
percent2= percent/100;
run; 

proc sgplot data=hijos; 
title "Distribución de la Cantidad de Hijos de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores";  
vbar cantidad_hijos/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black);
yaxis label="Participación en la muestra";
format percent2 percent8.2; 
xaxis label="Cantidad de Hijos"; 
run; 
 
*Tenencia de la Vivienda;
 data analisis.sargazo_raw6;
set analisis.sargazo_raw5;
if tenencia_de_la_vivienda="Arquiler" then tenencia="Alquiler"; else tenencia=tenencia_de_la_vivienda;  
run; 

proc freq data=analisis.sargazo_raw6; 
table tenencia/ out=vivienda; 
run;

data vivienda; 
set vivienda;
percent2= percent/100;
run; 

proc sgplot data=vivienda; 
where tenencia NE "N/E"; 
title "Distribución de la Propiedad de Vivienda de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores";  
hbar tenencia/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
xaxis label="Participación en la muestra";
format percent2 percent8.2; 
yaxis label="Tenencia de la Vivienda"; 
footnote1 "Nota: 12 personas no respondieron a esta pregunta"; 
run; 




/* Label: Percepción del Encuestado- Afirmaciones  */

libname analisis "/folders/myfolders/proyecto_sargazo";
*Este script contiene la limpieza de datos de las variables que
 representan la percepcion de los encuestados; 
/*

1- Tengo_conocimientos_sobre_la_var -  Tengo conocimientos sobre la variabilidad del clima
2- Tengo_conocimientos_sobre_el_alg - Tengo conocimientos sobre el alga que llega a las costas de nuestra región
3- Estas_algas_llegan_m__s_frecuent - Estas algas llegan más frecuentemente y en mayor cantidad nuestras costas
4- Considero_que_el_aumento_en_la_c - Considero que el aumento en la cantidad de algas que llega a las costas está relacionado con las variaciones del clima
5- El_sargazo_favorece_la_pesca_por - El sargazo favorece la pesca porque se aumenta la captura
6- El_sargazo_afecta_positivamente - El sargazo afecta positivamente a la pesca porque trae especies no comunes
7- Puedo_aprovechar_las_especies_qu  - Puedo aprovechar las especies que vienen asociadas al sargazo
8- El_sargazo_al_descomponerse_afec -  El sargazo al descomponerse afecta a manglares, corales y praderas marinas
9- El_sargazo_afecta_negativamente - El sargazo afecta negativamente a la pesca porque mata a los juveniles, lo cual afecta la captura de los meses posteriores
10- Los_gases_que_desprende_el_sarga - Los gases que desprende el sargazo al descomponerse me ha provocado mareo, nauseas durante la faena y erupción en la piel.
11- Puedo_tener_un_mayor_volumen_en - Puedo tener un mayor volumen en la captura pero los precios se caen por una mayor oferta y falta de un mercado alternativo
12- Muchos_juveniles_se_refugian_en - Muchos juveniles se refugian en las algas y viene en la captura pero yo no las libero
13- No_puedo_impedir_que_el_sargazo - No puedo impedir que el sargazo llegue pero puedo realizar una pesca responsable para ayudar a los ecosistemas y a que estas algas causen menos daños.
14- Si_me_dan_la_oportunidad__en_los - Si me dan la oportunidad, en los meses posteriores al sargazo, me dedico a otra actividad para que los peces se recuperen.
*/ 



data  analisis.sargazo_liker; 
set analisis.sargazo_raw24; 
rename 
Tengo_conocimientos_sobre_la_var =Pregunta_1
Tengo_conocimientos_sobre_el_alg =Pregunta_2
Estas_algas_llegan_m__s_frecuent =Pregunta_3
Considero_que_el_aumento_en_la_c  =Pregunta_4
El_sargazo_favorece_la_pesca_por =Pregunta_5
El_sargazo_afecta_positivamente =Pregunta_6
Puedo_aprovechar_las_especies_qu =Pregunta_7
El_sargazo_al_descomponerse_afec =Pregunta_8
El_sargazo_afecta_negativamente =Pregunta_9
Los_gases_que_desprende_el_sarga =Pregunta_10
Puedo_tener_un_mayor_volumen_en =Pregunta_11
Muchos_juveniles_se_refugian_en =Pregunta_12
No_puedo_impedir_que_el_sargazo =Pregunta_13
Si_me_dan_la_oportunidad__en_los =Pregunta_14;
run; 

data  analisis.sargazo_liker2; 
set analisis.sargazo_liker;
keep  provincia educacion numero Pregunta_1 Pregunta_2 Pregunta_3 Pregunta_4 Pregunta_5 Pregunta_6 Pregunta_7 Pregunta_8
Pregunta_9 Pregunta_10 Pregunta_11 Pregunta_12 Pregunta_13 Pregunta_14;
run; 

proc export data=analisis.sargazo_liker2 DBMS=xlsx 
outfile="/folders/myfolders/resultados_liker22.xlsx";
run;

*Estadistico de Cronbach; 
proc corr data= analisis.sargazo_liker alpha nomiss;
var Pregunta_1 Pregunta_2 Pregunta_3 Pregunta_4 Pregunta_5 Pregunta_6 Pregunta_7 Pregunta_8
Pregunta_9 Pregunta_10 Pregunta_11 Pregunta_12 Pregunta_13 Pregunta_14;
run;


proc freq data=analisis.sargazo_liker; 
run; 



*Otra forma de graficar, ver los liker charts alternativos de graphically speaking;
proc print data=analisis.sargazo_liker; 
run; 
proc freq data=analisis.sargazo_liker; 
table pregunta_14/ out=pregunta1;
run; 

data pregunta1;
set pregunta1;
percent2= percent/100;
run; 

proc sgplot data=pregunta1;
vbar pregunta_7/ response=percent2 datalabel datalabelattrs=(size=12 weight=bold); 
format percent2 percent32.2;
run; 





*
1- totalmente en desacuerdo
2- en desacuerdo 
3- neutral 
4- de acuerdo
5- totalmente de acuerdo
;





/* Label: otras_preguntas */

libname analisis "/folders/myfolders/proyecto_sargazo";

*Tabla Utilizada en el analisis;
proc sql; 
create table ganancia_arte as
select arte_pesca1, sum(ganancia_viaje2) as TOTAL_GANADO format comma32.,
 count(ganancia_viaje2) as RESPONDIERON,
 (calculated TOTAL_GANADO/ calculated RESPONDIERON) format comma32.1
as ganancia_por_encuestado
from analisis.sargazo_raw19
group by arte_pesca1
order by calculated  TOTAL_GANADO desc;

/*
Lco
Chah
Lco, Na
Lcu
*/ 

title height=16pt "Distribución de los Ingresos Estimados por Viaje" ; 
title2 height=14pt "Dado el Arte de Pesca Utilizado";
title3 height=14pt "Para una muestra de 129 Pescadores";
ods graphics on / width=600 pt height=400 pt;
proc sgplot data=analisis.sargazo_raw19; 
where arte_pesca1 in(" Lco" "Chah"  "Lcu" "Lcu, Lco"); 
vbox ganancia_viaje2 / category=arte_pesca1 connect=mean;
xaxis label="Arte de Pesca Reportado"; 
yaxis label="Distribución de los Ingresos Reportados"; 
footnote2 "Para las categorías con más de 10 encuestados";
run; 
 
*ANOVA;
data datos_anova; 
set analisis.sargazo_raw19; 
where arte_pesca1 in(" Lco" "Chah"  "Lcu" "Lcu, Lco"); 
keep  arte_pesca1 ganancia_viaje2;
run; 

proc means data=datos_anova printalltypes maxdec=3; 
    var ganancia_viaje2; 
    class arte_pesca1; 
    title "Descriptive Statistics of Garlic Weight";
run; 

proc glm data= datos_anova plots(only)=diagnostics(unpack); 
    class arte_pesca1;
    model ganancia_viaje2=arte_pesca1; 
    means arte_pesca1/ hovtest; 
    title "Análisis de Varianza dado el Arte de Pesca Utilizado";
run; 
quit; 




*Otra pregunta de investigacion;
data sargazo_cruce;
set analisis.sargazo_liker;
keep pregunta_1 pregunta_4;
run; 

data sargazo_cruce_2;
length pregunta_12 $ 32. pregunta_42 $ 32.; 
set sargazo_cruce;
where pregunta_1>0 and pregunta_4>0;
if pregunta_1>=4 then pregunta_12="De Acuerdo"; 
else if pregunta_1<3 then pregunta_12="En Desacuerdo";
else pregunta_12="Neutro";
if pregunta_4>=4 then pregunta_42="De Acuerdo"; 
else if pregunta_4<3 then pregunta_42="En Desacuerdo";
else pregunta_42="Neutro";
run; 

proc freq data=sargazo_cruce_2;
*where pregunta_12 not in("Neutro") and pregunta_42 not in("Neutro");
table pregunta_12*pregunta_42/ chisq expected;
run; 


data work.__tmp__;
    set WORK.SARGAZO_CRUCE_2;
    _Case_=_n_;
run;

proc transpose data=work.__tmp__ out=work.Stacked(drop=_Label_ 
        rename=(col1=resultado)) name=Pregunta;
    var pregunta_12 pregunta_42;
    by _Case_;
run;

proc delete data=WORK.__tmp__;
run;

 
title height=16pt "Comparación de la Afirmación 1 y la Afirmación 4"; 
title2 height=14pt "Para una muestra de 129 Pescadores";
ods graphics on / width=600 pt height=400 pt;
proc sgplot data=work.stacked pctlevel=group;
vbar Pregunta / group=resultado stat=pct seglabel seglabelattrs=(size=10) DATALABELFITPOLICY=NONE;
yaxis label="Participación en la muestra";
xaxis label="Afirmaciones";
footnote "Nota: Afirmación 1: Tengo conocimientos sobre la variabilidad del clima"; 
footnote2 "Afirmación 4: Considero que el aumento en la cantidad de algas que llega a las costas está relacionado con las variaciones del clima";
run;

proc freq data=analisis.sargazo_limpio; 
table provincia; 
run; 

proc print data=analisis.sargazo_raw10; 
where provincia="Azua";
run; 






/* Label: Actividad Pesquera Encuestados  */
libname analisis "/folders/myfolders/proyecto_sargazo";

*Modificaciones posteriores por los datos revisados; 
data analisis.rev_gas_ing;
set work.import; 
rename var17=costo_revision var18=ganancia_revision; 
run; 

proc sort data=analisis.rev_gas_ing; by numero; run; 
proc sort data=analisis.sargazo_raw14; by numero; run; 

data analisis.sargazo_14_5; 
merge analisis.sargazo_raw14 analisis.rev_gas_ing;
by numero; 
run; 
*Verificando los datos que cambiaron;
proc print data=analisis.sargazo_14_5; 
var numero costo_revision var17; 
where costo_revision ^= var17; 
run;

*ESTAS SON LAS VARIABLES QUE NECESITAN UNA MODIFICACION EN LA VARIABLE DE LOS COSTOS;
data analisis.sargazo_raw15;
length costo_de_viaje $ 42;
set analisis.sargazo_14_5; 
if costo_revision="A Remos" or costo_revision="Remo" or costo_revision="N/C" then costo_de_viaje="0";
else if Numero=2 then costo_de_viaje="1150"; 
else if numero=20 then costo_de_viaje="2000";
else if numero=21 then costo_de_viaje="5000";
else if numero=28 then costo_de_viaje="5200";
else if numero=39 then costo_de_viaje="2500";
else if numero=42 then costo_de_viaje="500";
else if numero=47 then costo_de_viaje="5000";
else if numero=51 then costo_de_viaje="500";
else if costo_revision="2,000-4,500" then costo_de_viaje="3250"; 
else if numero=57 then costo_de_viaje="1500";
else if numero=61 then costo_de_viaje="3500";
else if numero=69 then costo_de_viaje="2000";
else if numero=82 then costo_de_viaje="1800";
else if numero=108 then costo_de_viaje="5000";
else if numero=109 then costo_de_viaje="500";
else if numero=113 then costo_de_viaje="2000";
else if costo_revision="3,000-4,000" then costo_de_viaje="3500"; 
else if numero=129 then costo_de_viaje="5000";
else if costo_revision="80-90" then costo_de_viaje="85"; 
else costo_de_viaje=costo_revision;
run;


data analisis.sargazo_raw15;
set analisis.sargazo_raw15;
costo_de_viaje2=input(costo_de_viaje, 8.);
run; 


*Graficos;
proc sgplot data=analisis.sargazo_raw15;
title "Distribución de los Costos Estimados por Viaje"; 
title2 "Para una muestra de 129 Pescadores";   
*where costo_de_viaje2 >0 and costo_de_viaje2<100000; 
hbox costo_de_viaje2/ labelfar; 
xaxis label="Costo Estimado por Cada Viaje" values = (0 to 15000 by 1500) valueattrs=(size=8);
footnote1 "Nota: 8 personas no respondieron a esta pregunta"; 
format costo_de_viaje2 comma9.; 
run; 


data analisis.sargazo_raw16;
length rango_costo 8.;
set analisis.sargazo_raw15;
if costo_de_viaje2>50 and costo_de_viaje2<=1000 then rango_costo=1;
else if costo_de_viaje2>1001 and costo_de_viaje2<=3500 then rango_costo=2;
else if costo_de_viaje2>3501 and costo_de_viaje2<=6000 then rango_costo=3;
else if costo_de_viaje2>6001 and costo_de_viaje2<=8500 then rango_costo=4;
else if costo_de_viaje2>8501 and costo_de_viaje2<=11000 then rango_costo=5;
else if costo_de_viaje2>11001 and costo_de_viaje2<=15000 then rango_costo=6;
else if costo_de_viaje2>15001 and costo_de_viaje2<=20000 then rango_costo=7;
else rango_costo=costo_de_viaje2;
run; 

proc format;
value rangcosto
    1= "Menos de 1,000"
    2= "1,001-3,500"
    3= "3,501-6,000"
    4= "6,001-8,500"
    5= "8,501-11,000"
    6= "11,001-15,000"
    7= "15,001-20,000";
run;

proc freq data=analisis.sargazo_raw16;
where rango_costo>0;
table rango_costo/ out=rango_costo;
run; 

data rango_costo;
set rango_costo;
percent2=percent/100;
run;

title height=16pt "Distribución de los Costos Estimados por Viaje" ; 
title2 height=14pt "Para una muestra de 129 Pescadores";
ods graphics on / width=600 pt height=400 pt;
proc sgplot data=rango_costo; 
footnote "Nota: 8 personas no respondieron a esta pregunta"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación y criterios utilizados";
vbar rango_costo/ response=percent2  datalabel BARWIDTH=1 datalabelattrs=(size=11 weight=bold) 
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
xaxis label="Costo por Viaje" valueattrs=(size=8.8pt weight=bold);
yaxis label="Participación"; 
format percent2 percent32. rango_costo rangcosto32.; 
run;
title;
footnote;










/* Label: likert_graphs */
libname analisis "/folders/myfolders/proyecto_sargazo";


*THIS IS A FUCKING ABUSE, DO IT ON R; 
data analisis.likert_graphs_1;
set work.import;
format Participacion    total_de_acuerdo    total_desacuerdo    abajo   arriba  abajo2  arriba2 percent32.2;
run; 


proc sgpanel data=analisis.likert_graphs_1;
where id_pregunta="Pregunta_1" or id_pregunta="Pregunta_2";
  styleattrs datacolors=(&red pink white lightgreen &green) datacontrastcolors=(black);
  panelby id_pregunta / novarname noborder noheader nowall;
  highlow y=id_pregunta low=abajo high=arriba / group=grupo type=bar nooutline   
          lowlabel=total_desacuerdo highlabel=total_de_acuerdo dataskin=pressed barwidth=1;
  inset pregunta / position=top nolabel textattrs=(size=12);
  rowaxis display=(nolabel noticks noline) offsetmax=0.35 fitpolicy=none;
  colaxis display=(nolabel noticks novalues noline);
  keylegend / noborder;
run;




proc sgplot data=analisis.likert_graphs_1;
where id_pregunta="Pregunta_1";
  styleattrs datacolors=(&red pink white lightgreen &green) datacontrastcolors=(black);
  highlow  y=id_pregunta low=abajo high=arriba / group=grupo type=bar nooutline   
          lowlabel=total_desacuerdo highlabel=total_de_acuerdo;
          inset pregunta / position=top nolabel textattrs=(size=5);
          run; 


/* Label: a quienes le cuesta mas */
libname analisis "/folders/myfolders/proyecto_sargazo";


proc sgplot data=analisis.sargazo_raw17;
title "Distribución de los Costos Estimados por Viaje";
title2 "Dada la Provincia"; 
title3 "Para una muestra de 129 Pescadores";   
vbox costo_de_viaje2/ category=provincia connect=mean labelfar; 
yaxis label="Costo Estimado por Cada Viaje" valueattrs=(size=7);
footnote1 "Nota: 8 personas no respondieron a esta pregunta"; 
where provincia not in("Independencia");
footnote2 "Se excluyó del análisis la provincia Independecia debido a la baja frecuencia de respuesta";
format costo_de_viaje2 comma9.; 
run; 


/* Label: Activididad Pesquera Encuestados */
libname analisis "/folders/myfolders/proyecto_sargazo";

*Verificando los datos que cambiaron;
proc print data=analisis.sargazo_raw16; 
var numero ganancia_revision var18; 
where ganancia_revision ^= var18; 
run;

*ganancias_por_viaje; 
data analisis.sargazo_raw17;
length ganancia_viaje $ 32;
set analisis.sargazo_raw16; 
if numero=5 then ganancia_viaje="2500";
else if numero=18 then ganancia_viaje="500";
else if numero=39 then ganancia_viaje="1000";
else if numero=47 then ganancia_viaje="17500";
else if numero=48 then ganancia_viaje="1500";
else if numero=53 then ganancia_viaje="7000";
else if numero=56 then ganancia_viaje="200";
else if numero=64 then ganancia_viaje="3500"; 
else if numero=65 then ganancia_viaje="3000"; 
else if numero=67 then ganancia_viaje="1500";
else if numero=70 then ganancia_viaje="1500"; 
else if numero=76 then ganancia_viaje="2500"; 
else if numero=81 then ganancia_viaje="1000"; 
else if numero=83 then ganancia_viaje="3500"; 
else if numero=108 then ganancia_viaje="10000";
else if numero=113 then ganancia_viaje="6000";
else if numero=118 then ganancia_viaje="2750"; 
else if numero=119 then ganancia_viaje="4250";
else if numero=121 then ganancia_viaje="1000";
else if numero=125 then ganancia_viaje="2500";
else if numero=127 then ganancia_viaje="600";
else if ganancia_revision="N/C" then ganancia_viaje="0";
else if ganancia_revision="200-100" then ganancia_viaje="150"; 
else if ganancia_revision="0-3000" then ganancia_viaje="1500"; 
else if ganancia_revision="800-1000" then ganancia_viaje="900"; 
else if ganancia_revision="6,000-10,000" then ganancia_viaje="8000"; 
else ganancia_viaje=ganancia_revision;
run;

proc print data=analisis.sargazo_raw17; 
var numero ganancia_revision ganancia_viaje var18;  
run;

data analisis.sargazo_raw17;
set analisis.sargazo_raw17;
ganancia_viaje2=input(ganancia_viaje, 8.);
run; 

proc sgplot data=analisis.sargazo_raw17;
title "Distribución de las Ganancias Estimadas por Viaje"; 
title2 "Para una muestra de 129 Pescadores";   
where ganancia_viaje2>0; 
hbox ganancia_viaje2/ labelfar; 
xaxis label="Ganancia Estimada por Cada Viaje" values = (0 to 40000 by 1000) valueattrs=(size=8);
footnote1 "Nota: 3 personas no respondieron a esta pregunta"; 
format ganancia_viaje2 comma9.; 
run; 


*TRansformaciones al rango de ganancias; 
data analisis.sargazo_raw18;
length rango_ganancia 8.;
set analisis.sargazo_raw17;
if ganancia_viaje2>50 and ganancia_viaje2<=1000 then rango_ganancia=1;
else if ganancia_viaje2>1001 and ganancia_viaje2<=3500 then rango_ganancia=2;
else if ganancia_viaje2>3501 and ganancia_viaje2<=6000 then rango_ganancia=3;
else if ganancia_viaje2>6001 and ganancia_viaje2<=8500 then rango_ganancia=4;
else if ganancia_viaje2>8501 and ganancia_viaje2<=11000 then rango_ganancia=5;
else if ganancia_viaje2>11001 and ganancia_viaje2<=20000 then rango_ganancia=6;
else if ganancia_viaje2>=20001 and ganancia_viaje2<=30000 then rango_ganancia=7;
else if ganancia_viaje>30000 then rango_ganancia=8;
else rango_ganancia=ganancia_viaje2;
run; 

proc format;
value ranganancia
    1= "Menos de 1,000"
    2= "1,001-3,500"
    3= "3,501-6,000"
    4= "6,001-8,500"
    5= "8,501-11,000"
    6= "11,001-20,000"
    7= "20,001-30,000"
    8= "Mayor a 30,000";
run;

proc freq data=analisis.sargazo_raw18;
where rango_ganancia>0;
table rango_ganancia/ out=rango_ganancia;
run; 

data rango_ganancia;
set rango_ganancia;
percent2=percent/100;
run;

title height=16pt "Distribución de los ganancias Estimadas por Viaje" ; 
title2 height=14pt "Para una muestra de 129 Pescadores";
ods graphics on / width=600 pt height=400 pt;
proc sgplot data=rango_ganancia; 
footnote "Nota: 3 personas no respondieron a esta pregunta"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación y criterios utilizados";
vbar rango_ganancia/ response=percent2  datalabel BARWIDTH=1 datalabelattrs=(size=11 weight=bold) 
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
xaxis label="Ganancia por Viaje" valueattrs=(size=8.8pt weight=bold);
yaxis label="Participación"; 
format percent2 percent32. rango_ganancia ranganancia32.; 
run;
title;
footnote;










/* Label: Actividad Pesquera Encuestados  1 */
libname analisis "/folders/myfolders/proyecto_sargazo";

*VAR19 - ¿Usualmente cuáles son las artes de pesca que utiliza?
VAR20 - ¿Cuál es el sitio donde pesca?;

*Hacer las transformaciones; 
data  analisis.sargazo_raw19;
length arte_pesca1 $ 32; 
set analisis.sargazo_raw18;
if var19="Lco" then  arte_pesca1="Lco";
else if var19="Lco, Lcu" then arte_pesca1="Lco, Lcu";
else if var19="Bc"  then arte_pesca1="Bc";
else if var19="Bc,Lco" then  arte_pesca1="Bc,Lcu"; 
else if var19="Buceo"   then  arte_pesca1="Bc";
else if var19="CHah y Na"  then  arte_pesca1="Chah, Na";
else if var19="Chah"  then  arte_pesca1="Chah";
else if var19="Char"  then  arte_pesca1="Chah"; 
else if var19="LCu y  Lco" then  arte_pesca1="Lcu, Lco";
else if var19="Lcu y  Lco"  then  arte_pesca1="Lcu, Lco";
else if var19="LCu y   Lco"  then  arte_pesca1="Lcu, Lco"; 
else if var19="LCu y Buseo" then  arte_pesca1="Lcu, Bc";
else if var19="LCu y Char" then  arte_pesca1= "Lcu, Chah";
else if var19="LCu y Na"   then  arte_pesca1= "Lcu, Na";
else if var19="LCu, Char"  then  arte_pesca1= "Lcu, Chah";
else if var19="LCu, Lco, Na"  then  arte_pesca1=  "Lcu, Lco,Na";
else if var19="LCu,Lv" then  arte_pesca1= "Lcu,Lv";
else if var19="Lco Chah"  then  arte_pesca1=  "Lco,Chah";
else if var19="Lco Na" then  arte_pesca1= "Lco, Na";
else if var19="Lco, Chah"  then  arte_pesca1= "Lco, Chah";
else if var19="Lco, Chah y Na" then  arte_pesca1= "Lco, Chah, Na";
else if var19="Lco, LR, Lcu" then  arte_pesca1=   "Lco,LR,Lcu";
else if var19="Lco,LCU" then  arte_pesca1= "Lcu, Lco";
else if var19="Lcu" then  arte_pesca1= "Lcu";
else if var19="Lcu y Lco"  then  arte_pesca1= "Lcu,Lco";
else if var19="Lcu, Na y Lco"  then  arte_pesca1= "Lcu,Na,Lco";
else if var19="Llu" then  arte_pesca1= "Lcu";
else if var19="N/C" then  arte_pesca1= "N/C";
else if var19="Na" then  arte_pesca1= "Na";
else if var19="Na Pa"  then  arte_pesca1= "Na,Pa";
else if var19="Na y Char" then  arte_pesca1=  "Na,Chah";
else if var19="Na y Llu"  then  arte_pesca1=  "Na,Lcu";
else if var19="Na, Lco" then  arte_pesca1= "Na,Lco";
else if var19="Nasa"  then  arte_pesca1=  "Na";
else if var19="Pa, Lco y Na"  then  arte_pesca1=  "Pa,Lco,Na";
else arte_pesca1=var19; 
run; 

proc freq data=analisis.sargazo_raw19;
where arte_pesca1 NE "N/C";
table arte_pesca1/ out=arte_pesca; 
run; 

data arte_pesca;
set arte_pesca;
percent2=percent/100;
run; 

ods graphics on / width=765 pt height=545 pt;
proc sgplot data=arte_pesca; 
title "Artes de Pesca que utilizan los Encuestados"; 
title2 "Para una muestra de 129 Pescadores";  
hbar  arte_pesca1/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
xaxis label="Participación en la muestra";
format percent2 percent8.2; 
yaxis label="Arte de Pesca";
footnote "11 personas no respondieron a esta pregunta"; 
run; 
ods graphics off; 



/* Label: Actividad Pesquera Encuestados 1 */
libname analisis "/folders/myfolders/proyecto_sargazo";
proc print data=analisis.sargazo_limpio (obs=10); 
run; 

*VAR19 - ¿Usualmente cuáles son las artes de pesca que utiliza?
VAR20 - ¿Cuál es el sitio donde pesca?;
/*
data analisis.datos_sitio_pesca; 
set work.import;
run;
*/ 

*haciendo las modificaciones para traer los datos creados en excel;
data analisis.datos_sitio_pesca;
set analisis.datos_sitio_pesca; 
rename provincia=provincia2;
run; 

data analisis.datos_sitio_pesca; 
length provincia $ 42;
set analisis.datos_sitio_pesca;
provincia=provincia2;
drop provincia2;
run;



proc contents data=analisis.datos_sitio_pesca;
run; 
proc contents data=analisis.sargazo_raw19; 
run; 

proc sort data=analisis.datos_sitio_pesca; by provincia var20; run; 
proc sort data=analisis.sargazo_raw19; by provincia var20;run; 


data analisis.sargazo_raw20; 
merge analisis.sargazo_raw19(in=base) analisis.datos_sitio_pesca(in=extra_vars); 
by provincia var20;
if base;
run; 

data analisis.sargazo_raw21;
set analisis.sargazo_raw20;
length sitio_pesca_3 $ 42; 
if sitio_pesca_2="" then sitio_pesca_3="La Romana-Caleta"; else sitio_pesca_3=sitio_pesca_2; 
drop sitio_pesca_2;
run; 

proc freq data=analisis.sargazo_raw21 order=freq;
table sitio_pesca_3/ out=sitio_pesca;
run; 

data sitio_pesca;
set sitio_pesca;
percent2= percent/100;
run; 


ods graphics on / width=800 pt height=700 pt;
proc sgplot data=sitio_pesca; 
title "Lugar Específico Donde Pescan"; 
title2 "Para una muestra de 129 Pescadores";  
hbar sitio_pesca_3/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=4) DATALABELFITPOLICY=NONE
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc ;
xaxis label="Participación en la muestra";
format percent2 percent8.2; 
yaxis label="Sitio de Pesca" valueattrs=(size=6.5pt); 
footnote "Nota: Ver la documentación de las modificaciones y agrupaciones a esta variable en los anexos";
run; 
ods graphics off; 









/* Label: quienes ganan mas */
libname analisis "/folders/myfolders/proyecto_sargazo";


proc sgplot data=analisis.sargazo_raw17;
title "Distribución de los Ingresos Estimados por Viaje";
title2 "Dada la Provincia"; 
title3 "Para una muestra de 129 Pescadores";   
vbox ganancia_viaje2/ category=provincia connect=mean labelfar; 
yaxis label="Ganancia Estimada por Cada Viaje" valueattrs=(size=7);
footnote1 "Nota: 3 personas no respondieron a esta pregunta"; 
where provincia not in ("Independencia");
footnote2 "Se excluyó del análisis la provincia Independecia debido a la baja frecuencia de respuesta";
format ganancia_viaje2 comma9.; 
run; 

/* Label: Caracteristicas de los Encuestados 1 */
libname analisis "/folders/myfolders/proyecto_sargazo";

/* 
Enfoque a las variables que representan las caracteristicas de los
encuestados que son las siguientes variables
Observacion
Edad
Estado_Civil
Nivel_Escolar
No__de_hijos
Tenencia_de_la_vivienda
Localidad
Fecha 
Ingresos_mensuales
*/ 

*Localidad;
proc freq data=analisis.sargazo_raw7; 
table localidad;
run; 

proc print data=analisis.sargazo_raw17;
where localidad="Los Cocos"; 
run; 

 

data analisis.sargazo_raw7;
length localidad2 $ 42;
set analisis.sargazo_raw6;
if numero=126 then localidad2="Boca de Yuma";
else if numero=127 then localidad2="Boca de Yuma";
else if localidad="Puerto Bioso" then localidad2="Puerto viejo";
else if localidad="Bahoruco (Nolasco)" then localidad2= "Bahoruco"; 
else if localidad="Piedra" then localidad2= "Boca de Yuma";
else if localidad="Barahona (Guarocuna)" then localidad2= "Barahona"; 
else if localidad="El Puerto Cabrera" or localidad="Playa Puerto"
or localidad="Playa el Puerto Cabrera" then localidad2="Playa el Puerto";

else if localidad="Juan Esteban ( El Quemaito)" or localidad="Juan Esteban ( Puji Quemaito)"
then localidad2="Juan Esteban";

else if localidad="Las Caobita" then localidad2="Las Caobitas"; 

else if localidad="Playa Caleta Romana" then localidad2="Caleta Romana";

else if localidad="Playa Monterio" then localidad2="Monte Rio";

else if localidad="Playa Najayo" then localidad2="Najayo";

else if localidad="Playa Palenque" then localidad2="Palenque";

else if localidad="Playa Pedernales" then localidad2="Pedernales";

else if localidad="Rio Juan" then localidad2="Rio San Juan";
else if localidad="Tortusuero" then localidad2="Tortuguero";
else localidad2=localidad;
run; 

proc freq data=analisis.sargazo_raw7; 
table localidad2/ out=locations; 
run;

data locations; 
set locations;
percent2= percent/100;
run; 

ods graphics on / width=765 pt height=545 pt;
proc sgplot data=locations; 
title "Distribución de la Ubicación Geográfica de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores";  
hbar  localidad2/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
xaxis label="Participación en la muestra";
format percent2 percent8.2; 
yaxis label="Localidad"; 
run; 
ods graphics off; 


*Provincia;
data analisis.sargazo_raw8;
length Provincia $ 42;
set analisis.sargazo_raw7; 
if localidad="Bahoruco" then provincia= "Bahoruco";
else if localidad="Bahoruco (Nolasco)" then provincia= "Bahoruco";
else if localidad="Barahona (Guarocuna)" then provincia= "Barahona";
else if localidad="Billeya" then provincia= "Azua" ;
else if localidad="Boca de Boba" then provincia= "María Trinidad Sánchez";
else if localidad="Boca de Yuma" then provincia= "La Altagracia";
else if localidad="Caleta Romana" then provincia= "La Romana";
else if localidad="El Puerto Cabrera" then provincia= "María Trinidad Sánchez";
else if localidad="Guayacanes" then provincia= "San Pedro de Macorís";
else if localidad="Juan Esteban" then provincia= "Barahona";
else if localidad="Juan Esteban ( El Quemaito)" then provincia= "Barahona";
else if localidad="Juan Esteban ( Puji Quemaito)" then provincia= "Barahona";
else if localidad="Juancho Punta arena" then provincia= "Pedernales";
else if localidad="Las Caobita" then provincia= "Azua" ;
else if localidad="Las Caobitas" then provincia= "Azua" ;
else if localidad="Los Cocos" then provincia= "Pedernales";
else if localidad="Matancita" then provincia= "María Trinidad Sánchez";
else if localidad="Mella" then provincia= "Independencia" ;
else if localidad="Monte Rio" then provincia= "Azua" ;
else if localidad="Najayo" then provincia= "San Cristóbal";
else if localidad="Palenque" then provincia= "San Cristóbal";
else if localidad="Palmar de Ocoa" then provincia= "Azua" ;
else if localidad="Pedernales" then provincia= "Pedernales";
else if localidad="Piedra" then provincia= "La Altagracia";
else if localidad="Playa Bahoruco" then provincia= "Barahona";
else if localidad="Playa Caleta Romana" then provincia= "La Romana";
else if localidad="Playa Guarocuya" then provincia= "Barahona";
else if localidad="Playa Monterio" then provincia= "Azua" ;
else if localidad="Playa Najayo" then provincia= "San Cristóbal";
else if localidad="Playa Palenque" then provincia= "San Cristóbal";
else if localidad="Playa Pedernales" then provincia= "Pedernales";
else if localidad="Playa Puerto" then provincia= "María Trinidad Sánchez";
else if localidad="Playa el Puerto" then provincia= "María Trinidad Sánchez";
else if localidad="Playa el Puerto Cabrera" then provincia= "María Trinidad Sánchez";
else if localidad="Puerto Bioso" then provincia= "Azua";
else if localidad="Puerto viejo" then provincia= "Azua" ;
else if localidad="Punta Cana" then provincia= "La Altagracia";
else if localidad="Rio Juan" then provincia= "María Trinidad Sánchez";
else if localidad="Rio San Juan" then provincia= "María Trinidad Sánchez";
else if localidad="Tortuguero" then provincia= "Azua" ;
else if localidad="Tortusuero" then provincia= "Azua" ;
run;



proc freq data=analisis.sargazo_raw8; 
table provincia/ out=provincias; 
run;

data provincias; 
set provincias;
percent2= percent/100;
run;


ods graphics on / width=765 pt height=545 pt;
proc sgplot data=provincias; 
title "Distribución Provincial de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores";  
hbar  provincia/response=PERCENT2 datalabel BARWIDTH=0.9 datalabelattrs=(size=10 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black)
 categoryorder=respdesc;
xaxis label="Participación en la muestra";
format percent2 percent8.2; 
yaxis label="Provincia"; 
run; 
ods graphics off; 



























/* Label: Caracteristicas de los Encuestados  */
libname analisis "/folders/myfolders/proyecto_sargazo";

*Haz la modificacion de la variable ingreso y graficala; /* 
Enfoque a las variables que representan las caracteristicas de los
encuestados que son las siguientes variables
Observacion
Edad
Estado_Civil
Nivel_Escolar
No__de_hijos
Tenencia_de_la_vivienda
Localidad
Fecha 
Ingresos_mensuales
*/ 

data analisis.sargazo_raw9;
length ingresos 8.;
set analisis.sargazo_raw8; 
if ingresos_mensuales="N/C" then ingresos=""; else ingresos=ingresos_mensuales;
run; 


*Distribucion de los ingresos;
proc sgplot data=analisis.sargazo_raw9;
title "Distribución de los Ingresos de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores";   
hbox ingresos/ labelfar; 
xaxis label="Ingresos";
footnote1 "Nota: 12 personas no respondieron a esta pregunta"; 
format ingresos comma9.; 
run; 

*Modificacion en rangos;
data analisis.sargazo_raw10;
set analisis.sargazo_raw9;
length rango_ingresos $ 40;
if ingresos>=1000 and ingresos<=10000 then rango_ingresos="1,000-10,000"; 
else if ingresos>=10001 and ingresos<=20000 then rango_ingresos="10,001-20,000";
else if ingresos>=20001 and ingresos <=30000 then rango_ingresos="20,001-30,000";
else if ingresos>=30001 and ingresos <=40000 then rango_ingresos="30,001-40,000";
else if ingresos>=40001 and ingresos <=50000 then rango_ingresos="40,001-50,000"; 
else if ingresos>=50001 and ingresos <=60000 then rango_ingresos="50,001-60,000";
else if ingresos>=60001 and ingresos <=70000 then rango_ingresos="60,001-70,000"; 
else if ingresos>=70001 and ingresos <=80000 then rango_ingresos="70,001-80,000"; 
else if ingresos>=80001 then rango_ingresos="Más de 100,000"; 
else rango_ingresos="missing"; 
run; 

proc freq data=analisis.sargazo_raw10; 
where rango_ingresos NE "missing";
table rango_ingresos/ out=ingresos2 ;
run; 

data ingresos2; 
set ingresos2;
percent2= percent/100;
run;

ods graphics on / width=765 pt height=545 pt;
proc sgplot data=ingresos2; 
title "Distribución de Ingresos de los Encuestados"; 
title2 "Para una muestra de 129 Pescadores"; 
footnote "Nota: 50 personas no respondieron a esta pregunta"; 
vbar rango_ingresos/response=percent2 datalabel BARWIDTH=1 datalabelattrs=(size=10 weight=bold) 
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
xaxis label="Ingreso de los Encuestados" valueattrs=(size=11pt weight=bold);
yaxis label="Participación"; 
format percent2 percent8.2; 
run;
title;
footnote;
ods graphics off; 






/* Label: Caracteristicas de los Encuestados  1 */
libname analisis "/folders/myfolders/proyecto_sargazo";


/* Verificar el sentido de estas preguntas
Variables que representan el tiempo percibido de sargazo 
El_sargazo_llega_desde
El_sargazo_llega_para
*/ 
*Crear rangos para esta pregunta;
proc sort data=analisis.sargazo_raw10; by provincia;run; 
proc freq data=analisis.sargazo_raw10; 
by provincia; 
table El_sargazo_llega_para; 
run; 

*Crear rangos para esta pregunta;
proc freq data=analisis.sargazo_raw10; 
table El_sargazo_llega_para; 
run; 

/*data analisis.meses_cuando_llega;
set work.import;
keep Mes; 
run; 
*/ 

proc freq data=analisis.meses_cuando_llega; 
table mes/ out=cuando_llega; 
run; 

data cuando_llega;
set cuando_llega; 
length mes_num 8.;
if mes="enero" then mes_num=1;
else if mes=    "febrero" then mes_num=2;
else if mes=    "marzo"  then mes_num=3;
else if mes=    "abril" then mes_num=4;
else if mes=    "mayo" then mes_num=5;
else if mes=    "junio" then mes_num=6;
else if mes=    "julio" then mes_num=7;
else if mes=    "agosto"  then mes_num=8;
else if mes=    "septiembre"  then mes_num=9;
else if mes=    "octubre"  then mes_num=10;
else if mes=    "noviembre"  then mes_num=11;
else if mes=    "diciembre" then mes_num=12;
run; 

proc format;
value  mesesa 
1 = 'Enero'
2 = 'Febrero'
3 = 'Marzo'
4 = "Abril"
5 = "Mayo"
6 = "Junio"
7 = "Julio"
8 = "Agosto"
9 = "Septiembre"
10 = "Octubre"
11 = "Noviembre"
12 = "Diciembre";

data cuando_llega;
set cuando_llega;
percent2= percent/100;
run; 

ods graphics on / width=765 pt height=545 pt;
proc sgplot data=cuando_llega; 
title "¿Para qué Parte del año llega el Sargazo?"; 
title2 "Para una muestra de 129 Pescadores"; 
footnote "Nota: 19 personas no respondieron a esta pregunta y 4 no la respondieron correctamente"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación mensual y criterios utilizados";
vbar mes_num/response=percent2 datalabel BARWIDTH=1 datalabelattrs=(size=11 weight=bold) 
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
xaxis label="Meses del año" valueattrs=(size=8.5pt weight=bold);
yaxis label="Participación"; 
format percent2 percent8.2 mes_num mesesa32.; 
run;
title;
footnote;
ods graphics off;
 




/* Label: Características de los Encuestados  */

libname analisis "/folders/myfolders/proyecto_sargazo";


proc sort data=analisis.pesca_provincias; by provincia; run; 

proc freq data=analisis.pesca_provincias; 
by provincia; 
table mes;
run; 

data grafico_provincia;
set analisis.pesca_provincias; 
length mes_num 8.;
if mes="enero" then mes_num=1;
else if mes=    "febrero" then mes_num=2;
else if mes=    "marzo"  then mes_num=3;
else if mes=    "abril" then mes_num=4;
else if mes=    "mayo" then mes_num=5;
else if mes=    "junio" then mes_num=6;
else if mes=    "julio" then mes_num=7;
else if mes=    "agosto"  then mes_num=8;
else if mes=    "septiembre"  then mes_num=9;
else if mes=    "octubre"  then mes_num=10;
else if mes=    "noviembre"  then mes_num=11;
else if mes=    "diciembre" then mes_num=12;
run; 

proc print data=grafico_provincia; run; 

title height=35pt "¿Para qué Parte del año llega el Sargazo?" ; 
title2 "Para una muestra de 129 Pescadores" height=20pt; 
ods graphics on / width=800 pt height=400 pt;
proc sgplot data=grafico_provincia; 
by provincia;
footnote "Nota: 19 personas no respondieron a esta pregunta y 4 no la respondieron correctamente"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación mensual y criterios utilizados";
vbar Mes_num/ stat=freq  datalabel BARWIDTH=1 datalabelattrs=(size=11 weight=bold) 
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
xaxis label="Meses del año" valueattrs=(size=8.5pt weight=bold) values=(1 to 12 by 1);
yaxis label="Participación"; 
format  mes_num mesesa32.; 
run;
title;
footnote;
ods graphics off;




/* Label: Solicitud Adicional */
libname analisis "/folders/myfolders/proyecto_sargazo";



*Esta es la data que habia del analisis pesca provincia y los graficos que se realizaron; 
*Datos importados de los entregados por Marcia; 
proc print data=analisis.kg_de_pesca; 
run;  
*columnas en stack; 
proc print data=analisis.kg_de_pesca2;
run; 

*Columnas agrupadas por provincia y por mes;
proc sql;
create table analisis.kg_pes_agrupado as 
select Provincia, mes, mean(kg_de_pesca) as promedio_kgs
from analisis.kg_de_pesca2 
group by Provincia, mes;

*Datos para el grafico utilizado; 
data grafico_provincia;
set analisis.pesca_provincias; 
if mes="enero" then mes_num=1;
else if mes=    "febrero" then mes_num=2;
else if mes=    "marzo"  then mes_num=3;
else if mes=    "abril" then mes_num=4;
else if mes=    "mayo" then mes_num=5;
else if mes=    "junio" then mes_num=6;
else if mes=    "julio" then mes_num=7;
else if mes=    "agosto"  then mes_num=8;
else if mes=    "septiembre"  then mes_num=9;
else if mes=    "octubre"  then mes_num=10;
else if mes=    "noviembre"  then mes_num=11;
else if mes=    "diciembre" then mes_num=12;
run; 

proc sql; 
create table percepcion_llegada as 
select provincia, mes, count(mes_num) as percepcion_llegada
from grafico_provincia
group by provincia, mes; 

proc sql;
create table respuestas_provincia as
select provincia, sum(percepcion_llegada) as total_mes
from percepcion_llegada
group by provincia;

proc sort data=respuestas_provincia; by provincia; run; 
proc sort data=percepcion_llegada; by provincia; run; 

data percepcion_llegada_f; 
merge respuestas_provincia(in=bueno) percepcion_llegada (in=malo); 
by provincia; 
if bueno; 
participacion= percepcion_llegada/total_mes;
run; 

*modificacion de los datos; 
proc sort data=percepcion_llegada_f; by provincia mes; run;
proc sort data=analisis.kg_pes_agrupado; by provincia mes; run; 

data juntando; 
length mes_num 8.;
merge analisis.kg_pes_agrupado (in=bueno) percepcion_llegada_f; 
by provincia mes; 
if bueno; 
if mes="enero" then mes_num=1;
else if mes=    "febrero" then mes_num=2;
else if mes=    "marzo"  then mes_num=3;
else if mes=    "abril" then mes_num=4;
else if mes=    "mayo" then mes_num=5;
else if mes=    "junio" then mes_num=6;
else if mes=    "julio" then mes_num=7;
else if mes=    "agosto"  then mes_num=8;
else if mes=    "septiembre"  then mes_num=9;
else if mes=    "octubre"  then mes_num=10;
else if mes=    "noviembre"  then mes_num=11;
else if mes=    "diciembre" then mes_num=12;
run;

*Formato de los meses;
proc format;
value  mesesa 
1 = 'Enero'
2 = 'Febrero'
3 = 'Marzo'
4 = "Abril"
5 = "Mayo"
6 = "Junio"
7 = "Julio"
8 = "Agosto"
9 = "Septiembre"
10 = "Octubre"
11 = "Noviembre"
12 = "Diciembre"; 

*Formato del nombre de la variable;
data juntando2;
set juntando;
rename promedio_kgs=Captura_Promedio_en_Kg;
run; 

*Query que saca los datos generales; 
proc sql; 
create table datos_generales as
select mes_num, mean(Captura_Promedio_en_Kg) as total_captura,
sum(total_mes) as total_mensual, sum(percepcion_llegada) as total_percepcion
from juntando2
group by mes_num;



data datos_generales2; 
set datos_generales; 
participacion= total_percepcion/282; 
log_total_captura= log(total_captura); 
log_total_percepcion= log(total_percepcion);
run; 


*Relacion General- Scatter Plot; 
title1 height=17pt "¿Para qué Parte del año llega el Sargazo?" ; 
title2 height=15pt "Comparado con la Captura Promedio por Embarcación en Kgs"; 
title3 "Para una muestra de 129 Pescadores" height=20pt; 
ods graphics on / width=800 pt height=400 pt;
proc sgplot data=datos_generales2; 
scatter x=log_total_captura y=log_total_percepcion; 
xaxis valueattrs=(size=8.5pt weight=bold) values=(0 to 4.5 by 0.5);
yaxis  valueattrs=(size=8.5pt weight=bold) values=(0 to 4 by 0.5);
run;
title;
footnote;
ods graphics off;



*Datos generales; 
title1 height=17pt "¿Para qué Parte del año llega el Sargazo?" ; 
title2 height=15pt "Comparado con la Captura Promedio por Embarcación en Kgs"; 
title3 "Para una muestra de 129 Pescadores" height=20pt; 
ods graphics on / width=800 pt height=400 pt;
proc sgplot data=datos_generales2; 
footnote "Nota: 19 personas no respondieron a esta pregunta y 4 no la respondieron correctamente"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación mensual y criterios utilizados";
vbar Mes_num/ response=participacion  datalabel BARWIDTH=1 datalabelattrs=(size=12 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black);
vline mes_num/ response=total_captura nostatlabel y2axis lineattrs=(pattern=solid THICKNESS=2pt) datalabel markers
lineattrs=(pattern=solid color='#201F73') datalabel markers datalabelpos=bottom
markerattrs=(symbol=circlefilled color='#201F73' size=7pt) datalabelattrs=(size=9 color=black weight=bold); 
y2axis label="Captura por Desembarco Promedio en Kg"; 
xaxis label="Meses del año" valueattrs=(size=8.5pt weight=bold) values=(1 to 12 by 1);
yaxis label="Participación de la llegada Percibida del Sargazo"; 
format participacion percent9.2 total_captura comma9.1 mes_num mesesa.; 
keylegend/ exclude=("participacion (Sum)") title="Leyenda";
run;
title;
footnote;
ods graphics off;




*Para La Altagracia y la Romana debo poner el DATALABELPOS=down;
title1 height=17pt "¿Para qué Parte del año llega el Sargazo?" ; 
title2 height=15pt "Comparado con la Captura Promedio por Embarcación en Kgs"; 
title3 "Para una muestra de 129 Pescadores" height=20pt; 
ods graphics on / width=800 pt height=400 pt;
proc sgplot data=juntando2; 
by provincia;
footnote "Nota: 19 personas no respondieron a esta pregunta y 4 no la respondieron correctamente"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación mensual y criterios utilizados";
vbar Mes_num/ response=participacion  datalabel BARWIDTH=1 datalabelattrs=(size=12 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black);
vline mes_num/ response=Captura_Promedio_en_Kg nostatlabel y2axis lineattrs=(pattern=solid THICKNESS=2pt) datalabel markers
lineattrs=(pattern=solid color='#201F73') datalabel markers
markerattrs=(symbol=circlefilled color='#201F73' size=7pt) datalabelattrs=(size=9 color=black weight=bold); 
y2axis label="Captura por Desembarco Promedio en Kg"; 
xaxis label="Meses del año" valueattrs=(size=8.5pt weight=bold) values=(1 to 12 by 1);
yaxis label="Participación de la llegada Percibida del Sargazo"; 
format  participacion percent32.1 Captura_Promedio_en_Kg comma9.1 mes_num mesesa.; 
where provincia not in("Peravia" "Barahona" "La Altagracia" "La Romana");
keylegend/ exclude=("participacion (Sum)") title="Leyenda";
run;
title;
footnote;
ods graphics off;

*Otro grupo de graficos;
title1 height=17pt "¿Para qué Parte del año llega el Sargazo?" ; 
title2 height=15pt "Comparado con la Captura Promedio por Embarcación en Kgs"; 
title3 "Para una muestra de 129 Pescadores" height=20pt; 
ods graphics on / width=800 pt height=400 pt;
proc sgplot data=juntando2; 
by provincia;
footnote "Nota: 19 personas no respondieron a esta pregunta y 4 no la respondieron correctamente"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación mensual y criterios utilizados";
vbar Mes_num/ response=participacion  datalabel BARWIDTH=1 datalabelattrs=(size=12 weight=bold)
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) datalabelfitpolicy= rotate;
vline mes_num/ response=Captura_Promedio_en_Kg nostatlabel y2axis lineattrs=(pattern=solid THICKNESS=2pt) datalabel markers
lineattrs=(pattern=solid color='#201F73') datalabel markers datalabelpos=bottom
markerattrs=(symbol=circlefilled color='#201F73' size=7pt) datalabelattrs=(size=9 color=black weight=bold); 
y2axis label="Captura por Desembarco Promedio en Kg"; 
xaxis label="Meses del año" valueattrs=(size=8.5pt weight=bold) values=(1 to 12 by 1);
yaxis label="Participación de la llegada Percibida del Sargazo"; 
format  participacion percent32.1 Captura_Promedio_en_Kg comma9.1 mes_num mesesa.; 
where provincia  in("Barahona" "La Altagracia" "La Romana");
keylegend/ exclude=("participacion (Sum)") title="Leyenda";
run;
title;
footnote;
ods graphics off;


*Poniendo los datos por provincias en formato general; 








/* Label: Caracteristicas de los Encuestados  2 */
libname analisis "/folders/myfolders/proyecto_sargazo";

*El_sargazo_llega_desde; 
data analisis.sargazo_raw11;
length cuando_llego 8.;
set analisis.sargazo_raw10;
 if El_sargazo_llega_desde="2 meses" or
        El_sargazo_llega_desde="3 meses" or
        El_sargazo_llega_desde="7 meses" or
        El_sargazo_llega_desde="Febrero" or
        El_sargazo_llega_desde="Junio-Octubre"
        then cuando_llego=0;
else if El_sargazo_llega_desde="1 años" or
        El_sargazo_llega_desde="2 años" or
        El_sargazo_llega_desde="3 años" or
        El_sargazo_llega_desde="4 años" or
        El_sargazo_llega_desde="Varios años"
        then cuando_llego=1;
else if  El_sargazo_llega_desde="5 años" or
         El_sargazo_llega_desde="6 años" or
         El_sargazo_llega_desde="7 años" or
         El_sargazo_llega_desde="8 años"
         then cuando_llego=2;
else if  El_sargazo_llega_desde="10 años" or
         El_sargazo_llega_desde="12 años" or
         El_sargazo_llega_desde="15 años" or
         El_sargazo_llega_desde="17 años" or
         El_sargazo_llega_desde="18 años" or
         El_sargazo_llega_desde="20 años"
         then cuando_llego=3;
else if  El_sargazo_llega_desde="35 años" or
         El_sargazo_llega_desde="40 años"        
         then cuando_llego=4;
else if  El_sargazo_llega_desde="Siempre" 
         then cuando_llego=5;
else if  El_sargazo_llega_desde="N/C" 
         then  cuando_llego=6;
run; 

proc format; 
    value ordera
    0= "Menos de 1 año"
    1= "1-5 años"
    2= "5-10 años"
    3= "10-20 años"
    4= "Mas de 20 años"
    5= "Siempre"
    6= "N/C";
    run; 

proc freq data=analisis.sargazo_raw11; 
table cuando_llego/ out=cuando_llegof;
where cuando_llego NE 6; 
format cuando_llego ordera32.;
run; 

data cuando_llegof;
set cuando_llegof;
percent2= percent/100; 
run; 


title height=12pt "¿Desde hace cuanto tiempo llega el Sargazo?" ; 
title2 "Para una muestra de 129 Pescadores";
*ods graphics on / width=800 pt height=400 pt;
proc sgplot data=cuando_llegof; 
footnote "Nota: 9 personas no respondieron a esta pregunta"; 
footnote2 "Ver anexos para más detalles sobre esta agrupación mensual y criterios utilizados";
vbar cuando_llego/ response=percent2  datalabel BARWIDTH=1 datalabelattrs=(size=11 weight=bold) 
fillattrs=(color="lightblue") baselineattrs=(thickness=1 color=black) ;
xaxis label="Desde cuando llega el Sargazo" valueattrs=(size=8.5pt weight=bold);
yaxis label="Participación"; 
format percent2 percent32. cuando_llego ordera32.; 
run;
title;
footnote;
*ods graphics off;






