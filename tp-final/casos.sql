use ort_1c2025_2C;

/*
 CASOS: CREACION DE PERSONAS
 */
EXEC sp_InsertarPersona
    @nombre = 'Mateo',
    @apellido = 'Alonso',
    @tipo_documento = 'DNI',
    @numero_documento = 12345678,
    @email = 'mateo.alonso@example.com',
    @fecha_nac = '1997-08-24';

-- ERROR POR MISMO TIPO Y NUMERO DE DOC
EXEC sp_InsertarPersona
    @nombre = 'Juan',
    @apellido = 'Perez',
    @tipo_documento = 'DNI',
    @numero_documento = 12345678,
    @email = 'juan@example.com',
    @fecha_nac = '1997-10-24';

EXEC sp_InsertarPersona
    @nombre = 'Juan',
    @apellido = 'Perez',
    @tipo_documento = 'DNI',
    @numero_documento = 12245678;

/*
 CASOS: CREACION DE SERVICIOS
 */

EXEC sp_InsertarServicio
    @id_persona = 1,
    @id_tipo_servicio = 1,
    @telefono = '1122334455',
    @calle = 'Sanabria',
    @numero = 3100,
    @piso = 3,
    @departamento = 'C';

-- ERROR NO EXISTE PERSONA
EXEC sp_InsertarServicio
    @id_persona = 8,
    @id_tipo_servicio = 1,
    @telefono = '1122334455',
    @calle = 'Sanabria',
    @numero = 3100,
    @piso = 3,
    @departamento = 'C';

-- ERROR NO EXISTE tipo servicio
EXEC sp_InsertarServicio
    @id_persona = 1,
    @id_tipo_servicio = 8,
    @telefono = '1122334455',
    @calle = 'Sanabria',
    @numero = 3100,
    @piso = 3,
    @departamento = 'C';

-- ERROR NO TIENE TELEFONO
EXEC sp_InsertarServicio
    @id_persona = 5,
    @id_tipo_servicio = 2,
    @telefono = '1122334455',
    @calle = 'Beiro',
    @numero = 2100,
    @piso = 3,
    @departamento = 'C';

/*
 CASOS: Agregar cuando un prospecto no tiene mail y fecha
 */
EXEC sp_agregarMailFechaNacimiento
    @tipo_documento = 'DNI', @numero_documento = 12245678, @nuevo_email = 'jua@mail.com', @nueva_fecha_nac = '1997-08-27'

/*
 CASOS: Poner Inactivo un Servicio.
 */
-- Cliente tiene uno solo
EXEC sp_InactivarServicio
    @id_servicio = 10;

-- Cliente dos servicios, queda como activo el cliente e inactivo el servicio
EXEC sp_InsertarServicio
    @id_persona = 1,
    @id_tipo_servicio = 3,
    @telefono = '1122334455',
    @calle = 'Beiro',
    @numero = 2100,
    @piso = 3,
    @departamento = 'C';

EXEC sp_InactivarServicio
    @id_servicio = 11;