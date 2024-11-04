--CREATE DATABASE LAB3_ACTIVIDAD_3_1
--GO
--USE LAB3_ACTIVIDAD_3_1
--GO
--CREATE TABLE USUARIOS(
--  IDUSUARIO BIGINT NOT NULL PRIMARY KEY IDENTITY (1, 1),
--  DNI VARCHAR(10) NOT NULL UNIQUE,
--  APELLIDO VARCHAR(50) NOT NULL,
--  NOMBRE VARCHAR(50) NOT NULL,
--  DOMICILIO VARCHAR(50) NULL,
--  FECHA_NAC DATE  NULL,
--  ESTADO BIT NOT NULL
--)
--GO
--CREATE TABLE TARJETAS(
--  IDTARJETA BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
--  IDUSUARIO BIGINT NOT NULL FOREIGN KEY REFERENCES USUARIOS(IDUSUARIO),
--  FECHA_ALTA DATE NOT NULL,
--  SALDO MONEY NOT NULL,
--  ESTADO BIT NOT NULL  
--)
--GO
--CREATE TABLE LINEAS(
--  IDLINEA BIGINT NOT NULL PRIMARY KEY,
--  NOMBRE VARCHAR(30) NOT NULL,
--  DOMICILIO VARCHAR(50) NULL
--)
--GO
--CREATE TABLE VIAJES(
--  IDVIAJE BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
--  FECHA DATETIME NOT NULL DEFAULT(GETDATE()),
--  NRO_INTERNO BIGINT NULL,
--  IDLINEA BIGINT NOT NULL FOREIGN KEY REFERENCES LINEAS(IDLINEA),
--  IDTARJETA BIGINT NOT NULL FOREIGN KEY REFERENCES TARJETAS(IDTARJETA),
--  IMPORTE SMALLMONEY NOT NULL
--)
--GO
--CREATE TABLE MOVIMIENTOS(
--  IDMOVIMIENTOS BIGINT NOT NULL PRIMARY KEY IDENTITY(1, 1),
--  FECHA DATETIME NOT NULL,
--  IDTARJETA BIGINT NOT NULL FOREIGN KEY REFERENCES TARJETAS(IDTARJETA),
--  IMPORTE SMALLMONEY NOT NULL,
--  TIPO CHAR NOT NULL CHECK (TIPO = 'C' OR TIPO = 'D') -- 'C' - CRÉDITO y 'D' - DÉBITO
--)


--			-- Insertar usuarios en la tabla USUARIOS
--INSERT INTO USUARIOS (DNI, APELLIDO, NOMBRE, DOMICILIO, FECHA_NAC, ESTADO)
--VALUES ('12345678', 'Perez', 'Juan', 'Av. Siempre Viva 123', '1990-01-01', 1);

--INSERT INTO USUARIOS (DNI, APELLIDO, NOMBRE, DOMICILIO, FECHA_NAC, ESTADO)
--VALUES ('87654321', 'Garcia', 'Maria', 'Calle Falsa 456', '1985-05-15', 1);

---- Insertar tarjetas para los usuarios en la tabla TARJETAS
--INSERT INTO TARJETAS (IDUSUARIO, FECHA_ALTA, SALDO, ESTADO)
--VALUES (1, '2023-01-01', 1000.00, 1);

--INSERT INTO TARJETAS (IDUSUARIO, FECHA_ALTA, SALDO, ESTADO)
--VALUES (2, '2023-02-01', 500.00, 1);

---- Insertar líneas de viaje en la tabla LINEAS
--INSERT INTO LINEAS (IDLINEA, NOMBRE, DOMICILIO)
--VALUES (1, 'Linea 101', 'Terminal Central');

---- Insertar un viaje en la tabla VIAJES
--INSERT INTO VIAJES (FECHA, NRO_INTERNO, IDLINEA, IDTARJETA, IMPORTE)
--VALUES (GETDATE(), 123, 1, 1, 50.00);

---- Insertar un movimiento de tipo crédito en la tabla MOVIMIENTOS
--INSERT INTO MOVIMIENTOS (FECHA, IDTARJETA, IMPORTE, TIPO)
--VALUES (GETDATE(), 1, 200.00, 'C');

