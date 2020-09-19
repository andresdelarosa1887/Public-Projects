libname itla "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_3";

PROC PRINT DATA=itla.train (obs=5); 
run; 

*CLASE DEL PASAJERO, LA EDAD PROMEDIO DE LOS PASAJEROS DE LA PRIMERA CLASE ES MAYOR; 
proc means data=itla.train; 
var age; 
class pclass;
run;

*CARACTERISTICAS DE LA EDAD PROMEDIO QUE IS MISSING; 
proc sql; 
select embarked,pclass,sex, PARCH, count(survived) as TOTAL
from itla.train
where age is missing 
group by embarked,pclass,sex,parch; 

proc sql; 
select embarked,pclass,sex, PARCH, mean(age) as EDAD_PROMEDIO
from itla.train
where age is not missing 
group by embarked,pclass,sex,parch
order by embarked,pclass,sex,parch; 
*CARACTERISTICAS DE CUANDO EL FARE ESTA MISSING PARA IMPUTAR;
proc sql; 
select embarked,pclass,sex, PARCH, count(survived) as TOTAL
from itla.train
where FARE=0
group by embarked,pclass,sex,parch; 

proc sql; 
select embarked,pclass,sex, PARCH, mean(fare) as EDAD_PROMEDIO
from itla.train
where fare is not missing 
group by embarked,pclass,sex,parch
order by parch; 

*IMPUTANDO LAS EDADES CON EL PROMEDIO DE LA EDAD QUE TIENE EL PASAJERO 
CON ESAS MISMAS CARACTERISTICAS; 

data itla.train_2; 
length agem 8.;
set itla.train; 
     if embarked="C" and Pclass=1 and sex="female" and Parch=0 then agem=36.60714;
else if embarked="C" and Pclass=1 and sex="male" and Parch=0 then agem=39.88;
else if embarked="C" and Pclass=2 and sex="male" and Parch=0 then agem=30.1;
else if embarked="C" and Pclass=3 and sex="female" and Parch=0 then agem=14.75;
else if embarked="C" and Pclass=3 and sex="female" and Parch=1 then agem=11.78571;
else if embarked="C" and Pclass=3 and sex="female" and Parch=2 then agem=15;
else if embarked="C" and Pclass=3 and sex="male" and Parch=0 then agem=27.28571;
else if embarked="C" and Pclass=3 and sex="male" and Parch=1 then agem=13.105;
else if embarked="Q" and Pclass=2 and sex="female" and Parch=0 then agem=30;
else if embarked="Q" and Pclass=3 and sex="female" and Parch=0 then agem=19.6875;
else if embarked="Q" and Pclass=3 and sex="female" and Parch=2 then agem=15;
else if embarked="Q" and Pclass=3 and sex="male" and Parch=0 then agem=37;
else if embarked="S" and Pclass=1 and sex="female" and Parch=0 then agem=34.96;
else if embarked="S" and Pclass=1 and sex="female" and Parch=1 then agem=37.44444;
else if embarked="S" and Pclass=1 and sex="male" and Parch=0 then agem=43.74038;
else if embarked="S" and Pclass=2 and sex="female" and Parch=0 then agem=33.5;
else if embarked="S" and Pclass=2 and sex="male" and Parch=0 then agem=33.55405;
else if embarked="S" and Pclass=3 and sex="female" and Parch=0 then agem=26.275;
else if embarked="S" and Pclass=3 and sex="female" and Parch=1 then agem=16.76923;
else if embarked="S" and Pclass=3 and sex="female" and Parch=2 then agem=13.3125;
else if embarked="S" and Pclass=3 and sex="male" and Parch=0 then agem=28.58611;
else if embarked="S" and Pclass=3 and sex="male" and Parch=1 then agem=16.94444;
else if embarked="S" and Pclass=3 and sex="male" and Parch=2 then agem=10.88462;
else agem=age; 
run;

*COMPROBACION DE LA IMPUTACION DE LA EDAD- completa y combrobada;
proc sql; 
select embarked,pclass,sex, PARCH,COUNT(age) AS REAL, mean(agem) as IMPUTACION
from itla.train_2
where age is missing 
group by embarked,pclass,sex,parch; 









