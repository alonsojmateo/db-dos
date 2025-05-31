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

-- 4) sp_ListarVentasXCliente. A raíz de un cliente y dos fechas enviadas como valores
-- parámetro de rango, devuelve un listado de todas las ventas que se encuentra
-- involucrado esa persona.
CREATE PROCEDURE sp_ListarVentasXCliente
    @dni_cliente VARCHAR(10),
    @fecha_desde DATE,
    @fecha_hasta DATE
AS
BEGIN
SELECT
        V.id_venta AS ID_Venta,
        V.fecha_venta AS FechaVenta,
        C.apellido AS ApellidoCliente,
        C.nombre AS NombreCliente,
        P.nombre AS NombreProducto,
        DV.cantidad AS CantidadVendida,
        P.precio_unit AS PrecioUnitario,
        (DV.cantidad * P.precio_unit) AS SubtotalLinea
    FROM
        VENTAS AS V
    INNER JOIN
        CLIENTES AS C ON V.dni_cliente = C.dni
    INNER JOIN
        DETALLE_VENTAS AS DV ON V.id_venta = DV.id_venta
    INNER JOIN
        PRODUCTOS AS P ON DV.id_producto = P.id_producto
    WHERE
        V.dni_cliente = @dni_cliente
        AND V.fecha_venta BETWEEN @fecha_desde AND @fecha_hasta
    ORDER BY
        V.fecha_venta ASC, V.id_venta ASC, P.nombre ASC;
END


-- EXEC sp_ListarVentasXCliente @dni_cliente = '12345678', @fecha_desde = '2025-05-01', @fecha_hasta = '2025-05-31';