
CREATE DATABASE Actividad_1_2
GO
USE Actividad_1_2
GO


CREATE TABLE Libros(
ID INT PRIMARY KEY IDENTITY(1,1),
Titulo VARCHAR(50) NOT NULL,
Publicacion INT NOT NULL CHECK(Publicacion > 0),
Categoria VARCHAR(50) NOT NULL
)
GO


CREATE TABLE Autores(
ID INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) NOT NULL,
PaisNacimiento VARCHAR (50) NOT NULL
)
GO


CREATE TABLE Clientes(
ID INT PRIMARY KEY IDENTITY(1,1),
Nombre VARCHAR(50) NOT NULL,
Correo VARCHAR(100) UNIQUE NOT NULL
)
GO
CREATE TABLE Compras(
ID INT PRIMARY KEY IDENTITY(1,1),
IDCliente INT NOT NULL,
IDLibro INT NOT NULL,
FechaAdquisicion DATE NOT NULL,
FOREIGN KEY(IDCliente) REFERENCES Clientes(ID),
FOREIGN KEY(IDLibro) REFERENCES Libros(ID),

)
GO
CREATE TABLE Puntajes(
ID INT IDENTITY(1,1) PRIMARY KEY,
IDCompra INT NOT NULL UNIQUE,
Puntaje INT CHECK (Puntaje BETWEEN 1 AND 10) NULL, --en caso de que no haya terminado de leer el libro.
FOREIGN KEY (IDCompra) REFERENCES Compras(ID)
)
GO
CREATE TABLE Libros_Autores(
IDLibro INT NOT NULL,
IDAutor INT NOT NULL,
PRIMARY KEY (IDLibro,IDAutor),
FOREIGN KEY (IDLibro) REFERENCES Libros(ID),
FOREIGN KEY (IDAutor) REFERENCES Autores(ID)
)
GO



