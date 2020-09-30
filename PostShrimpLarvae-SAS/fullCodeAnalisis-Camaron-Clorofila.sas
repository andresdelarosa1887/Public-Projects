/* Label: Descriptivo Inicial */
libname camaron "/folders/myshortcuts/PROYECTOS_R/CAMARON_CLOROFILA/proyecto_camaron_clorofila";

/*
data camaron.datos_camaron; 
set work.import;
mes= month(Fecha);
dia= day(Fecha); 
ano= year(Fecha);
run;
data camaron.datos_camaron2;  
set work.stacked; 
mes= month(Fecha);
dia= day(Fecha); 
ano= year(Fecha);
run;
data camaron.datos_camaron2;
set camaron.datos_camaron2; 
label captura= "Especie del Camarón";
run; 
*/

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

proc contents data=camaron.datos_camaron2 nodetails;
run;


*Grafico inicial de la informacion, captura promedio por ano, observacion por cada ano; 
proc sql; 
create table captura_total as
select ano, sum(captura_total) as total_capturado 
from camaron.datos_camaron2
where ano>=2017
group by ano; 
*Sacando el promedio por captura;
proc means data=camaron.datos_camaron3;
var logcaptura_total; 
class ano;
where ano>2016; 
output out=ejercicio_media mean=a_mean n=Observaciones; 
run; 

data ejercicio_media;  set ejercicio_media; 
media_geometrica= exp(a_mean);  keep  ano  media_geometrica Observaciones;
where ano is not missing; 
run;
*Uniendo datos de la captura total con el promedio geometrico; 
proc sort data=captura_total; by ano; run; 
proc sort data= ejercicio_media; by ano; run; 

data grafico_inicial; 
merge captura_total ejercicio_media; 
by ano; 
label total_capturado="Total Capturado en Kg"
 media_geometrica="Captura Promedio por Viaje";
run; 

title height=15pt "Total Capturado por Periodo de Estudio en Kg";
title2 height=12pt "Enero 2017- Septiembre 2019";
proc sgplot data=grafico_inicial  noborder noautolegend;
yaxistable media_geometrica Observaciones /  stat=mean valueattrs=(size=12) nostatlabel; 
hbar ano/ response=total_capturado datalabel
datalabelattrs=(size=12) ; *fillattrs=(color="#201F73"); 
format total_capturado comma9.2 media_geometrica comma9.2; 
yaxis display=(noline) label= "Periodo de Estudio" valueattrs=(size=12) labelattrs=(size=12);
xaxis label="Total Capturado en Kg" valueattrs=(size=11.5) labelattrs=(size=12);
footnote height=6pt "Se utilizó el promedio Geométrico"  ; 
run;

*Grafico de la Captura por mes; 
proc sql; 
create table captura_total as
select mes, sum(captura_total) as total_capturado 
from camaron.datos_camaron2
where ano>=2017
group by mes; 
*Sacando el promedio por captura;
proc means data=camaron.datos_camaron3;
var logcaptura_total; 
class mes;
where ano>2016; 
output out=ejercicio_media mean=a_mean n=Observaciones LCLM=lclm Uclm=uclm ;  
run; 

data ejercicio_media;  set ejercicio_media; 
media_geometrica= exp(a_mean);
intervalo_superior= exp(lclm); 
intervalo_menor= exp(uclm);
keep  mes  media_geometrica  intervalo_superior intervalo_menor Observaciones; 
run;

proc print data=ejercicio_media;
*Uniendo datos de la captura total con el promedio geometrico; 
proc sort data=captura_total; by mes; run; 
proc sort data= ejercicio_media; by mes; run; 

data grafico_inicial; 
merge captura_total ejercicio_media; 
by mes; 
label total_capturado="Total Capturado en Kg"
 media_geometrica="Captura Promedio por Viaje";
run; 

title height=15pt "Total Capturado por Periodo de Estudio en Kg";
title2 height=12pt "Enero 2017- Septiembre 2019";
proc sgplot data=grafico_inicial  noborder noautolegend;
yaxistable media_geometrica Observaciones /  stat=mean valueattrs=(size=12) nostatlabel; 
hbar mes/ response=total_capturado datalabel
datalabelattrs=(size=12) ; *fillattrs=(color="#201F73"); 
format total_capturado comma9.2 media_geometrica comma9.2 mes  mesesa32.; 
yaxis display=(noline) label= "Periodo de Estudio" valueattrs=(size=12) labelattrs=(size=12);
xaxis label="Total Capturado en Kg" valueattrs=(size=11.5) labelattrs=(size=12);
footnote height=6pt "Se utilizó el promedio Geométrico"  ; 
run;


