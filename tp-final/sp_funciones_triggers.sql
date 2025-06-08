use ort_1c2025_2C;

-- STORE: Crear una persona prospecto
CREATE PROCEDURE sp_InsertarPersona
    @nombre varchar(100),
    @apellido varchar(150),
    @tipo_documento VARCHAR(25),
    @numero_documento NUMERIC(8, 0),
    @email VARCHAR(150) = NULL,
    @fecha_nac DATE = NULL
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ErrorMessage VARCHAR(4000)
    BEGIN TRY
        INSERT INTO Personas (nombre, apellido, tipo_documento, numero_documento, email, fecha_nac, estado)
        VALUES (@nombre, @apellido, @tipo_documento, @numero_documento, @email, @fecha_nac, 'Prospecto');
        PRINT 'Persona Creada.'
    END TRY
    BEGIN CATCH
        SELECT
            ERROR_NUMBER() AS ErrorNumber
            ,ERROR_MESSAGE() AS ErrorMessage;
        return ERROR_MESSAGE()
    END CATCH
END

-- STORE: Creacion de nuevo servicio
-- Se agrega a una persona, en caso de no ser cliente, lo convierte en uno
CREATE PROCEDURE sp_InsertarServicio
    @id_persona INT,
    @id_tipo_servicio INT,
    @telefono VARCHAR(20) = NULL,
    @calle VARCHAR(100),
    @numero NUMERIC(5, 0),
    @piso NUMERIC(2, 0),
    @departamento VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PersonaEstadoActual VARCHAR(20);
    DECLARE @NombreTipoServicio VARCHAR(50);
    DECLARE @PersonaEmail VARCHAR(150);
    DECLARE @PersonaFechaNac DATE;

    BEGIN TRY
        BEGIN TRANSACTION
            SELECT @PersonaEstadoActual = estado,
                   @PersonaEmail = email,
                   @PersonaFechaNac = fecha_nac FROM Personas
            WHERE id_persona = @id_persona;

            SELECT @NombreTipoServicio = nombre_tipo_servicio FROM TiposServicios
            WHERE id_tipo_servicio = @id_tipo_servicio;

            IF (@NombreTipoServicio = 'Telefonía Fija' OR @NombreTipoServicio = 'VOIP') AND @telefono IS NULL
            BEGIN
                RAISERROR('Error: Para el tipo de servicio "%s", el teléfono es obligatorio.', 16, @NombreTipoServicio);
            END

            IF (@PersonaEstadoActual = 'Prospecto') AND (@PersonaEmail IS NULL OR @PersonaFechaNac IS NULL)
            BEGIN
                RAISERROR('Error: la persona "%s" debe tener email y fecha de nacimiento. Completarlas primero.', 16, @id_persona);
            end

            INSERT INTO Servicios (id_persona, id_tipo_servicio, telefono, calle,
                                   numero, piso, departamento, fecha_inicio, estado)
            VALUES (@id_persona, @id_tipo_servicio, @telefono, @calle,
                    @numero, @piso, @departamento, GETDATE(), 'Activo');

            IF @PersonaEstadoActual = 'Prospecto' OR @PersonaEstadoActual = 'Inactivo'
            BEGIN
                UPDATE Personas
                SET estado = 'Activo'
                WHERE id_persona = @id_persona;
            END

            COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT
            ERROR_NUMBER() AS ErrorNumber
            ,ERROR_MESSAGE() AS ErrorMessage;
        return ERROR_MESSAGE()
    END CATCH
END;

CREATE PROCEDURE sp_agregarMailFechaNacimiento
    @tipo_documento VARCHAR(25),
    @numero_documento NUMERIC(8, 0),
    @nuevo_email VARCHAR(150) = NULL,
    @nueva_fecha_nac DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Personas
    SET
        email = ISNULL(@nuevo_email, email),
        fecha_nac = ISNULL(@nueva_fecha_nac, fecha_nac)
    WHERE tipo_documento = @tipo_documento
      AND numero_documento = @numero_documento;
END;

CREATE PROCEDURE sp_InactivarServicio
    @id_servicio INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IdPersona INT;
    DECLARE @CantServiciosActivos INT;

    BEGIN TRY
        SELECT @IdPersona = id_persona FROM Servicios
        where id_servicio = @id_servicio
        AND estado = 'Activo';


        select @CantServiciosActivos = count(*) FROM Servicios
        where id_persona = @IdPersona;

        BEGIN TRANSACTION;
            UPDATE Servicios
                SET estado = 'Inactivo'
            WHERE id_servicio = @id_servicio;

            IF(@CantServiciosActivos = 1)
            BEGIN
                UPDATE Personas
                    SET estado = 'Inactivo'
                WHERE id_persona = @IdPersona
            END
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT
            ERROR_NUMBER() AS ErrorNumber
            ,ERROR_MESSAGE() AS ErrorMessage;
        return ERROR_MESSAGE()
    END CATCH
