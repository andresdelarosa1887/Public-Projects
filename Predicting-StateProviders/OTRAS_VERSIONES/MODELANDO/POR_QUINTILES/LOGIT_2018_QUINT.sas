libname logit "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/LOGIT_MODEL/MODELING_LOGITS/POR_QUINTILES"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA/ORIGIN";
libname rpe "/folders/myfolders/DGCP/CIERRES/DATOS/RPE";

*QUEDA MEJOR VER LAS DIFERENCIAS EN EL TOP 10% DE LOS PROVEEDORES CON MAYORES ADJUDICA
CIONES ES DECIR, PROVEEDORES QUE HAN CONTRATADO EN TOTAL A JUNIO DE 2018 
MAS DE 5,114,120 PESOS;

proc sql; 
create table rpedistintos_2018 as 
select distinct ano_aprobacion,rpe, sum(valor_total) as TOTAL_CONTRATADO FORMAT=DOLLAR32.
from compras.historicos_break
where ano_aprobacion=2018 and ORIGEN="PT" 
group by rpe
HAVING CALCULATED TOTAL_CONTRATADO>5114120
order by ano_aprobacion,rpe; 

data rpedistintos_2018_2;
length ADJUDICADO 8.;  
set rpedistintos_2018;
if rpe>0 then ADJUDICADO=1;
rename ANO_APROBACION=ANO_ADJUDICACION;
rename rpe=rpe_1;
run; 

data rpedistintos_2018_3; 
set rpedistintos_2018_2;
rpe= input(rpe_1, 8.);
drop rpe_1;
run; 

*MODIFICANDO EL REGISTRO DE PROVEEDOR; 
data logit.logit_1;
set rpe.fin_jun_mej; 
drop Ocupacion	Observacion FechaRegistroMercantil Direccion Contacto FechaUltimaActualizacion A__oUltimaActualizacion
A__oUltimaModificacion TelefonoComercial PosicionContacto TelefonoContacto CorreoContacto RazonSocial NombreComercial
Documento TipoDocumento FechaAlta Periodo Mes FechaBaja Estatus MesUltimaActualizacion  NUMERO_REGION 
REGION EsMiPyme RubroPrincipal Municipio FechaUltimaModificacion MesUltimaModificacion TipoPersona CumpleCriterioMiPymeSegunDGII;
rename ANO=ANO_REGISTRO;
where estatus="Activo";
run; 


data logit.logit_2;
set logit.logit_1;
ANOS_REGISTRADA= 2019-ANO_REGISTRO;
if PROVINCIA="DISTRITO NACIONAL" THEN ESDISTRITO=1; ELSE ESDISTRITO=0; 
if TipoFabricante="Sí" then  Esfabricante=1; else Esfabricante=0;
if TipoDistribuidor="Sí" then  EsDistribuidor=1; else EsDistribuidor=0;
if TipoImportador="Sí" then  EsImportador=1; else EsImportador=0;
if TipoContratista="Sí" then  EsContratista=1; else EsContratista=0;
if TipoBienes="Sí" then  EsBienes=1; else EsBienes=0;
if TipoConsultoria="sí" then  EsConsultoria=1; else EsConsultoria=0;
if TipoServicios="Sí" then  EsServicios=1; else EsServicios=0;
DROP PROVINCIA TipoFabricante	TipoDistribuidor TipoImportador	TipoContratista	TipoBienes	TipoConsultoria	TipoServicios ; 
run; 

*HACIENDO EL JOIN;
proc sort data=logit.logit_2; by rpe; 
run; 
proc sort data=rpedistintos_2018_3; by rpe; 
run; 

data logit.logit_334;
merge logit.logit_2 (in=BASES) rpedistintoS_2018_3 (in=ADJUDICADOSS);
BY rpe;
run; 

*SACANDO LOS ANOS DISTINTOS ADJUDICADOS;
proc sql; 
create table work.anos_dist AS
select distinct rpe, count(distinct ano_aprobacion) as ANOS_DIST_ADJUDICADO
from compras.historicos_break
group by rpe;
run; 

*SACANDO SI FUE ADJUDICADO EL ANO PASADO;
proc sql; 
create table work.ano_pasado as 
select distinct rpe, count(distinct ano_aprobacion) as ADJUDICACION_ANO_PASADO
from compras.historicos_break
where ano_aprobacion=2017
group by rpe;

