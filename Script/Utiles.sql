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
