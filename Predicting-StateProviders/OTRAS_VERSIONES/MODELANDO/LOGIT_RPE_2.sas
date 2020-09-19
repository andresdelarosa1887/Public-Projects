
*EXPLORATORY DATA ANAYLISIS; 
data rpe.logit_3371; 
set rpe.logit_337; 
if genero="Femenino" then genero_2=1; else genero_2=0;
run; 

PROC SQL; 
select genero, count(adjudicado_2017) as FRECUENCIA
from rpe.logit_338
where adjudicado_2017=0
group by genero; 

PROC SQL; 
select genero, count(adjudicado_2017) as FRECUENCIA
from rpe.logit_338
group by genero; 


ods select all; 
proc logistic data=rpe.logit_3371 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class CLASIFICACION_RPE (param=effect)
	genero (param=reference ref='Masculino');
	model ADJANO_2016(event='1')= Genero	CLASIFICACION_RPE	ANOS_REGISTRADA
	CERT_MIC	DISTANOS_ADJ/ clodds=pl; 
	TITLE1 "QUE CARACTERISTICAS DE LOS PROVEEDORS INFLUYERON A QUE ESTOS FUERAN ADJUDICADOS"; 
	TITLE2 "EN EL 2017";
	store out=que_locura; 
run; 



ods select all; 
proc logistic data=rpe.logit_337 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class genero (param=reference ref='No Especificado') 
		  CLASIFICACION_RPE (param=reference ref="No clasificada"); 
	model ADJUDICADO_2017(event='1')= Genero CERT_MIC; 
	TITLE1 "QUE CARACTERISTICAS DE LOS PROVEEDORS INFLUYERON A QUE ESTOS FUERAN ADJUDICADOS"; 
	TITLE2 "EN EL 2017";
	store out=que_locura22; 
run; 

proc freq data=rpe.logit_337; 
tables genero*ADJANO_2016/ NOCOL NOPERCENT NOROW; 
run; 

