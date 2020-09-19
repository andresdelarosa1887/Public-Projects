libname logit "/folders/myshortcuts/3_ESTUDIOS/MODELACIONES/01_clasificacion_proveedores/05_modelo_SAS_anterior/MODELING_LOGITS/1_LOGIT_2018/DATOS"; 


*SOLAMENTE UTILIZAR LOS DATOS DEL PORTAL TRANSACCIONAL PARA INCLUIR OTRAS VARIABLES DE INTERES
COMO LA CANTIDAD DE VECES QUE PARTICIPO UN PROVEEDOR EN UN PROCESO DE COMPRA;
*ES NECESARIO UTILIZAR LOS DATOS QUE FUERON UTILIZADOS PARA CREAR LA BASE DE DATOS
CONSOLIDADA, PERO ESTA BASE DE RPE NO TIENE ALGUNAS CLASIFICACIONES, A MENOS QUE SE CRUZEN;

*SACANDO LAS ADJUDICACIONES DEL 2018; 
/*
proc sql; 
create table rpedistintos_2018 as 
select distinct rpe, ano_aprobacion
from compras.historicos_break
where ano_aprobacion=2018 and ORIGEN="PT" 
group by rpe
order by rpe; 
*/ 

proc sql; 
create table rpedistintos_2018 as 
select distinct ano_aprobacion,rpe,
sum(valor_total) as TOTAL_CONTRATADO FORMAT=DOLLAR32.
from compras.historicos_break
where ano_aprobacion=2018 and ORIGEN="PT" 
group by rpe, ano_aprobacion
order by rpe; 

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
drop Ocupacion  Observacion FechaRegistroMercantil Direccion Contacto FechaUltimaActualizacion A__oUltimaActualizacion
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
DROP PROVINCIA TipoFabricante   TipoDistribuidor TipoImportador TipoContratista TipoBienes  TipoConsultoria TipoServicios ; 
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


proc print data=logit.logit_337 (obs=10); 
run; 

proc sgplot data=logit.logit_337; 
vbar adjudicado_2018/ stat=freq datalabel; 
run; 
 
proc print data=logit.logit_337 (obs=1); run; 


proc logistic data=logit.logit_337 PLOTS(MAXPOINTS=NONE)
    plots(only)=(effect oddsratio);
    class genero (param=reference ref='Masculino') 
          clasificacion_empresarial_3 (param=reference ref="MIPYMES no certificadas y otras organizaciones")
          MACROREGION (param=reference ref="SURESTE"); 
    model ADJUDICADO_2018(event='1')= Genero clasificacion_empresarial_3    ANOS_REGISTRADA MACROREGION
      EsBienes EsServicios
    ADJANO_2017 DISTANOS_ADJ;
    TITLE1 "QUE CARACTERISTICAS DE LOS PROVEEDORS INFLUYERON A QUE ESTOS FUERAN ADJUDICADOS"; 
    TITLE2 "EN EL 2018 EN EL PORTAL TRANSACCIONAL";
    store out=logit_2018_NOR; 
run; 


*VERIFICACION DE LAS VARIABLES CODIFICADAS;
/*
proc freq data=rpe.logit_2; 
tables TipoDistribuidor*EsDistribuidor; 
run; 
proc freq data=rpe.logit_2; 
tables TipoFabricante*EsFabricante; 
run;
proc freq data=rpe.logit_2; 
tables TipoContratista*EsContratista; 
run;
proc freq data=rpe.logit_2; 
tables TipoImportador*EsImportador; 
run;
proc freq data=rpe.logit_2; 
tables TipoBienes*EsBienes; 
run;
proc freq data=rpe.logit_2; 
tables TipoConsultoria*EsConsultoria; 
run;
proc freq data=rpe.logit_2; 
tables TipoServicios*EsServicios; 
run;
*/