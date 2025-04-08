/* INSTITUTO TERCIARIO ORT*/
/* BASE DE DATOS II*/
/* Clase 2: Ejercicios Restricciones*/
/* Lunes 7/4/2025*/

use ort_1c2025_2C;

/*Ejercicio Constraints
Crear las siguientes tablas y aplicar restricciones según se indica:
• LIBROS (isbn, título, precio, cantidad (not null))
• AUTORES (id_author, email (unique)
• LIBROS_AUTORES (isbn (FK), authored (FK))
Restricciones:
1. Agregar restricción UNIQUE al campo título de la tabla LIBROS;
2. Agregar restricción NOT NULL al campo precio de la tabla LIBROS;
3. Modificar la restricción NOT NULL del campo precio en la tabla LIBROS e incluir una
restricción de tipo CHECK para que el valor sea mayor que 0;
4. Eliminar la restricción UNIQUE del campo email de la tabla AUTORES;
5. Eliminar cualquiera de las restricciones de foreign key;
6. Eliminar la clave primaria (luego que la foreign key referenciada es eliminada);
7. Agregar un atributo en la tabla autores e incluirle una restricción.
*/

-- 1

CREATE TABLE libros (
    isnb NUMERIC(15) PRIMARY KEY,
    titulo VARCHAR(150),
    precio decimal,
    cantidad int not null
);

CREATE TABLE autores (
    id_autor INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(150) UNIQUE
);

CREATE TABLE libros_autores(
    isbn NUMERIC(15),
    id_autor int,
    constraint fk_isbn foreign key (isbn) references libros(isnb),
    constraint fk_id_autor foreign key (id_autor) references autores(id_autor)
);

alter table libros add constraint c_titulo unique(titulo);

-- 2. Agregar restricción NOT NULL al campo precio de la tabla LIBROS
alter table libros alter column precio decimal not null;

-- 3. Modificar la restricción NOT NULL del campo precio en la tabla LIBROS e incluir una
-- restricción de tipo CHECK para que el valor sea mayor que 0;
alter table libros add constraint c_precio check(precio > 0);

-- inserts

INSERT INTO libros (isnb, titulo, precio, cantidad) VALUES (9781234567890, 'El Principito', 25.50, 10);
INSERT INTO libros (isnb, titulo, precio, cantidad) VALUES (9781234567891, 'Cien Años de Soledad', 10.00, 5);
INSERT INTO libros (isnb, titulo, precio, cantidad) VALUES (9781234567892, 'Don Quijote de la Mancha', 30.00, 8);
INSERT INTO libros (isnb, titulo, precio, cantidad) VALUES (9781234567893, 'Rayuela', 28.75, 6);
INSERT INTO libros (isnb, titulo, precio, cantidad) VALUES (9781234567894, 'Ficciones', 35.90, 7);

SELECT isnb, titulo, precio, cantidad from libros;

-- 4. Eliminar la restricción UNIQUE del campo email de la tabla AUTORES;
-- modifico la anterior, redefino la columna
alter table autores alter column email varchar(150);