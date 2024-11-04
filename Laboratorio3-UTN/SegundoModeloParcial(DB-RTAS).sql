--Create Database ModeloExamen20242C
--Go
--Use ModeloExamen20242C
--go
--Create Table Materias(
--    ID_Materia bigint not null primary key identity (1, 1),
--    Nombre varchar(100) not null,
--    ID_Carrera int not null,
--    HorasSemanales tinyint
--)
--go
--Create Table Docentes(
--    Legajo bigint not null primary key identity (1,1),
--    Apellidos varchar(100) not null,
--    Nombre varchar(100) not null,
--    AñoIngreso int 
--)
--go
--Create Table Cargos(
--    ID_Cargo tinyint not null primary key,
--    Nombre varchar(50)
--)
--go
--Create Table PlantaDocente(
--    ID bigint not null primary key identity (1, 1),
--    Legajo bigint not null foreign key references Docentes(Legajo),
--    ID_Materia bigint not null foreign key references Materias(ID_Materia),
--    ID_Cargo tinyint not null foreign key references Cargos(ID_Cargo),
--    Año int not null
--)
--go
---- Datos
--Insert into Materias(Nombre, ID_Carrera, HorasSemanales)
--Values 
--('Matematica', 1, 6),
--('Fisica 1', 1, 4),
--('Fisica 2', 1, 4),
--('Quimica 1', 2, 4),
--('Quimica 2', 2, 4),
--('Programacion I', 3, 6),
--('Programacion II', 3, 6),
--('Algoritmos', 3, 8),
--('Estadistica', 1, 3),
--('Economia', 3, 2),
--('Legislacion', 2, 2),
--('Sociedad y Estado', 2, 2),
--('Bases de Datos I', 3, 4),
--('Bases de Datos II', 3, 4)

--INSERT INTO Docentes (Apellidos, Nombre, AñoIngreso) VALUES
--('Gonzalez', 'Maria', 2010),
--('Rodriguez', 'Carlos', 2015),
--('Lopez', 'Laura', 2012),
--('Martinez', 'Juan', 2017),
--('Perez', 'Ana', 2011),
--('Gomez', 'Diego', 2014),
--('Fernandez', 'Silvia', 2013),
--('Sanchez', 'Eduardo', 2016),
--('Gimenez', 'Andrea', 2009),
--('Rojas', 'Sergio', 2018),
--('Acosta', 'Marcela', 2008),
--('Romero', 'Hernan', 2019),
--('Mendoza', 'Carolina', 2007),
--('Suarez', 'Ricardo', 2020),
--('Castro', 'Mariana', 2006),
--('Ortega', 'Daniel', 2021),
--('Silva', 'Florencia', 2005),
--('Herrera', 'Gabriel', 2022),
--('Torres', 'Valeria', 2004),
--('Luna', 'Nicolas', 2023);

--Insert into Cargos(ID_Cargo, Nombre)
--Values 
--(1, 'Profesor'),
--(2, 'Jefe de trabajos practicos'),
--(3, 'Ayudante de primera'),
--(4, 'Ayudante de segunda')

--INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año) VALUES
--    (1, 1, 1, 2020),
--    (1, 2, 2, 2020),
--    (3, 3, 3, 2021),
--    (2, 4, 4, 2021),
--    (5, 5, 1, 2020),
--    (2, 6, 2, 2020),
--    (7, 7, 3, 2020),
--    (4, 8, 4, 2021),
--    (4, 9, 1, 2022),
--    (10, 10, 2, 2021),
--    (5, 11, 3, 2020),
--    (12, 12, 4, 2021),
--    (13, 13, 1, 2022),
--    (5, 14, 2, 2023),
--    (15, 1, 3, 2023),
--    (6, 2, 4, 2023),
--    (5, 3, 1, 2023),
--    (1, 4, 2, 2021),
--    (19, 5, 3, 2022),
--    (2, 6, 4, 2023);



---------------------------->             MODELO DEL SEGUNDO PARCIAL		<------------------------------------------------------

SELECT * FROM Docentes;
SELECT * FROM PlantaDocente;
SELECT * FROM Materias;
SELECT * FROM Cargos;

--- PUNTO (1) 

--1)		    Haciendo uso de la base de datos que se encuentra en el Campus Virtual
--			    resolver:
--				Hacer un trigger que al ingresar un registro no permita que un docente pueda
--				tener una materia con el cargo de profesor (IDCargo = 1) si no tiene una
--				antigüedad de al menos 5 años. 
--				Tampoco debe permitir que haya más de un
--				docente con el cargo de profesor (IDCargo = 1) en la misma materia y año. Caso
--				contrario registrar el docente a la planta docente.

