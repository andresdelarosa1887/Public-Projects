libname tarea "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_2";

data attrmap;
infile datalines dlm=",";
retain ID "Outlet_Identifier";
length value $ 32; 
input value $ fillcolor $ linecolor $;
datalines;
OUT010,gray,gray		
OUT013,gray,gray	
OUT017,gray,gray		
OUT018,gray,gray		
OUT019,gray,gray	
OUT027,blue,black	
OUT035,gray,gray		
OUT045,gray,gray		
OUT046,gray,gray		
OUT049,gray,gray	
;
run;

*SNACK FOODS;
*GRAFICO_1;
proc sql;
create table grafico21 as
select Outlet_Identifier,Outlet_Type, count(distinct item_identifier) as CANTIDAD_PRODUCTOS format=comma9.
, mean(item_mrp) AS PRECIO_PROMEDIO FORMAT=dollar32.
from tarea.asignacion_3
where item_type="Snack Foods"
group by Outlet_Identifier,Outlet_Type;

  proc rank data=grafico21 out=out1 groups=5;                               
     var PRECIO_PROMEDIO;                                                          
     ranks rank1;                                                      
  run;   

proc sgplot data=grafico21 dattrmap=attrmap  noborder noautolegend ;
vbar outlet_identifier/ response=cantidad_productos attrid=Outlet_Identifier  categoryorder=respasc datalabel
datalabelattrs=(size=11.5 color=black) group=outlet_identifier; 
vbar outlet_identifier/ response=precio_promedio stat=mean y2axis  datalabel  fillattrs=(color=blue) 
datalabelattrs=(size=11.5 color=white) barwidth=0.01 y2axis
                outlineattrs=(color=white) attrid=Outlet_Identifier
                baselineattrs=(thickness=0)  fillattrs=(color=blue) group=outlet_identifier;
y2axis min=135 label='Precio Promedio' values=(135 to 180 by 5);
yaxis label="Cantidad de Productos Distintos";
title HEIGHT=12pt JUSTIFY=CENTER "Cantidad de Productos Distintos y sus Precios Promedios por Tienda"; 
title2 HEIGHT=12pt JUSTIFY=CENTER "Snacks"; 
xaxis label="Tienda";
run; 


*GRAFICO_2 NO EXISTE UNA RELACION ENTRE PRECIO Y CANTIDAD;
proc sql; 
create table grafico_2 as 
select item_type, Item_Identifier, sum(cantidad_vendida) as total_vendido format=comma9., mean(ITEM_MRP) as pROMEDIO_PRECIO
from tarea.asignacion_3
where item_type="Snack Foods"
group by  item_type,Item_Identifier
order by total_vendido desc; 

PROC SGPLOT data=grafico_2;
scatter x=promedio_precio y=total_vendido; 
run;

*GRAFICO_3 CANTIDAD DE PRODUCTOS VENDIDOS;
proc sql;
create table grafico_3 as
select outlet_identifier, sum(cantidad_vendida) as TOTAL_VENDIDO
from tarea.asignacion_3 
where item_type="Snack Foods"
group by outlet_identifier; 

proc sgplot data=grafico_3 dattrmap=attrmap  noborder noautolegend;
vbar outlet_identifier/ response=TOTAL_VENDIDO  categoryorder=respasc datalabel
datalabelattrs=(size=11.5 color=black)  attrid=outlet_identifier group=outlet_identifier; 
yaxis label="Cantidad de Productos Vedidos";
format total_vendido comma32.;
title HEIGHT=12pt JUSTIFY=CENTER "Cantidad de Productos Vendidos"; 
title2 HEIGHT=12pt JUSTIFY=CENTER "Snacks"; 
xaxis label="Tienda";
run; 


*HOUSEHOLD;
*GRAFICO_1;
proc sql;
create table grafico21 as
select Outlet_Identifier,Outlet_Type, count(distinct item_identifier) as CANTIDAD_PRODUCTOS format=comma9.
, mean(item_mrp) AS PRECIO_PROMEDIO FORMAT=dollar32.
from tarea.asignacion_3
where item_type="Household"
group by Outlet_Identifier,Outlet_Type;

  proc rank data=grafico21 out=out1 groups=5;                               
     var PRECIO_PROMEDIO;                                                          
     ranks rank1;                                                      
  run;   


proc sgplot data=grafico21 dattrmap=attrmap  noborder noautolegend ;
vbar outlet_identifier/ response=cantidad_productos attrid=Outlet_Identifier  categoryorder=respasc datalabel
datalabelattrs=(size=11.5 color=black) group=outlet_identifier; 
vbar outlet_identifier/ response=precio_promedio stat=mean y2axis  datalabel  fillattrs=(color=blue) 
datalabelattrs=(size=11.5 color=black) barwidth=0.01 y2axis
                outlineattrs=(color=white) attrid=Outlet_Identifier
                baselineattrs=(thickness=0)  fillattrs=(color=blue) group=outlet_identifier;
y2axis min=135 label='Precio Promedio' values=(135 to 195 by 5);
yaxis label="Cantidad de Productos Distintos";
title HEIGHT=12pt JUSTIFY=CENTER "Cantidad de Productos Distintos y sus Precios Promedios por Tienda"; 
title2 HEIGHT=12pt JUSTIFY=CENTER "Productos del Hogar"; 
xaxis label="Tienda";
run; 


*GRAFICO_2 NO EXISTE UNA RELACION ENTRE PRECIO Y CANTIDAD;
proc sql; 
create table grafico_2 as 
select item_type, Item_Identifier, sum(cantidad_vendida) as total_vendido format=comma9., mean(ITEM_MRP) as pROMEDIO_PRECIO
from tarea.asignacion_3
where item_type="Household"
group by  item_type,Item_Identifier
order by total_vendido desc; 

PROC SGPLOT data=grafico_2;
scatter x=promedio_precio y=total_vendido; 
run;

*GRAFICO_3 CANTIDAD DE PRODUCTOS VENDIDOS;
proc sql;
create table grafico_3 as
select outlet_identifier, sum(cantidad_vendida) as TOTAL_VENDIDO
from tarea.asignacion_3 
where item_type="Household"
group by outlet_identifier; 

  proc rank data=grafico3 out=out1 groups=5;                               
     var PRECIO_PROMEDIO;                                                          
     ranks rank1;                                                      
  run;   

proc sgplot data=grafico_3 dattrmap=attrmap  noborder noautolegend;
vbar outlet_identifier/ response=TOTAL_VENDIDO  categoryorder=respasc datalabel
datalabelattrs=(size=11.5 color=black)  attrid=outlet_identifier group=outlet_identifier; 
yaxis label="Cantidad de Productos Vedidos";
format total_vendido comma32.;
title HEIGHT=12pt JUSTIFY=CENTER "Cantidad de Productos Vendidos"; 
title2 HEIGHT=12pt JUSTIFY=CENTER "Productos del Hogar"; 
xaxis label="Tienda";
run; 
		