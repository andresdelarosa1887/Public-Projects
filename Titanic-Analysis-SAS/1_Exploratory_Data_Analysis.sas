libname itla "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_3";

*PROBANDO LAS DIFERENCIAS DE GENERO EN LOS QUE SOBREVIVIERON Y LOS QUE NO SOBREVIVIERON; 
proc means data=itla.train_2 mean median q1 q3 nmiss;
title "PROMEDIO DE EDAD DE LAS PERSONAS QUE SOBREVIVIERON POR GENERO"; 
class sex; 
var agem fare; 
where survived=1;
run; 

proc ttest data=itla.train_2 
	plots(shownull)= interval h0=0 sides=u; 
class sex; 
var agem; 
where survived=1;
title "DIFERENCIAS DE MEDIA DE LOS HOMBRES Y MAS MUJERES QUE SOBREVIVIERON";
run; 

proc means data=itla.train_2 mean median q1 q3 missing nmiss ; 
title "PROMEDIO DE EDAD DE LAS PERSONAS QUE NO SOBREVIVIERON POR GENERO";
class sex; 
var agem; 
where survived=0;
run; 

proc ttest data=itla.train_2 
	plots(shownull)= interval h0=0 sides=u; 
class sex; 
var agem; 
where survived=0;
title "DIFERENCIAS DE MEDIA DE LOS HOMBRES Y MAS MUJERES QUE NO SOBREVIVIERON";
run; 

*El 74.20% de las personas que sobrevivieron era mujer;
proc freq data=itla.train_2; 
tables sex*survived; 
run; 

*La mayoria de las personas que no sobrevivieron eran de la 3ra clase, la mayoria de las que sobrevivieron eran 
de la primera clase; 
proc freq data=itla.train_2; 
tables pclass*survived; 
run; 

*las edades diferian por clase social?;
proc means data=itla.train_2; 
class pclass; 
var agem; 
run; 

proc glm data= itla.train_2 plots; 
	class pclass; 
	model agem=pclass; 
	means pclass / hovtest; 
	title "PROBANDO LA IGUALDAD DE EDAD POR CLASES";
run; 
quit; 
title;

(only)=diagnostics(unpack)
*No existen diferencias estadísticamente significativas 
entre la edad promedio de los que sobrevivieron
 y los que no sobrevivieron a un 10% nivel de significancia;
proc means data=itla.train_2; 
class survived; 
var agem; 
run; 


proc ttest data=itla.train_2 
	plots(shownull)= interval h0=0 sides=u; 
class survived; 
var agem; 
title "DIFERENCIAS DE EDAD EN LOS QUE SOBREVIVIERON Y LOS QUE NO SOBREVIVIERON";
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


*EXPLICAR EL POR QUE TOME EL PUERTO DE EMBARQUE DE REFERENCIA S (ES DE DONDE SALIERON MAS PERSONAS, 644 MAS DEL 70%);
proc logistic data=itla.train_2 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class Pclass (param=reference ref='3')
	      sex (param=reference ref="male")
	      Embarked (param=reference ref="S");
	model survived(event='1')= Pclass sex Embarked Agem Parch Fare;
	TITLE1 "QUE CARACTERISTICAS DE LOS PASAJEROS INFLUYERON A QUE ESTOS MURIERAN"; 
	store out=itla_pf;
	where fare>0; 
run; 
*TOMANDO LAS CARACTERISTICAS PROMEDIO DE LA POBLACION, QUE PASA CON LA PROBABILIDAD CUANDO CAMBIA 
LA EDAD, ENFOCADO A GENERO DE LA PRIMERA CLASE;
data predictions_3373; 
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
; 
run;

proc plm restore=itla_pf; 
	score data=predictions_3373 out=simulaciones_3373/ ilink;
	title "Predictions using PROC PLM";
run;
     ods graphics / noborder;
proc sgplot data=simulaciones_3373; 
vline agem/response=predicted stat=mean group=sex datalabel markers;
format predicted percent32.2  AGEM age.;
styleattrs backcolor=blueviolet;
run; 

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

proc sgpanel data=simulaciones_3374; 
panelby pclass/ columns=3 uniscale=column;
vline agem/response=predicted stat=mean group=sex datalabel markers;
format predicted percent32.2;
run; 


