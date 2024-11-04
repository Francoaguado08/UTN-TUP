

--Create Database SegundoParcial20242C
--go
--Use SegundoParcial20242C
--go
--Create Table Provincias(
--    ID_Provincia int not null primary key identity (1, 1),
--    Nombre varchar(50) not null,
--    ImpuestoImportacion decimal(10, 2) null -- Por ej: 25 es 25% de recargo. NULL si no tiene recargo.
--)
--go
--Create Table Clientes(
--    ID_Cliente int not null primary key identity (1, 1),
--    ID_Provincia int not null foreign key references Provincias(ID_Provincia),
--    Apellidos varchar(100) not null,
--    Nombres varchar(100) not null,
--    Domicilio varchar(200) not null
--)
--go
--Create Table Importaciones(
--    ID_Importacion bigint not null primary key identity (1, 1),
--    ID_Cliente int not null foreign key references Clientes(ID_Cliente),
--    Descripcion varchar(200),
--    Fecha date,
--    Valor money,
--    Arancel money,
--    Pagado bit
--)
--GO
--Create Table Envios(
--    ID_Importacion bigint not null primary key foreign key references Importaciones(ID_Importacion),
--    FechaEstimada date,
--    Costo money
--)
--go
---- Provincias
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Buenos Aires', 5);
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Cordoba', 11);
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Santa Fe', 17);
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Entre Rios', 28);
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Tucumán', null);
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('Mendoza', null);
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('La Pampa', null);
--    INSERT INTO Provincias (Nombre, ImpuestoImportacion) VALUES ('San Juan', null);

---- Clientes
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (5, 'Gonzalez', 'Juan', 'Av. Mitre 123');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (4, 'Rodriguez', 'María', 'Av. San Martin 456');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (1, 'Sanchez', 'Pedro', 'Av. 9 de Julio 789');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (7, 'Perez', 'Lucia', 'Av. Corrientes 123');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (8, 'Gomez', 'Diego', 'Av. Rivadavia 456');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (2, 'Martinez', 'Ana', 'Av. Belgrano 789');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (3, 'Diaz', 'Carlos', 'Av. La Plata 123');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (6, 'Lopez', 'Sofia', 'Av. San Juan 456');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (5, 'Ramirez', 'Jorge', 'Av. Salta 789');
--    INSERT INTO Clientes (ID_Provincia, Apellidos, Nombres, Domicilio) VALUES (1, 'Jimenez', 'Luciana', 'Av. Córdoba 123');



---------------------------------------- SEGUNDO PARCIAL LABORATORIO 3 / ALUMNO: FRANCO EZEQUIEL AGUADO-------------------------------------------------------

--Hacer un trigger para que al agregar una importación calcule el arancel de la misma. El mismo se calcula de la siguiente manera:

--Un 5% sobre el valor de la importación si el cliente acumula menos de $50000 importados en el año (en que se realiza la importación).

--Si no acumula menos de $50000:
--El arancel corresponde al 10% sobre el valor de la importación del producto. Al arancel calculado se le debe aplicar un recargo porcentual 
--del impuesto de importación asociado a la provincia del cliente.


--Por ejemplo:
--Si el valor de importación es $ 200000. Y el impuesto provincial es 10%. Entonces el arancel es de $22000 
--Si el valor de importación es $200000. Y el impuesto provincial es inexistente. Entonces el arancel es de $20000

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--(1)  PUNTO 1
 --  Un 5% sobre el valor de la importación si el cliente acumula menos de $50000 importados en el año (en que se realiza la importación).

-- SELECT * FROM Clientes;
-- SELECT * FROM Importaciones;



