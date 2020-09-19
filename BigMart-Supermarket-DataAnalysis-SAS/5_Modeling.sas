libname tarea "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_2";

proc sort data=tarea.asignacion_2; by Item_Type;run;  
proc reg data=tarea.asignacion_2  Tableout outest=Est rsquare; 
by Item_Type;
model Item_Outlet_Sales= 
	fat1 item_weight_2 Item_Visibility Item_MRP;
output out=regres p=yhat r=e stdp=sd;
where item_type in("Fruits and Vegetables" "Snack Foods" "Household") and item_visibility>0;
run;


proc print data=tarea.asignacion_2; 
var Item_Outlet_Sales fat1 item_weight_2 Item_Visibility Item_MRP;
where item_type in("Fruits and Vegetables") and item_visibility>0;
run;


proc sql; 
create table something as
select Item_Identifier, sum(item_visibility) as VISIBILIDAD, sum(item_outlet_sales) as VENTAS
from tarea.asignacion_2
where item_type in("Fruits and Vegetables") 
group by item_identifier;

proc sgplot data=tarea.asignacion_2; 
scatter x=Item_mrp y=Item_Visibility; 
where item_type in("Fruits and Vegetables") and item_visibility>0;
run;

proc print data=something;
run;

ods graphics/ imagemap=on; 
proc corr data=tarea.asignacion_2 nosimple plots=matrix(nvar=all histogram) PLOTS(MAXPOINTS=777);
	var Item_Outlet_Sales fat1 item_weight_2 Item_Visibility Item_MRP;
	id item_identifier;
run; 