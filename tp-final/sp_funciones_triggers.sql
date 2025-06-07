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