data work.anos_dist_2; set work.anos_dist; rename rpe=rpe_1; run; 
data work.anos_dist_3; set work.anos_dist_2; RPE= input(rpe_1, 8.); drop rpe_1;run; 
proc contents data=work.anos_dist_3; run; 
proc print data=work.anos_dist_3 (obs=10); run; 
data work.ano_pasado_2; set work.ano_pasado; rename rpe=rpe_1; run; 
data work.ano_pasado_3; set work.ano_pasado_2; RPE= input(rpe_1, 8.); drop rpe_1;run; 
proc contents data=work.ano_pasado_3; run; 
proc print data=work.ano_pasado_3 (obs=10); run; 

proc sort data=work.ano_pasado_3; by rpe; run; 
proc sort data=work.anos_dist_3; by rpe; run; 

data logit.logit_335; merge logit.logit_334 (in=BASES) work.ano_pasado_3 (in=ADJUDICADOSS);BY rpe; if bases; run; 
data logit.logit_336; merge logit.logit_335 (in=BASES) work.anos_dist_3 (in=ADJUDICADOSS); BY rpe; if bases; run; 

proc print data=logit.logit_336 (obs=10); run;

data logit.logit_337; 
set logit.logit_336; 
if ADJUDICADO=1 then ADJUDICADO_2018=1; ELSE ADJUDICADO_2018=0;
if ADJUDICACION_ANO_PASADO=1 then ADJANO_2017=1; ELSE ADJANO_2017=0;
if CertificadoPorMIC="Si" then CERT_MIC=1; Else CERT_MIC=0;
if ANOS_DIST_ADJUDICADO>0 then DISTANOS_ADJ=ANOS_DIST_ADJUDICADO; ELSE DISTANOS_ADJ=0; 
DROP ADJUDICADO ADJUDICACION_ANO_PASADO ANO_ADJUDICACION CertificadoPorMIC ANOS_DIST_ADJUDICADO SEXO;   
RUN;


ods select all; 
proc logistic data=logit.logit_337 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class genero (param=reference ref='Masculino') 
		  clasificacion_empresarial_3 (param=reference ref="MIPYMES no certificadas y otras organizaciones")
		  MACROREGION (param=reference ref="SURESTE"); 
	model ADJUDICADO_2018(event='1')= Genero	clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	Esfabricante	EsDistribuidor	EsImportador	EsContratista	EsBienes	EsConsultoria	EsServicios
	ADJANO_2017	DISTANOS_ADJ;
		title "EN EL TOP 90% DE LO CONTRATADO POR PROVEEDOR"; 
	TITLE2 "EN EL 2018- DATOS PORTAL TRANSACCIONAL";
	store out=logit_2018; 
run; 


PROC PRINT DATA=logit.logit_337 (obs=1);
run;

proc freq data=logit.logit_337; 
tables clasificacion_empresarial_3; 
run; 

*PREDICCIONES; 
data predictions_3373; 
infile datalines dlm=",";
length GENERO $14 clasificacion_empresarial_3 $100 MACROREGION  $100; 
input  Genero	clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	Esfabricante	EsDistribuidor	EsImportador	EsContratista	EsBienes	EsConsultoria	EsServicios
	ADJANO_2017	DISTANOS_ADJ;
