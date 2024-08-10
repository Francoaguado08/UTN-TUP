


USE univ;
		--Consultas de Seleccion - Clausula WHERE
		--ACT 2.1


  
 --(1) Listado de todos los idiomas.
  Select * From Idiomas; 
  

  --(2) Listado de todos los cursos.
  Select *  From Cursos;


  --(3) Listado con nombre, costo de curso, certificacion, estreno de todos los cursos.
  Select Nombre,CostoCurso,CostoCertificacion, Estreno  From Cursos; 

-- (4)Listado con ID, nombre, costo de inscripci�n y ID de nivel de todos los cursos cuyo costo de certificaci�n sea menor a $5000.  
   SELECT 
    C.ID,
    C.Nombre,
    C.CostoCertificacion,
    C.IDNivel
    FROM 
    Cursos AS C

    WHERE 
    C.CostoCertificacion < 5000;

	------------------------------------------------


-- (5)Listado con ID, nombre, costo de inscripci�n y ID de nivel de todos los cursos cuyo costo de certificaci�n sea mayor a $1200.


   SELECT C.ID,C.Nombre,C.CostoCurso,C.IDNivel
   FROM Cursos AS C
   WHERE C.CostoCertificacion > 1200;
	----------------------------------------------

--6)	Listado con nombre, n�mero y duraci�n de todas las clases del curso con ID n�mero 6.
	SELECT C.Nombre, C.Numero, C.Duracion
	FROM Clases AS C
	WHERE C.ID = 6;

		----------------------------------------------
--(7)	Listado con nombre, n�mero y duraci�n de todas las clases del curso con ID n�mero 10.
	
	Select Nombre, Numero, Duracion From Clases Where ID=10;
	----------------------------------------------

 Select * From Cursos where ID=4;
 Select * From Clases;
 Select *  From Cursos;

-- (8)	[Listado con nombre y duraci�n de todas las clases] del curso con ID n�mero 4. Ordenado por duraci�n de mayor a menor.

 SELECT C.Nombre,C.Duracion
 FROM Clases AS C
 WHERE C.IDCurso=4 
 ORDER BY C.Duracion DESC;
 
 ----------------------------------------------
 --(9) --Listado de cursos con nombre, fecha de estreno, costo del curso, costo de certificaci�n ordenados por fecha de estreno de manera creciente.
		SELECT C.Nombre,C.Estreno,C.CostoCurso,C.CostoCertificacion
		FROM Cursos AS C
		ORDER BY C.Estreno ASC;
		

----------------------------------------------

-- (10)Listado con nombre, fecha de estreno y costo del curso de todos aquellos cuyo ID de nivel sea 1, 5, 9 o 10.
	SELECT C.Nombre,C.Estreno, C.CostoCurso
	FROM Cursos AS C
	WHERE C.IDNivel IN (1,5,9,10);
 --Si est�n almacenados como enteros, es mejor usar la cl�usula IN para compararlos.


		----------------------------------------------

--(11)	--Listado con nombre, fecha de estreno y costo de cursado de los tres cursos m�s caros de certificar.

	Select * from Cursos;
	Select * From Certificaciones;
    Select * From Inscripciones;
	Select * From Clases;

	SELECT TOP 3 WITH TIES C.Nombre, C.Estreno, C.CostoCurso
	FROM Cursos AS C
	ORDER BY C.CostoCertificacion  DESC;

	---------------------------------------------------------------------------------
	
	
	--(12)
	--Listado con nombre, duraci�n y n�mero de todas las clases de los cursos con ID 2, 5 y 7. Ordenados por ID de Curso ascendente y luego por n�mero de clase ascendente.
	SELECT C.Nombre,C.Duracion,C.Numero 
	FROM Clases AS C 
	WHERE C.IDCurso IN (2,5,7)
	ORDER BY C.IDCurso ASC, C.Numero ASC;
		----------------------------------------------

	
--(13)  Listado con nombre y fecha de estreno de todos los cursos cuya fecha de estreno haya sido en el primer semestre del a�o 2019.
--Primer semestre = los primeros 6 meses... lo cual no tengo ningun dato.
   SELECT C.Nombre, C.Estreno
   FROM Cursos AS C
   WHERE YEAR(C.Estreno)= 2019 AND MONTH(C.Estreno) BETWEEN 1 AND 6

	Select C.Nombre, C.Estreno
	From Cursos AS C
	Where Year(C.Estreno) = 2019 AND MONTH(C.Estreno) BETWEEN 6 AND 12; 

	


		----------------------------------------------

	--(14) Listado de cursos cuya fecha de estreno haya sido en el a�o 2020.

     SELECT * FROM Cursos AS C WHERE YEAR(C.Estreno) = 2020;


		----------------------------------------------

--  (15) Listado de cursos cuyo mes de estreno haya sido entre el 1 y el 4.
 
   Select *
   From Cursos AS C
   WHERE MONTH(C.Estreno) BETWEEN 1 AND 4;
   
----------------------------------------------

	--(16) Listado de clases cuya duraci�n se encuentre entre 15 y 90 minutos.
	SELECT * FROM Clases AS C WHERE C.Duracion BETWEEN 15 AND 90;
 

		----------------------------------------------

	
	---(17) Listado de contenidos cuyo tama�o supere los 5000MB y sean de tipo 4 o sean menores a 400MB y sean de tipo 1.
 
	 SELECT * FROM Contenidos AS C
	 WHERE 
      (C.Tama�o > 5000 AND C.IDTipo= 4)
		OR
	  (C.Tama�o < 40 AND C.IDTipo = 1);



	------------------------------------------------------------------
	--(18)
   --Listado de cursos que no posean ID de nivel.
    SELECT * FROM Cursos AS C
	WHERE C.IDNivel IS NULL; 
  


   --(19)
   --Listado de cursos cuyo costo de certificaci�n corresponda al 20% o m�s del costo del curso.
    Select *  From Cursos Where CostoCertificacion >= 0.2 * CostoCurso;

   
--(20) Listado de costos de cursado de todos los cursos sin repetir y ordenados de mayor a menor.
Select  Distinct CostoCurso 
From Cursos 
Order By costoCurso DESC;



