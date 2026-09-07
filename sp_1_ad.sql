--- SITIO A
-- CREAR MI LINKED SERVER

IF NOT EXISTS (SELECT 1 FROM sys.servers WHERE name = 'SitioB')
BEGIN
    EXEC sp_addlinkedserver
    @server = 'SitioB',
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = 'SitioB,1433',
    @provstr = N'encrypt=yes;trustservercertificate=yes'

    EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'SitioB',
    @useself = 'false',
    @rmtuser = 'sa',
    @rmtpassword = 'Adrian2026!Secure'
END

select * from SitioB.MEDICITY_B.dbo.DIAGNOSTICO_B;
select * from SitioB.MEDICITY_B.dbo.DOCTOR_B;
select * from SitioB.MEDICITY_B.dbo.ESPECIALIDAD_B;

-- BASE CENTRALIZADA LLENAR LOS DATOS
USE MEDICITY
SELECT * FROM CIUDAD
INSERT INTO CIUDAD VALUES
('QUITO'),
('AMBATO')

SELECT * FROM PACIENTE
INSERT INTO PACIENTE VALUES
('PACIENTE 1', '1995-01-02 10:00:00', 'CENTRO', 1),
('PACIENTE 2', '1955-11-02 10:00:00', 'NORTE', 2)

SELECT * FROM ESPECIALIDAD
INSERT INTO ESPECIALIDAD VALUES
('ESPECIALIDAD 1'),
('ESPECIALIDAD 2')

SELECT * FROM DOCTOR
INSERT INTO DOCTOR
VALUES ('JUAN',1,1),('ANA',2,2)


SELECT * FROM CITA_MEDICA
INSERT INTO CITA_MEDICA (ID_PACIENTE,ID_DOCTOR,FECHAHORA)
VALUES (1,2,GETDATE()),(2,1, GETDATE() + DAY(5))

SELECT GETDATE() + DAY(5)

SELECT * FROM DIAGNOSTICO
INSERT INTO DIAGNOSTICO (ID_CITA, NOMBRE, DESCRIPCION, TRATAMIENTO)
VALUES (1,'CITA_1','PACIENTE JOVEN','REPOSO')


SELECT P.NOMBRE PACIENTE, P.FECHA_NACIMIENTO,
P.DIRECCION, C.NOMBRE CIUDAD_PACIENTE, D.NOMBRE DOCTOR, E.NOMBRE ESPECIALIDAD,
CM.FECHAHORA,
COALESCE(DI.DESCRIPCION,'S/I') DESCRIPCION, COALESCE(DI.TRATAMIENTO,'S/I') TRATAMIENTO
FROM CITA_MEDICA CM
INNER JOIN PACIENTE P ON P.ID = CM.ID_PACIENTE
INNER JOIN DOCTOR D ON D.ID = CM.ID_DOCTOR
INNER JOIN CIUDAD C ON C.ID = P.ID_CIUDAD
INNER JOIN ESPECIALIDAD E ON E.ID = D.ID_ESPECIALIDAD
LEFT JOIN DIAGNOSTICO DI ON DI.ID_CITA = CM.ID


-- MIGRAR DATOS A SITIO A
SELECT * FROM MEDICITY_A.DBO.CIUDAD_A

INSERT INTO MEDICITY_A.DBO.CIUDAD_A (NOMBRE)
SELECT NOMBRE FROM MEDICITY.DBO.CIUDAD --CENTRALIZADO

SELECT * FROM MEDICITY_A.DBO.PACIENTE_A

INSERT INTO MEDICITY_A.DBO.PACIENTE_A (NOMBRE, FECHA_NACIMIENTO,DIRECCION,ID_CIUDAD)
SELECT NOMBRE, FECHA_NACIMIENTO,DIRECCION,ID_CIUDAD FROM MEDICITY.DBO.PACIENTE --CENTRALIZADO

SELECT * FROM MEDICITY_A.DBO.CITA_MEDICA_A

INSERT INTO MEDICITY_A.DBO.CITA_MEDICA_A (ID_PACIENTE, ID_DOCTOR,FECHAHORA)
SELECT ID_PACIENTE, ID_DOCTOR,FECHAHORA FROM MEDICITY.DBO.CITA_MEDICA --CENTRALIZADO