---- Insertar un movimiento de tipo débito en la tabla MOVIMIENTOS
--INSERT INTO MOVIMIENTOS (FECHA, IDTARJETA, IMPORTE, TIPO)
--VALUES (GETDATE(), 2, 50.00, 'D');



---------------------				ESTRUCTURAS BASICAS PARA NO PERDER TIEMPO EN EL EXAMEN			------------------------------------------------->

												
	--------------------------< TRIGGERS >---------------------------------------------------------------
				
CONSULTA : INSERT / INSERTED
		  DELETE / DELETED
		UPDATE/ AMBAS
	
	--	ESQUEMA:
		
 CREATE TRIGGER TR_nombredeltrigger ON tabla --SOBRE QUE TABLA
 AFTER INSERT -- LUEGO DEL INSERT  
 AS
 BEGIN--CPOMIENZO

		BEGIN TRY
				 BEGIN TRANSACTION;
				 --(1) Registrar la venta .
				 --(2) Descontar el Stock. para eso necesito conocer el IDARTICULO Y LA CANT A DESCONTAR
				 --(3) Realizar el UPDATE CORRESPONDIENTE.

				 DECLARE @IDARTICULO BIGINT
				 DECLARE @CANTIDAD INT
				 
				 SELECT @IDARTICULO =  IDARTICULO, @CANTIDAD = CANTIDAD FROM INSERTED 
				 
				 UPDATE ARTICULOS SET STOCK = STOCK - @CANTIDAD WHERE IDARTICULO = @IDARTICULO



				 COMMIT TRANSACTION
	     END TRY
		 BEGIN CATCH
		            ROLLBACK TRANSACTION
		 END CATCH


 END--FIN


 --------------------------------------------------------------------------------------------------------------------------------------------------------------

 VISTAS

 CREATE VIEW  VW_NOMBREVISTA
 AS
 


 GO
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
													
													SP CON TRANSACCTION



 CREATE PROCEDURE sp_Agregar_Tarjeta
    @DNI VARCHAR(10),
	  @Nombre VARCHAR(50),                --PARAMETROS QUE ME DICE EL ENUNCIADO CON EL MISMO TIPO DE DATO QUE EN LA DB'
		 @FechaNacimiento DATE,				
	     @Domicilio VARCHAR(50),
AS
BEGIN
    BEGIN TRANSACTION;   -- Inicia la transacción

    BEGIN TRY -- Hago el Uso del Try (1)
      
	   --(2)Declaro las variables Y COMIENZO CON EL DESARROLLO QUE HABIA HECHO.
	    DECLARE @IDUsuario BIGINT;
        DECLARE @IDTarjetaAntigua BIGINT;
        DECLARE @SaldoAntiguo MONEY;

        	

        COMMIT; --- SI SE EJECUTO TODO CORRECTAMENTE LO QUE HACER ES MANDAR EL COMMIT OSEA EL 'OK'
        PRINT 'Tarjeta agregada exitosamente y saldo traspasado.';
    END TRY
    
	
	BEGIN CATCH
        ROLLBACK;  --- SI HUBO ALGUN ERROR LO QUE HACE ES USAR EL ROLLBACK =  MARCAR LA CONSISTENCIA!
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;



----------------------------------------------------------------------------------------------------------------------------------------------------------------
FUNCIONES


CREATE FUNCTION NombreFuncion 
(
    @Parametro1 TipoDato, -- Definir los parámetros de entrada con tipo de dato
    @Parametro2 TipoDato
)
RETURNS TipoRetorno -- Definir el tipo de dato que devolverá la función
AS
BEGIN
    DECLARE @Resultado TipoRetorno; -- Declarar una variable para almacenar el resultado

    -- Lógica de la función
    SET @Resultado = ...; -- Asignar un valor a la variable

    -- Devolver el resultado
    RETURN @Resultado;
END;


-------------------------------------------------------------------------------------------------------------------------------------------------








--ACTIVIDAD 3-1


