libname rpe "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018/MODELING_LOGITS"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA";
libname rpeb "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018";
*SACANDO LAS ADJUDICACIONES DEL 2017; 
proc sql; 
create table rpedistintos as  
select distinct rpe 
from compras.final_mod 
group by rpe
order by rpe; 

data rpedistintos_2; 
length ADJUDICADO 8.;   
set rpedistintos;
if rpe>0 then ADJUDICADO=1; 
rename ANO_APROBACION=ANO_ADJUDICACION;
rename rpe=rpe_1; run; 

data rpedistintos_3; 
 set rpedistintos_2; 
 rpe= input(rpe_1, 8.);
drop rpe_1; run; 

*MODIFICANDO EL REGISTRO DE PROVEEDOR; 
data rpe.logit_1;
set rpeb.final_reg_2; 
drop Ocupacion	Observacion FechaRegistroMercantil Direccion Contacto FechaUltimaActualizacion A__oUltimaActualizacion
A__oUltimaModificacion TelefonoComercial PosicionContacto TelefonoContacto CorreoContacto RazonSocial NombreComercial
Documento TipoDocumento FechaAlta Periodo Mes FechaBaja Estatus MesUltimaActualizacion MACROREGION NUMERO_REGION
REGION EsMiPyme RubroPrincipal Municipio FechaUltimaModificacion MesUltimaModificacion TipoPersona CumpleCriterioMiPymeSegunDGII;
rename ANO=ANO_REGISTRO clasificacionrpe_m= CLASIFICACION_RPE;
run; 

data rpe.logit_2;
set rpe.logit_1;
ANOS_REGISTRADA= 2018-ANO_REGISTRO;
if PROVINCIA="DISTRITO NACIONAL" THEN ESDISTRITO=1; ELSE ESDISTRITO=0; 
if TipoFabricante="Sí" then  Esfabricante=1; else Esfabricante=0;
if TipoDistribuidor="Sí" then  EsDistribuidor=1; else EsDistribuidor=0;
if TipoImportador="Sí" then  EsImportador=1; else EsImportador=0;
if TipoContratista="Sí" then  EsContratista=1; else EsContratista=0;
if TipoBienes="Sí" then  EsBienes=1; else EsBienes=0;
if TipoConsultoria="sí" then  EsConsultoria=1; else EsConsultoria=0;
if TipoServicios="Sí" then  EsServicios=1; else EsServicios=0;
DROP PROVINCIA TipoFabricante	TipoDistribuidor	TipoImportador	TipoContratista	TipoBienes	TipoConsultoria	TipoServicios ; 
where ano_registro<2018; 
run; 


*HACIENDO EL JOIN;
proc sort data=rpe.logit_2; by rpe; 
run; 
proc sort data=rpedistintos_3; by rpe; 
run; 

data rpe.logit_334;
merge rpe.logit_2 (in=BASES) rpedistintoS_3 (in=ADJUDICADOSS);
BY rpe;
if bases;
run; 

*SACANDO LOS ANOS DISTINTOS ADJUDICADOS;
proc sql; 
create table work.anos_dist AS
select distinct rpe, ano_aprobacion
from compras.final_mod; 

data work.anos_dist_2; set work.anos_dist; rename rpe=rpe_1; run; 
data work.anos_dist_3; set work.anos_dist_2; RPE= input(rpe_1, 8.); drop rpe_1;run; 
proc contents data=work.anos_dist_3; run; 
proc print data=work.anos_dist_3 (obs=10); run; 
proc sort data=work.anos_dist_3; by rpe; run; 

data rpe.logit_335; merge rpe.logit_334 (in=BASES) work.anos_dist_3 (in=ADJUDICADOSS); BY rpe; if bases; run; 


data rpe.logit_336; 
set rpe.logit_335; 
if ADJUDICADO=1 then ADJUDICADOD=1; ELSE ADJUDICADOD=0;
if CertificadoPorMIC="Si" then CERT_MIC=1; Else CERT_MIC=0;
DROP ADJUDICADO CertificadoPorMIC ANOS_DIST_ADJUDICADO RPE;   
RUN;

proc print data=rpe.logit_336 (obs=1); run;
proc freq data=rpe.logit_336;
tables genero*adjudicadod; 
run; 


proc sql; 
select genero, adjudicadod, 
from rpe.logit_336
groupby genero, adjudicadod;



