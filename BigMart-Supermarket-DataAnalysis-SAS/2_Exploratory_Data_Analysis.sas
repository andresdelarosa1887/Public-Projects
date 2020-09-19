libname tarea "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_2";

proc sort data=tarea.asignacion_2; by Item_Type;run;  
proc reg data=tarea.asignacion_2 noprint Tableout outest=Est rsquare; 
by Outlet_Establishment_Year;
model Item_Outlet_Sales= Baking_Good Bread Breakfast Canned Dairy
Frozen Fruits_Vegetables Frozen Hard_Drinks Health_Hygiene 
Household Meat Others Seafood Snack_Foods Soft_Drinks Starchy_Foods
	fat1 item_weight_2 Item_Visibility Item_MRP;
output out=regres p=yhat r=e stdp=sd;
run;


*CREACION DEL GRAFICO 1 DEL PROYECTO;
proc sql;
create table grafico_1 as
select item_type, sum(item_outlet_sales) as total_vendido format dollar32. 
from tarea.asignacion_2
group by item_type
order by calculated  total_vendido desc;

*los tipos de item que se encuentran en los dos ultimos quintiles de las ventas totales
de todas las tiendas; 
  proc rank data=grafico_1 out=out1 groups=5;                               
     var total_vendido;                                                          
     ranks rank1;                                                      
  run;   

data attrmap;
infile datalines dlm=",";
retain ID "item_type";
length value $ 32; 
input value $ fillcolor $ linecolor $;
datalines;
Fruits and Vegetables,blue,black	
Snack Foods,blue,black	
Household,blue,black		
Frozen Foods,gray,gray	
Dairy,gray,gray		
Canned,gray,gray		
Baking Goods,gray,gray	
Health and Hygiene,gray,gray		
Meat,gray,gray		
Soft Drinks,gray,gray		
Breads,gray,gray		
Hard Drinks,gray,gray		
Starchy Foods,gray,gray		
Others,gray,gray		
Breakfast,gray,gray	
Seafood,gray,gray	
;
run;
ods graphics on / width=765 pt height=545 pt;
proc sgplot data=grafico_1 dattrmap=attrmap  noborder noautolegend;
title HEIGHT=14pt JUSTIFY=CENTER "Ventas Totales en Dólares"; 
title2 HEIGHT=11pt JUSTIFY=CENTER "En Todas las Tiendas" ;
hbar item_type/ response=total_vendido stat=sum datalabel
 datalabelattrs=(size=12) categoryorder=respdesc
attrid=item_type group=item_type; 
format total_vendido dollar32.;
yaxis display=(noline) label= "Tipo de Producto" valueattrs=(size=12) labelattrs=(size=12);
xaxis label="Ventas Totales en US$" valueattrs=(size=11.5) labelattrs=(size=12);
run;
