


----- ACT 2.2 DE CONSULTAS ---------

SELECT * From Usuarios;
Select * From Datos_Personales;

--(1) Listado con nombre de usuario de todos los usuarios y sus respectivos nombres y apellidos.

SELECT U.NombreUsuario, DP.Apellidos, DP.Nombres
FROM Usuarios AS U
INNER JOIN Datos_Personales AS DP ON U.ID= DP.ID;

----------------------------
Select * From Localidades;
Select * From Paises;
----------------------------
--(2) Listado con apellidos, nombres, fecha de nacimiento y nombre del país de nacimiento. 

SELECT DP.Apellidos,DP.Telefono, DP.Nacimiento, P.Nombre
FROM Datos_Personales AS DP
JOIN Localidades AS L ON DP.ID = L.ID
JOIN Paises  AS P ON L.ID = P.ID;



--(3)Listado con nombre de usuario, apellidos, nombres, ¡EMAIL O CELULAR !de todos los usuarios que vivan en [un domicilio comience con vocal].
    --NOTA: Si no tiene email, obtener el celular.

 SELECT U.NombreUsuario, DP.Apellidos, DP.Nombres,
		CASE 
			WHEN DP.Email IS NOT NULL THEN DP.Email
			ELSE DP.Celular
			END AS Contacto 
 FROM Datos_Personales AS DP
 JOIN Usuarios AS U ON DP.ID=U.ID
 WHERE DP.Domicilio LIKE '[AEIOU]%';



---(4)Listado con nombre de usuario, apellidos, nombres, email o celular o domicilio como 'Información de contacto'.
--NOTA: Si no tiene email, obtener el celular y si no posee celular obtener el domicilio.

SELECT U.NombreUsuario, DP.Apellidos,DP.Nombres,
		CASE 
			WHEN DP.Email IS NOT NULL THEN DP.Email
			WHEN DP.Celular  IS NOT NULL THEN DP.Celular
			ELSE DP.Domicilio
			END AS Informacion_De_Contacto
FROM Datos_Personales AS DP
JOIN Usuarios AS U ON DP.ID=U.ID;

			 

--(5) 
--Listado con apellido y nombres, nombre del curso y costo de la inscripción de todos los usuarios inscriptos a cursos.

--NOTA: No deben figurar los usuarios que no se inscribieron a ningún curso.

SELECT * FROM Inscripciones;


SELECT DP.Apellidos, DP.Nombres, C.Nombre, I.Costo AS CostoInscripcion
FROM Datos_Personales AS DP 
JOIN Usuarios AS U ON DP.ID = U.ID
JOIN Inscripciones AS I ON U.ID = I.ID
JOIN Cursos AS C ON I.ID = C.ID
WHERE I.IDUsuario IS NOT NULL;


--(6)
--Listado con nombre de curso, nombre de usuario y mail de todos los inscriptos a cursos que se hayan estrenado en el año 2020.

SELECT * FROM Usuarios;


SELECT C.Nombre, U.NombreUsuario, DP.Email
FROM Cursos AS C
JOIN Inscripciones AS I ON C.ID=I.ID
JOIN Usuarios AS U ON I.ID=I.IDUsuario
JOIN Datos_Personales AS DP ON U.ID=DP.ID
WHERE YEAR(C.Estreno) = 2010;



--(7)Listado con nombre de curso, nombre de usuario, apellidos y nombres, fecha de inscripción, costo de inscripción, fecha de pago e importe de pago. 
--Sólo listar información de aquellos que hayan pagado.

SELECT C.Nombre, U.NombreUsuario, DP.Apellidos,DP.Nombres,I.Fecha, I.Costo,P.Fecha,P.Importe 
FROM Cursos AS C
JOIN Inscripciones AS I ON C.ID=I.IDCurso
JOIN Usuarios AS U ON I.IDUsuario=U.ID
JOIN Datos_Personales AS DP ON U.ID=DP.ID
JOIN Pagos AS P ON I.ID=P.IDInscripcion
WHERE P.IDInscripcion IS NOT NULL; --ESTO ASEGURA QUE SOLO SE SELECCIONEN LOS REGISTROS QUE CUENTAN CON UN PAGO ASOCIADO.


 

 -- (8) Listado con nombre y apellidos, género, fecha de nacimiento, mail, nombre del curso y fecha de certificación de todos aquellos usuarios que se hayan certificado.
 SELECT * FROM Datos_Personales;
 SELECT * FROM Cursos;


 SELECT DP.Nombres, DP.Apellidos,DP.Genero,DP.Nacimiento,DP.Email,C.Nombre,CER.Fecha
 FROM Datos_Personales AS DP
 JOIN Usuarios AS U ON DP.ID=U.ID
 JOIN Inscripciones AS I ON U.ID=I.IDUsuario
 JOIN Cursos AS C ON I.IDCurso=C.ID
 JOIN Certificaciones AS CER ON I.ID=CER.IDInscripcion
 WHERE CER.IDInscripcion IS NOT NULL;
 




 --(9)