--A) Realizar una función llamada TotalDebitosxTarjeta que reciba un ID de Tarjeta y registre el total acumulado en pesos de movimientos de 
--tipo débito que registró esa tarjeta. 
--La función no debe contemplar el estado de la tarjeta para realizar el cálculo.	
		

		CREATE FUNCTION TotalDebitosxTarjeta (@IDTARJETA BIGINT)
		RETURNS MONEY
		AS 
		BEGIN
			DECLARE @TotalDebitos MONEY;
			SELECT @TotalDebitos = SUM(IMPORTE)
			FROM MOVIMIENTOS
			WHERE IDTARJETA = @IDTARJETA AND TIPO = 'D';
			
			RETURN ISNULL(@TotalDebitos,0);
		END;
		GO
			
		SELECT dbo.TotalDebitosxTarjeta(2); --prueba de que funciona.



		--B) Crear la función TotalCreditosxTarjeta	
		
		
		
		
		
		
		
		
		
		
		
		
		CREATE FUNCTION TotalCreditosxTarjeta(@IDTARJETA BIGINT)
		RETURNS MONEY
		AS 
		BEGIN
			 DECLARE @TotalCreditos MONEY;
			 SELECT @TotalCreditos = SUM (IMPORTE)
			 FROM MOVIMIENTOS
			 WHERE IDTARJETA = @IDTARJETA AND TIPO = 'C';
			 RETURN ISNULL(@TotalCreditos,0);
		END;
		GO
		SELECT dbo.TotalCreditosxTarjeta(1);


--C) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma debe contener:
--Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.

		CREATE VIEW Vista_UsuariosTarjetas
		AS
		SELECT
		 U.APELLIDO,
		 U.NOMBRE,
         T.IDTARJETA AS NumeroTarjetaSUBE,
         T.ESTADO AS EstadoTarjeta,
         T.SALDO
         FROM 
         USUARIOS AS U
         INNER JOIN 
         TARJETAS AS T ON U.IDUSUARIO = T.IDUSUARIO;
         GO

	--D) Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. La misma debe contener: 
	--Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje, número de interno y nombre de la línea.

   	  CREATE VIEW Vista_UsuariosViajes
      AS
      SELECT 
        U.APELLIDO,
        U.NOMBRE,
        T.IDTARJETA AS NumeroTarjetaSUBE,
        V.FECHA AS FechaViaje,
        V.IMPORTE AS ImporteViaje,
        V.NRO_INTERNO,
        L.NOMBRE AS NombreLinea
		FROM 
			USUARIOS AS U
		INNER JOIN 
			TARJETAS AS T ON U.IDUSUARIO = T.IDUSUARIO
		INNER JOIN 
			VIAJES AS V ON T.IDTARJETA = V.IDTARJETA
		INNER JOIN 
			LINEAS AS L ON V.IDLINEA = L.IDLINEA;
		GO


		--E) Crear vista de Estadísticas de Tarjetas
		--Esta vista proporcionará estadísticas para cada tarjeta, incluyendo:

		--Apellido y Nombre del usuario. OK
		--Número de tarjeta SUBE. OK
		--Cantidad de viajes realizados.
		--Total de dinero acreditado históricamente.
		--Cantidad de recargas.
		--Importe promedio de recargas.
		--Estado de la tarjeta.


		CREATE VIEW Vista_EstadisticaXTarjetas
		AS
		SELECT U.APELLIDO, U.NOMBRE, T.IDTARJETA  AS NumeroTarjetaSube,
		(SELECT COUNT(*) FROM VIAJES WHERE IDTARJETA = T.IDTARJETA )AS CantidadDeViajes,
		dbo.TotalCreditosxTarjeta(T.IDTARJETA) AS TotalDineroAcreditado	,
		(SELECT COUNT(*) FROM MOVIMIENTOS WHERE IDTARJETA = T.IDTARJETA AND TIPO = 'C') AS CantidadRecargas,
		(SELECT AVG(IMPORTE) FROM MOVIMIENTOS WHERE IDTARJETA = T.IDTARJETA AND TIPO = 'C') AS ImportePromedioRecargas,
		T.ESTADO AS EstadoTarjeta
		FROM 
		 USUARIOS AS U
		INNER JOIN 
		TARJETAS AS T ON U.IDUSUARIO = T.IDUSUARIO;
		GO


		--La subconsulta COUNT(*) FROM VIAJES cuenta los viajes.
		--TotalCreditosxTarjeta(T.IDTARJETA) calcula el total de dinero acreditado.
		--COUNT(*) con TIPO = 'C' cuenta las recargas.
		--AVG(IMPORTE) con TIPO = 'C' calcula el importe promedio de las recargas.




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->


		--ACTIVIDAD 3.2 ALMACENAMIENTOS PROCESADOS!
		
		--A) Realizar un procedimiento almacenado llamado sp_Agregar_Usuario que permita registrar un usuario en el sistema. 
		--El procedimiento debe recibir como parámetro DNI, Apellido, Nombre, Fecha de nacimiento y los datos del domicilio del usuario.
		
		
		CREATE PROCEDURE SP_Agregar_Usuario
	     @DNI VARCHAR(10),
	     @Apellido VARCHAR(50),
	     @Nombre VARCHAR(50),                --PARAMETROS QUE ME DICE EL ENUNCIADO CON EL MISMO TIPO DE DATO QUE EN LA DB'
		 @FechaNacimiento DATE,				
	     @Domicilio VARCHAR(50)
		
		AS
		BEGIN 
			INSERT INTO Usuarios(DNI,APELLIDO,NOMBRE,DOMICILIO,FECHA_NAC,ESTADO)
			VALUES(@DNI, @Apellido, @Nombre, @FechaNacimiento, @Domicilio, 1);
		END;
		GO
