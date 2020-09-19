libname logit "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/LOGIT_MODEL/MODELING_LOGITS/MAYOR_5MM"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA/ORIGIN";
libname rpe "/folders/myfolders/DGCP/CIERRES/DATOS/RPE";

PROC means DATA=COMPRAS.HISTORICOS_BREAK;
VAR valor_total; 
class sexo; 
where ano_aprobacion=2015;
run; 

proc sql; 
create table rpedistintos_20173 as 
select distinct ano_aprobacion,rpe
from compras.historicos_break
where ano_aprobacion=2017 and valor_total>500000
group by rpe, ano_aprobacion
order by rpe; 



*PROBABILIDAD DE ADJUDICACION DE CONTRATACIONES QUE EN ESE ANO SU CONTRATACION SUMAN MAS DE 500,000;
proc sql; 
create table rpedistintos_2017 as 
select distinct ano_aprobacion,rpe, sum(valor_total) as TOTAL_CONTRATADO FORMAT=DOLLAR32.
from compras.historicos_break
where ano_aprobacion=2017 
group by rpe, ano_aprobacion
HAVING CALCULATED TOTAL_CONTRATADO>10000000
order by rpe; 


data rpedistintos_2017_2;
length ADJUDICADO 8.;  
set rpedistintos_2017;
if rpe>0 then ADJUDICADO=1;
rename ANO_APROBACION=ANO_ADJUDICACION;
rename rpe=rpe_1;
run; 

data rpedistintos_2017_3; 
set rpedistintos_2017_2;
rpe= input(rpe_1, 8.);
drop rpe_1;
run; 

*MODIFICANDO EL REGISTRO DE PROVEEDOR; 
data logit.logit_16;
set rpe.fin_jun_MEJ; 
drop Ocupacion	Observacion FechaRegistroMercantil Direccion Contacto FechaUltimaActualizacion A__oUltimaActualizacion
A__oUltimaModificacion TelefonoComercial PosicionContacto TelefonoContacto CorreoContacto RazonSocial NombreComercial
Documento TipoDocumento FechaAlta Periodo Mes FechaBaja Estatus MesUltimaActualizacion  NUMERO_REGION
REGION EsMiPyme RubroPrincipal Municipio FechaUltimaModificacion MesUltimaModificacion TipoPersona CumpleCriterioMiPymeSegunDGII;
rename ANO=ANO_REGISTRO;
run; 

data logit.logit_26;
set logit.logit_16;
ANOS_REGISTRADA= 2018-ANO_REGISTRO;
if PROVINCIA="DISTRITO NACIONAL" THEN ESDISTRITO=1; ELSE ESDISTRITO=0; 
if TipoFabricante="Sí" then  Esfabricante=1; else Esfabricante=0;
if TipoDistribuidor="Sí" then  EsDistribuidor=1; else EsDistribuidor=0;
if TipoImportador="Sí" then  EsImportador=1; else EsImportador=0;
if TipoContratista="Sí" then  EsContratista=1; else EsContratista=0;
if TipoBienes="Sí" then  EsBienes=1; else EsBienes=0;
if TipoConsultoria="sí" then  EsConsultoria=1; else EsConsultoria=0;
if TipoServicios="Sí" then  EsServicios=1; else EsServicios=0;
DROP PROVINCIA TipoFabricante	TipoDistribuidor TipoImportador	TipoContratista	TipoBienes	TipoConsultoria	TipoServicios ; 
where ano_registro<2018; 
run; 

*HACIENDO EL JOIN;
proc sort data=logit.logit_26; by rpe; 
run; 
proc sort data=rpedistintos_2017_3; by rpe; 
run; 

data logit.logit_3346;
merge logit.logit_26 (in=BASES) rpedistintoS_2017_3 (in=ADJUDICADOSS);
BY rpe;
if bases;
run; 

*SACANDO LOS ANOS DISTINTOS ADJUDICADOS;
proc sql; 
create table work.anos_dist AS
select distinct rpe, count(distinct ano_aprobacion) as ANOS_DIST_ADJUDICADO
from compras.historicos_break
where ano_aprobacion<2018
group by rpe;
run; 

proc print data=work.anos_dist;
where anos_dist_adjudicado>12;
run; 


proc print data=work.anos_dist (obs=1); 
where ANOS_DIST_ADJUDICADO>12;
run; 

proc print data=rpe.fin_jun_MEJ; 
where rpe=1223;
run; 


*SACANDO SI FUE ADJUDICADO EL ANO PASADO;
proc sql; 
create table work.ano_pasado as 
select distinct rpe, count(distinct ano_aprobacion) as ADJUDICACION_ANO_PASADO
from compras.historicos_break
where ano_aprobacion=2016 
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

data logit.logit_3356; merge logit.logit_3346 (in=BASES) work.ano_pasado_3 (in=ADJUDICADOSS);BY rpe; if bases; run; 
data logit.logit_3366; merge logit.logit_3356 (in=BASES) work.anos_dist_3 (in=ADJUDICADOSS); BY rpe; if bases; run; 

proc print data=logit.logit_3366 (obs=10); run;

data logit.logit_3376; 
set logit.logit_3366; 
if ADJUDICADO=1 then ADJUDICADO_2017=1; ELSE ADJUDICADO_2017=0;
if ADJUDICACION_ANO_PASADO=1 then ADJANO_2016=1; ELSE ADJANO_2016=0;
if CertificadoPorMIC="Si" then CERT_MIC=1; Else CERT_MIC=0;
if ANOS_DIST_ADJUDICADO>0 then DISTANOS_ADJ=ANOS_DIST_ADJUDICADO; ELSE DISTANOS_ADJ=0; 
DROP ADJUDICADO ADJUDICACION_ANO_PASADO ANO_ADJUDICACION CertificadoPorMIC ANOS_DIST_ADJUDICADO;   
RUN;

proc print data=logit.logit_3376 (obs=10); 
run; 
proc freq data=logit.logit_3376; 
tables CLASIFICACION_EMPRESARIAL_3*ADJUDICADO_2017;  
run; 
