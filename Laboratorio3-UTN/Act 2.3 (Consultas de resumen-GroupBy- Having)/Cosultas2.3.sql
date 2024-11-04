
--ACTIVIDAD 2.3


SELECT * FROM Archivos;

----1
----La cantidad de archivos con extensión zip.
 SELECT COUNT(*) AS CantidadZIP
 FROM Archivos
 WHERE Extension = 'ZIP';

--2
--La cantidad de archivos que fueron modificados y, por lo tanto, su fecha de última modificación no es la misma que la fecha de creación.
	SELECT COUNT(*) AS ArchivosModificados
	FROM Archivos
	WHERE FechaCreacion <> FechaUltimaModificacion;
	-- <>QUE SEA DISTINTO.
 
--3
--La fecha de creación más antigua de los archivos con extensión pdf.
SELECT CAST(MIN(FechaCreacion)AS Date)  AS FechaMasAntigua
FROM Archivos
WHERE Extension = 'pdf'
--CAST(MIN(FechaCreacion) AS Date): Convierte el resultado del MIN(FechaCreacion) (que probablemente sea de tipo DATETIME) 
--a un tipo de dato DATE, que solo incluye la parte de la fecha (año, mes, día) sin incluir la hora.


--(4)
--{La cantidad de extensiones distintas} cuyos archivos tienen en su {nombre o en su descripción la palabra 'Informe' o 'Documento'}.
SELECT COUNT(DISTINCT Extension)
FROM Archivos
WHERE Nombre  LIKE '%Informe%' OR Nombre LIKE '%Documento%'
			OR Descripcion LIKE 'Informe' OR Descripcion LIKE '%Documento%';

--5
--{El promedio de tamaño (expresado en Megabytes)} de los archivos con extensión 'doc', 'docx', 'xls', 'xlsxSELECT AVG(CAST(A.Tamaño AS FLOAT) / 1024 / 1024) AS PromedioTamanoMB

SELECT AVG(CAST (A.Tamaño AS FLOAT)/ 1024 /1024) AS PromedioTamanoMB
FROM Archivos AS A 
WHERE A.Extension IN ('doc', 'docx', 'xls', 'xlsx');

--6
--La cantidad de archivos }que le fueron compartidos al usuario con apellido 'Clarck'
SELECT COUNT(*) AS CantidadArchivosCompartidos
FROM ArchivosCompartidos AS AC
INNER JOIN Usuarios AS U ON AC.IDUsuario = U.IDUsuario
WHERE U.Apellido = 'Clarck' ;

--7


SELECT * FROM TiposUsuario;
SELECT * FROM Usuarios;


--La cantidad de tipos de usuario} que tienen asociado usuarios que registren, como dueños, archivos con extensión pdf.
SELECT COUNT(DISTINCT U.IDTipoUsuario) AS CantTiposUsuario
FROM Usuarios AS U 
INNER JOIN Archivos AS A ON  U.IDUsuario = A.IDUsuarioDueño
WHERE A.Extension = 'pdf';
--8
--El tamaño máximo }expresado en Megabytes de los archivos que hayan sido creados en el año 2024.
SELECT MAX( CAST(A.Tamaño AS FLOAT) /1024 /1024) AS TamañoMaxArchivos
FROM Archivos AS A
WHERE year(A.FechaCreacion) = '2024';
--9
--El nombre del tipo de usuario y {la cantidad de usuarios distintos} de dicho tipo que registran, como dueños, archivos con extensión pdf.

SELECT TU.TipoUsuario AS NombreTipoUsuario, COUNT(DISTINCT U.IDUsuario) AS CantidadUsersDistinct
FROM Usuarios AS U
INNER JOIN TiposUsuario  AS TU ON U.IDTipoUsuario = TU.IDTipoUsuario
INNER JOIN Archivos AS A ON A.IDUsuarioDueño = U.IDUsuario
WHERE A.Extension='pdf'
GROUP BY TU.TipoUsuario;
--10
--<El nombre y apellido de los usuarios dueños> y la suma total del tamaño de los archivos que tengan compartidos con otros usuarios.
--Mostrar ordenado de mayor sumatoria de tamaño a menor.

