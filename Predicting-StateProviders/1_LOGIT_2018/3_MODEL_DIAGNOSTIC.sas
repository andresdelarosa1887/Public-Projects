libname logit "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/LOGIT_MODEL/MODELING_LOGITS/1_LOGIT_2018/DATOS"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA/ORIGIN";
libname rpe "/folders/myfolders/DGCP/CIERRES/DATOS/RPE";
libname simula "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/DATOS/DATOS_GRAFICOS/EN_ORDEN/SIMULACIONES_LOGIT";

*EVALUANDO EL MODELO; 
proc plm restore=logit_2018_NOR; 
	score data=logit.logit_337 out=model_diagnostics/ ilink;
	title "Predictions using PROC PLM";
run;

data model_diagnostics_2; 
set model_diagnostics; 
if predicted>0.50 then prediccion=1; 
else prediccion=0; 
run; 

data model_diagnostics_3; 
set model_diagnostics_2; 
length RESULTADO_1 $ 40 RESULTADO $ 40;
if prediccion =adjudicado_2018 then RESULTADO_1="CORRECT";
else RESULTADO_1="INCORRECTO"; 
if prediccion=1 and adjudicado_2018=1 then RESULTADO="TP";
else if prediccion=0 and adjudicado_2018=0 then RESULTADO="TN";
else if prediccion=1 and adjudicado_2018=0 then RESULTADO="FP";
else if prediccion=0 and adjudicado_2018=1 then RESULTADO="FN";
run; 

proc freq data=model_diagnostics_3; 
table resultado*resultado_1;
run; 

proc freq data=model_diagnostics_3; 
table resultado;
run; 

proc freq data=model_diagnostics_3; 
table adjudicado_2018*prediccion/nopercent nocol norow; 
run;
 