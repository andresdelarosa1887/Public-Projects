libname itla "/folders/myfolders/PERSONALES/ITLA/DATOS/ASIGNACION_3";


*EXPLICAR EL POR QUE TOME EL PUERTO DE EMBARQUE DE REFERENCIA S (ES DE DONDE SALIERON MAS PERSONAS, 644 MAS DEL 70%);
proc logistic data=itla.train_2 PLOTS(MAXPOINTS=NONE)
	plots(only)=(effect oddsratio);
	class Pclass (param=reference ref='3')
	      sex (param=reference ref="male")
	      Embarked (param=reference ref="S");
	model survived(event='1')= Pclass sex  Agem Parch ;
	TITLE1 "QUE CARACTERISTICAS DE LOS PASAJEROS INFLUYERON A QUE ESTOS MURIERAN"; 
	store out=itla_pf;
	where fare>0; 
run; 

proc freq data=itla.train_2; 
tables embarked;
run; 

