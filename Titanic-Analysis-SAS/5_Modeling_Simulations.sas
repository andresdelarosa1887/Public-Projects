libname itla "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_3";

*VIENDO EL COMPORTAMIENTO POR CLASE SOCIAL; 
data predictions_3374; 
infile datalines dlm=",";
length Pclass 8 sex $33 embarked $33; 
input Pclass sex Embarked Agem Parch Fare;
datalines;
1,male,S,0,0,32.2042080
1,male,S,5,0,32.2042080
1,male,S,10,0,32.2042080
1,male,S,15,0,32.2042080
1,male,S,20,0,32.2042080
1,male,S,25,0,32.2042080
1,male,S,30,0,32.2042080
1,male,S,35,0,32.2042080
1,male,S,40,0,32.2042080
1,male,S,45,0,32.2042080
1,male,S,50,0,32.2042080
1,male,S,55,0,32.2042080
1,male,S,60,0,32.2042080
1,male,S,65,0,32.2042080
1,male,S,70,0,32.2042080
1,male,S,75,0,32.2042080
1,male,S,80,0,32.2042080
1,male,S,85,0,32.2042080
1,female,S,0,0,32.2042080
1,female,S,5,0,32.2042080
1,female,S,10,0,32.2042080
1,female,S,15,0,32.2042080
1,female,S,20,0,32.2042080
1,female,S,25,0,32.2042080
1,female,S,30,0,32.2042080
1,female,S,35,0,32.2042080
1,female,S,40,0,32.2042080
1,female,S,45,0,32.2042080
1,female,S,50,0,32.2042080
1,female,S,55,0,32.2042080
1,female,S,60,0,32.2042080
1,female,S,65,0,32.2042080
1,female,S,70,0,32.2042080
1,female,S,75,0,32.2042080
1,female,S,80,0,32.2042080
1,female,S,85,0,32.2042080
2,male,S,0,0,32.2042080
2,male,S,5,0,32.2042080
2,male,S,10,0,32.2042080
2,male,S,15,0,32.2042080
2,male,S,20,0,32.2042080
2,male,S,25,0,32.2042080
2,male,S,30,0,32.2042080
2,male,S,35,0,32.2042080
2,male,S,40,0,32.2042080
2,male,S,45,0,32.2042080
2,male,S,50,0,32.2042080
2,male,S,55,0,32.2042080
2,male,S,60,0,32.2042080
2,male,S,65,0,32.2042080
2,male,S,70,0,32.2042080
2,male,S,75,0,32.2042080
2,male,S,80,0,32.2042080
2,male,S,85,0,32.2042080
2,female,S,0,0,32.2042080
2,female,S,5,0,32.2042080
2,female,S,10,0,32.2042080
2,female,S,15,0,32.2042080
2,female,S,20,0,32.2042080
2,female,S,25,0,32.2042080
2,female,S,30,0,32.2042080
2,female,S,35,0,32.2042080
2,female,S,40,0,32.2042080
2,female,S,45,0,32.2042080
2,female,S,50,0,32.2042080
2,female,S,55,0,32.2042080
2,female,S,60,0,32.2042080
2,female,S,65,0,32.2042080
2,female,S,70,0,32.2042080
2,female,S,75,0,32.2042080
2,female,S,80,0,32.2042080
2,female,S,85,0,32.2042080
3,male,S,0,0,32.2042080
3,male,S,5,0,32.2042080
3,male,S,10,0,32.2042080
3,male,S,15,0,32.2042080
3,male,S,20,0,32.2042080
3,male,S,25,0,32.2042080
3,male,S,30,0,32.2042080
3,male,S,35,0,32.2042080
3,male,S,40,0,32.2042080
3,male,S,45,0,32.2042080
3,male,S,50,0,32.2042080
3,male,S,55,0,32.2042080
3,male,S,60,0,32.2042080
3,male,S,65,0,32.2042080
3,male,S,70,0,32.2042080
3,male,S,75,0,32.2042080
3,male,S,80,0,32.2042080
3,male,S,85,0,32.2042080
3,female,S,0,0,32.2042080
3,female,S,5,0,32.2042080
3,female,S,10,0,32.2042080
3,female,S,15,0,32.2042080
3,female,S,20,0,32.2042080
3,female,S,25,0,32.2042080
3,female,S,30,0,32.2042080
3,female,S,35,0,32.2042080
3,female,S,40,0,32.2042080
3,female,S,45,0,32.2042080
3,female,S,50,0,32.2042080
3,female,S,55,0,32.2042080
3,female,S,60,0,32.2042080
3,female,S,65,0,32.2042080
3,female,S,70,0,32.2042080
3,female,S,75,0,32.2042080
3,female,S,80,0,32.2042080
3,female,S,85,0,32.2042080
; 
run;