END

-- STORE: Crear Ticket
-- Tengo que pasar datos persona, id_empleado, id_tipologia, id_servicio ya existentes
CREATE PROCEDURE sp_CrearTicket
    @tipo_documento VARCHAR(25),
    @numero_documento NUMERIC(8, 0),
    @id_tipologia INT,
    @id_servicio INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @IdPersona INT;
    BEGIN TRY
        SELECT @IdPersona = id_persona from Personas
        WHERE numero_documento = @numero_documento AND tipo_documento = @tipo_documento;

        INSERT INTO Tickets (id_persona, id_servicio, id_tipologia)
        VALUES (@IdPersona, @id_servicio, @id_tipologia);
    END TRY
    begin catch
        SELECT
            ERROR_NUMBER() AS ErrorNumber
            ,ERROR_MESSAGE() AS ErrorMessage;
        return ERROR_MESSAGE()
    end catch
end

CREATE PROCEDURE sp_AsignarTicket
    @id_ticket INT,
    @id_empleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
            UPDATE Tickets SET id_empleado = id_empleado WHERE id_ticket = @id_ticket;

        COMMIT;
    END TRY
    begin catch
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SELECT
            ERROR_NUMBER() AS ErrorNumber
            ,ERROR_MESSAGE() AS ErrorMessage;
        return ERROR_MESSAGE()
    end catch
end

CREATE PROCEDURE sp_ActualizarEstadoTicket
    @id_ticket INT,
    @estado_nuevo VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @estado_actual VARCHAR(20);

    BEGIN TRY
        SELECT @estado_actual = estado FROM Tickets WHERE id_ticket = @id_ticket;
        IF @estado_actual IS NULL
        BEGIN
            RAISERROR('Error: no se encontro ticket "%s"', 16, @id_ticket);
        END

        IF fn_SePuedeCambiarEstado (@estado_actual, @estado_nuevo) = 0
        BEGIN
            RAISERROR('Error: Transición de estado inválida de "%s" a "%s" para el ticket %d. O el nuevo estado no es válido.', 16, 1, @estado_actual, @estado_nuevo, @id_ticket);
        END

        IF @estado_nuevo = 'Resuelto'
        BEGIN
            UPDATE Tickets SET estado = @estado_nuevo AND fecha_resuelto = GETDATE() WHERE id_ticket = @id_ticket;
        end
        ELSE IF @estado_nuevo = 'Cerrado'
        BEGIN
            UPDATE Tickets SET estado = @estado_nuevo AND fecha_cerrado = GETDATE() WHERE id_ticket = @id_ticket;
        end
        ELSE
        BEGIN
            UPDATE Tickets SET estado = @estado_nuevo WHERE id_ticket = @id_ticket;
        END
    END TRY
    begin catch
        SELECT
            ERROR_NUMBER() AS ErrorNumber
            ,ERROR_MESSAGE() AS ErrorMessage;
        return ERROR_MESSAGE()
    end catch

end

CREATE FUNCTION fn_SePuedeCambiarEstado
(
    @estado_actual VARCHAR(20),
    @estado_nuevo VARCHAR(20)
)
RETURNS BIT
AS
BEGIN
    DECLARE @es_valida BIT = 0;

    IF @estado_actual = 'Abierto' AND @estado_nuevo = 'En Progreso'
    BEGIN
        SET @es_valida = 1;
    end

    IF @estado_actual = 'En Progreso' AND @estado_nuevo IN ('Pendiente Cliente', 'Resuelto')
    BEGIN
        SET @es_valida = 1;
    end

    IF @estado_actual IN ('Pendiente Cliente', 'Resuelto') AND @estado_nuevo = 'En Progreso'
    BEGIN
        SET @es_valida = 1;
    end

    IF @estado_actual = 'Resuelto' AND @estado_nuevo = 'Cerrado'
    BEGIN
        SET @es_valida = 1;
    end

    RETURN @es_valida;
END;

CREATE TRIGGER trigger_emails
ON Tickets
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_ticket_nuevo INT;
    DECLARE @id_persona_nuevo INT;
    DECLARE @nuevo_estado_val VARCHAR(20);
    DECLARE @estado_anterior_val VARCHAR(20);

    IF UPDATE(estado)
    BEGIN
        SELECT
            @id_ticket_nuevo = id_ticket,
            @id_persona_nuevo = id_persona,
            @nuevo_estado_val = estado
        FROM
            inserted;

        SELECT
            @estado_anterior_val = estado
        FROM
            deleted;
        INSERT INTO EmailsPendientes (id_ticket, id_persona, estado_anterior, nuevo_estado, fecha_registro)
        VALUES (@id_ticket_nuevo, @id_persona_nuevo, @estado_anterior_val, @nuevo_estado_val, GETDATE());
    END
END;