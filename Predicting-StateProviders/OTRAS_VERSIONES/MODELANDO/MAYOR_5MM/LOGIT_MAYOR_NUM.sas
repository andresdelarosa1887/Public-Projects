libname logit "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/LOGIT_MODEL/MODELING_LOGITS/MAYOR_5MM"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA/ORIGIN";
libname rpe "/folders/myfolders/DGCP/CIERRES/DATOS/RPE";

*verificar la libreria logit antes de correr el programa, para este script se utiliza la libreria modeling logits
y se toma la tabla logit.3376;


ods select all; 
proc logistic data=logit.logit_3376 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class genero (param=reference ref='Masculino') 
		  clasificacion_empresarial_3 (param=reference ref="MIPYMES no certificadas y otras organizaciones")
		  MACROREGION (param=reference ref="SURESTE"); 
	model ADJUDICADO_2017(event='1')= Genero	clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	Esfabricante	EsDistribuidor	EsImportador	EsContratista	EsBienes	EsConsultoria	EsServicios
	ADJANO_2016	DISTANOS_ADJ/ clodds=pl selection=stepwise slentry=0.30 slstay=0.35; 
	TITLE1 "QUE CARACTERISTICAS DE LOS PROVEEDORS INFLUYERON A QUE ESTOS FUERAN ADJUDICADOS"; 
	TITLE2 "EN EL 2017";
	store out=logit_2017; 
run; 

proc freq data=rpe.logit_337;
tables clasificacion_empresarial_3; 
run; 
proc print data=rpe.logit_337(obs=1); 
run; 



*CREAR UNA SIMULACION DE UNA MIPYME; 
data predictions_337; 
infile datalines dlm=",";
length GENERO $14 CLASIFICACION_RPE $16; 
input GENERO CLASIFICACION_RPE ANOS_REGISTRADA	ESDISTRITO	Esfabricante
EsDistribuidor	EsImportador	EsContratista	EsBienes	EsConsultoria
EsServicios ADJANO_2016	CERT_MIC DISTANOS_ADJ;
datalines;
Masculino,       Pequeña empresa,1,0,1,0,0,0,0,0,0,0,1,1
Masculino,       Pequeña empresa,2,0,1,0,0,0,0,0,0,0,1,1
Masculino,       Pequeña empresa,3,0,1,0,0,0,0,0,0,0,1,1
Masculino,       Pequeña empresa,4,0,1,0,0,0,0,0,0,0,1,1
Masculino,       Pequeña empresa,5,0,1,0,0,0,0,0,0,0,1,1
Masculino,       Pequeña empresa,6,0,1,0,0,0,0,0,0,0,1,1
Femenino,        Pequeña empresa,1,0,1,0,0,0,0,0,0,0,1,1
Femenino,        Pequeña empresa,2,0,1,0,0,0,0,0,0,0,1,1
Femenino,        Pequeña empresa,3,0,1,0,0,0,0,0,0,0,1,1
Femenino,        Pequeña empresa,4,0,1,0,0,0,0,0,0,0,1,1
Femenino,        Pequeña empresa,5,0,1,0,0,0,0,0,0,0,1,1
Femenino,        Pequeña empresa,13,0,1,0,0,0,0,0,0,0,1,1
; 
run;

proc plm restore=logit_2017; 
	score data=predictions_337 out=simulaciones_337/ ilink;
	title "Predictions using PROC PLM";
run; 

proc print data=simulaciones_337; 
run; 


title "PROBABILIDAD DE UN FABRICANTE QUE NO ES DEL DISTRITO A SER ADJUDICADO EN EL 2016"; 
TITLE2 "QUE ES UNA PEQUENA EMPRESA CERTIFICADA POR EL MIC";
proc sgplot data=simulaciones_337; 
series x=ANOS_REGISTRADA y=predicted / group=GENERO datalabel;
format predicted percent8.2;
run;  