-- MIGRAR INFORMACION DESDE SITIO A AL SITIO B
SELECT * FROM SitioB.MEDICITY_B.DBO.ESPECIALIDAD_B

INSERT INTO SitioB.MEDICITY_B.DBO.ESPECIALIDAD_B (NOMBRE)
SELECT NOMBRE FROM MEDICITY.DBO.ESPECIALIDAD --CENTRALIZADO


SELECT * FROM SitioB.MEDICITY_B.DBO.DOCTOR_B

INSERT INTO SitioB.MEDICITY_B.DBO.DOCTOR_B (NOMBRE, ID_ESPECIALIDAD, ID_CIUDAD)
SELECT NOMBRE, ID_ESPECIALIDAD, ID_CIUDAD FROM MEDICITY.DBO.DOCTOR --CENTRALIZADO


SELECT * FROM SitioB.MEDICITY_B.DBO.DIAGNOSTICO_B

INSERT INTO SitioB.MEDICITY_B.DBO.DIAGNOSTICO_B (ID_CITA,NOMBRE, DESCRIPCION, TRATAMIENTO)
SELECT ID_CITA,NOMBRE, DESCRIPCION, TRATAMIENTO FROM MEDICITY.DBO.DIAGNOSTICO --CENTRALIZADO

USE MEDICITY_A
GO

-- Vista: consulta general de citas
CREATE OR ALTER VIEW consulta_general AS
SELECT
    ROW_NUMBER() OVER (ORDER BY CM.FECHAHORA) AS num,
    CM.ID AS id_cita,
    CM.ID_PACIENTE AS id_paciente,
    P.NOMBRE AS paciente,
    P.FECHA_NACIMIENTO AS fecha_nacimiento,
    P.DIRECCION AS direccion,
    P.ID_CIUDAD AS id_ciudad_paciente,
    C.NOMBRE AS ciudad_paciente,
    CM.ID_DOCTOR AS id_doctor,
    D.NOMBRE AS doctor,
    D.ID_CIUDAD AS id_ciudad_doctor,
    CD.NOMBRE AS ciudad_doctor,
    D.ID_ESPECIALIDAD AS id_especialidad,
    E.NOMBRE AS especialidad,
    CM.FECHAHORA AS fechahora,
    DI.ID AS id_diagnostico,
    COALESCE(DI.NOMBRE, 'S/I') AS nombre_diagnostico,
    COALESCE(DI.DESCRIPCION, 'S/I') AS descripcion,
    COALESCE(DI.TRATAMIENTO, 'S/I') AS tratamiento
FROM MEDICITY_A.dbo.CITA_MEDICA_A CM
INNER JOIN MEDICITY_A.dbo.PACIENTE_A P ON P.ID = CM.ID_PACIENTE
INNER JOIN SitioB.MEDICITY_B.dbo.DOCTOR_B D ON D.ID = CM.ID_DOCTOR
INNER JOIN MEDICITY_A.dbo.CIUDAD_A C ON C.ID = P.ID_CIUDAD
INNER JOIN MEDICITY_A.dbo.CIUDAD_A CD ON CD.ID = D.ID_CIUDAD
INNER JOIN SitioB.MEDICITY_B.dbo.ESPECIALIDAD_B E ON E.ID = D.ID_ESPECIALIDAD
LEFT JOIN SitioB.MEDICITY_B.dbo.DIAGNOSTICO_B DI ON DI.ID_CITA = CM.ID;
GO

select * from consulta_general
GO