*Captura por Especie;
proc sql; 
create table captura_total as
select captura, sum(captura_total) as total_capturado 
from camaron.datos_camaron2
group by captura; 
proc print data=captura_total; sum total_capturado; run;

*Captura por Especie y por año; 
proc sql; 
create table captura_total2 as
select ano,captura, sum(captura_total) as total_capturado 
from camaron.datos_camaron2
where ano>=2017
group by ano, captura; 

*Ubicacion de la captura; 
* Hay que hacer unas modificaciones en los niveles de la variable sitio de pesca;
data camaron.datos_camaron3; 
set camaron.datos_camaron2;
Sitio_de_pesca= lowcase(Sitio_de_pesca);
logcaptura_total = log(captura_total);
run; 

ods graphics on / width=900 pt height=545 pt;
proc sgplot data=camaron.datos_camaron3;
title "Camarón Capturado por Sitio de Pesca";
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vbar  ano/response=captura_total stat=sum group=sitio_de_pesca 
 groupdisplay=stack datalabel datalabelattrs=(size=11pt weight=bold)  seglabel seglabelattrs=(size=11pt); 
 where ano>2016; 
 xaxis label= "Periodo de captura"; 
 yaxis label= "Total capturado en Kg"; 
 format captura_total comma9.0; 
run;
title;
footnote;
ods graphics off;


proc sql; 
create table captura_total2 as
select Sitio_de_pesca, sum(captura_total) as total_capturado 
from camaron.datos_camaron3
where ano=2019
group by Sitio_de_pesca
order by calculated total_capturado; 

proc print data=captura_total2; sum total_capturado; run; 

proc means data=camaron.datos_camaron3;
var captura_total;
class sitio_de_pesca;
where ano=2019;
run; 

*Captura promedio del camaron por sitio de pesca;
*Sacando el promedio geometrico y transformando la informacion para graficar por sitio de pesca; 
proc means data=camaron.datos_camaron3;
var logcaptura_total; 
class sitio_de_pesca;
where ano>2016; 
output out=ejercicio_media mean=a_mean n=Observaciones; 
run; 

data ejercicio_media;  set ejercicio_media; 
media_geometrica= exp(a_mean);  keep  sitio_de_pesca
  media_geometrica Observaciones;
where sitio_de_pesca is not missing; 
run;

proc sql; 
create table total_capturado as
select Sitio_de_pesca, sum(captura_total) as total_capturado
from camaron.datos_camaron3
where ano>2016
group by Sitio_de_pesca; 

proc sort data=total_capturado; by sitio_de_pesca; run; 
proc sort data=ejercicio_media; by sitio_de_pesca; run; 

data total_juntos; 
merge total_capturado ejercicio_media; 
by sitio_de_pesca; 
keep sitio_de_pesca total_capturado media_geometrica  Observaciones;
label media_geometrica="Captura Promedio por Viaje"; 
run; 

*Grafico de la Captura Promedio por Sitio de Pesca; 
ods graphics on / width=765 pt height=545 pt;
title height=15pt "Total Capturado por Sitio de Pesca en Kg";
title2 height=12pt "Enero 2017- Septiembre 2019";
proc sgplot data=total_juntos  noborder noautolegend;
yaxistable media_geometrica Observaciones /  stat=mean valueattrs=(size=11.5) nostatlabel; 
hbar sitio_de_pesca/ response=total_capturado datalabel
datalabelattrs=(size=12) categoryorder=respdesc; *fillattrs=(color="#201F73"); 
format total_capturado comma9.2; 
yaxis display=(noline) label= "Sitio de Pesca" valueattrs=(size=12) labelattrs=(size=12);
xaxis label="Total Capturado en Kg" valueattrs=(size=11.5) labelattrs=(size=12);
footnote height=6pt "Se utilizó el promedio Geométrico"  ; 
run;
ods graphics off; 