CREATE TRIGGER TR_ValidarProfesor_PlantaDocente ON PlantaDocente
INSTEAD OF INSERT 
AS
 BEGIN--COMIENZO

		BEGIN TRY
				 BEGIN TRANSACTION;
				 DECLARE @Legajo BIGINT
			     DECLARE @ID_Materia BIGINT
				 DECLARE @ID_Cargo TINYINT
				 DECLARE @Año INT
				 DECLARE @AñoIngreso INT
				 --(1) OBTENER LOS VALORES QUE INSERTASTE
				 SELECT @Legajo = Legajo, @ID_Materia = ID_Materia, @ID_Cargo = ID_Cargo, @Año = Año 
				 FROM inserted; --inserted para capturar los valores del registro que intenta insertarse en PlantaDocente.

				 --(2) Verificar si el cargo es de profesor (ID_Cargo = 1)
				 IF @ID_Cargo = 1
				 BEGIN
						---(2.1)Obtenemos el año de ingreso de la tabla docentes
						SET @AñoIngreso = (SELECT AñoIngreso FROM Docentes WHERE Legajo =  @Legajo);
						
						---(2.2)Verificamos la antiguedad.
						IF(@Año - @AñoIngreso) < 5 
						BEGIN
								RAISERROR('El docente no tiene la antigüedad requerida de al menos 5 años para ser profesor.', 16, 1);
								RETURN;
						END

						-- (3) Verificar si ya existe un profesor en la misma materia y año.
						IF EXISTS(
									SELECT 1
									FROM PlantaDocente
									WHERE ID_Materia = @ID_Materia AND Año = @Año AND ID_Cargo = 1)
						
						BEGIN
							RAISERROR('Ya existe un profesor asignado para esta materia y año.', 16, 1);
							RETURN;
						END
						
				 END
						
						
                -- Si las validaciones pasan, insertar el registro en PlantaDocente
				INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año)
				VALUES (@Legajo, @ID_Materia, @ID_Cargo, @Año);

				 COMMIT TRANSACTION
	     END TRY
		 BEGIN CATCH
		            ROLLBACK TRANSACTION
		 END CATCH


 END--FIN
				

-- PUNTO (2)

--Hacer una función SQL que a partir de un legajo docente y un año devuelva la
--cantidad de horas semanales que dedicará esa persona a la docencia ese año.
--La cantidad de horas es un número entero >= 0.
--NOTA: No hay que multiplicar el valor por la cantidad de semanas que hay en un
--año.





CREATE FUNCTION fn_HorasSemanalesDocente
(
    @Legajo BIGINT,    -- Identificador del docente
    @Año INT           -- Año para el cual calcularemos las horas semanales
)
RETURNS INT
AS
BEGIN
		DECLARE @TotalHorasSemanales INT
		-- Usamos COALESCE para que, en caso de que no haya asignaciones, se devuelva 0.
		-- Calcular la suma de horas semanales para el docente en el año especificado.
		SELECT @TotalHorasSemanales = COALESCE(SUM(M.HorasSemanales),0)
        FROM PlantaDocente AS PD
		INNER JOIN Materias M ON PD.ID_Materia = M.ID_Materia  -- Unimos con la tabla Materias para obtener las horas semanales
        WHERE PD.Legajo = @Legajo AND PD.Año = @Año;   
		-- Filtramos por el docente y año proporcionados

		RETURN @TotalHorasSemanales;  -- Retornamos el total de horas semanales

END;


--PUNTO (3)
--Hacer un procedimiento almacenado que reciba un ID de Materia y liste la
--cantidad de docentes distintos que han trabajado en ella.



CREATE PROCEDURE sp_ContarDocentesPorMateria
(
    @ID_Materia BIGINT 
)
AS
BEGIN
  
    DECLARE @CantidadDocentes INT;

    -- Contamos la cantidad de docentes distintos que han trabajado en la materia indicada
    SELECT @CantidadDocentes = COUNT(DISTINCT Legajo)
    FROM PlantaDocente
    WHERE ID_Materia = @ID_Materia;

    -- Mostramos el resultado al usuario
    PRINT 'La cantidad de docentes que han trabajado en esta materia es: ' + CAST(@CantidadDocentes AS VARCHAR);
END;

SELECT * FROM Materias

EXEC sp_ContarDocentesPorMateria 1;


--------------------------------------------------- FIN --------------------------------------------------------------->