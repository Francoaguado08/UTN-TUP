--1
--{Los nombres y extensiones y tamaño en Megabytes de los archivos} que pesen más 
--que el promedio de archivos.

SELECT A.Nombre, A.Extension, A.Tamaño  / 1048576  AS TAMAÑO_MB 
FROM Archivos AS A 
WHERE A.Tamaño > 
				(SELECT AVG(AR.Tamaño) FROM Archivos AS AR);


--los valores de tamaño están expresados en bytes, y deseas convertirlos a megabytes (MB) para que el resultado sea más claro.
--Para hacerlo, debes dividir el valor de la columna Tamaño entre 1,048,576 (1 MB en bytes).

--2
--Los usuarios indicando apellido y nombre que no sean dueños de ningún archivo con extensión 'zip'.

SELECT U.Apellido, U.Nombre
FROM Usuarios AS U 
WHERE U.IDUsuario NOT IN 
						(SELECT A.IDUsuarioDueño
						 FROM Archivos AS A
						 WHERE A.Extension = 'ZIP')


--3
--{Los usuarios indicando IDUsuario, apellido, nombre y tipo de usuario} que no hayan creado ni modificado ningún archivo 
--en el año actual.

SELECT U.IDUsuario, U.Apellido, U.Nombre, TU.TipoUsuario
FROM Usuarios AS U
INNER JOIN TiposUsuario AS TU ON U.IDTipoUsuario = TU.IDTipoUsuario
WHERE U.IDUsuario NOT IN 
                            (SELECT A.IDUsuarioDueño
							 FROM Archivos AS A
							 WHERE YEAR(A.FechaCreacion) = YEAR(GETDATE())
							 OR YEAR(A.FechaUltimaModificacion) = YEAR(GETDATE())  );			
							 
--La subconsulta devuelve una lista de usuarios que sí han creado o modificado archivos este año.
--NOT IN: La consulta principal excluye a esos usuarios, por lo tanto, solo te muestra a los 
--usuarios que no han creado ni modificado archivos en el año actual.


--4
--Los tipos de usuario que no registren usuario con archivos eliminados.


  SELECT TU.TipoUsuario 
  FROM TiposUsuario AS TU
  INNER JOIN Usuarios AS U ON TU.IDTipoUsuario = U.IDTipoUsuario
  WHERE U.IDUsuario NOT IN 
                           (SELECT A.IDUsuarioDueño 
						    FROM Archivos AS A
							WHERE A.Eliminado = 0);


--5
--Los tipos de archivos que no se hayan compartido con el permiso de 'Lectura'

 SELECT  DISTINCT TA.TipoArchivo
 FROM TiposArchivos AS TA
 INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
 WHERE A.IDArchivo NOT IN 
                          (SELECT DISTINCT AC.IDArchivo
						   FROM ArchivosCompartidos AS AC
						   INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso
						   WHERE P.Nombre = 'Lectura' );




--En la subconsulta el IDArchivo de AC puede ocurrir que aparezca varias veces. Es decir, el mismo archivo fue compartido como lectura a 
--varias personas. 
--Se recomienda siempre hacer uso de Distinct para evitar tener duplicados
						  
--6
--Los nombres y extensiones de los archivos que tengan un tamaño mayor al del archivo con extensión 'xls' más grande.


  
   SELECT AR.Nombre, AR.Extension FROM Archivos AS AR
   WHERE  AR.Tamaño >  
					(SELECT MAX(A.Tamaño)
					FROM Archivos AS A WHERE A.Extension = 'xls');
	






--7
--Los nombres y extensiones de los archivos que tengan un tamaño mayor al del archivo con extensión 'zip' más pequeño.

  SELECT A.Nombre, A.Extension
  FROM Archivos AS A 
  WHERE A.Tamaño > 
                 ( SELECT MIN(A.Tamaño)
				  FROM Archivos AS A WHERE A.Extension = 'zip'
				   
				   );

				   -------------------------A PARTIR DE ACA REPASAR PARA EXAMEN.


--8
--Por cada tipo de archivo indicar el tipo y la cantidad de archivos eliminados y la cantidad de archivos no eliminados.



SELECT TA.TipoArchivo,
        SUM(CASE WHEN A.Eliminado = 1 THEN 1 ELSE 0 END) AS CantidadEliminados,
		SUM(CASE WHEN A.Eliminado = 0 THEN 1 ELSE 0 END) AS CantidadNoEliminados