<--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		
--B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé de alta una tarjeta. 
--El procedimiento solo debe recibir el DNI del usuario.

--Como el sistema sólo permite una tarjeta activa por usuario, el procedimiento debe:
--Dar de baja la última tarjeta del usuario (si corresponde).@TARJETAVIEJA
--Dar de alta la nueva tarjeta del usuario INSERT INTO TARJETAS
--Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde) @SALDOANTIGUO
CREATE PROCEDURE sp_Agregar_Tarjeta
    @DNI VARCHAR(10)
AS
BEGIN
    BEGIN TRANSACTION;   -- Inicia la transacción

    BEGIN TRY -- Hago el Uso del Try (1)
      
	   --(2)Declaro las variables Y COMIENZO CON EL DESARROLLO QUE HABIA HECHO.
	    DECLARE @IDUsuario BIGINT;
        DECLARE @IDTarjetaAntigua BIGINT;
        DECLARE @SaldoAntiguo MONEY;

        SET @IDUsuario = (SELECT IDUSUARIO FROM USUARIOS WHERE DNI = @DNI);
        
        IF @IDUsuario IS NULL
        BEGIN
            RAISERROR('Usuario no encontrado.', 16, 1);
            ROLLBACK;
            RETURN;
        END
        
        SET @IDTarjetaAntigua = (SELECT TOP 1 IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario AND ESTADO = 1 ORDER BY FECHA_ALTA DESC);

        IF @IDTarjetaAntigua IS NOT NULL
        BEGIN
            SET @SaldoAntiguo = (SELECT SALDO FROM TARJETAS WHERE IDTARJETA = @IDTarjetaAntigua);
            UPDATE TARJETAS SET ESTADO = 0 WHERE IDTARJETA = @IDTarjetaAntigua;
        END


        ELSE
        BEGIN
            SET @SaldoAntiguo = 0;
        END

        INSERT INTO TARJETAS (IDUSUARIO, FECHA_ALTA, SALDO, ESTADO)
        VALUES (@IDUsuario, GETDATE(), @SaldoAntiguo, 1);

		---

        COMMIT; --- SI SE EJECUTO TODO CORRECTAMENTE LO QUE HACER ES MANDAR EL COMMIT OSEA EL 'OK'
        PRINT 'Tarjeta agregada exitosamente y saldo traspasado.';
    END TRY
    
	
	BEGIN CATCH
        ROLLBACK;  --- SI HUBO ALGUN ERROR LO QUE HACE ES USAR EL ROLLBACK =  MARCAR LA CONSISTENCIA!
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;



-------- SP SIN TRANSACCION -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  CREATE PROCEDURE SP_Agregar_Tarjeta
  @DNI VARCHAR(10)
  AS
