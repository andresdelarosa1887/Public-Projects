libname rpe "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018"; 
libname compras "/folders/myfolders/DGCP/BASE_COMPRAS/DATA";

*MODIFICANDO LOS ANOS ADJUDICADOS PARA EL 2016- REGISTRO DE PROVEDOR AL 2016;
data rpe.logit_3372; 
set rpe.logit_337; 
IF DISTANOS_ADJ>0 THEN DISTANOS_ADJ2=DISTANOS_ADJ-1; ELSE DISTANOS_ADJ2=0;
IF ANOS_REGISTRADA>0 then ANOS_REGISTRADA2= ANOS_REGISTRADA-1; ELSE ANOS_REGISTRADA2=1;
drop ADJUDICADO_2017; 
where ano_registro<2017; 
drop ano_registro DISTANOS_ADJ ANOS_REGISTRADA2;
RUN; 

data rpe.logit_3373;
set rpe.logit_337;
if ADJUDICADo_2017= 1 or ADJANO_2016=1 then ADJUDICADOD=1; 
ELSE ADJUDICADOD=0;
run; 


*ADJUDICACIONES DEL ANO 2016 COMO VARIABLE DEPENDIENTE;
ods select all; 
proc logistic data=rpe.logit_3373 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class genero (param=ref ref="Femenino") 
		  CLASIFICACION_RPE (param=reference ref="No clasificada"); 
	model ADJUDICADOD(event='1')= Genero CLASIFICACION_RPE	ANOS_REGISTRADA	ESDISTRITO
		CERT_MIC DISTANOS_ADJ/ lackfit; 
	TITLE1 "QUE CARACTERISTICAS DE LOS PROVEEDORS INFLUYERON A QUE ESTOS FUERAN ADJUDICADOS"; 
	TITLE2 "EN EL 2016";
	store out=logit_todos; 
run; 

proc freq data=rpe.logit_3373;
tables genero*adjudicadod; 
run; 