FROM Archivos AS A 
INNER JOIN TiposArchivos AS TA ON A.IDTipoArchivo = TA.IDTipoArchivo
GROUP BY TA.TipoArchivo;



--9
--Por cada usuario indicar el IDUsuario, el apellido, el nombre, la cantidad de archivos pequeños (menos de 20MB) y la cantidad de archivos grandes (20MBs o más)

SELECT U.IDUsuario, U.Apellido, U.Nombre, 
       COUNT(CASE WHEN (A.Tamaño / 1048576) < 20 THEN 1 ELSE NULL END) AS CantArchiPeques,
       COUNT(CASE WHEN (A.Tamaño / 1048576) >= 20 THEN 1 ELSE NULL END) AS CantArchiGrandes
FROM Usuarios AS U
INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
GROUP BY U.IDUsuario, U.Apellido, U.Nombre;





--10
--Por cada usuario indicar el IDUsuario, el apellido, el nombre y la cantidad de archivos creados en el año 2022, la cantidad en el año 2023 y la cantidad creados en el 2024.

	 SELECT U.IDUsuario, U.Apellido, U.Nombre, 
	 COUNT(CASE WHEN YEAR(A.FechaCreacion) = 2022 THEN  1 ELSE NULL END) AS CantArchi2022,
	 COUNT(CASE WHEN YEAR(A.FechaCreacion) = 2022 THEN  1 ELSE NULL END) AS CantArchi2023,
	 COUNT(CASE WHEN YEAR(A.FechaCreacion) = 2022 THEN  1 ELSE NULL END) AS CantArchi2024
	 FROM Usuarios AS U
	 INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
	 GROUP BY U.IDUsuario, U.Apellido, U.Nombre;





--11
--Los archivos que fueron compartidos con permiso de 'Comentario' pero no con permiso de 'Lectura'

 SELECT A.*
FROM Archivos AS A
WHERE A.IDArchivo IN  (
						SELECT AC.IDArchivo
						FROM ArchivosCompartidos AS AC
						INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso
						WHERE P.Nombre = 'Comentario'
						)
AND A.IDArchivo NOT IN (
						 SELECT AC.IDArchivo
						 FROM ArchivosCompartidos AS AC
						 INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso
						 WHERE P.Nombre = 'Lectura'
                        );





--12
--Los tipos de archivos que registran más archivos eliminados que no eliminados.

 
	SELECT TA.TipoArchivo
	FROM TiposArchivos AS TA
	INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo
	GROUP BY TA.TipoArchivo
	HAVING COUNT(CASE WHEN A.Eliminado = 1 THEN 1 END) > COUNT(CASE WHEN A.Eliminado = 0 THEN 1 END);





--13
--Los usuario que registren más archivos pequeños que archivos grandes (pero que al menos registren un archivo de cada uno)

SELECT U.IDUsuario, U.Apellido, U.Nombre
FROM Usuarios AS U
INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
GROUP BY U.IDUsuario, U.Apellido, U.Nombre
HAVING COUNT(A.IDArchivo) > 0 -- Asegura que haya archivos en general
   AND COUNT(A.IDArchivo) > 0
   AND SUM(CASE WHEN A.Tamaño < 20 * 1024 * 1024 THEN 1 ELSE 0 END) > 
       SUM(CASE WHEN A.Tamaño >= 20 * 1024 * 1024 THEN 1 ELSE 0 END);
	   --Cuenta los archivos pequeños y grandes utilizando SUM con CASE. Verifica que haya más archivos pequeños que grandes.




--14
--Los usuarios que hayan creado más archivos en el 2022 que en el 2023 y en el 2023 que en el 2024.

SELECT U.IDUsuario, U.Apellido, U.Nombre
FROM Usuarios AS U
INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
WHERE YEAR(A.FechaCreacion) IN (2022, 2023, 2024)
GROUP BY U.IDUsuario, U.Apellido, U.Nombre
HAVING 
    SUM(CASE WHEN YEAR(A.FechaCreacion) = 2022 THEN 1 ELSE 0 END) > SUM(CASE WHEN YEAR(A.FechaCreacion) = 2023 THEN 1 ELSE 0 END)
    AND SUM(CASE WHEN YEAR(A.FechaCreacion) = 2023 THEN 1 ELSE 0 END) > SUM(CASE WHEN YEAR(A.FechaCreacion) = 2024 THEN 1 ELSE 0 END);