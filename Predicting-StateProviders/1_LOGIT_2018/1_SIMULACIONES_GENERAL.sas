libname logit "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/LOGIT_MODEL/MODELING_LOGITS/1_LOGIT_2018/DATOS"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA/ORIGIN";
libname rpe "/folders/myfolders/DGCP/CIERRES/DATOS/RPE";
libname simula "/folders/myshortcuts/DGCP_SAS_R/DOCUMENTO_AGOSTO/DATOS/DATOS_GRAFICOS/EN_ORDEN/SIMULACIONES_LOGIT";

*SIMULANDO DANDO LOS ANOS DISTINTOS DE ADJUDICACION;
*PREDICCIONES DE LA CLASIFICACION EMPRESARIAL, ASUMIENDO QUE TODOS LOS PROVEEDORES PERTENECEN A LA
MACRO REGION SURESTE Y SON DE PROPIETARIO MASCULINO;
data clasificacion_3373; 
infile datalines dlm=",";
length GENERO $14 clasificacion_empresarial_3 $100 MACROREGION  $100; 
input  Genero clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	  EsBienes EsServicios
	ADJANO_2017	DISTANOS_ADJ;;
datalines;
Masculino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,1
Masculino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,2
Masculino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,3
Masculino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,4
Masculino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,5
Masculino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,6
Masculino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,7
Masculino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,8
Masculino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,1
Masculino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,2
Masculino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,3
Masculino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,4
Masculino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,5
Masculino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,6
Masculino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,7
Masculino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,8
Masculino,Gran empresa,2,SURESTE,0,1,0,1
Masculino,Gran empresa,3,SURESTE,0,1,0,2
Masculino,Gran empresa,4,SURESTE,0,1,0,3
Masculino,Gran empresa,5,SURESTE,0,1,0,4
Masculino,Gran empresa,6,SURESTE,0,1,0,5
Masculino,Gran empresa,7,SURESTE,0,1,0,6
Masculino,Gran empresa,8,SURESTE,0,1,0,7
Masculino,Gran empresa,9,SURESTE,0,1,0,8
Masculino,Gran empresa,2,SURESTE,0,1,0,1
Masculino,Gran empresa,3,SURESTE,0,1,0,2
Masculino,Gran empresa,4,SURESTE,0,1,0,3
Masculino,Gran empresa,5,SURESTE,0,1,0,4
Masculino,Gran empresa,6,SURESTE,0,1,0,5
Masculino,Gran empresa,7,SURESTE,0,1,0,6
Masculino,Gran empresa,8,SURESTE,0,1,0,7
Masculino,Gran empresa,9,SURESTE,0,1,0,8
Masculino,Persona Física,2,SURESTE,0,1,0,1
Masculino,Persona Física,3,SURESTE,0,1,0,2
Masculino,Persona Física,4,SURESTE,0,1,0,3
Masculino,Persona Física,5,SURESTE,0,1,0,4
Masculino,Persona Física,6,SURESTE,0,1,0,5
Masculino,Persona Física,7,SURESTE,0,1,0,6
Masculino,Persona Física,8,SURESTE,0,1,0,7
Masculino,Persona Física,9,SURESTE,0,1,0,8
Masculino,Persona Física,2,SURESTE,0,1,0,1
Masculino,Persona Física,3,SURESTE,0,1,0,2
Masculino,Persona Física,4,SURESTE,0,1,0,3
Masculino,Persona Física,5,SURESTE,0,1,0,4
Masculino,Persona Física,6,SURESTE,0,1,0,5
Masculino,Persona Física,7,SURESTE,0,1,0,6
Masculino,Persona Física,8,SURESTE,0,1,0,7
Masculino,Persona Física,9,SURESTE,0,1,0,8
; 
run;

proc plm restore=logit_2018_NOR; 
	score data=clasificacion_3373 out=simclasificacion_3373/ ilink;
	title "Predictions using PROC PLM";
run;

data simula.b_clasificacion_adj;
set simclasificacion_3373;
run; 



title "Evolución de la Probabilidad de Adjudicación"; 
TITLE2 "Por Clasificación Empresarial";
TITLE3 "dado Años distintos adjudicación";
proc sgplot data=simula.b_clasificacion_adj; 
	vline DISTANOS_ADJ / response=predicted stat=mean group=clasificacion_empresarial_3 datalabel markers;
	format predicted percent8.2;
	xaxis label="Años de Adjudicación";
	yaxis label="Predicción de la Probabilidad de éxito";
	footnote1 "Estimando la probabilidad de éxito de adjudicación";
	footnote2 "Utilizando datos del Portal Transaccional a Junio 2018"; 
run; 


*PREDICCIONES DE GENERO ASUMIENDO A UNA MIPYME CERTIFICADA POR EL MIC;
data  genero_3373; 
infile datalines dlm=",";
length GENERO $14 clasificacion_empresarial_3 $100 MACROREGION  $100; 
input  Genero clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	  EsBienes EsServicios
	ADJANO_2017	DISTANOS_ADJ;;
datalines;
Masculino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,1
Masculino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,2
Masculino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,3
Masculino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,4
Masculino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,5
Masculino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,6
Masculino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,7
Femenino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,1
Femenino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,2
Femenino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,3
Femenino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,4
Femenino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,5
Femenino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,6
Femenino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,7
; 
run;

proc plm restore=logit_2018_NOR; 
	score data=genero_3373 out=simgenero_3373/ ilink;
	title "Predictions using PROC PLM";
run;

data simula.a_simgenero_adj;
set simgenero_3373;
run; 

