libname rpe "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA/ORIGIN";
libname rpe_l "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018/MODELING_LOGITS";

*MODIFICANDO LOS ANOS ADJUDICADOS PARA EL 2016- REGISTRO DE PROVEDOR AL 2016;
data rpe.logit_3372; 
set rpe.logit_337; 
IF DISTANOS_ADJ>0 THEN DISTANOS_ADJ2=DISTANOS_ADJ-1; ELSE DISTANOS_ADJ2=0;
IF ANOS_REGISTRADA>0 then ANOS_REGISTRADA2= ANOS_REGISTRADA-1; ELSE ANOS_REGISTRADA2=1;
drop ADJUDICADO_2017; 
where ano_registro<2017; 
drop ano_registro DISTANOS_ADJ ANOS_REGISTRADA;
RUN; 
proc print data=rpe_l.logit_3372 (obs=8);  
run; 
proc freq data=rpe_l.logit_3372; 
tables clasificacion_rpe*esfabricante; 
run; 

*
Esfabricante
EsDistribuidor
EsImportador
EsContratista
EsBienes
EsConsultoria
EsServicios
ADJANO_2016;

*ADJUDICACIONES DEL ANO 2016 COMO VARIABLE DEPENDIENTE;
*ods select none; 
ods select all; 
proc logistic data=rpe_l.logit_3372 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class genero (param=reference ref='Masculino') 
		  CLASIFICACION_RPE (param=reference ref="No clasificada"); 
	model  ADJANO_2016(event='1')= Genero CLASIFICACION_RPE  CERT_MIC CLASIFICACION_RPE*CERT_MIC ANOS_REGISTRADA2	ESDISTRITO 
	Esfabricante	EsDistribuidor	EsImportador	EsContratista	EsBienes	EsConsultoria	EsServicios
			DISTANOS_ADJ2/ clodds=pl selection=backward slentry=0.10 slstay=0.15; 
	TITLE1 "QUE CARACTERISTICAS DE LOS PROVEEDORS INFLUYERON A QUE ESTOS FUERAN ADJUDICADOS"; 
	store out=logit_2016; 
run; 
*CERT_MIC

;
proc freq data=rpe.logit_3372;
tables clasificacion_rpe*CERT_MIC; 
where ADJANO_2016=1; 
run; 




*CREAR UNA SIMULACION DE UNA MIPYME; 
data predictions_3372; 
infile datalines dlm=",";
length GENERO $14 CLASIFICACION_RPE $16; 
input  Genero CLASIFICACION_RPE	ESDISTRITO	Esfabricante	EsDistribuidor
	EsImportador EsContratista	EsBienes	EsConsultoria
	EsServicios	CERT_MIC DISTANOS_ADJ2	ANOS_REGISTRADA2;
datalines;
Femenino,Pequeña empresa,  1,0,0,0,0,1,0,1,0,0,1
Femenino,Mediana empresa,  1,0,0,0,0,1,0,1,0,0,1
Femenino,Micro empresa,    1,0,0,0,0,1,0,1,0,0,1
Femenino,N/A,              1,0,0,0,0,1,0,1,0,0,1
Femenino,No clasificada,   1,0,0,0,0,1,0,1,0,0,1
Masculino,Pequeña empresa, 1,0,0,0,0,1,0,1,0,0,1
Masculino,Mediana empresa, 1,0,0,0,0,1,0,1,0,0,1
Masculino,Micro empresa,   1,0,0,0,0,1,0,1,0,0,1
Masculino,N/A,             1,0,0,0,0,1,0,1,0,0,1
Masculino,No clasificada,  1,0,0,0,0,1,0,1,0,0,1
; 
run;


proc plm restore=logit_2016; 
	score data=predictions_3372 out=simulaciones_3372/ ilink;
	title "Predictions using PROC PLM";
run;


title "PROBABILIDAD DE UN FABRICANTE QUE NO ES DEL DISTRITO A SER ADJUDICADO EN EL 2016"; 
TITLE2 "CERTIFICADA O NO CERTIFICADA POR EL MIC";
proc sgplot data=simulaciones_3372; 
vbar genero/ response=predicted group=clasificacion_rpe groupdisplay=cluster datalabel; 
format predicted percent8.2;
where clasificacion_rpe not in("N/A" "No clasificada");
run; 

title "PROBABILIDAD DE UN FABRICANTE QUE NO ES DEL DISTRITO A SER ADJUDICADO EN EL 2016"; 
TITLE2 "QUE ES UNA PEQUENA EMPRESA CERTIFICADA POR EL MIC";
proc sgplot data=simulaciones_3372; 
vbar CERT_MIC/ response=predicted group=genero groupdisplay=cluster datalabel; 
format predicted percent8.2;
run; 






