libname rpe "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA";

proc print data=rpe.logit_337 (obs=10); 
run; 

*ods select none; 
ods select all; 
proc logistic data=rpe.logit_338 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class genero (param=reference ref='Masculino') 
		  CLASIFICACION_RPE (param=reference ref="No clasificada"); 
	model ADJUDICADO_2017(event='1')= Genero	CLASIFICACION_RPE	ANOS_REGISTRADA	ESDISTRITO
	Esfabricante	EsDistribuidor	EsImportador	EsContratista	EsBienes	EsConsultoria	EsServicios
	ADJANO_2016	CERT_MIC	DISTANOS_ADJ/ clodds=pl selection=stepwise slentry=0.30 slstay=0.35; 
	TITLE1 "QUE CARACTERISTICAS DE LOS PROVEEDORS INFLUYERON A QUE ESTOS FUERAN ADJUDICADOS"; 
	TITLE2 "EN EL 2017";
	store out=que_locura; 
run; 

proc print data=rpe.logit_337 (obs=10); 
run; 

PROC SQL; 
select genero, count(adjudicado_2017)
from rpe.logit_338
where adjudicado_2017=1
group by genero; 

*CREAR UNA SIMULACION DE UNA MIPYME; 
data predictions_337; 
infile datalines dlm=",";
length GENERO $14 CLASIFICACION_RPE $16; 
input GENERO CLASIFICACION_RPE ANOS_REGISTRADA	ESDISTRITO	Esfabricante
EsDistribuidor	EsImportador	EsContratista	EsBienes	EsConsultoria
EsServicios ADJANO_2016	CERT_MIC DISTANOS_ADJ;
datalines;
Masculino,       Pequeña empresa,1,0,1,0,0,0,0,0,0,0,1,1
Masculino,       Pequeña empresa,2,0,1,0,0,0,0,0,0,0,1,2
Masculino,       Pequeña empresa,3,0,1,0,0,0,0,0,0,0,1,3
Masculino,       Pequeña empresa,4,0,1,0,0,0,0,0,0,0,1,4
Masculino,       Pequeña empresa,5,0,1,0,0,0,0,0,0,0,1,5
Masculino,       Pequeña empresa,6,0,1,0,0,0,0,0,0,0,1,6
Femenino,        Pequeña empresa,1,0,1,0,0,0,0,0,0,0,1,1
Femenino,        Pequeña empresa,2,0,1,0,0,0,0,0,0,0,1,2
Femenino,        Pequeña empresa,3,0,1,0,0,0,0,0,0,0,1,3
Femenino,        Pequeña empresa,4,0,1,0,0,0,0,0,0,0,1,4
Femenino,        Pequeña empresa,5,0,1,0,0,0,0,0,0,0,1,5
Femenino,        Pequeña empresa,6,0,1,0,0,0,0,0,0,0,1,6
; 
run;

proc plm restore=que_locura; 
	score data=predictions_337 out=something/ ilink;
	title "Predictions using PROC PLM";
run; 


proc print data=rpe.logit_337 (obs=10); 
where ADJUDICADO_2017=1; 
run; 

proc sql; 
select genero, count(EstadoActual) as TOTAL_CONTEO 
from rpe.logit_337
where ADJUDICADO_2017=1 
group by genero;