-- SP: insertar doctor (create)
CREATE OR ALTER PROCEDURE sp_InsertarDoctor
    @NOMBRE VARCHAR(200),
    @ID_ESPECIALIDAD INT,
    @ID_CIUDAD INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista la ciudad local
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CIUDAD_A
        WHERE ID = @ID_CIUDAD
    )
    BEGIN
        RAISERROR('La ciudad ingresada no existe.', 16, 1);
        RETURN;
    END;

    -- Validar que exista la especialidad en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [SitioB].[MEDICITY_B].[dbo].[ESPECIALIDAD_B]
        WHERE ID = @ID_ESPECIALIDAD
    )
    BEGIN
        RAISERROR('La especialidad ingresada no existe.', 16, 1);
        RETURN;
    END;

    INSERT INTO [SitioB].[MEDICITY_B].[dbo].[DOCTOR_B] (
        NOMBRE,
        ID_ESPECIALIDAD,
        ID_CIUDAD
    )
    VALUES
    (
        @NOMBRE,
        @ID_ESPECIALIDAD,
        @ID_CIUDAD
    );

    SELECT
        'Doctor registrado correctamente' AS MENSAJE;
END;
GO

EXEC sp_InsertarDoctor 'LUIS', 1,1

select * from [SitioB].[MEDICITY_B].[dbo].[DOCTOR_B]
GO

-- SP: actualizar cita médica (update)
CREATE OR ALTER PROCEDURE sp_ActualizarCitaMedica
    @ID INT,
    @ID_PACIENTE INT,
    @ID_DOCTOR INT,
    @FECHAHORA DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista la cita
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CITA_MEDICA_A
        WHERE ID = @ID
    )
    BEGIN
        RAISERROR('La cita médica no existe.', 16, 1);
        RETURN;
    END;

    -- Validar fecha
    IF @FECHAHORA < GETDATE()
    BEGIN
        RAISERROR(
            'La fecha y hora de la cita no puede ser anterior a la fecha actual.',
            16,
            1
        );
        RETURN;
    END;

    -- Validar paciente en Sitio A
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[PACIENTE_A]
        WHERE ID = @ID_PACIENTE
    )
    BEGIN
        RAISERROR('El paciente ingresado no existe.', 16, 1);
        RETURN;
    END;

    -- Validar doctor en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [SitioB].[MEDICITY_B].[dbo].[DOCTOR_B]
        WHERE ID = @ID_DOCTOR
    )
    BEGIN
        RAISERROR('El doctor ingresado no existe.', 16, 1);
        RETURN;
    END;

    -- Actualizar
    UPDATE dbo.CITA_MEDICA_A
    SET
        ID_PACIENTE = @ID_PACIENTE,
        ID_DOCTOR = @ID_DOCTOR,
        FECHAHORA = @FECHAHORA
    WHERE ID = @ID;
END;
GO

SELECT * FROM CITA_MEDICA_A
exec sp_ActualizarCitaMedica 1,2,2,'2026-09-12 10:00:00'
GO

-- Vista: doctores
CREATE OR ALTER VIEW vista_doctores AS
SELECT
    D.ID,
    D.NOMBRE AS DOCTOR,
    D.ID_ESPECIALIDAD,
    E.NOMBRE AS ESPECIALIDAD,
    D.ID_CIUDAD,
    C.NOMBRE AS CIUDAD
FROM [SitioB].[MEDICITY_B].[dbo].[DOCTOR_B] D
INNER JOIN [SitioB].[MEDICITY_B].[dbo].[ESPECIALIDAD_B] E ON E.ID = D.ID_ESPECIALIDAD
INNER JOIN dbo.CIUDAD_A C ON C.ID = D.ID_CIUDAD;
GO

SELECT * FROM vista_doctores
GO

-- SP: insertar diagnóstico (create)
CREATE OR ALTER PROCEDURE sp_InsertarDiagnostico
    @ID_CITA INT,
    @NOMBRE VARCHAR(50),
    @DESCRIPCION VARCHAR(200),
    @TRATAMIENTO VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista la cita en Sitio A
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CITA_MEDICA_A
        WHERE ID = @ID_CITA
    )
    BEGIN
        RAISERROR('La cita médica ingresada no existe.', 16, 1);
        RETURN;
    END;

    INSERT INTO [SitioB].[MEDICITY_B].[dbo].[DIAGNOSTICO_B] (
        ID_CITA,
        NOMBRE,
        DESCRIPCION,
        TRATAMIENTO
    )
    VALUES
    (
        @ID_CITA,
        @NOMBRE,
        @DESCRIPCION,
        @TRATAMIENTO
    );

    SELECT
        'Diagnóstico registrado correctamente' AS MENSAJE;
