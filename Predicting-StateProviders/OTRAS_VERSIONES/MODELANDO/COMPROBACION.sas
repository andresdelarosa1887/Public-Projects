libname rpemay "/folders/myfolders/DGCP/BASE_RPE/DATA/A_MAYO_2018";
libname rpejun "/folders/myfolders/DGCP/CIERRES/DATOS/RPE";


*LAS DISTRIBUCIONES NO DEBERIAN CAMBIAR COMO LO HACEN EN EL LOGIT POR LO QUE EL RATIO DE POSIBILIDADES DEBE SER DIFERENTE;
proc sql; 
create table rpemay as
select genero,count(distinct rpe) as TOTAL_REGISTRADO
from rpemay.final_reg_2
where ano<2018
group by genero;


proc sql; 
create table rpejun as
select genero,count(distinct rpe) as TOTAL_REGISTRADO
from rpejun.fin_jun_mej
where ano<2018
group by genero;

proc print data=rpemay; 
sum total_registrado; 
run; 



proc print data=rpejun; 
sum total_registrado; 
run; 