*Grafico del sitio de peca por Especie;
ods graphics on / width=765 pt height=545 pt;
title height=15pt "Total Capturado por Sitio de Pesca y por Especie en Kg";
title2 height=12pt "Enero 2017- Septiembre 2019";
proc sgplot data=camaron.datos_camaron3  noborder;
hbar sitio_de_pesca/ response=captura_total stat=sum datalabel group=captura
datalabelattrs=(size=12) categoryorder=respdesc; *fillattrs=(color="#201F73"); 
format captura_total comma9.2; 
where ano>2016;
yaxis display=(noline) label= "Sitio de Pesca" valueattrs=(size=12) labelattrs=(size=12);
xaxis label="Total Capturado en Kg" valueattrs=(size=11.5) labelattrs=(size=12);
footnote height=6pt "Se utilizó el promedio Geométrico"  ; 
run;
ods graphics off; 


*Transformaciones para sacar tabla resumen del ano por especie;
proc sql; 
create table tabla_resumen as 
select captura, sitio_de_pesca, sum(captura_total) as total_capturado 
from camaron.datos_camaron3
group by sitio_de_pesca, captura; 

proc sort data=WORK.tabla_resumen out=WORK.SORTTempTableSorted;
    by Sitio_de_pesca;
run;

proc transpose data=WORK.SORTTempTableSorted 
out=tabla_resumen2;
    var total_capturado;
    id captura;
    by Sitio_de_pesca;
run;

proc print data=tabla_resumen2; run; 




/* Label: clorofila_exploratorio */
libname camaron "/folders/myshortcuts/PROYECTOS_R/CAMARON_CLOROFILA/proyecto_camaron_clorofila";

/*
FILENAME REFFILE '/folders/myfolders/proyecto_camaron_clorofila/clorofila_modificado.xlsx';
PROC IMPORT DATAFILE=REFFILE
    DBMS=XLSX
    OUT=WORK.IMPORT;
    GETNAMES=YES;
RUN;
data camaron.datos_clorofila;
set work.import; 
mes= month(Fecha);
dia= day(Fecha); 
ano= year(Fecha);
run;

data camaron.datos_clorofila;
length tomar_encuenta 8.; 
set camaron.datos_clorofila;
valor_log= log(valor_final); 
if valor_final=0 then tomar_encuenta=0;
else if mes=4 and ano=2017 then tomar_encuenta=0;
else if mes=12 then tomar_encuenta=0; 
else tomar_encuenta=1; 
rename ano=Periodo; 
run;

*/

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
run; 


*Frecuencia de medicion;
proc freq data=camaron.datos_clorofila;
table Periodo*mes/ nocol nocum nopercent norow;
where tomar_encuenta=1;
run;

*Distribucion anual de la clorofila medida; 
ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_clorofila; 
title "Distribución anual de la Clorofila mg/m3"; 
title2 "En las Costas de Samaná";
title3 "Enero 2017- Septiembre 2019";
vbox valor_final/ category=ano  connect=median
fillattrs=(color="lightblue");
xaxis label="Año" valueattrs=(size=8.5pt weight=bold);
yaxis label="Concentración de la Clorofila Medida mg/m3"; 
where tomar_encuenta=1;
footnote "Para 107 observaciones";
run;
title;
footnote;
ods graphics off;

proc means data=camaron.datos_clorofila; 
var valor_final;
class ano;
where tomar_encuenta=1;
run;        

*Distribucion historica mensual; 
ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_clorofila; 
title "Intensidad Promedio Mensual de la Clorofila mg/m3"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vline mes/ response=valor_final group=Periodo stat=mean markers
datalabel=valor_final;
xaxis label="Meses del Año" valueattrs=(size=8.5pt weight=bold);
yaxis label="Promedio de la Concentración de la Clorogila mg/m3"; 
format   mes  mesesa32. valor_final comma9.2; 
where tomar_encuenta=1;
xaxistable valor_final /stat=freq colorgroup=Periodo  
/* */ valueattrs=(weight=bold size=11pt weight=normal) title="Frecuencia de Observaciones"
 titleattrs=(weight=bold size=8.8pt color=black)