BEGIN
	DECLARE @IDUsuario BIGINT;
    DECLARE @IDTarjetaAntigua BIGINT;
	DECLARE @SaldoAntiguo MONEY;
  
  --Paso 1: Obtener el ID del usuario.
   SET @IDUsuario = (SELECT IDUSUARIO FROM USUARIOS WHERE DNI = @DNI);
  --Paso 2: Verificar si el usuario existe
   IF @IDUsuario IS NULL
   BEGIN																		--SE DECLARA LA VARIABLE IDUSUARIO Y SE VERIFICA SI ES NULL.					
        -- Si el usuario no existe, mostrar un mensaje de error
        RAISERROR('Usuario no encontrado.', 16, 1);
        RETURN;
    END

 -- Paso 3: Obtener la última tarjeta activa del usuario (si tiene).
    SET @IDTarjetaAntigua = (SELECT TOP 1 IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario AND  ESTADO = 1 ORDER BY FECHA_ALTA DESC);

	-- Paso 4: Si existe una tarjeta activa anterior, realizar la baja lógica y guardar su saldo
	IF @IDTarjetaAntigua IS NOT NULL																			--SE OBTIENE LA TARJETA ANTIGUA, SE GUARDA EL SALDO SI EXISTE Y SE 
																												--ACTUALIZA EL ESTADO DE LA TARJETA A 0(INACTIVO).
		BEGIN
		     SET @SaldoAntiguo = (SELECT SALDO FROM TARJETAS WHERE IDTARJETA = @IDTarjetaAntigua);
			-- Actualizar el estado de la tarjeta anterior a inactiva (baja lógica)
			UPDATE TARJETAS SET ESTADO = 0 WHERE IDTARJETA = @IDTarjetaAntigua;
		END
		ELSE
    		BEGIN
            -- Si no hay tarjeta anterior, el saldo antiguo es cero
            SET @SaldoAntiguo = 0;
        END	
			 
    

	--POR ULTIMO CREAR LA NUEVA TARJETA PARA EL USUARIO Y ASIGNAR EL SALDO DE LA TARJETA ANTERIOR.
	  INSERT INTO TARJETAS (IDUSUARIO,FECHA_ALTA,SALDO,ESTADO)
						   VALUES(@IDUsuario, GETDATE(), @SaldoAntiguo, 1);


       PRINT 'TARJETA AGREGADA EXITOSAMENTE';

END

 --PRUEEBA DE SP
--Ejecuta el procedimiento para agregar una nueva tarjeta a un usuario existente por su DNI. Esto desactiva cualquier tarjeta anterior y transfiere el saldo a la nueva tarjeta.
EXEC sp_Agregar_Tarjeta @DNI = '43092932'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--C) Realizar un procedimiento almacenado llamado sp_Agregar_Viaje que registre un viaje a una tarjeta en particular.
--El procedimiento debe recibir: Número de tarjeta, importe del viaje, nro de interno y nro de línea.
--El procedimiento deberá:
--Descontar el saldo (1)
--Registrar el viaje   --INSERT INTO VIAJES (2)
--Registrar el movimiento de débito (3)

--NOTA: Una tarjeta no puede tener una deuda que supere los $2000.



CREATE PROCEDURE SP_Agregar_Viaje
@IDTarjeta BIGINT,
@Importe SMALLMONEY,
@NroInterno BIGINT,
@IDLinea BIGINT          --ESTO ES LO QUE TENGO, ESTOS DATOS ME LOS DA EL USUARIO COMO PARAMETRO!
AS
BEGIN
	  
	  --NECESITAMSO OBTENER EL SALDO ACTUAL PARA DESP DECONTAR EL SALDO
	  DECLARE @SaldoActual MONEY;

	  SET @SaldoActual = (SELECT SALDO FROM TARJETAS WHERE IDTARJETA = @IDTarjeta);

	  IF (@SaldoActual - @Importe ) >= -2000     --NOTA: Una tarjeta no puede tener una deuda que supere los $2000.
	                                              --Si no tiene la deuda procedo a descontar.
      

	  --Descontar el saldo (1)
	  BEGIN 
			UPDATE TARJETAS SET SALDO = SALDO - @Importe WHERE IDTARJETA = @IDTarjeta; --ACTUALIZO EL SALDO / LE DESCUENTO EL IMPORTE DIGAMOS

	  --Registrar el viaje (2)
			INSERT INTO VIAJES(FECHA,IDLINEA,IDTARJETA, IMPORTE,NRO_INTERNO) VALUES(GETDATE(), @IDLinea, @IDTarjeta, @Importe, @NroInterno);
		

	  --Registrar el movimiento de débito (3)
			INSERT INTO MOVIMIENTOS(FECHA,IDTARJETA,IMPORTE,TIPO)
							VALUES(GETDATE(), @IDTarjeta, @Importe, 'D');
         

	  END
	  ELSE
			RAISERROR('Saldo Insuficiente. No se puede realizar el viaje.',16,1);
	  END
	  


