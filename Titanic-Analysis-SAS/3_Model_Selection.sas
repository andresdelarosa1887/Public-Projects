libname itla "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_3";

*EVALUANDO EL MODELO; 
proc plm restore=itla_pf; 
	score data=itla.train_2 out=simulaciones_3375/ ilink;
	title "Predictions using PROC PLM";
run;

data itla.model_selection; 
set simulaciones_3375; 
if predicted>0.50 then prediccion=1; 
else prediccion=0; 
run; 

data itla.model_selection_2; 
set itla.model_selection; 
length RESULTADO_1 $ 40 RESULTADO $ 40;
if prediccion =survived then RESULTADO_1="CORRECT";
else RESULTADO_1="INCORRECTO"; 
if prediccion=1 and survived=1 then RESULTADO="TP";
else if prediccion=0 and survived=0 then RESULTADO="TN";
else if prediccion=1 and survived=0 then RESULTADO="FP";
else if prediccion=0 and survived=1 then RESULTADO="FN";
run; 

proc freq data=itla.model_selection_2; 
table resultado*resultado_1;
run; 

proc freq data=itla.model_selection_2; 
table resultado;
run; 

proc freq data=itla.model_selection_2; 
table survived*prediccion/nopercent nocol norow; 
run;
 


