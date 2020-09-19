libname itla "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_3";

proc print data=itla.train_2 (obs=1); 
run; 

*PONIENDO EL FORMATO DE LA EDAD;
proc format; 
value age
0 - 9.99 = "0 - 9"
10-19.99= "10- 19"
20 - 29.99 = '20 - 29'
30 - 39.99 = '30 - 39'
40 - 49.99 = '40 - 49'
50 - 59.99 = '50 - 59'
60-69.99= "60- 69"
70 - 100 = "70 o más";
run;

proc freq data=itla.train_2;
tables agem*pclass; 
format agem age.; 
run; 

proc sort data=itla.train_2; by pclass; run;
proc means data=itla.train_2; 
by pclass;
var fare; 
class agem; 
format agem age.; 
where fare>0;
run; 


*ANALISIS DE LAS VENTAS;
ods graphics on / width=6.5in height=3.5in;
proc sgpanel data=itla.train_2; 
panelby pclass/ columns=3 uniscale=column;
title "INGRESOS POR VENTAS DEL TITANIC";
title2 "POR CLASES Y POR EDADES";
vline agem/response=fare stat=sum datalabel datalabelattrs=(color=black size=8) nostatlabel 
 MARKERS markerattrs=(symbol=circlefilled color=red size=7) lineattrs=(thickness=1.1); 
colaxis label="EDADES" labelattrs=(size=12 weight=bold) grid; 
rowaxis label="INGRESOS POR VENTAS" labelattrs=(size=12 weight=bold) grid;
format agem age. fare dollar9.;
run; 
ods graphics off;
*ANALISIS DE LA CANTIDAD DE PERSONAS POR EDAD POR CLASE; 
proc sgplot data=itla.train_2; 
title "CANTIDAD DE PASAJEROS";
title2 "POR CLASES Y POR EDADES";
vbar agem/ response=fare stat=freq group=pclass
datalabel seglabel datalabelattrs=(size=8 weight=bold) seglabelattrs=(size=8 weight=bold);
format agem age. fare comma9.;
xaxis label="EDADES" labelattrs=(size=12 weight=bold) grid; 
yaxis label="CANTIDAD DE PASAJEROS" labelattrs=(size=12 weight=bold) grid;
run; 

*ANALISIS DE LA CANTIDAD DE FAMILIARES POR CLASE; 
proc sgplot data=itla.train_2; 
title "INGRESOS POR VENTAS DE TITANIC";
title2 "POR CLASES Y POR EDADES";
vbar Parch/ response=fare stat=freq group=pclass datalabel seglabel;
run;

proc sgplot data=itla.train_2; 
by pclass; 
scatter x=agem y=fare; 
format agem age.;
run; 