END

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--D) Realizar un procedimiento almacenado llamado sp_Agregar_Saldo que registre un movimiento de crédito a una tarjeta en particular. 
--El procedimiento debe recibir: El número de tarjeta y el importe a recargar. Modificar el saldo de la tarjeta.


CREATE PROCEDURE SP_Agregar_Saldo
    @IDTarjeta BIGINT,
    @ImporteDeCarga MONEY
AS
BEGIN
    -- Paso 1: Verificar si la tarjeta existe
    IF EXISTS (SELECT 1 FROM TARJETAS WHERE IDTARJETA = @IDTarjeta)
    BEGIN
        -- Paso 2: Actualizar el saldo de la tarjeta sumando el importe de recarga
        UPDATE TARJETAS SET SALDO = SALDO + @ImporteDeCarga
        WHERE IDTARJETA = @IDTarjeta;

        PRINT 'Saldo agregado exitosamente.';
    END
    ELSE
    BEGIN
        -- Si la tarjeta no existe, mostrar un mensaje de error
        RAISERROR('Número de tarjeta inválido o no encontrado.', 16, 1);
    END
END;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--E) Realizar un procedimiento almacenado llamado sp_Baja_Fisica_Usuario que elimine un usuario del sistema. 
--La eliminación deberá ser 'en cascada'. Esto quiere decir que para cada usuario primero deberán eliminarse todos los viajes y recargas de sus respectivas tarjetas. 
--Luego, todas sus tarjetas y por último su registro de usuario.

CREATE PROCEDURE SP_Baja_Fisica_Usuario
    @DNI VARCHAR(10)   ---Para eliminarlo como parametro identificador del usuario le vamos a pedir el DNI.
AS
BEGIN
    DECLARE @IDUsuario BIGINT;

    -- Obtener el ID del usuario 
    SET @IDUsuario = (SELECT IDUSUARIO FROM USUARIOS WHERE DNI = @DNI);

    IF @IDUsuario IS NOT NULL
    BEGIN
        -- Eliminar los viajes
        DELETE FROM VIAJES WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario);
       
	   -- Eliminar los movimientos de todas las tarjetas del usuario.
		DELETE FROM MOVIMIENTOS WHERE IDTARJETA IN (SELECT IDTARJETA FROM TARJETAS WHERE IDUSUARIO = @IDUsuario);

        -- Eliminar todas las tarjetas del usuario
        DELETE FROM TARJETAS WHERE IDUSUARIO = @IDUsuario;

        -- Finalmente, eliminar el usuario
        DELETE FROM USUARIOS WHERE IDUSUARIO = @IDUsuario;
    END
    ELSE
    BEGIN
        -- Si no existe el usuario, arrojar un error
        RAISERROR('Usuario no encontrado.', 16, 1);
    END
END;
GO


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--							VIDEOS EZXPLICATIVOS CON EJEMPLO DE USOS DE TRIGGERS.


