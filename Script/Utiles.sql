-- CALCULAR EL PRIMER DIA DEL MES
declare
    @w_f_primerdia	varchar(10), --> varchar por el print, sino datetime
    @i_fecha_inf	datetime

select @i_fecha_inf = '10/31/2022'

select @w_f_primerdia = convert(varchar(10),dateadd(dd,- datepart(dd, @i_fecha_inf) + 1 , @i_fecha_inf ),101)

print @w_f_primerdia

---------------------------------------------------------------------------------------
--SQR-Quitar las barras de fecha y poner ddmmaaaa

select str_replace (convert(varchar(10),im_f_hasta,103), '/', null)

---------------------------------------------------------------------------------------
--CALCULO EL PRIMER DIA DEL AÑO DESDE LA FECHA DE INFORMACION

--SELECT @w_f_inicio = CAST(CAST(YEAR(convert(char(10),@w_fecha_inf,101)) AS varchar(4)) + '0101' AS datetime)

select @w_f_inicio = cast(cast(year(@w_fecha_inf) as varchar(4)) + '0101' as datetime)

---------------------------------------------------------------------------------------

/*Para leer un archivo CSV en SQL Server y luego volcarlo a una nueva tabla,
 puedes usar el operador BULK INSERT o la función OPENROWSET. Aquí tienes un ejemplo utilizando BULK INSERT:

Supongamos que tienes un archivo CSV llamado datos.csv con los siguientes datos:*/

Fecha,Importe,Razon_Social,CUIT
2024-04-05,1000,Empresa A,123456789
2024-04-06,1500,Empresa B,987654321

--Puedes utilizar el siguiente script para leer este archivo y volcarlo a una nueva tabla en SQL Server:
-- Crear la nueva tabla
CREATE TABLE NuevaTabla (
    Fecha DATE,
    Importe DECIMAL(10, 2),
    Razon_Social VARCHAR(100),
    CUIT VARCHAR(20)
);

-- Realizar la carga desde el archivo CSV
BULK INSERT [Custodia].[dbo].[InfFIFO_Op]
FROM 'C:\Users\MB433864\Desktop\datos.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Separador de campos
    ROWTERMINATOR = '\n',    -- Separador de filas
    FIRSTROW = 2            -- Ignorar la primera fila si contiene encabezados
);

/*Asegúrate de reemplazar 'C:\ruta\al\archivo\datos.csv' con la ruta correcta a tu archivo CSV.
Después de ejecutar este script, la tabla NuevaTabla contendrá los datos del archivo CSV. 
Puedes verificarlo ejecutando una simple consulta SELECT:*/

SELECT * FROM NuevaTabla;

---------------------------INVERSA---------------------------------

/*Para exportar datos desde una tabla en SQL Server a un archivo CSV, puedes utilizar la función BCP (Bulk Copy Program)
o la función SQLCMD. Aquí te muestro un ejemplo utilizando BCP:
Supongamos que tienes una tabla llamada NuevaTabla que contiene los datos que deseas exportar al archivo CSV.
Puedes utilizar el siguiente script para exportar estos datos a un archivo CSV:*/

-- Consulta para seleccionar los datos que deseas exportar
DECLARE @sqlQuery NVARCHAR(MAX);
SET @sqlQuery = 'SELECT * FROM NuevaTabla';

-- Ruta del archivo CSV
DECLARE @filePath NVARCHAR(1000) = 'C:\ruta\al\archivo\exportado.csv';

-- Ejecutar el comando BCP para exportar datos al archivo CSV
DECLARE @bcpCommand NVARCHAR(1000);
SET @bcpCommand = 'bcp "' + @sqlQuery + '" queryout "' + @filePath + '" -c -t, -T -S' + @@SERVERNAME;

EXEC xp_cmdshell @bcpCommand;

/*En este script, @sqlQuery contiene la consulta SQL que selecciona los datos que deseas exportar.
Asegúrate de ajustar esta consulta según tus necesidades.
@filePath es la ruta del archivo CSV donde se exportarán los datos.
@bcpCommand contiene el comando BCP que ejecutará la exportación de datos. -c indica que los datos se exportarán
en formato de caracteres Unicode, -t, especifica que el separador de campo será una coma (,), -T indica que se utilizará 
la autenticación de Windows y -S se utiliza para especificar el nombre del servidor SQL.
Después de ejecutar este script, los datos de la tabla NuevaTabla se exportarán al archivo CSV especificado
en la ruta proporcionada.*/