END;
GO

EXEC sp_InsertarDiagnostico 1, 'CONTROL', 'PACIENTE ESTABLE', 'CONTINUAR TRATAMIENTO'

select * from [SitioB].[MEDICITY_B].[dbo].[DIAGNOSTICO_B]
GO

-- SP: actualizar doctor (update)
CREATE OR ALTER PROCEDURE sp_ActualizarDoctor
    @ID INT,
    @NOMBRE VARCHAR(200),
    @ID_ESPECIALIDAD INT,
    @ID_CIUDAD INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que exista el doctor en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [SitioB].[MEDICITY_B].[dbo].[DOCTOR_B]
        WHERE ID = @ID
    )
    BEGIN
        RAISERROR('El doctor ingresado no existe.', 16, 1);
        RETURN;
    END;

    -- Validar que exista la ciudad en Sitio A
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.CIUDAD_A
        WHERE ID = @ID_CIUDAD
    )
    BEGIN
        RAISERROR('La ciudad ingresada no existe.', 16, 1);
        RETURN;
    END;

    -- Validar que exista la especialidad en Sitio B
    IF NOT EXISTS (
        SELECT 1
        FROM [SitioB].[MEDICITY_B].[dbo].[ESPECIALIDAD_B]
        WHERE ID = @ID_ESPECIALIDAD
    )
    BEGIN
        RAISERROR('La especialidad ingresada no existe.', 16, 1);
        RETURN;
    END;

    UPDATE [SitioB].[MEDICITY_B].[dbo].[DOCTOR_B]
    SET
        NOMBRE = @NOMBRE,
        ID_ESPECIALIDAD = @ID_ESPECIALIDAD,
        ID_CIUDAD = @ID_CIUDAD
    WHERE ID = @ID;

    SELECT
        'Doctor actualizado correctamente' AS MENSAJE;
END;
GO

EXEC sp_ActualizarDoctor 1, 'JUAN CARLOS', 1, 1

select * from [SitioB].[MEDICITY_B].[dbo].[DOCTOR_B]
GO

-- Vista: diagnósticos
CREATE OR ALTER VIEW vista_diagnosticos AS
SELECT
    DI.ID,
    DI.ID_CITA,
    DI.NOMBRE AS DIAGNOSTICO,
    DI.DESCRIPCION,
    DI.TRATAMIENTO,
    CM.ID_PACIENTE,
    P.NOMBRE AS PACIENTE,
    CM.FECHAHORA
FROM [SitioB].[MEDICITY_B].[dbo].[DIAGNOSTICO_B] DI
INNER JOIN dbo.CITA_MEDICA_A CM ON CM.ID = DI.ID_CITA
INNER JOIN dbo.PACIENTE_A P ON P.ID = CM.ID_PACIENTE;
GO

SELECT * FROM vista_diagnosticos
GO

-- Vista: pacientes
CREATE OR ALTER VIEW vista_pacientes AS
SELECT
    P.ID,
    P.NOMBRE,
    P.FECHA_NACIMIENTO,
    P.DIRECCION,
    P.ID_CIUDAD,
    C.NOMBRE AS CIUDAD
FROM dbo.PACIENTE_A P
INNER JOIN dbo.CIUDAD_A C ON C.ID = P.ID_CIUDAD;
GO

-- Vista: citas médicas
CREATE OR ALTER VIEW vista_citas AS
SELECT
    CM.ID,
    CM.ID_PACIENTE,
    P.NOMBRE AS PACIENTE,
    CM.ID_DOCTOR,
    D.NOMBRE AS DOCTOR,
    CM.FECHAHORA
FROM dbo.CITA_MEDICA_A CM
INNER JOIN dbo.PACIENTE_A P ON P.ID = CM.ID_PACIENTE
INNER JOIN SitioB.MEDICITY_B.dbo.DOCTOR_B D ON D.ID = CM.ID_DOCTOR;
GO

SELECT * FROM vista_pacientes
SELECT * FROM vista_citas
