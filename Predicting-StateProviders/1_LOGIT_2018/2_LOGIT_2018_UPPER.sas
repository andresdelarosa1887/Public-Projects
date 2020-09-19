libname logit "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/LOGIT_MODEL/MODELING_LOGITS/1_LOGIT_2018/DATOS"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA/ORIGIN";
libname rpe "/folders/myfolders/DGCP/CIERRES/DATOS/RPE";


*QUEDA MEJOR VER LAS DIFERENCIAS EN EL TOP 10% DE LOS PROVEEDORES CON MAYORES ADJUDICA
CIONES ES DECIR, PROVEEDORES QUE HAN CONTRATADO EN TOTAL A JUNIO DE 2018 
MAS DE 5,114,120 PESOS;

proc sql;
create table rpedistintos2_2018 as 
select distinct ano_aprobacion,rpe, sum(valor_total) as TOTAL_CONTRATADO FORMAT=DOLLAR32.
from compras.historicos_break
where ano_aprobacion=2018 and ORIGEN="PT" 
group by rpe
HAVING CALCULATED TOTAL_CONTRATADO>5114120
order by ano_aprobacion,rpe; 

data rpedistintos2_2018_2;
length ADJUDICADO 8.;  
set rpedistintos2_2018;
if rpe>0 then ADJUDICADO=1;
rename ANO_APROBACION=ANO_ADJUDICACION;
rename rpe=rpe_1;
run; 

data rpedistintos2_2018_3; 
set rpedistintos2_2018_2;
rpe= input(rpe_1, 8.);
drop rpe_1;
run; 

*MODIFICANDO EL REGISTRO DE PROVEEDOR; 
data logit.logit_12;
set rpe.fin_jun_mej; 
drop Ocupacion	Observacion FechaRegistroMercantil Direccion Contacto FechaUltimaActualizacion A__oUltimaActualizacion
A__oUltimaModificacion TelefonoComercial PosicionContacto TelefonoContacto CorreoContacto RazonSocial NombreComercial
Documento TipoDocumento FechaAlta Periodo Mes FechaBaja Estatus MesUltimaActualizacion  NUMERO_REGION 
REGION EsMiPyme RubroPrincipal Municipio FechaUltimaModificacion MesUltimaModificacion TipoPersona CumpleCriterioMiPymeSegunDGII;
rename ANO=ANO_REGISTRO;
where estatus="Activo";
run; 


data logit.logit_22;
set logit.logit_12;
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
proc sort data=logit.logit_22; by rpe; 
run; 
proc sort data=rpedistintos2_2018_3; by rpe; 
run; 

data logit.logit_3342;
merge logit.logit_22 (in=BASES) rpedistintoS_2018_3 (in=ADJUDICADOSS);
BY rpe;
run; 

*SACANDO LOS ANOS DISTINTOS ADJUDICADOS;
proc sql; 
create table work.anos_dist2 AS
select distinct rpe, count(distinct ano_aprobacion) as ANOS_DIST_ADJUDICADO
from compras.historicos_break
group by rpe;
run; 

*SACANDO SI FUE ADJUDICADO EL ANO PASADO;
proc sql; 
create table work.ano_pasado2 as 
select distinct rpe, count(distinct ano_aprobacion) as ADJUDICACION_ANO_PASADO
from compras.historicos_break
where ano_aprobacion=2017
group by rpe;

data work.anos_dist_22; set work.anos_dist2; rename rpe=rpe_1; run; 
data work.anos_dist_32; set work.anos_dist_22; RPE= input(rpe_1, 8.); drop rpe_1;run; 
proc contents data=work.anos_dist_32; run; 
proc print data=work.anos_dist_3 (obs=10); run; 
data work.ano_pasado_22; set work.ano_pasado2; rename rpe=rpe_1; run; 
data work.ano_pasado_32; set work.ano_pasado_22; RPE= input(rpe_1, 8.); drop rpe_1;run; 
proc contents data=work.ano_pasado_32; run; 
proc print data=work.ano_pasado_32 (obs=10); run; 

proc sort data=work.ano_pasado_32; by rpe; run; 
proc sort data=work.anos_dist_32; by rpe; run; 

data logit.logit_3352; merge logit.logit_3342 (in=BASES) work.ano_pasado_32 (in=ADJUDICADOSS);BY rpe; if bases; run; 
data logit.logit_3362; merge logit.logit_3352 (in=BASES) work.anos_dist_32 (in=ADJUDICADOSS); BY rpe; if bases; run; 

proc print data=logit.logit_3362 (obs=10); run;

data logit.logit_3372; 
set logit.logit_3362; 
if ADJUDICADO=1 then ADJUDICADO_2018=1; ELSE ADJUDICADO_2018=0;
if ADJUDICACION_ANO_PASADO=1 then ADJANO_2017=1; ELSE ADJANO_2017=0;
if CertificadoPorMIC="Si" then CERT_MIC=1; Else CERT_MIC=0;
if ANOS_DIST_ADJUDICADO>0 then DISTANOS_ADJ=ANOS_DIST_ADJUDICADO; ELSE DISTANOS_ADJ=0; 
DROP ADJUDICADO ADJUDICACION_ANO_PASADO ANO_ADJUDICACION CertificadoPorMIC ANOS_DIST_ADJUDICADO;   
RUN;


ods select all; 
proc logistic data=logit.logit_3372 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class genero (param=reference ref='Masculino') 
		  clasificacion_empresarial_3 (param=reference ref="MIPYMES no certificadas y otras organizaciones")
		  MACROREGION (param=reference ref="SURESTE"); 
	model ADJUDICADO_2018(event='1')= Genero clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	  EsBienes EsServicios
	ADJANO_2017	DISTANOS_ADJ;
		title "EN EL TOP 90% DE LO CONTRATADO POR PROVEEDOR"; 
	TITLE2 "EN EL 2018- DATOS PORTAL TRANSACCIONAL";
	store out=logit_2018; 
run; 