CREATE TRIGGER TRG_Calcular_Arancel_Importacion
ON Importaciones
AFTER INSERT  -- al agregar una importación calcule el arancel de la misma
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ID_Importacion BIGINT;
        DECLARE @ID_Cliente INT;
        DECLARE @Valor MONEY;
        DECLARE @Fecha DATE;

        DECLARE @AcumuladoAnual MONEY;
        DECLARE @ImpuestoProvincia DECIMAL(10, 2);
        DECLARE @Arancel MONEY;

        
     
	   SELECT @ID_Importacion = ID_Importacion, @ID_Cliente = ID_Cliente, @Valor = Valor, @Fecha = Fecha FROM INSERTED;
         

      
		--CALCULO EL MONTO ACUMULADO EN EL AÑO. (MONTO DE IMPORTACIONES ACUMULADO EN EL AÑO)
        SELECT @AcumuladoAnual = SUM(Valor)
        FROM Importaciones  WHERE ID_Cliente = @ID_Cliente AND YEAR(Fecha) = YEAR(@Fecha);
       
        -- impuesto de la provincia 
        SELECT @ImpuestoProvincia = P.ImpuestoImportacion
        FROM Clientes AS C
        INNER JOIN Provincias AS P ON C.ID_Provincia = P.ID_Provincia
        WHERE C.ID_Cliente = @ID_Cliente;
		--@ImpuestoProvincia--> aca tengo el impuesto de la provincia del cliente insertado.
                                       
        -- Determino el arancel basado en el acumulado anual
        IF @AcumuladoAnual < 50000
        BEGIN
           
            SET @Arancel = @Valor * 0.05;
        END
        ELSE -- Si no acumula menos de $50000:
        BEGIN
            SET @Arancel = @Valor * 0.10;
            -- Si hay un impuesto de importación en la provincia, le agrego  al arancel.
            IF @ImpuestoProvincia IS NOT NULL
            BEGIN
                SET @Arancel = @Arancel * (1 + @ImpuestoProvincia / 100);
            END

         END
            



        -- Actualizar la importación con el arancel calculado
        UPDATE Importaciones SET Arancel = @Arancel WHERE ID_Importacion = @ID_Importacion;
        
    
        COMMIT TRANSACTION;
    END TRY
        
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Error en la transaccion.', 16, 1);
    END CATCH;
        
       
END;
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------

-- PUNTO (2)
-- TIENE QUE HABER REGISTRADO AL MENOS UNA IMPORTACION!
CREATE VIEW vw_ImportacionesConEnvios
AS
SELECT I.ID_Cliente, I.ID_Importacion, YEAR(I.Fecha) AS Ano, E.ID_Importacion AS EnvioRegistrado
    
FROM Importaciones  AS I
   
INNER JOIN  Envios AS E ON I.ID_Importacion = E.ID_Importacion;
GO


CREATE PROCEDURE SP_ClientesConEnviosCompletos
    @Ano INT
AS
BEGIN
    SELECT DISTINCT C.Apellidos, C.Nombres
    FROM Clientes AS C
    JOIN vw_ImportacionesConEnvios AS V ON C.ID_Cliente = V.ID_Cliente
    WHERE V.Ano = @Ano
    GROUP BY C.ID_Cliente, C.Apellidos, C.Nombres
    HAVING COUNT(V.ID_Importacion) > 0  -- Al menos una importación
       AND COUNT(V.ID_Importacion) = COUNT(V.EnvioRegistrado); --TODAS CON ENVIOSSS
END;
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------

--PUNTO (3)


--creo mi funcion para calcular el total de aranceles pendientes
CREATE FUNCTION fn_Total_Aranceles_Pendientes(@ID_Cliente INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalPendiente MONEY;
	SET @TotalPendiente = (SELECT Arancel FROM Importaciones WHERE ID_Cliente = @ID_Cliente AND Pagado = 0);
    RETURN ISNULL(@TotalPendiente, 0);
END;
GO

 
CREATE TRIGGER TRG_CalcularCostoEnvio
ON Envios
INSTEAD OF INSERT -- "al agregar un envío, realice las siguientes verificaciones y cálculos"
AS
BEGIN
    

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ID_Importacion BIGINT;
        DECLARE @ID_Cliente INT;
        DECLARE @Arancel MONEY;
        DECLARE @CostoEnvio MONEY;
        DECLARE @TotalPendiente MONEY;

        -- (1) Obtengo el ID de la importación.
        SELECT @ID_Importacion = ID_Importacion FROM inserted;

        -- (2)Obtengo el ID del cliente y el arancel de la importación
        SELECT @ID_Cliente = ID_Cliente, @Arancel = Arancel  FROM Importaciones  WHERE ID_Importacion = @ID_Importacion;
        
		--(3)TotalPendiete de mi funcion
        SET @TotalPendiente = dbo.fn_Total_Aranceles_Pendientes(@ID_Cliente);
        

        --(4)El costo del envío es el 50% del arancel de la importación que se quiere enviar 
		--si el cliente no registra importaciones pendientes de pago.
		
		IF @TotalPendiente = 0
        BEGIN
            -- Si no tiene importaciones pendientes.. 
            SET @CostoEnvio = @Arancel * 0.5;
        END
        ELSE  --el costo de envío es el 200% del arancel + 1% de los aranceles pendientes
        BEGIN
            SET @CostoEnvio = (@Arancel * 2) + (@TotalPendiente * 0.01);
        END
           

        --- (5)Actualizo el costo del envio!
        UPDATE Envios SET Costo = @CostoEnvio WHERE ID_Importacion = @ID_Importacion;
        
        COMMIT TRANSACTION;
    END TRY
        

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR ('¡ERROR! En la transaccion de calcular el costo de envio.', 16, 1);
    END CATCH;
  
  
END
---------------------------------------------------------------------------------------------------
  
  --- PROBANDO TODO: 