SELECT * FROM Permisos;
SELECT * FROM ArchivosCompartidos;
SELECT * FROM Usuarios;
SELECT * FROM Archivos;
SELECT * FROM TiposArchivos;

SELECT U.Nombre, U.Apellido, SUM(A.Tamaño) AS SumaTotalTamaño --El nombre y apellido de los usuarios dueños> y la suma total del tamaño de los archivos 
FROM Usuarios AS U
INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
GROUP BY U.Nombre, U.Apellido
ORDER BY SumaTotalTamaño DESC; --Mostrar ordenado de mayor sumatoria de tamaño a menor.

--11
--El nombre del tipo de archivo y el promedio de tamaño de los archivos que corresponden a dicho tipo de archivo.

SELECT TA.TipoArchivo, AVG(A.Tamaño) AS PromedioTamaño
FROM TiposArchivos AS TA
INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
GROUP BY TA.TipoArchivo;

--12
--Por cada extensión, indicar la extensión, la cantidad de archivos con esa extensión y el total acumulado en bytes. Ordenado por cantidad de archivos de forma ascendente.
SELECT A.Extension, 
       COUNT(A.IDArchivo) AS CantidadArchivos, 
       SUM(A.Tamaño) AS TotalAcumulado
FROM Archivos AS A
GROUP BY A.Extension
ORDER BY CantidadArchivos ASC;

--13
--Por cada usuario, indicar IDUSuario, Apellido, Nombre y la sumatoria total en bytes de los archivos que es dueño. 
--Si algún usuario no registra archivos indicar 0 en la sumatoria total.

SELECT U.IDUsuario, U.Apellido, U.Nombre,
CASE	
	WHEN SUM(A.Tamaño) IS NULL THEN 0
	ELSE SUM(A.Tamaño)
	END AS SumatoriaTotalBytes
FROM Usuarios AS U
LEFT JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
GROUP BY U.IDUsuario,  U.Apellido, U.Nombre;

--14
--Los tipos de archivos que fueron compartidos más de una vez con el permiso con nombre 'Lectura'
SELECT TA.TipoArchivo, COUNT(AC.IDArchivo) AS VecesCompartido
FROM TiposArchivos AS TA
INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso -- Aquí la referencia debe ser correcta
WHERE P.Nombre = 'Lectura'
GROUP BY TA.TipoArchivo
HAVING COUNT(AC.IDArchivo) > 1;
--15
--Escribí una consulta que requiera una función de resumen, el uso de joins y de having. 
--Pega en el Foro de Actividad 2.3 en el hilo "Queries del Ejercicio 15" el enunciado de la consulta y la tabla en formato texto plano de lo que daría como resultado con los datos que trabajamos en conjunto.
SELECT TA.TipoArchivo, SUM(A.Tamaño) AS TotalTamaño
FROM TiposArchivos AS TA
INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso
WHERE P.Nombre = 'Lectura'
GROUP BY TA.TipoArchivo
HAVING SUM(A.Tamaño) > 5000;







--16
--Por cada tipo de archivo, {indicar el tipo de archivo }y el tamaño del archivo de dicho tipo que sea más pesado.

   SELECT TA.TipoArchivo, MAX(A.Tamaño) AS ArchivoMasPesado
   FROM TiposArchivos AS TA
   INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo  
   GROUP BY TA.TipoArchivo

--17
--El nombre del tipo de archivo y el promedio de tamaño de los archivos que corresponden a dicho tipo de archivo. 
--Solamente listar aquellos registros que superen los 50 Megabytes de promedio.

SELECT TA.TipoArchivo, AVG(A.Tamaño) AS PromedioTamaño
FROM TiposArchivos AS TA
INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo  
GROUP BY TA.TipoArchivo
HAVING AVG(A.Tamaño) > 50 * 1024 * 1024;  -- 50 Megabytes en bytes

