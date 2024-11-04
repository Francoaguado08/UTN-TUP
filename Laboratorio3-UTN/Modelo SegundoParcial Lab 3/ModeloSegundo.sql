Create Database ModeloExamen20242C
Go
Use ModeloExamen20242C
go
Create Table Materias(
    ID_Materia bigint not null primary key identity (1, 1),
    Nombre varchar(100) not null,
    ID_Carrera int not null,
    HorasSemanales tinyint
)
go
Create Table Docentes(
    Legajo bigint not null primary key identity (1,1),
    Apellidos varchar(100) not null,
    Nombre varchar(100) not null,
    AñoIngreso int 
)
go
Create Table Cargos(
    ID_Cargo tinyint not null primary key,
    Nombre varchar(50)
)
go
Create Table PlantaDocente(
    ID bigint not null primary key identity (1, 1),
    Legajo bigint not null foreign key references Docentes(Legajo),
    ID_Materia bigint not null foreign key references Materias(ID_Materia),
    ID_Cargo tinyint not null foreign key references Cargos(ID_Cargo),
    Año int not null
)
go
-- Datos
Insert into Materias(Nombre, ID_Carrera, HorasSemanales)
Values 
('Matematica', 1, 6),
('Fisica 1', 1, 4),
('Fisica 2', 1, 4),
('Quimica 1', 2, 4),
('Quimica 2', 2, 4),
('Programacion I', 3, 6),
('Programacion II', 3, 6),
('Algoritmos', 3, 8),
('Estadistica', 1, 3),
('Economia', 3, 2),
('Legislacion', 2, 2),
('Sociedad y Estado', 2, 2),
('Bases de Datos I', 3, 4),
('Bases de Datos II', 3, 4)

INSERT INTO Docentes (Apellidos, Nombre, AñoIngreso) VALUES
('Gonzalez', 'Maria', 2010),
('Rodriguez', 'Carlos', 2015),
('Lopez', 'Laura', 2012),
('Martinez', 'Juan', 2017),
('Perez', 'Ana', 2011),
('Gomez', 'Diego', 2014),
('Fernandez', 'Silvia', 2013),
('Sanchez', 'Eduardo', 2016),
('Gimenez', 'Andrea', 2009),
('Rojas', 'Sergio', 2018),
('Acosta', 'Marcela', 2008),
('Romero', 'Hernan', 2019),
('Mendoza', 'Carolina', 2007),
('Suarez', 'Ricardo', 2020),
('Castro', 'Mariana', 2006),
('Ortega', 'Daniel', 2021),
('Silva', 'Florencia', 2005),
('Herrera', 'Gabriel', 2022),
('Torres', 'Valeria', 2004),
('Luna', 'Nicolas', 2023);

Insert into Cargos(ID_Cargo, Nombre)
Values 
(1, 'Profesor'),
(2, 'Jefe de trabajos practicos'),
(3, 'Ayudante de primera'),
(4, 'Ayudante de segunda')

INSERT INTO PlantaDocente (Legajo, ID_Materia, ID_Cargo, Año) VALUES
    (1, 1, 1, 2020),
    (1, 2, 2, 2020),
    (3, 3, 3, 2021),
    (2, 4, 4, 2021),
    (5, 5, 1, 2020),
    (2, 6, 2, 2020),
    (7, 7, 3, 2020),
    (4, 8, 4, 2021),
    (4, 9, 1, 2022),
    (10, 10, 2, 2021),
    (5, 11, 3, 2020),
    (12, 12, 4, 2021),
    (13, 13, 1, 2022),
    (5, 14, 2, 2023),
    (15, 1, 3, 2023),
    (6, 2, 4, 2023),
    (5, 3, 1, 2023),
    (1, 4, 2, 2021),
    (19, 5, 3, 2022),
    (2, 6, 4, 2023);