--Listado de cursos con nombre, costo de cursado y certificación, costo total (cursado + certificación) con 10% de todos los cursos de nivel Principiante.
SELECT * FROM Cursos;


SELECT C.Nombre, C.CostoCurso, C.CostoCertificacion, N.Nombre, (C.CostoCurso + C.CostoCertificacion) AS CostoTotal,
		CASE
		    WHEN N.Nombre = 'Principiante' THEN ((C.CostoCurso + C.CostoCertificacion)* 0.90)
			ELSE NULL
			END AS CostoTotalDescuento
FROM Cursos AS C
JOIN Niveles AS N ON C.IDNivel = N.ID;



--(10)Listado con nombre y apellido y mail de todos los instructores. Sin repetir.


SELECT DISTINCT  DP.Nombres,DP.Apellidos, DP.Email
FROM Datos_Personales AS DP
JOIN Usuarios AS U ON DP.ID = DP.ID
JOIN Instructores_x_Curso AS IXC ON U.ID = IXC.IDUsuario 
ORDER BY DP.Apellidos ASC;


--(11) Listado con nombre y apellido de todos los usuarios que hayan cursado algún curso cuya categoría sea 'Historia'.
SELECT DP.Apellidos, DP.Nombres, CAT.Nombre
FROM Datos_Personales AS DP
JOIN Usuarios AS U ON DP.ID=DP.ID
JOIN Inscripciones AS I ON U.ID=I.IDUsuario
JOIN Cursos AS C ON I.IDCurso=C.ID
JOIN Categorias_x_Curso AS CXC ON C.ID=CXC.IDCurso
JOIN Categorias AS CAT ON CXC.IDCategoria=CAT.ID
WHERE CAT.Nombre='Historia';


--(12) Listado con nombre de idioma, código de curso y código de tipo de idioma. Listar todos los idiomas indistintamente si no tiene cursos relacionados.
--Yo creo que lo que quiere decir es que si en codigo de curso es null pero tiene codigo de idioma que lo muestre??

--ACA me muestra si tiene idiOMAS ID , aunqque no tenga C.id(curso relacionado)


SELECT I.Nombre AS NombreIdioma, C.ID AS CodigoCurso, I.ID AS CodigoTipoIdioma
FROM Idiomas AS I
LEFT JOIN Idiomas_x_Curso AS IC ON I.ID = IC.IDIdioma
LEFT JOIN Cursos AS C ON IC.IDCurso = C.ID;

SELECT I.Nombre AS NombreIdioma, C.ID AS CodigoCurso, I.ID AS CodigoTipoIdioma
FROM Idiomas AS I	
JOIN Idiomas_x_Curso AS IC ON I.ID = IC.IDIdioma
JOIN Cursos AS C ON IC.IDCurso = C.ID;



--(13)Listado con nombre de idioma de todos los idiomas que no tienen cursos relacionados.

	SELECT I.Nombre AS NombreIdioma
	FROM Idiomas AS I
	LEFT JOIN Idiomas_x_Curso AS IXC ON I.ID = IXC.IDIdioma
	WHERE IXC.IDCurso IS NULL;

	SELECT *  FROM FormatosIdioma;
	SELECT *  FROM Idiomas_x_Curso;
	SELECT * FROM Idiomas;


--(14)Listado con nombres de idioma que figuren como audio de algún curso. Sin repeticiones.

   SELECT  distinct IDIO.Nombre AS NombreIdiomas
   FROM Idiomas AS IDIO
   JOIN Idiomas_x_Curso AS IXC ON IDIO.ID=IXC.IDIdioma
   JOIN FormatosIdioma AS FI ON IXC.IDFormatoIdioma=FI.ID
   WHERE FI.Nombre='Audio';
   

   
   
   
   
	 


