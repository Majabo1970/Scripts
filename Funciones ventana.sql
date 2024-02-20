SELECT Book, FORMAT(SUM(Monto), 'C', 'en-US') as SumaxBook
FROM PROD.dbo.BLOTTER
group by Book

Book	SumaxBook
BANKING	116908222,85699011
CONTA	895,944
TRADING	5099802734,325779

/*Funcion ventana agrupado por Book agregando columna Total x Monto para cada especie*/
SELECT
    Cliente,
    Plazo,
    Book,
    FORMAT(Monto, 'C', 'en-US') AS Monto,
    FORMAT(SUM(Monto) OVER (PARTITION BY Book), 'C', 'en-US') AS TotalMontoxBook
FROM PROD.dbo.BLOTTER
ORDER BY Book;

Cliente                         Plazo	Book	Monto	    TotalMontoxBook
EMPRESA-000595	                0	    BANKING	$2,240.00	$116,908,222.86
MONEDA PATAGONIA FONDO DE INVE	0	    BANKING	$1.00	    $116,908,222.86
BBVA BANCO FRANCES	            2	    BANKING	$1.00	    $116,908,222.86
MAE	                            2	    BANKING	$1.00	    $116,908,222.86
CARTERA ITAU	                0	    BANKING	$1.00	    $116,908,222.86
BBVA BANCO FRANCES	            0	    BANKING	$1.00	    $116,908,222.86
BBVA BANCO FRANCES	            0	    BANKING	$1.00	    $116,908,222.86
BBVA BANCO FRANCES	            0	    BANKING	$1.00	    $116,908,222.86
BBVA BANCO FRANCES	            0	    BANKING	$1.00	    $116,908,222.86
BBVA BANCO FRANCES	            -281	BANKING	$1.00	    $116,908,222.86

/*Idem anterior con la funcion promedio*/
SELECT
    Cliente,
    Plazo,
    Book,
    FORMAT(Monto, 'C', 'en-US') AS Monto,
    FORMAT(AVG(Monto) OVER (PARTITION BY Book), 'C', 'en-US') AS PromMontoxBook
FROM PROD.dbo.BLOTTER
ORDER BY Book, Cliente;

Cliente             Plazo   Book	Monto	PromMontoxBook
BANCO PATAGON       2	    BANKING	$1.00	$5,082,966.21
BBVA BANCO FRANCES	2	    BANKING	$1.00	$5,082,966.21
BBVA BANCO FRANCES	2	    BANKING	$172.38	$5,082,966.21
BBVA BANCO FRANCES	0	    BANKING	$1.69	$5,082,966.21
BBVA BANCO FRANCES	0	    BANKING	$1.00	$5,082,966.21
BBVA BANCO FRANCES	0	    BANKING	$1.00	$5,082,966.21
BBVA BANCO FRANCES	0	    BANKING	$1.00	$5,082,966.21
BBVA BANCO FRANCES	0	    BANKING	$1.00	$5,082,966.21
BBVA BANCO FRANCES	-281	BANKING	$1.00	$5,082,966.21
BBVA BANCO FRANCES	0	    BANKING	$1.00	$5,082,966.21

/*-----------------------------------------------------------*/
CREATE TABLE #TempSuma (
    SumaResultado DECIMAL(18, 2),
    PrecioAgregado FLOAT
);

DECLARE nombreCursor CURSOR FOR
SELECT Cliente, Precio
FROM PROD.dbo.BLOTTER
WHERE Precio > 1 AND Precio < 3;

DECLARE @Cliente varchar(30);
DECLARE @Precio float;
DECLARE @sumaAcumulada DECIMAL(18, 2) = 0;
DECLARE @PrecioAgregado float;

OPEN nombreCursor;

FETCH NEXT FROM nombreCursor INTO @Cliente, @Precio;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Calcular la suma fila por fila
    SET @sumaAcumulada = @sumaAcumulada + @Precio;

    -- Insertar la suma en la tabla temporal
    INSERT INTO #TempSuma (SumaResultado, PrecioAgregado) VALUES (@sumaAcumulada, @Precio);

    -- Actualizar la variable @PrecioAgregado para la siguiente iteración
    SET @PrecioAgregado = @Precio;

    FETCH NEXT FROM nombreCursor INTO @Cliente, @Precio;
END;

CLOSE nombreCursor;
DEALLOCATE nombreCursor;

-- Ver los resultados en la tabla temporal
SELECT * FROM #TempSuma;

-- Eliminar la tabla temporal
DROP TABLE #TempSuma;

|SumaResultado|	PrecioAgregado|
|*************|***************|
2.00	        2
3.40	        1,4
4.90	        1,5
6.40	        1,5
8.40	        2
9.70	        1,3
10.87	        1,169
12.56	        1,69
14.25	        1,69
15.42	        1,169
16.59	        1,169
17.76	        1,169
18.93	        1,169
19.94	        1,01
20.95	        1,009
21.96	        1,0085
22.97	        1,00867
24.17	        1,2
25.20	        1,03
26.23	        1,03
27.41	        1,182
28.59	        1,182
29.77	        1,182
30.95	        1,182
31.97	        1,02
32.99	        1,021
34.01	        1,021
35.03	        1,021
36.05	        1,0211
37.07	        1,0211
38.09	        1,0211
39.12	        1,0305
40.12	        1,0005
41.14	        1,0205
42.16	        1,0205
43.18	        1,02
45.81	        2,63
48.44	        2,63
50.44	        2
52.44	        2
54.44	        2
56.44	        2
58.44	        2
60.44	        2
62.44	        2
64.44	        2
66.44	        2
68.44	        2