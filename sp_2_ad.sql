--- SITIO B
-- CREAR MI LINKED SERVER

IF NOT EXISTS (SELECT 1 FROM sys.servers WHERE name = 'SitioA')
BEGIN
    EXEC sp_addlinkedserver
    @server = 'SitioA',
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = 'SitioA,1433',
    @provstr = N'encrypt=yes;trustservercertificate=yes'

    EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'SitioA',
    @useself = 'false',
    @rmtuser = 'sa',
    @rmtpassword = 'Adrian2026!Secure'
END

SELECT * FROM SitioA.MEDICITY_A.DBO.CIUDAD_A
SELECT * FROM SitioA.MEDICITY_A.DBO.PACIENTE_A
SELECT * FROM SitioA.MEDICITY_A.DBO.CITA_MEDICA_A