datalines;
Masculino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,0,1,0,0,1,1
Masculino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,0,1,0,0,1,2
Masculino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,0,1,0,0,1,3
Masculino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,0,1,0,0,1,4
Masculino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,0,1,0,0,1,5
Masculino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,0,1,0,0,1,6
Masculino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,0,1,0,0,1,7
Masculino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,0,1,0,0,1,8
Femenino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,0,1,0,0,1,1
Femenino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,0,1,0,0,1,2
Femenino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,0,1,0,0,1,3
Femenino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,0,1,0,0,1,4
Femenino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,0,1,0,0,1,5
Femenino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,0,1,0,0,1,6
Femenino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,0,1,0,0,1,7
Femenino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,0,1,0,0,1,8
Masculino,Gran empresa,2,SURESTE,0,1,0,0,1,0,0,1,1
Masculino,Gran empresa,3,SURESTE,0,1,0,0,1,0,0,1,2
Masculino,Gran empresa,4,SURESTE,0,1,0,0,1,0,0,1,3
Masculino,Gran empresa,5,SURESTE,0,1,0,0,1,0,0,1,4
Masculino,Gran empresa,6,SURESTE,0,1,0,0,1,0,0,1,5
Masculino,Gran empresa,7,SURESTE,0,1,0,0,1,0,0,1,6
Masculino,Gran empresa,8,SURESTE,0,1,0,0,1,0,0,1,7
Masculino,Gran empresa,9,SURESTE,0,1,0,0,1,0,0,1,8
Femenino,Gran empresa,2,SURESTE,0,1,0,0,1,0,0,1,1
Femenino,Gran empresa,3,SURESTE,0,1,0,0,1,0,0,1,2
Femenino,Gran empresa,4,SURESTE,0,1,0,0,1,0,0,1,3
Femenino,Gran empresa,5,SURESTE,0,1,0,0,1,0,0,1,4
Femenino,Gran empresa,6,SURESTE,0,1,0,0,1,0,0,1,5
Femenino,Gran empresa,7,SURESTE,0,1,0,0,1,0,0,1,6
Femenino,Gran empresa,8,SURESTE,0,1,0,0,1,0,0,1,7
Femenino,Gran empresa,9,SURESTE,0,1,0,0,1,0,0,1,8
Masculino,Persona Física,2,SURESTE,0,1,0,0,1,0,0,1,1
Masculino,Persona Física,3,SURESTE,0,1,0,0,1,0,0,1,2
Masculino,Persona Física,4,SURESTE,0,1,0,0,1,0,0,1,3
Masculino,Persona Física,5,SURESTE,0,1,0,0,1,0,0,1,4
Masculino,Persona Física,6,SURESTE,0,1,0,0,1,0,0,1,5
Masculino,Persona Física,7,SURESTE,0,1,0,0,1,0,0,1,6
Masculino,Persona Física,8,SURESTE,0,1,0,0,1,0,0,1,7
Masculino,Persona Física,9,SURESTE,0,1,0,0,1,0,0,1,8
Femenino,Persona Física,2,SURESTE,0,1,0,0,1,0,0,1,1
Femenino,Persona Física,3,SURESTE,0,1,0,0,1,0,0,1,2
Femenino,Persona Física,4,SURESTE,0,1,0,0,1,0,0,1,3
Femenino,Persona Física,5,SURESTE,0,1,0,0,1,0,0,1,4
Femenino,Persona Física,6,SURESTE,0,1,0,0,1,0,0,1,5
Femenino,Persona Física,7,SURESTE,0,1,0,0,1,0,0,1,6
Femenino,Persona Física,8,SURESTE,0,1,0,0,1,0,0,1,7
Femenino,Persona Física,9,SURESTE,0,1,0,0,1,0,0,1,8
;
run;

proc plm restore=logit_2018; 
	score data=predictions_3373 out=simulaciones_3373/ ilink;
	title "Predictions using PROC PLM";
run;
proc print data=simulaciones_3373; 
run;

title "Evolución de la Probabilidad por Género"; 
TITLE2 "De una pequeña empresa Certificada en el MIC que Provee Bienes";
TITLE3 "dado Años distintos adjudicación";
proc sgplot data=simulaciones_3373; 
series x=DISTANOS_ADJ y=predicted / group=genero datalabel markers;
format predicted percent8.2;
xaxis label="Años de Adjudicación";
yaxis label="Predicción";
footnote "La probabilidad de éxito de ser adjudicada en los años 2016 y 2017";
run; 
title "Evolución de la Probabilidad por Género"; 
TITLE2 "De una pequeña empresa Certificada en el MIC que Provee Bienes";
TITLE3 "dado Años distintos adjudicación";


proc sgplot data=simulaciones_3373; 
vline DISTANOS_ADJ/ response=predicted stat=mean group=clasificacion_empresarial_3 datalabel markers;
format predicted percent8.2;
xaxis label="Años de Adjudicación";
yaxis label="Predicción";
footnote "La probabilidad de éxito de ser adjudicada en los años 2016 y 2017";
run; 