labelattrs=(weight=bold size=11pt) labelpos=left; 
run;
title;
footnote;
ods graphics off;

ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_clorofila; 
title "Distribución Histórica Mensual de la Clorofila Medida"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vbox valor_final/ category=mes  connect=mean; 
xaxis label="Meses del Año" valueattrs=(size=8.5pt weight=bold);
yaxis label="Intensidad de la Clorofila"; 
format   mes  mesesa32. valor_final comma9.2; 
where tomar_encuenta=1;
run; 
ods graphics off;

*Intervalos de confianza; 
proc means data=camaron.datos_clorofila  N NMISS CLM nway ;
  class Mes;
  var valor_final;
  where tomar_encuenta=1;
  format   mes  mesesa32. valor_final comma9.2; 
  output out=want  /autoname;
run;

*Distribucion historica Semanal; 
ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_clorofila noautolegend; 
title "Intensidad Promedio Semanal de la Clorofila mg/m3"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vline Semana/ response=valor_final group=Periodo stat=mean markers
datalabel=valor_final;
xaxis label="Semana del mes" valueattrs=(size=8.5pt weight=bold);
yaxis label="Promedio de la Concentración de la Clorogila mg/m3"; 
format  valor_final comma9.2; 
where tomar_encuenta=1;
xaxistable valor_final /stat=freq colorgroup=Periodo  
/* */ valueattrs=(weight=bold size=11pt weight=normal) title="Frecuencia de Observaciones"
 titleattrs=(weight=bold size=8.8pt color=black)
labelattrs=(weight=bold size=11pt) labelpos=left; 
run;
title;
footnote;
ods graphics off;

ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_clorofila; 
title "Distribución Histórica Semanal de la Clorofila mg/m3"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vbox valor_final/ category=Semana connect=mean; 
xaxis label="Semana del Mes" valueattrs=(size=8.5pt weight=bold);
yaxis label="Intensidad de la Clorofila"; 
format  valor_final comma9.2; 
where tomar_encuenta=1;
xaxistable valor_final /stat= mean x=Semana label="Promedio"
/* */ valueattrs=(weight=bold size=11pt weight=normal) 
 titleattrs=(weight=bold size=8.8pt color=black)
labelattrs=(weight=bold size=11pt) labelpos=left;
run; 
ods graphics off;



ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_clorofila; 
title "Distribución Histórica Diaria Mensual de la Clorofila Medida"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vbox valor_final/ category=dia  connect=mean; 
xaxis label="Días del Mes" valueattrs=(size=8.5pt weight=bold);
yaxis label="Intensidad de la Clorofila"; 
format  valor_final comma9.2; 
where tomar_encuenta=1;
run; 
ods graphics off;


proc print data=camaron.datos_clorofila;
where tomar_encuenta=1;  
run;

libname correl "/folders/myshortcuts/PROYECTOS_R/CAMARON_CLOROFILA/proyecto_camaron_clorofila/correlacion_camaron_clorofila";

data correl.clorofila_inicial;
set camaron.datos_clorofila; 
where tomar_encuenta=1; 
run; 



 






/* Label: Descriptivo Inicial 2 */
libname camaron "/folders/myshortcuts/PROYECTOS_R/CAMARON_CLOROFILA/proyecto_camaron_clorofila";

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
run; 

proc contents data=camaron.datos_camaron3 nodetails; run; 

*Captura promedio del camaron por especie del camaron;
*Sacando el promedio geometrico y transformando la informacion para graficar por sitio de pesca; 
proc means data=camaron.datos_camaron3;
var logcaptura_total; 
class arte;
where ano>2016; 
output out=ejercicio_media mean=a_mean n=Observaciones; 
run; 

data ejercicio_media;  set ejercicio_media; 
media_geometrica= exp(a_mean);  keep  arte
  media_geometrica Observaciones;
where arte is not missing; 
run;

proc sql; 
create table total_capturado as
select arte, sum(captura_total) as total_capturado
from camaron.datos_camaron3
where ano>2016
group by arte; 

proc sort data=total_capturado; by arte; run; 
proc sort data=ejercicio_media; by arte; run; 

data total_juntos; 
merge total_capturado ejercicio_media; 
by arte; 
keep arte total_capturado media_geometrica  Observaciones;
label media_geometrica="Captura Promedio por Viaje"; 
run; 

