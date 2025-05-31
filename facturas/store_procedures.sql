USE ort_1c2025_2C;

-- 1) sp_InsertarProducto. Recibe como parámetro los datos del producto y los
-- almacena en la base de datos
CREATE PROCEDURE sp_InsertarProducto
    @product_name varchar(100),
    @pais_imp varchar(50),
    @precio_unit numeric(10, 2),
    @stock int
AS
BEGIN
    BEGIN TRY
        SET IDENTITY_INSERT PRODUCTOS OFF
        insert into PRODUCTOS (nombre, pais_imp, precio_unit, stock) values (@product_name, @pais_imp, @precio_unit, @stock)
        select convert(INT,@@IDENTITY) as retorno
    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar producto.';
    END CATCH
END
GO

-- exec sp_InsertarProducto @product_name = 'Hidrogeno', @pais_imp = 'Canada', @precio_unit = 3000, @stock = 7

SELECT * FROM CLIENTES;

-- 2) sp_InsertarCliente. Recibe como parámetro los datos del cliente y los guarda. Si
-- existiera un teléfono, debe registrarlo también en la tabla de teléfonos
CREATE PROCEDURE sp_InsertarCliente
    @dni varchar(10),
    @apellido varchar(100),
    @nombre varchar(100),
    @fecha_nac date,
    @mail varchar(100)
AS
BEGIN
    BEGIN TRY
        insert into CLIENTES (dni, apellido, nombre, fecha_nac, mail)
        values (@dni, @apellido, @nombre, @fecha_nac, @mail)
        select convert(INT,@@IDENTITY) as retorno
    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar cliente.';
    END CATCH
END
GO

-- EXEC sp_InsertarCliente @dni = '40123456', @apellido = 'Perez', @nombre = 'Roberto', @fecha_nac = '1992-04-20', @mail = 'roberto.perez@example.com';

-- 3) sp_VerificarStock. Recibe como parámetro un producto (el ID) y retorna el stock del
-- mismo.
CREATE PROCEDURE sp_VerificarStock
    @id_producto INT
AS
BEGIN
    DECLARE @stock_actual INT;
    BEGIN TRY
        SELECT @stock_actual = stock
        FROM PRODUCTOS
        WHERE id_producto = @id_producto;
        SELECT @stock_actual AS retorno_stock;
    END TRY
    BEGIN CATCH
        PRINT 'Error al obtener stock de producto.';
    end catch
end

-- EXEC sp_VerificarStock @id_producto = 2;