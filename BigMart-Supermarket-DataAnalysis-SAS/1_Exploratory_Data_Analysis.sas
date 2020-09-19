libname tarea "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_2";

data work.mejora;
set work.import;
if Item_Fat_Content in("LF" "low fat" "Low Fat") then fat="Low Fat";
else fat="Regular";
run; 

*EN TODOS LOS ANOS SOLO HAY UN TIPO DE OUTLET LOCATION TYPE; 
proc freq data=work.mejora;
tables item_weight*Outlet_Establishment_Year/missing;
run;

proc means data=work.mejora; 
var item_weight;
class outlet_establishment_year; 
run; 


proc sql; 
create table cantidad_empresas as
select outlet_establishment_year, count(distinct Outlet_Identifier) AS total_fundadas
from tarea.asignacion
group by outlet_establishment_year;

proc sgplot data=cantidad_empresas; 
vbar outlet_establishment_year/response=TOTAL_FUNDADAS;
run;



*items de cada tienda; 
proc sql; 
select outlet_identifier,Item_Type, count(distinct item_identifier), sum(item_outlet_sales)
from work.mejora 
group by outlet_identifier,Item_Type;


*where Outlet_Identifier= "OUT049";

proc sgplot data=WORK.MEJORA;
	hbox Item_Outlet_Sales / category=item_type connect=mean;
	yaxis grid;
run;
		where Outlet_Identifier= "OUT049";


*HACER UN ANALISIS EN GENERAL POR TIPO DE TIENDA Y VER SI EL TIER INFLUYE EN EL MONTO TOTAL DE LAS VENTAS;
proc sgplot data= work.mejora;
vbox Outlet_Establishment_Year/ category=item_outlet_sales group=Item_MRP groupdisplay=cluster;
run; 


proc means data=work.mejora;
class Outlet_Establishment_Year Outlet_Location_Type; 
var item_outlet_sales;
run; 


*ANALISIS EXPLORATORIO DE LOS DATOS;
*NO EXISTE UNA RELACION ENTRE EL PESO DEL ITEM Y LA VISIBILIDAD DE LA TIENDA;
proc sgplot data=WORK.MEJORA;
	vline Outlet_Establishment_Year/ response=Item_Outlet_Sales group=fat;
	xaxis grid;
	yaxis grid;
run;




*POSIBLE TWO WAY ANOVA; 
proc sgplot data=WORK.mejora;
	vbox Item_Visibility / category=fat group=Outlet_location_type 
		grouporder=descending;
	yaxis grid;
run;


*VER COMO SE COMPORTA EN EL TIEMPO LA VISIBILIDAD DEL ITEM DEPENDIENDO DEL CONTENIDO DE GRASA;
proc sgplot data=work.mejora;
	vline Outlet_Establishment_Year / response=Item_Outlet_Sales stat=sum
		group=fat;
	yaxis grid;
run;

proc sgplot data=WORK.mejora;
	vbox Item_Visibility  / category=Outlet_Establishment_Year group=fat
		grouporder=descending;
	yaxis grid;
run;

*los productos low fat tienen el precio de retail mas alto en los tres tipos de tienda; 
proc sgplot data=WORK.MEJORA;
	vbar fat / response=Item_MRP group=Outlet_Location_Type groupdisplay=cluster;
	yaxis grid;
run;
*que itemes tienen los mayores precios de retail; 


