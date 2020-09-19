libname tarea "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_2";

*transformaciones iniciales;
data work.mejora;
set work.import;
if Item_Fat_Content in("LF" "low fat" "Low Fat") then fat="Low Fat";
else fat="Regular";
run;

*convirtiendo los niveles de la variable categorica item_type en variables
binarias. tambien, convirtiendo la variable fat en binaria;
data tarea.asignacion_1; 
set work.mejora; 
if item_type="Baking Goods" then  Baking_Good= 1; else Baking_Good=0; 
if item_type="Breads" then Bread= 1; else Bread=0; 
if item_type="Breakfast" then Breakfast= 1; else Breakfast=0;
if item_type="Canned" then Canned= 1; else Canned=0;
if item_type="Dairy" then Dairy= 1; else Dairy=0;
if item_type="Frozen Foods" then Frozen= 1; else Frozen=0;
if item_type="Fruits and Vegetables" then Fruits_Vegetables= 1; else Fruits_Vegetables=0;
if item_type="Hard Drinks" then Hard_Drinks= 1; else Hard_Drinks=0;
if item_type="Health and Hygiene" then Health_Hygiene= 1; else Health_Hygiene=0;
if item_type="Household" then Household= 1; else Household=0;
if item_type="Meat" then Meat= 1; else Meat=0;
if item_type="Others" then Others= 1; else Others=0;
if item_type="Seafood" then Seafood= 1; else Seafood=0;
if item_type="Snack Foods" then Snack_Foods= 1; else Snack_Foods=0;
if item_type="Soft Drinks" then Soft_Drinks= 1; else Soft_Drinks=0;
if item_type="Starchy Foods" then Starchy_Foods= 1; else Starchy_Foods=0;
if fat="Low Fat" then fat1=0; else fat1=1; 
run; 

*verificacion de la conversion de las variables binarias; 
%let tipo_item= Baking_Good Bread Breakfast Canned Dairy
Frozen Fruits_Vegetables Frozen Hard_Drinks Health_Hygiene 
Household Meat Others Seafood Snack_Foods Soft_Drinks Starchy_Foods;

proc freq data=tarea.asignacion_1;
tables &tipo_item*item_type;
run; 

proc freq data=tarea.asignacion_1;
tables fat*fat1;
run; 

*TRATANDO LOS VALORES FALTANTES;
*ITEM_WEIGHT; 
proc means data=tarea.asignacion_1; 
var item_weight;
class outlet_establishment_year item_type; 
run; 

*dado que los promedios generales de los pesos son muy similares
en las tiendas que fueron fundadas en los anos posteriores segun 
el siguiente one way anova item_weight=outlet_establishment_year, en el 
cual con un valor P de 0.8724 no se rechaza la hipotesis nula al 5% del
nivel de significancia, es decir el ano en que fue fundada la empresa no tiene un efecto en el peso promedio;
 
proc glm data= tarea.asignacion_1 plots(only)=diagnostics(unpack); 
	class outlet_establishment_year; 
	model item_weight=outlet_establishment_year; 
	title "Testing for equality of meas with proc GLM";
run; 
quit; 
title;

*Voy a imputar los valores faltantes del peso del item en las 2 tiendas
que fueron fundadas en el 2985  con el promedio del peso de ese item en las tiendas
que fueron fundadas en los anos posteriores; 
proc sql; 
select item_type,mean(item_weight) as PESO_PROMEDIO
from tarea.asignacion_1
group by item_type;

data tarea.asignacion_2; 
length item_weight_2 8.;
set tarea.asignacion_1; 
if item_type="Baking Goods" and outlet_establishment_year=1985 then Item_weight_2=12.27711; 
else if item_type="Breads" and outlet_establishment_year=1985 then Item_weight_2=11.34694;  
else if item_type="Breakfast" and outlet_establishment_year=1985 then Item_weight_2=12.7682; 
else if item_type="Canned" and outlet_establishment_year=1985 then Item_weight_2=12.30571; 
else if item_type="Dairy" and outlet_establishment_year=1985 then Item_weight_2=13.42607;
else if item_type="Frozen Foods" and outlet_establishment_year=1985 then Item_weight_2=12.86706; 
else if item_type="Fruits and Vegetables" and outlet_establishment_year=1985 then Item_weight_2=13.22477;
else if item_type="Hard Drinks" and outlet_establishment_year=1985 then Item_weight_2=11.40033; 
else if item_type="Health and Hygiene" and outlet_establishment_year=1985 then Item_weight_2=13.14231; 
else if item_type="Household" and outlet_establishment_year=1985 then Item_weight_2=13.38474; 
else if item_type="Meat" and outlet_establishment_year=1985 then Item_weight_2=12.81734; 
else if item_type="Others" and outlet_establishment_year=1985 then Item_weight_2=13.85328; 
else if item_type="Seafood" and outlet_establishment_year=1985 then Item_weight_2=12.55284;
else if item_type="Snack Foods" and outlet_establishment_year=1985 then Item_weight_2=12.98788; 
else if item_type="Soft Drinks" and outlet_establishment_year=1985 then Item_weight_2=11.84746; 
else if item_type="Starchy Foods" and outlet_establishment_year=1985 then Item_weight_2=13.69073; 
else item_weight_2=item_weight; 
run; 
 
*COMPROBACION DE LA IMPUTACION; 
proc sgplot data=tarea.asignacion_2;
vbox Item_weight_2  / category=Outlet_Establishment_Year group=fat1
grouporder=descending;
yaxis grid;
run;

proc freq data=tarea.asignacion_2; 
tables Outlet_Establishment_Year;
where item_weight_2>0;
run;

*TRATANDO LOS VALORES FALTANTES;
*ITEM_VISIBILITY;                      
proc means data=tarea.asignacion_2; 
var ITEM_VISIBILITY;
class outlet_establishment_year; 
run; 



proc sort data=tarea.asignacion_2; by Item_Type;run;  
proc reg data=tarea.asignacion_2 noprint Tableout outest=Est rsquare; 
by Item_Type;
model Item_Outlet_Sales= 
	fat1 item_weight_2 Item_Visibility Item_MRP;
output out=regres p=yhat r=e stdp=sd;
run;





Baking_Good Bread	Breakfast	Canned	Dairy
	Frozen	Fruits_Vegetables	Hard_Drinks	Health_Hygiene	Household
	Meat Others	Seafood	Snack_Foods	Soft_Drinks	

;
proc print data=t; 
run; 

proc tabulate data=t noseps;     
  class Outlet_Identifier variable;                     
  var estimate stderr;    
  table variable=''*(estimate =' '*sum=' '                         
                     stderr=' '*sum=' '*F=stderrf.),               
         Outlet_Identifier=' '                                                 
          / box=[label="Parameter"] rts=15 row=float misstext=' ';
run;






