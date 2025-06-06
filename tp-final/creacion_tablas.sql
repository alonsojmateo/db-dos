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

-- CREACION TABLA TIPOLOGIAS
CREATE TABLE Tipologias (
    id_tipologia INT IDENTITY(1, 1) PRIMARY KEY,
    nombre_tipologia VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(250)
);

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

-- CREACION TABLAR TICKET
CREATE TABLE Tickets (
    id_ticket INT IDENTITY(1, 1) PRIMARY KEY,
    id_persona INT NOT NULL,
    id_tipologia INT NOT NULL,
    id_empleado INT NOT NULL,
    id_servicio INT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'Abierto' CHECK (estado IN ('Abierto', 'En Progreso', 'Pendiente Cliente', 'Resuelto', 'Cerrado')),
    fecha_abierto DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_resuelto DATETIME NULL,
    fecha_cerrado DATETIME NULL,
    CONSTRAINT FK_Tickets_Personas FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
    CONSTRAINT FK_Tickets_Tipologias FOREIGN KEY (id_tipologia) REFERENCES Tipologias(id_tipologia),
    CONSTRAINT FK_Tickets_Empleados FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);