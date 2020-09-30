libname rpe "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA";
libname rpe_l "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018/MODELING_LOGITS";
libname graficos "/folders/myfolders/DGCP/DOCUMENTO_AGOSTO/DATOS/DATOS_GRAFICOS/SIMULACIONES_LOGIT";


data predictions_3373; 
infile datalines dlm=",";
length GENERO $14 CLASIFICACION_RPE $16; 
input  Genero CLASIFICACION_RPE	ESDISTRITO	Esfabricante	EsDistribuidor
	EsImportador EsContratista	EsBienes	EsConsultoria
	EsServicios	CERT_MIC DISTANOS_ADJ2	ANOS_REGISTRADA2;
datalines;
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,1
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,1,2
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,2,3
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,3,4
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,4,5
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,5,6
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,6,7
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,7,8
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,1
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,1,2
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,2,3
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,3,4
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,4,5
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,5,6
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,6,7
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,7,8
; 
run;

proc plm restore=logit_2016; 
	score data=predictions_3373 out=simulaciones_3373/ ilink;
	title "Predictions using PROC PLM";
run;
proc print data=simulaciones_3373; 
run;

title "Evolución de la Probabilidad por Género"; 
TITLE2 "De una pequeña empresa Certificada en el MIC que Provee Bienes";
TITLE3 "dado Años distintos adjudicación";
proc sgplot data=simulaciones_3373; 
series x=DISTANOS_ADJ2 y=predicted / group=genero datalabel markers;
format predicted percent8.2;
xaxis label="Años de Adjudicación";
yaxis label="Predicción";
footnote "La probabilidad de éxito de ser adjudicada en los años 2016 y 2017";
run; 

data graficos.simulacion_1; 
set simulaciones_3373;
run; 

*PREDICCIONES 2; 
data predictions_33731; 
infile datalines dlm=",";
length GENERO $14 CLASIFICACION_RPE $16; 
input  Genero CLASIFICACION_RPE	ESDISTRITO	Esfabricante	EsDistribuidor
	EsImportador EsContratista	EsBienes	EsConsultoria
	EsServicios	CERT_MIC DISTANOS_ADJ2	ANOS_REGISTRADA2;
datalines;
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,1
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,2
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,3
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,4
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,5
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,6
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,7
Masculino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,8
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,1
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,2
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,3
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,4
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,5
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,6
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,7
 Femenino,Pequeña empresa,1,0,0,0,0,1,0,1,1,0,8
; 
run;

proc plm restore=logit_2016; 
	score data=predictions_33731 out=simulaciones_33731/ ilink;
	title "Predictions using PROC PLM";
run;

title "Evolución de la Probabilidad por Género"; 
TITLE2 "De una pequeña empresa Certificada en el MIC que Provee Bienes";
TITLE3 "dado los Años de Registro en el RPE";
proc sgplot data=simulaciones_33731; 
series x=ANOS_REGISTRADA2 y=predicted / group=genero datalabel markers;
format predicted percent8.2;
xaxis label="Años de Registro sin Lograr una Adjudicación";
yaxis label="Predicción";
footnote "La probabilidad de éxito de ser adjudicada en los años 2016 y 2017";
run; 

data graficos.simulacion_2; 
set simulaciones_33731;
run; 