--EJEMPLOS USADOS PARA LA EXPLICACION DE TRIGGERS.

 -- EN ESTE CASO QUEREMOS CREAR UN TRIGGER QUE SE DISPARE CUANDO SE INSERTE  UNA VENTA PARA DESCONTAR
 -- EL STOCK.



 CREATE TRIGGER TR_AGREGAR_VENTA ON VENTAS --SOBRE QUE TABLA
 AFTER INSERT -- LUEGO DEL INSERT
 AS
 BEGIN--CPOMIENZO

		BEGIN TRY
				 BEGIN TRANSACTION;
				 --(1) Registrar la venta .
				 --(2) Descontar el Stock. para eso necesito conocer el IDARTICULO Y LA CANT A DESCONTAR
				 --(3) Realizar el UPDATE CORRESPONDIENTE.

				 DECLARE @IDARTICULO BIGINT
				 DECLARE @CANTIDAD INT
				 SELECT @IDARTICULO =  IDARTICULO, @CANTIDAD = CANTIDAD FROM INSERTED 
				 
				 UPDATE ARTICULOS SET STOCK = STOCK - @CANTIDAD WHERE IDARTICULO = @IDARTICULO



				 COMMIT TRANSACTION
	     END TRY
		 BEGIN CATCH
		            ROLLBACK TRANSACTION
		 END CATCH


 END--FIN
 
 ------------------------------------------------------------------------------------------------------------------------------------------
 CREATE TRIGGER TR_AGREGAR_VENTA ON VENTAS --SOBRE QUE TABLA
 INSTEAD OF INSERT -- Va a capturar el Insert en la tabla de ventas, y va a ejecutar este codigo. 
 AS
 BEGIN--CPOMIENZO

		BEGIN TRY
				 BEGIN TRANSACTION;
				 --(1) Registrar la venta .
				 DECLARE @IDARTICULO BIGINT
				 DECLARE @CANTIDAD INT
				 SELECT @IDARTICULO =  IDARTICULO, @CANTIDAD = CANTIDAD FROM INSERTED 
				 DECLARE @PU MONEY -- VAMOS A GUARDAR EL PRECIO UNITARIO DEL ARTICULO.
				 SELECT @PU = PRECIO FROM ARTICULOS WHERE IDARTICULO = @IDARTICULO
				 --YA TENEMOS EL ARTICULO, LA CANTIDAD Y EL PRECIO NOS QUEDA REGISTRAR LA VENTA.

				 INSERT INTO VENTAS(IDARTICULO, CANTIDAD, FECHA, DNI, IMPORTE)
				 SELECT IDARTICULO, CANTIDAD, GETDATE(), DNI,  @PU * @CANTIDAD FROM INSERTED

				 --(2) Descontar el Stock. para eso necesito conocer el IDARTICULO Y LA CANT A DESCONTAR
				 --(3) Realizar el UPDATE CORRESPONDIENTE.
				 UPDATE ARTICULOS SET STOCK = STOCK - @CANTIDAD WHERE IDARTICULO = @IDARTICULO
				 COMMIT TRANSACTION
	     END TRY
		 BEGIN CATCH
		            ROLLBACK TRANSACTION
		 END CATCH
 END--FIN

 --------------------------------------------------------------------------------------------------------------------------------------------------


 -- TRIGGER DE EJEMPLO PARA CUANDO SE DISPARE UN DELETE.


 --TENDRIAMOS TODOS LOS ARTICULOS CON EL ESTADO 1 Y CUANDO SE PRODUZCA UN DELETE, TENDRIAMOS QUE CAMBIARLO A 0.
 -- EN VEZ DE EJECUTAR UN DELETE LO VA A TRANSCRIBIR Y VA A EJECUTAR UN UPDATE.

 --RESUMEN: CUANDO SE HAGA UN DELETE EN LA TABLA ARTICULOS, NO VA A OCURRIR ESE DELETE Y PASE A HACER UN UPDATE DE ESE ARTICULO AL ESTADO 
 --> EN 0
 CREATE TRIGGER TR_BAJALOGICA_ARTICULO ON ARTICULOS
 INSTEAD OF DELETE -- SE LEE: "EN LUGAR DE"/ EN VEZ DE EJECUTAR EL DELETE VA A HACER EL CODIGO DENTRO.
 AS 
 BEGIN 
	BEGIN TRY 
			BEGIN TRANSACTION
			
			SELECT @IDARTICULO = IDARTICULO FROM DELETED --SET @IDARTICULO = (SELECT IDARTICULO FROM DELETED)

			UPDATE ARTICULOS SET ESTADO = 0 WHERE IDARTICULO = @IDARTICULO;



			COMMIT TRANSACTION 
	END TRY

	BEGIN CATCH
	            ROLLBACK TRANSACTION          
	END CATCH


 END

 -------------------------------------------------------------------------------------------------------------------------------------------------
 ------ ATENCION !!!! 
 --- SI NECESITAMOS QUE EL TRIGGER DEJE DE FUNCIONAR POR CIERTO MOMENTO, EN ESTE CASO SERIA SI QUISIERAMOS DARLE UNA BAJA FISICA A ESE ARTICULO
 --- NO HACE FALTA HACER UN DROP DEL TRIGGER 
 DISABLE TRIGGER Nombre_del_Trigger  ON ARTICULOS;
 ENABLE TRIGGER  Nombre_del_Trigger  ON ARTICULOS;


 ----------------------------------------------------------------------------------------------------------------------------------------------------


 --		TRIGGER QUE SE DISPARE CUANDO HACEMOS UNA CONSULTA DE UPDATE !!

 -- EN ESTE CASO SI NUESTO STOCK EN ALGUN MOMNETO LUEGO DEL UPDATE QUEDA POR DE BAJO DEL STOCK MINIMO, ENTONCES QUE AUTOMATICAMENTE, GENERE UNA ORDEN DE PEDIDO.

 -- La Particularidad de los TRIGGERS DE TIPO UPDATE ES QUE CUENTAN CON LAS TABLAS INSERTED Y DELETED, ESTO QUIERE DECIR QUE LOS DATOS NUEVOS QUE VAN A REGISTRARSE
 -- EN NUESTRA TABLA A PARTIR DEL UPDATE ( LOS DATOS QUE SE VAN A INCORPORAR AL REGISTRO VAN A ESTAR EN INSERTED Y LOS DATOS QUE VAN A SER REEMPLAZADO POR ESTE UPDATE 
 --																																SE VAN A ENCONTRAR EN LA TABLA DELETED)
  

  CREATE TRIGGER TR_MODIFICAR_ARTICULO ON ARTICULOS
  AFTER UPDATE
  AS
  BEGIN
		BEGIN TRY
					BEGIN TRANSACTION
					DECLARE @STOCK INT 
					DECLARE @STOCK_MIN INT 
					DECLARE @IDARTICULO BIGINT 

					SELECT @IDARTICULO = IDARTICULO, @STOCK = @STOCK FROM INSERTED
					SELECT @STOCK_MIN = STOCK_MIN FROM ARTICULOS WHERE IDARTICULO = @IDARTICULO

					IF @STOCK < @STOCK_MIN BEGIN
						INSERT INTO  PÉDIDOS (IDARTICULO, CANTIDAD, FECHA)
						VALUES(@IDARTICULO, @STOCK_MIN -@STOCK, GETDATE())

					END

		
	            	COMMIT TRANSACTION
		END TRY
		BEGIN CATCH

		ROLLBACK TRANSACTION 

		END CATCH


  END



  --ENTONCES LO QUE TENEMOS ES LA FUNCIONALIDAD DE QUE AUTOMATICAMENTE GENERE NUESTRA ORNDEN DE PEDIDO EN EL CASO DE QUE EL STOCK SEA MENOR AL STOCK MIN
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
 ---      ACTIVIDAD 3.4  ---- TRIGGERS


 1) Realizar un trigger que al agregar un viaje:
- Verifique que la tarjeta se encuentre activa.
- Verifique que el saldo de la tarjeta sea suficiente para realizar el viaje.
- Registre el viaje
- Registre el movimiento
- Descuente el saldo de la tarjeta








CREATE TRIGGER 
INSTEAD OF INSERT
ON 




















2) Realizar un trigger que al registrar un nuevo usuario:
- Registre el usuario
- Registre una tarjeta a dicho usuario

3) Realizar un trigger que al registrar una nueva tarjeta:
- Le realice baja lógica a la última tarjeta del cliente.
- Le asigne a la nueva tarjeta el saldo de la última tarjeta del cliente.
- Registre la nueva tarjeta para el cliente (con el saldo de la vieja tarjeta, la fecha de alta de la tarjeta deberá ser la del sistema).

4) Realizar un trigger que al eliminar un cliente:
- Elimine el cliente
- Elimine todas las tarjetas del cliente
- Elimine todos los movimientos de sus tarjetas
- Elimine todos los viajes de sus tarjetas






