--18
--Listar las extensiones que registren más de 2 archivos que no hayan sido compartidos.

SELECT A.Extension, COUNT(A.IDArchivo) AS CantidadArchivosNoCompartidos
FROM Archivos AS A
LEFT JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
WHERE AC.IDArchivo IS NULL  -- Esto filtra los archivos que NO están compartidos
GROUP BY A.Extension
HAVING COUNT(A.IDArchivo) > 2;




---REPASO PARA EL PARCIAL.
--(1)
	SELECT COUNT(A.IDArchivo) AS CantArhivos
	FROM Archivos AS A 
	WHERE Extension = 'zip';

--(2)  La cantidad de archivos que fueron modificados y, por lo tanto, su fecha de
--	   última modificación no es la misma que la fecha de creación.

	SELECT COUNT(*) AS CantArchiModificados
	FROM Archivos AS A 
	WHERE A.FechaCreacion <> A.FechaUltimaModificacion ; 

	 	 --(3) La fecha de creación más antigua de los archivos con extensión pdf.  SELECT  MIN(A.FechaCreacion)   FROM Archivos AS A  WHERE A.Extension = 'pdf';  -- CAST(MIN(FechaCreacion) AS Date)  Convierte el resultado de MIN(FechaCreacion) a un tipo de dato Date, eliminando la parte de la hora si está presente. --(4)La cantidad de extensiones distintas cuyos archivos tienen en su nombre o en
	--su descripción la palabra 'Informe' o 'Documento'.	SELECT COUNT(A.Extension)    FROM Archivos AS A	WHERE A.Nombre LIKE '%Informe%' OR A.Nombre LIKE 'Documento' OR A.Descripcion LIKE 'Informe' OR Descripcion LIKE '%Documento%';--(5) El promedio de tamaño (expresado en Megabytes) de los archivos con
-- extensión 'doc', 'docx', 'xls', 'xlsx'.	SELECT AVG(A.Tamaño / 1048576.0) AS PromTamañoMB	FROM Archivos AS A 	WHERE A.Extension IN  ('doc', 'docx', 'xls', 'xlsx' )  ;		-- PROMEDIO EN MBBBB!!!!!!!!!!!!! ---------------------------------------------------> MEGABYTES.		--(6)		--La cantidad de archivos que le fueron compartidos al usuario con apellido
		----Clarck'

	SELECT COUNT(A.IDArchivo) AS CantArchiCompartidos
	FROM Archivos AS A
	INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
	INNER JOIN Usuarios AS U ON AC.IDUsuario = U.IDUsuario 
	WHERE U.Apellido = 'Clarck';


	--(7)
	--La cantidad de tipos de usuario que tienen asociado usuarios que registren,
    --como dueños, archivos con extensión pdf.
	SELECT COUNT(DISTINCT TU.TipoUsuario) AS CantTipoUser
	FROM TiposUsuario AS TU
	INNER JOIN Usuarios AS U ON TU.IDTipoUsuario = U.IDTipoUsuario
	INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
	WHERE A.Extension = 'pdf';


	--8
	--El tamaño máximo }expresado en Megabytes de los archivos que hayan sido creados en el año 2024.

	SELECT MAX(A.Tamaño / 1048576.0 )
	FROM Archivos AS A 
	WHERE YEAR(A.FechaCreacion) = 2024;


	--9 
	--El nombre del tipo de usuario y {la cantidad de usuarios distintos} de dicho tipo que registran, como dueños, archivos con extensión pdf.

	 SELECT TU.TipoUsuario AS NombreTipoUser, COUNT(DISTINCT U.IDUsuario) AS CantUserDistinct
	 FROM TiposUsuario AS TU
     INNER JOIN Usuarios AS U ON TU.IDTipoUsuario = U.IDTipoUsuario
	 INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
	 WHERE A.Extension = 'pdf'
	 GROUP BY TU.TipoUsuario;


	 --10