*Grafico de la Captura Promedio por Arte de Pesca; 
ods graphics on / width=765 pt height=545 pt;
title height=15pt "Total Capturado por Arte de Pesca en Kg";
title2 height=12pt "Enero 2017- Septiembre 2019";
proc sgplot data=total_juntos  noborder noautolegend;
yaxistable media_geometrica Observaciones /  stat=mean valueattrs=(size=11.5) nostatlabel; 
hbar arte/ response=total_capturado datalabel
datalabelattrs=(size=12) categoryorder=respdesc; *fillattrs=(color="#201F73"); 
format total_capturado comma9.2; 
yaxis display=(noline) label= "Arte" valueattrs=(size=12) labelattrs=(size=12);
xaxis label="Total Capturado en Kg" valueattrs=(size=11.5) labelattrs=(size=12);
footnote height=6pt "Se utilizó el promedio Geométrico"  ; 
run;
ods graphics off; 

*Camaron Capturado por Especie y por Arte de Pesca;
ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_camaron3;
where ano>2016; 
title "Camarón Capturado por Arte de Pesca y Especie";
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
hbar arte/response=captura_total stat=sum group=captura 
 groupdisplay=stack datalabel datalabelattrs=(size=11pt weight=bold)  seglabel seglabelattrs=(size=11pt) categoryorder=respdesc; 
 xaxis label="Total Capturado"; 
 yaxis label="Arte de Pesca"; 
 format captura_total comma9.2; 
run;
title;
footnote;
ods graphics off;


*Camaron capturado por arte de pesca y localidad;
proc sql; 
create table agrupacion_ubicacion as 
select Arte, Sitio_de_pesca,  sum(captura_total) as total_captura
from camaron.datos_camaron3
where ano>2016 
group by  Arte, Sitio_de_pesca; 
proc sort data=WORK.AGRUPACION_UBICACION out=WORK.SORTTempTableSorted;
    by Sitio_de_pesca arte;
run;
proc transpose data=WORK.SORTTempTableSorted prefix='Arte-'n 
        out=agrupacion_ubicacion2(drop=_Name_);
    var total_captura;
    id arte;
    by Sitio_de_pesca;
run;
proc delete data=WORK.SORTTempTableSorted;
run;
proc print data=agrupacion_ubicacion2; 
run;



    



*Otros graficos utilizados en el analisis de la informacion que no fueron incluidos en el proyecto;
proc sql; 
create table agrupacion_mensual as 
select ano,mes, tipo_de_captura,  sum(captura_total) as promedio_captura
from camaron.datos_camaron2
group by ano,mes, tipo_de_captura; 

ods graphics on / width=765 pt height=545 pt;
proc sgplot data=agrupacion_mensual; 
title "Distribución  Mensual del Camarón Capturado por Tipo"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vline mes/ response=promedio_captura group=tipo_de_captura  datalabel=promedio_captura groupdisplay=cluster;
xaxis label="Meses del Año" valueattrs=(size=8.5pt weight=bold);
yaxis label="Cantidad de Camarón Capturado"; 
format   mes  mesesa32. promedio_captura comma9.2; 
run;
title;
footnote;
ods graphics off;



ods graphics on / width=765 pt height=545 pt;
proc sgpanel data=camaron.datos_camaron2; 
panelby tipo_de_captura; 
title "Distribución  Mensual del Camarón Capturado por Tipo"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vline mes/ response=captura_total stat=sum group=ano  datalabel=captura_total groupdisplay=cluster;
format   mes  mesesa32. captura_total comma9.2; 
where ano>2016;
run;
title;
footnote;
ods graphics off;




ods graphics on / width=765 pt height=545 pt;
proc sgpanel data=camaron.datos_camaron2; 
panelby tipo_de_captura; 
title "Distribución  Mensual del Camarón Capturado por Tipo"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vbox captura_total/ category=mes connect=mean;
format   mes  mesesa32. captura_total comma9.2; 
where ano>2016;
colaxis label="Meses del Año" valueattrs=(size=8.5pt weight=bold); 
rowaxis label="Cantidad de Camarón Capturado";
run;
title;
footnote;
ods graphics off;


