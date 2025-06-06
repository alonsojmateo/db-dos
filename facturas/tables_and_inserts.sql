-- CREACION DE TABLAS:
USE ort_1c2025_2C;

CREATE TABLE PRODUCTOS (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_imp VARCHAR(50) NOT NULL,
    precio_unit NUMERIC(10, 2) NOT NULL,
    stock INT NOT NULL,
    CHECK (stock >= 5)
)

CREATE TABLE CLIENTES (
    dni VARCHAR(10) PRIMARY KEY,
    apellido VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_nac DATE NOT NULL,
    mail VARCHAR(100) UNIQUE
)

CREATE TABLE TELEFONOS (
    id_telefono INT IDENTITY(1,1) PRIMARY KEY,
    dni_cliente VARCHAR(10) NOT NULL,
    numero_telefono VARCHAR(20) NOT NULL,
    FOREIGN KEY (dni_cliente) REFERENCES Clientes(dni)
);

CREATE TABLE VENTAS (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    dni_cliente VARCHAR(10) NOT NULL,
    FOREIGN KEY (dni_cliente) REFERENCES CLIENTES(dni)
);

CREATE TABLE DETALLE_VENTAS (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad NUMERIC(5) NOT NULL CHECK (cantidad > 0),
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

-- INSERT PRODUCTOS
INSERT INTO PRODUCTOS (nombre, pais_imp, precio_unit, stock) VALUES ( 'Acetona', 'Argentina', 15000.00, 10);
INSERT INTO PRODUCTOS (nombre, pais_imp, precio_unit, stock) VALUES ( 'Alcohol', 'Chile', 35000.00, 5);
INSERT INTO PRODUCTOS (nombre, pais_imp, precio_unit, stock) VALUES ( 'Solvente', 'China', 8000.00, 12);
INSERT INTO PRODUCTOS (nombre, pais_imp, precio_unit, stock) VALUES ( 'Acido', 'Estados Unidos', 28000.00, 6);
INSERT INTO PRODUCTOS (nombre, pais_imp, precio_unit, stock) VALUES ( 'Cloruro', 'Alemania', 25000.00, 8);

-- INSERT CLIENTES
INSERT INTO CLIENTES (dni, apellido, nombre, fecha_nac, mail) VALUES ('12345678', 'Gomez', 'Ana', '1985-03-15', 'ana.gomez@example.com');
INSERT INTO CLIENTES (dni, apellido, nombre, fecha_nac, mail) VALUES ('87654321', 'Rodriguez', 'Juan', '1990-07-20', 'juan.r@example.com');
INSERT INTO CLIENTES (dni, apellido, nombre, fecha_nac, mail) VALUES ('23456789', 'Fernandez', 'Maria', '1978-11-10', 'maria.f@example.com');
INSERT INTO CLIENTES (dni, apellido, nombre, fecha_nac, mail) VALUES ('98765432', 'Lopez', 'Carlos', '1995-01-05', NULL); -- Cliente sin mail
INSERT INTO CLIENTES (dni, apellido, nombre, fecha_nac, mail) VALUES ('34567890', 'Sanchez', 'Laura', '1982-09-25', 'laura.s@example.com');

-- INSERT TELEFONOS
INSERT INTO TELEFONOS (dni_cliente, numero_telefono) VALUES ('12345678', '1122334455');
INSERT INTO TELEFONOS (dni_cliente, numero_telefono) VALUES ('12345678', '1166778899');
INSERT INTO TELEFONOS (dni_cliente, numero_telefono) VALUES ('87654321', '1155443322');
INSERT INTO TELEFONOS (dni_cliente, numero_telefono) VALUES ('23456789', '1199887766');
INSERT INTO TELEFONOS (dni_cliente, numero_telefono) VALUES ('34567890', '1111223344');
INSERT INTO TELEFONOS (dni_cliente, numero_telefono) VALUES ('87654321', '1133221100');

-- INSERT VENTAS
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-20', '12345678');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-21', '87654321');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-22', '12345678');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-23', '23456789');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-24', '34567890');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-25', '87654321');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-26', '12345678');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-27', '23456789');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-28', '34567890');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-29', '98765432');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-30', '12345678');
INSERT INTO VENTAS (fecha_venta, dni_cliente) VALUES ('2025-05-30', '87654321');

-- INSERT DETALLE_VENTAS
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (1, 1, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (1, 3, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (2, 2, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (2, 4, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (3, 1, 3);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (3, 2, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (4, 3, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (4, 4, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (5, 1, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (5, 2, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (6, 5, 3);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (6, 1, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (7, 2, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (7, 4, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (8, 3, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (8, 5, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (9, 1, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (9, 3, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (10, 2, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (10, 4, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (11, 1, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (11, 5, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (12, 2, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (12, 3, 2);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (1, 5, 1);
INSERT INTO DETALLE_VENTAS (id_venta, id_producto, cantidad) VALUES (2, 3, 1);
