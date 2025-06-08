use ort_1c2025_2C;

-- CREACION TABLA PERSONAS
CREATE TABLE Personas (
    id_persona INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    tipo_documento VARCHAR(25) NOT NULL,
    numero_documento NUMERIC(8, 0) NOT NULL,
    email VARCHAR(150),
    fecha_nac DATE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Prospecto', 'Activo', 'Inactivo')),
    CONSTRAINT UQ_Personas_TipoNumeroDocumento UNIQUE (tipo_documento, numero_documento),
    CONSTRAINT CK_Personas_Mayor18Anios CHECK (fecha_nac IS NULL OR fecha_nac <= DATEADD(YEAR, -18, GETDATE()))
);

-- CREACION TABLA TIPO DE SERVICIO
CREATE TABLE TiposServicios (
    id_tipo_servicio INT IDENTITY(1, 1) PRIMARY KEY,
    nombre_tipo_servicio VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO TiposServicios (nombre_tipo_servicio) VALUES ('Telefonía Fija');
INSERT INTO TiposServicios (nombre_tipo_servicio) VALUES ('Internet');
INSERT INTO TiposServicios (nombre_tipo_servicio) VALUES ('VOIP');

-- CREACION TABLA SERVICIOS
CREATE TABLE Servicios (
    id_servicio INT IDENTITY(1, 1) PRIMARY KEY,
    id_persona INT NOT NULL,
    id_tipo_servicio INT NOT NULL,
    telefono VARCHAR(20),
    calle VARCHAR(100) NOT NULL,
    numero NUMERIC(5, 0) NOT NULL,
    piso NUMERIC(2, 0) NOT NULL,
    departamento VARCHAR(10) NOT NULL,
    fecha_inicio DATE NOT NULL DEFAULT GETDATE(),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Activo', 'Inactivo')),
    CONSTRAINT FK_Servicios_Personas FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
    CONSTRAINT FK_Servicios_TipoServicios FOREIGN KEY (id_tipo_servicio) REFERENCES TiposServicios(id_tipo_servicio)
);

-- CREACION TABLA EMPLEADO
CREATE TABLE Empleados (
    id_empleado INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(150) NOT NULL,
    login VARCHAR(50) NOT NULL UNIQUE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Activo', 'Inactivo'))
);

INSERT INTO Empleados(nombre, apellido, login, estado) VALUES ('Maria', 'Perez', 'abcd', 'Activo');

-- CREACION TABLA TIPOLOGIAS
CREATE TABLE Tipologias (
    id_tipologia INT IDENTITY(1, 1) PRIMARY KEY,
    nombre_tipologia VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO Tipologias (nombre_tipologia) VALUES
('Reimpresión de Factura'),
('Servicio Degradado'),
('Cambio de Velocidad'),
('Baja de Servicio'),
('Facturación de Cargos Erróneos'),
('Mudanza de servicio');

-- CREACION TABLA RELACION TIPOLOGIA SERVICIO
CREATE TABLE TipologiaServicio (
    id_tipologia_servicio INT IDENTITY(1, 1) PRIMARY KEY,
    id_tipologia INT NOT NULL,
    id_tipo_servicios INT NOT NULL,
    sla_horas NUMERIC(5, 2) NOT NULL,
    CONSTRAINT FK_SLATipoServ_Tipologia FOREIGN KEY (id_tipologia) REFERENCES Tipologias(id_tipologia),
    CONSTRAINT FK_SLATipoServ_TipoServicio FOREIGN KEY (id_tipo_servicios) REFERENCES TiposServicios(id_tipo_servicio),
    CONSTRAINT UQ_SLATipoServ_Combinacion UNIQUE (id_tipologia, id_tipo_servicios)
);


INSERT INTO TipologiaServicio (id_tipologia, id_tipo_servicios, sla_horas) VALUES
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Reimpresión de Factura'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Internet'), 24.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Reimpresión de Factura'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Telefonía Fija'), 24.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Reimpresión de Factura'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'VOIP'), 24.00),

((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Servicio Degradado'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Internet'), 4.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Servicio Degradado'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Telefonía Fija'), 6.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Servicio Degradado'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'VOIP'), 4.00),

((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Cambio de Velocidad'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Internet'), 48.00),

((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Baja de Servicio'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Internet'), 72.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Baja de Servicio'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Telefonía Fija'), 48.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Baja de Servicio'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'VOIP'), 56.00),

((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Facturación de Cargos Erróneos'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Internet'), 12.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Facturación de Cargos Erróneos'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Telefonía Fija'), 12.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Facturación de Cargos Erróneos'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'VOIP'), 12.00),

((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Mudanza de servicio'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Internet'), 120.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Mudanza de servicio'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'Telefonía Fija'), 72.00),
((SELECT id_tipologia FROM Tipologias WHERE nombre_tipologia = 'Mudanza de servicio'), (SELECT id_tipo_servicio FROM TiposServicios WHERE nombre_tipo_servicio = 'VOIP'), 96.00);

-- CREACION TABLAR TICKET
CREATE TABLE Tickets (
    id_ticket INT IDENTITY(1, 1) PRIMARY KEY,
    id_persona INT NOT NULL,
    id_tipologia INT NOT NULL,
    id_empleado INT,
    id_servicio INT,
    estado VARCHAR(20) NOT NULL DEFAULT 'Abierto' CHECK (estado IN ('Abierto', 'En Progreso', 'Pendiente Cliente', 'Resuelto', 'Cerrado')),
    fecha_abierto DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_resuelto DATETIME NULL,
    fecha_cerrado DATETIME NULL,
    CONSTRAINT FK_Tickets_Personas FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
    CONSTRAINT FK_Tickets_Tipologias FOREIGN KEY (id_tipologia) REFERENCES Tipologias(id_tipologia),
    CONSTRAINT FK_Tickets_Empleados FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

-- CREACION TABLA EMAILS PENDIENTES
CREATE TABLE EmailsPendientes (
    id_email_log INT IDENTITY(1,1) PRIMARY KEY,
    id_ticket INT NOT NULL,
    id_persona INT NOT NULL,
    estado_anterior VARCHAR(20) NOT NULL,
    nuevo_estado VARCHAR(20) NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_EmailsPendientes_Tickets FOREIGN KEY (id_ticket) REFERENCES Tickets(id_ticket),
    CONSTRAINT FK_EmailsPendientes_Personas FOREIGN KEY (id_persona) REFERENCES Personas(id_persona)
);