title "Evolución de la Probabilidad de Adjudicación de una MIPYME Certificada de servicios"; 
TITLE2 "Por Género";
TITLE3 "Dado años distintos adjudicación";
proc sgplot data=simgenero_3373; 
	vline DISTANOS_ADJ / response=predicted stat=mean group=genero datalabel markers;
	format predicted percent8.2;
	xaxis label="Años de Adjudicación";
	yaxis label="Predicción de la Probabilidad de éxito";
	footnote1 "Estimando la probabilidad de éxito de adjudicación";
	footnote2 "Utilizando datos del Portal Transaccional a Junio 2018"; 
run; 

*PREDICCIONES POR MACROREGION;
data  macroregion_3373; 
infile datalines dlm=",";
length GENERO $14 clasificacion_empresarial_3 $100 MACROREGION  $100; 
input  Genero clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	  EsBienes EsServicios
	ADJANO_2017	DISTANOS_ADJ;;
datalines;
Femenino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,1
Femenino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,2
Femenino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,3
Femenino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,4
Femenino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,5
Femenino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,6
Femenino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,7
Femenino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,8
Femenino,MIPYMES Certificadas por el MIC,2,SUROESTE,0,1,0,1
Femenino,MIPYMES Certificadas por el MIC,3,SUROESTE,0,1,0,2
Femenino,MIPYMES Certificadas por el MIC,4,SUROESTE,0,1,0,3
Femenino,MIPYMES Certificadas por el MIC,5,SUROESTE,0,1,0,4
Femenino,MIPYMES Certificadas por el MIC,6,SUROESTE,0,1,0,5
Femenino,MIPYMES Certificadas por el MIC,7,SUROESTE,0,1,0,6
Femenino,MIPYMES Certificadas por el MIC,8,SUROESTE,0,1,0,7
Femenino,MIPYMES Certificadas por el MIC,9,SUROESTE,0,1,0,8
Femenino,MIPYMES Certificadas por el MIC,2,NORTE,0,1,0,1
Femenino,MIPYMES Certificadas por el MIC,3,NORTE,0,1,0,2
Femenino,MIPYMES Certificadas por el MIC,4,NORTE,0,1,0,3
Femenino,MIPYMES Certificadas por el MIC,5,NORTE,0,1,0,4
Femenino,MIPYMES Certificadas por el MIC,6,NORTE,0,1,0,5
Femenino,MIPYMES Certificadas por el MIC,7,NORTE,0,1,0,6
Femenino,MIPYMES Certificadas por el MIC,8,NORTE,0,1,0,7
Femenino,MIPYMES Certificadas por el MIC,9,NORTE,0,1,0,8
; 
run;

proc plm restore=logit_2018_NOR; 
	score data=macroregion_3373 out=simmacroregion_3373/ ilink;
	title "Predictions using PROC PLM";
run;

data simula.c_simclasificacion_adj;
set simmacroregion_3373;
run; 

title "Evolución de la Probabilidad de Adjudicación de una MIPYME Certificada de servicios"; 
TITLE2 "por Macroregión";
TITLE3 "Dado años distintos adjudicación";
proc sgplot data=simmacroregion_3373; 
	vline DISTANOS_ADJ / response=predicted stat=mean group=macroregion datalabel markers;
	format predicted percent8.2;
	xaxis label="Años de Adjudicación";
	yaxis label="Predicción de la Probabilidad de éxito";
	footnote1 "Estimando la probabilidad de éxito de adjudicación";
	footnote2 "Utilizando datos del Portal Transaccional a Junio 2018"; 
run; 


*SIMULANDO DANDO LOS ANOS DISTINTOS DE REGISTRO SIN ADJUDICACION;
data  genero_reg_3373; 
infile datalines dlm=",";
length GENERO $14 clasificacion_empresarial_3 $100 MACROREGION  $100; 
input  Genero clasificacion_empresarial_3	ANOS_REGISTRADA	MACROREGION
	  EsBienes EsServicios
	ADJANO_2017	DISTANOS_ADJ;;
datalines;
Masculino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,0
Masculino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,2,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,3,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,4,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,5,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,6,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,7,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,8,SURESTE,0,1,0,0
Femenino,MIPYMES Certificadas por el MIC,9,SURESTE,0,1,0,0
; 
run;


proc plm restore=logit_2018_NOR; 
	score data=genero_reg_3373 out=simgenero_reg_3373/ ilink;
	title "Predictions using PROC PLM";
run;

data simula.d_simgenero_reg;
set simgenero_reg_3373;
run; 

title "Evolución de la Probabilidad de Adjudicación de una MIPYME Certificada de servicios"; 
TITLE2 "Por Género";
TITLE3 "Dado años distintos adjudicación";
proc sgplot data=simgenero_reg_3373; 
	vline ANOS_REGISTRADA / response=predicted stat=mean group=genero datalabel markers;
	format predicted percent8.2;
	xaxis label="Años de Adjudicación";
	yaxis label="Predicción de la Probabilidad de éxito";
	footnote1 "Estimando la probabilidad de éxito de adjudicación";
	footnote2 "Utilizando datos del Portal Transaccional a Junio 2018"; 
run; 

proc sql; 
CREATE TABLE SOLICITUD_FOMENTO AS
select cod_unidad_compra,unidad_compra, sum(valor_total) as TOTAL_ADJUDICADO format=dollar32., 
 count(rpe) as CANTIDAD_CONTRATOS, 
 count(distinct RPE) as CANTIDAD_ADJUDICADOS
from compras.historicos 
where ano_aprobacion=2017
group by cod_unidad_compra, unidad_compra
order by calculated TOTAL_ADJUDICADO DESC;

proc print data=solicitud_fomento; 
sum TOTAL_ADJUDICADO CANTIDAD_CONTRATOS; 
run; 