proc plm restore=itla_pf; 
	score data=predictions_3374 out=simulaciones_3374/ ilink;
	title "Predictions using PROC PLM";
run;

proc format; 
value age
0 - 9.99 = "0 - 9"
10-19.99= "10- 19"
20 - 29.99 = '20 - 29'
30 - 39.99 = '30 - 39'
40 - 49.99 = '40 - 49'
50 - 59.99 = '50 - 59'
60-69.99= "60- 69"
70 - 100 = "70 o más";
run;


ods graphics on / width=7.5in height=6in;
proc sgpanel data=simulaciones_3374; 
title "Probabilidad Estimada de Supervivencia";
title2 "Dada la Edad del Pasajero y la Clase";
panelby pclass/ columns=3 uniscale=column;
vline agem/response=predicted stat=mean group=sex datalabel markers
 datalabelattrs=(color=black size=8) nostatlabel 
 MARKERS markerattrs=(symbol=circlefilled color=red size=7) lineattrs=(thickness=1.1);
format predicted percent32.2 agem age. ;
 colaxis label= "Rango de Edad"  labelattrs=(size=9 weight=bold) grid;
 rowaxis label="Probabilidad Estimada de Supervivencia" labelattrs=(size=9 weight=bold) grid ;
footnote1 "Manteniendo todo lo demás constante: numero de acompañantes=0";
refline 0.5 /lineattrs=(pattern=2 thickness=2px);
run; 

*VIENDO EL COMPORTAMIENTO POR CANTIDAD DE PERSONAS; 
data predictions_3375; 
infile datalines dlm=",";
length Pclass 8 sex $33 embarked $33; 
input Pclass sex Embarked Agem Parch Fare;
datalines;
  1,male,S,40,0,32.204208
  1,male,S,40,1,32.204208
  1,male,S,40,2,32.204208
  1,male,S,40,3,32.204208
  1,male,S,40,4,32.204208
  1,male,S,40,5,32.204208
  1,male,S,40,6,32.204208
1,female,S,35,0,32.204208
1,female,S,35,1,32.204208
1,female,S,35,2,32.204208
1,female,S,35,3,32.204208
1,female,S,35,4,32.204208
1,female,S,35,5,32.204208
1,female,S,35,6,32.204208
  2,male,S,30,0,32.204208
  2,male,S,30,1,32.204208
  2,male,S,30,2,32.204208
  2,male,S,30,3,32.204208
  2,male,S,30,4,32.204208
  2,male,S,30,5,32.204208
  2,male,S,30,6,32.204208
2,female,S,28,0,32.204208
2,female,S,28,1,32.204208
2,female,S,28,2,32.204208
2,female,S,28,3,32.204208
2,female,S,28,4,32.204208
2,female,S,28,5,32.204208
2,female,S,28,6,32.204208
  3,male,S,25,0,32.204208
  3,male,S,25,1,32.204208
  3,male,S,25,2,32.204208
  3,male,S,25,3,32.204208
  3,male,S,25,4,32.204208
  3,male,S,25,5,32.204208
  3,male,S,25,6,32.204208
3,female,S,21.5,0,32.204208
3,female,S,21.5,1,32.204208
3,female,S,21.5,2,32.204208
3,female,S,21.5,3,32.204208
3,female,S,21.5,4,32.204208
3,female,S,21.5,5,32.204208
3,female,S,21.5,6,32.204208
;
run; 

proc plm restore=itla_pf; 
	score data=predictions_3375 out=simulaciones_3375/ ilink;
	title "Predictions using PROC PLM";
run;

ods graphics on / width=7.5in height=6in;
proc sgpanel data=simulaciones_3375; 
title "Probabilidad Estimada de Supervivencia de un Pasajero";
title2 "Dada la Cantidad de personas que viajaban con el/ella y la Clase";
panelby pclass/ columns=3 uniscale=column;
vline parch/response=predicted stat=mean group=sex datalabel markers
 datalabelattrs=(color=black size=8) nostatlabel 
 MARKERS markerattrs=(symbol=circlefilled color=red size=7) lineattrs=(thickness=1.1);
format predicted percent32.2 agem age. ;
 colaxis label= "Cantidad de Familiares Abordo"  labelattrs=(size=9 weight=bold) grid;
 rowaxis label="Probabilidad Estimada de Supervivencia" labelattrs=(size=9 weight=bold) grid ;
footnote1 "Manteniendo todo lo demás constante: edad mediana por sexo la clase en el grupo";
refline 0.5 /lineattrs=(pattern=2 thickness=2px);
run; 

proc sort data=itla.train_2; by sex; run;
proc means data=itla.train_2 median; 
by sex;
class pclass; 
var age; 
run; 

proc freq data=itla.train_2; 
tables parch*survived; 
run; 


proc freq data=itla.train_2;
tables agem*survived;
format agem age.;
run; 