--<El nombre y apellido de los usuarios dueños> y la suma total del tamaño de los archivos que tengan compartidos con otros usuarios.
--Mostrar ordenado de mayor sumatoria de tamaño a menor.

SELECT U.Nombre, U.Apellido, SUM(A.Tamaño) AS SumaTotalTamaño --El nombre y apellido de los usuarios dueños> y la suma total del tamaño de los archivos 
FROM Usuarios AS U
INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
GROUP BY U.Nombre, U.Apellido
ORDER BY SumaTotalTamaño DESC; --Mostrar ordenado de mayor sumatoria de tamaño a menor.

--11
--El nombre del tipo de archivo y el promedio de tamaño de los archivos que corresponden a dicho tipo de archivo.
  
  SELECT TA.TipoArchivo, AVG(A.Tamaño) AS PromTamaño
  FROM TiposArchivos AS TA
  INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
  GROUP BY TA.TipoArchivo 
  ORDER BY  PromTamaño DESC;

  --12
--Por cada extensión, indicar la extensión, la cantidad de archivos con esa extensión y el total acumulado en bytes. 
--Ordenado por cantidad de archivos de forma ascendente.

  SELECT A.Extension, COUNT(A.IDArchivo) AS CantArchivosConEstaExtension, SUM(A.Tamaño) AS TotalAcumBytes
  FROM Archivos AS A 
  GROUP BY A.Extension
  ORDER BY CantArchivosConEstaExtension ASC;

  --13
--Por cada usuario, indicar IDUSuario, Apellido, Nombre y la sumatoria total en bytes de los archivos que es dueño. 
--Si algún usuario no registra archivos indicar 0 en la sumatoria total.
 
	SELECT  U.IDUsuario, U.Apellido, U.Nombre,
	CASE 
		WHEN SUM(A.Tamaño) IS NULL THEN 0
		ELSE SUM(A.Tamaño)
		END AS SumatoriaTotal
	FROM Usuarios AS U
	LEFT JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
	GROUP BY U.IDUsuario, U.Apellido, U.Nombre;

--(14)
--Los tipos de archivos que fueron compartidos más de una vez con el permiso con nombre 'Lectura'  Tipoarchivo, archivos, archivosCompartidos
		SELECT TA.TipoArchivo, COUNT(AC.IDArchivo) AS CantCompartida
		FROM TiposArchivos AS TA
		INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
		INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
		INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso 
		WHERE P.Nombre = 'Lectura' 
		GROUP BY TA.TipoArchivo
		HAVING COUNT(AC.IDArchivo) > 1;
	

	
--16
--Por cada tipo de archivo, {indicar el tipo de archivo }y el tamaño del archivo de dicho tipo que sea más pesado.

  SELECT TA.TipoArchivo, MAX(A.Tamaño) AS MASPESADO
  FROM TiposArchivos AS TA
  INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
  GROUP BY TA.TipoArchivo

    
--17
--El nombre del tipo de archivo y el promedio de tamaño de los archivos que corresponden a dicho tipo de archivo. 
--Solamente listar aquellos registros que superen los 50 Megabytes de promedio.

  SELECT TA.TipoArchivo, AVG(A.Tamaño) AS PromedioTamaño
  FROM TiposArchivos AS TA
  INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
  GROUP BY TA.TipoArchivo 
	 HAVING AVG(A.Tamaño) > 50 * 1024 * 1024;  -- 50 Megabytes en bytes


	--18
--Listar las extensiones que registren más de 2 archivos que no hayan sido compartidos.

SELECT A.Extension, COUNT(A.IDArchivo) AS CantidadArchivosNoCompartidos
FROM Archivos AS A
LEFT JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
WHERE AC.IDArchivo IS NULL  -- Archivos que no han sido compartidos
GROUP BY A.Extension
HAVING COUNT(A.IDArchivo) > 2; -- Extensiones con más de 2 archivos no compartidos