--(15)Listado con nombres y apellidos de todos los usuarios y el nombre del país en el que nacieron. Listar todos los países indistintamente si no tiene usuarios relacionados.


 SELECT DP.Nombres, DP.Apellidos, P.Nombre
 FROM Datos_Personales AS DP
 JOIN Localidades AS L ON DP.IDLocalidad=L.ID
 RIGHT JOIN Paises AS P ON L.IDPais = P.ID
 ORDER BY DP.Nombres;


--(16)Listado con nombre de curso, fecha de estreno y nombres de usuario de todos los inscriptos. Listar todos los nombres de usuario indistintamente si no se inscribieron a ningún curso.
 
	 SELECT C.Nombre, C.Estreno, U.NombreUsuario
	 FROM Cursos AS C
	 JOIN Inscripciones AS I  ON C.ID = I.IDCurso
	 RIGHT JOIN Usuarios AS U ON I.IDUsuario = U.ID;

 

 --(17) Listado con nombre de usuario, apellido, nombres, género, fecha de nacimiento y mail de todos los usuarios que no cursaron ningún curso.
	SELECT U.NombreUsuario, DP.Apellidos, DP.Nombres, DP.Genero, DP.Nacimiento, DP.Email
	FROM Datos_Personales AS DP
	JOIN Usuarios AS U ON DP.ID = U.ID
	LEFT JOIN Inscripciones AS I ON U.ID = I.IDUsuario
	WHERE I.IDCurso IS NULL;



 --18 Listado con nombre y apellido, nombre del curso, puntaje otorgado y texto de la reseña. Sólo de aquellos usuarios que hayan realizado una reseña inapropiada.
	
	
	SELECT DP.Apellidos, DP.Nombres, C.Nombre, R.Puntaje, R.Observaciones
	FROM Datos_Personales AS DP
	JOIN Usuarios AS U ON DP.ID = U.ID
	JOIN Inscripciones AS I ON U.ID = I.IDUsuario
	JOIN Cursos AS C ON I.ID = C.ID
	JOIN Reseñas AS R ON I.ID = R.IDInscripcion
	WHERE R.Inapropiada = 1;
	

	


 --(19) Listado con nombre del curso, costo de cursado, costo de certificación, nombre del idioma y nombre del tipo de idioma de 
 --todos los cursos cuya fecha de estreno haya
 -- sido antes del año actual. Ordenado por nombre del curso y luego por nombre de tipo de idioma. Ambos ascendentemente.

  SELECT C.Nombre, C.CostoCurso, C.CostoCertificacion, I.Nombre, FI.Nombre
  FROM Cursos AS C 
  JOIN Idiomas_x_Curso AS IXC ON C.ID = IXC.IDCurso
  JOIN FormatosIdioma AS FI ON IXC.IDFormatoIdioma = FI.ID
  JOIN Idiomas AS I ON IXC.IDIdioma = I.ID
  WHERE YEAR(C.Estreno) < YEAR(GETDATE())
  ORDER BY C.Nombre ASC, FI.Nombre ASC;
 


--(20) Listado con nombre del curso y todos los importes de los pagos relacionados.

	SELECT C.Nombre, P.Importe
	FROM Cursos AS C
	JOIN Inscripciones AS I ON C.ID =I.IDCurso
	JOIN Pagos AS P ON I.ID = p.IDInscripcion
	ORDER BY C.Nombre ASC;


-- (21) Listado con nombre de curso, costo de cursado y una leyenda que indique "Costoso" si el costo de cursado es mayor a $ 15000,
--"Accesible" si el costo de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y $2499 y "Gratis" si el costo es $0.


SELECT C.Nombre, C.CostoCurso,
 CASE
        WHEN CostoCurso > 15000 THEN 'Costoso'
        WHEN CostoCurso BETWEEN 2500 AND 15000 THEN 'Accesible'
        WHEN CostoCurso BETWEEN 1 AND 2499 THEN 'Barato'
        WHEN CostoCurso = 0 THEN 'Gratis'
        ELSE 'Desconocido' -- Manejo de valores no esperados
    END AS Estado
FROM Cursos AS C;