ods graphics on / width=765 pt height=545 pt;
proc sgpanel data=camaron.datos_camaron2; 
panelby tipo_de_captura; 
title "Distribución  Mensual del Camarón Capturado por Tipo"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vbox captura_total/ category=arte connect=mean;
format   mes  mesesa32. captura_total comma9.2; 
where ano>2016;
colaxis label="Meses del Año" valueattrs=(size=8.5pt weight=bold); 
rowaxis label="Cantidad de Camarón Capturado";
run;
title;
footnote;
ods graphics off;





/* Label: Analisis de Correlacion */
libname correl "/folders/myshortcuts/PROYECTOS_R/CAMARON_CLOROFILA/proyecto_camaron_clorofila/correlacion_camaron_clorofila";
libname camaron "/folders/myshortcuts/PROYECTOS_R/CAMARON_CLOROFILA/proyecto_camaron_clorofila";

/*
*Creando los datos del camaron para el analisis de correlacion;
proc sql;
create table something as
select  ano, mes, dia, sum(captura_total) as total_capturado 
from camaron.datos_camaron3
where ano>2016
group by ano, mes, dia;
data correl.camaron_inicial; 
set something; 
run; 
*/

*Analisis de correlacion del camaron y la clorofila; 
*Por dia;
proc sql; 
create table  ano_mes_clorofila as
select periodo as ano, mes,dia, mean(valor_final) as intensidad_de_clorofila
from correl.clorofila_inicial
group by ano, mes, dia;
proc sql; 
create table  ano_mes_camaron as
select ano, mes,dia, sum(total_capturado) as camaron_capturado
from correl.camaron_inicial
group by ano, mes, dia;

*Preparando el Join por dia ;
proc sort data=ano_mes_clorofila; by ano mes dia; run; 
proc sort data=ano_mes_camaron; by ano mes dia; run; 

data juntos; 
merge ano_mes_clorofila ano_mes_camaron;
by ano mes dia;
run; 
proc sgplot data=juntos; 
by ano;
scatter x=camaron_capturado y=intensidad_de_clorofila; 
run;

*Por mes;
proc sql; 
create table  ano_mes_clorofila as
select periodo as ano, mes, mean(valor_final) as intensidad_de_clorofila
from correl.clorofila_inicial
group by ano, mes;

proc sql; 
create table  ano_mes_camaron as
select ano, mes, sum(total_capturado) as camaron_capturado
from correl.camaron_inicial
group by ano, mes;

*Preparando el Join por mes ;
proc sort data=ano_mes_clorofila; by ano mes ; run; 
proc sort data=ano_mes_camaron; by ano mes ; run; 

data juntos; 
merge ano_mes_clorofila ano_mes_camaron;
by ano mes;
run; 

*Grafico de la correlacion entre ambas variables; 
ods graphics on / width=765 pt height=545 pt;
proc sgplot data=juntos; 
title "Relación entre el Camarón Capturado y la Intensidad Promedio de la Clorofila";
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
scatter x=camaron_capturado y=intensidad_de_clorofila/
 markerattrs=(color=blue size=10 symbol=CircleFilled); 
 xaxis label="Intensidad Promedio de la Clorofila"; 
 yaxis label="Camarón Capturado en Kg";  
run;
title;
footnote;
ods graphics off;

proc corr data=juntos plots=matrix(histogram);
var camaron_capturado intensidad_de_clorofila;
run;



*Distribucion historica mensual; 
ods graphics on / width=765 pt height=545 pt;
proc sgplot data=camaron.datos_clorofila; 
title "Intensidad Promedio Mensual de la Clorofila mg/m3"; 
title2 "En las Costas de Samaná"; 
title3 "Enero 2017- Septiembre 2019";
vline mes/ response=valor_final group=Periodo stat=mean markers
datalabel=valor_final;
xaxis label="Meses del Año" valueattrs=(size=8.5pt weight=bold);
yaxis label="Promedio de la Concentración de la Clorogila mg/m3"; 
format   mes  mesesa32. valor_final comma9.2; 
where tomar_encuenta=1;
xaxistable valor_final /stat=freq colorgroup=Periodo  
/* */ valueattrs=(weight=bold size=11pt weight=normal) title="Frecuencia de Observaciones"
 titleattrs=(weight=bold size=8.8pt color=black)
labelattrs=(weight=bold size=11pt) labelpos=left; 
run;
title;





