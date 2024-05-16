
--****************QUERY TOTALIZADOR****************--

SELECT *
FROM OPERACIONES o
    LEFT JOIN OPERACIONES_EXTRADATA x ON x.NroOperacion = o.MinManual
    JOIN MOVIMIENTOS_FONDOS m ON m.MinManual = o.MinManual
    JOIN TESORO ag ON ag.Codigo = -m.ProdNro
    LEFT JOIN RELACION_MOVIMIENTOSFONDOS_TOTALES r ON r.MinManual = m.MinManual
WHERE
    o.Tipo NOT IN ('TOMCA', 'COLCA')
    AND m.FVnc <= (SELECT UltimoIni FROM PARAM_GLOBAL)
    AND m.CodMov = 'CtaExt'
    AND m.EstinfoCod IS NULL
    AND m.EstadoCod IN ('aImp', 'Pend','aNet', 'QFPend')
    AND ag.IndiNeteo = 'E'    -- totaliza por especie
    AND NOT EXISTS (SELECT 1 FROM RELACION_MOVIMIENTOSFONDOS_TOTALES r WHERE r.MinManual = m.MinManual and r.Tratada = 'Q')
    AND NOT EXISTS (SELECT 1  FROM MOVIMIENTOS_FONDOS m2 WHERE m2.MinManual = m.MinManual AND m2.EstinfoCod IS NOT NULL)
    --and x.PEP is null
    ORDER BY o.MinManual;

select top 10 * from OPERACIONES_EXTRADATA
where NroOperacion in (2152039,6735883,6735895)

--UPDATE OPERACIONES_EXTRADATA
--SET PEP = 'N'
--WHERE NroOperacion in (2152039,6735883,6735895)

--*************QUERY COLUMNAS DEL Totalizador**************--

SELECT DISTINCT
(CASE WHEN (r.MinManual IS NOT NULL) THEN '*' ELSE '' END) AS marcaTotaliza,
o.MinManual AS nroOperacion,
o.Cliente AS clienteNombre,
o.Tipo AS tipo,
o.EspPpal AS especieCodigo,
o.CPpal AS cantidadPrincipal,
o.EspPago AS especiePagoDenominacion,
o.Neto AS neto,
o.Precio AS precio,
o.FchVnc AS fechaVencimiento,
o.EstadoCod AS codigoEstado,
x.PEP AS pep,
r.AgrupaPepNoPep AS agrupaPep,
o.EnteLiq as enteLiquidador
FROM OPERACIONES o
LEFT JOIN OPERACIONES_EXTRADATA x ON x.NroOperacion = o.MinManual
JOIN MOVIMIENTOS_FONDOS m ON m.MinManual = o.MinManual
JOIN TESORO ag ON ag.Codigo = -m.ProdNro
LEFT JOIN RELACION_MOVIMIENTOSFONDOS_TOTALES r ON r.MinManual = m.MinManual
WHERE
o.Tipo NOT IN ('TOMCA', 'COLCA')
AND m.FVnc <= (SELECT UltimoIni FROM PARAM_GLOBAL)
AND m.CodMov = 'CtaExt'
--AND m.EstinfoCod IS NULL
AND m.EstadoCod IN ('aImp', 'Pend','aNet', 'QFPend')
AND ag.IndiNeteo = 'E'
AND NOT EXISTS (SELECT 1 FROM RELACION_MOVIMIENTOSFONDOS_TOTALES r WHERE r.MinManual = m.MinManual and r.Tratada = 'Q')
AND NOT EXISTS (SELECT 1 FROM MOVIMIENTOS_FONDOS m2 WHERE m2.MinManual = m.MinManual AND m2.EstinfoCod IS NOT NULL)
ORDER BY o.MinManual