

DECLARE @PFDesde datetime = '20240101', @PMes int = 1
--AS
--BEGIN 

DECLARE @mes int = 12
DECLARE @Fecha datetime = '20240101'
SELECT @PFDesde = @Fecha, @PMes = @mes

DECLARE @FHasta datetime = (SELECT dateadd(second, -1, dateadd(month, @PMes, @PFDesde)))


/*Obtenemos lAS especies que son Titulos y Acciones*/
SELECT  EspAbrev
INTO    #esp
FROM    Custodia.._RelEspGrupo  r WITH(NOLOCK),
        Custodia.._ItemsDeTablas i
WHERE   r.GrEspCod = i.ItemCod
AND r.CptoCod = 1
AND i.TablaId = 221
AND ItemCod IN (1,2);

/*Identificamos todAS lAS operaciones a excluir, PASes, de Mercado etc..*/
WITH cmt_Excluidos (MinManual)
AS (
SELECT DISTINCT MinManual
FROM PROD..VW_OPERACIONES_ALL  o WITH(NOLOCK)
WHERE 1 = 1
AND FchVnc >= @PFDesde
AND Tipo IN ('Cmp','Vnta')
AND (MinManual IN (SELECT DISTINCT NroOperacion FROM PROD..OPERACIONES_EXTRADATA  WITH(NOLOCK)
                    WHERE NroOrden IS NOT NULL AND FchVnc BETWEEN @PFDesde AND @FHasta)
OR  MinManual IN (SELECT DISTINCT minmanual FROM PROD..PasesOp WITH(NOLOCK))
OR  (Cliente = 'MERCADO DE VALORES D')
OR  MinManual in (SELECT isnull(o2.OpPrev,-1)
                    FROM PROD..VW_OPERACIONES_ALL  o2 WITH(NOLOCK)
                    WHERE o2.EspPpal = o.EspPpal
                    AND FchVnc BETWEEN @PFDesde AND @FHasta)
OR  (Cliente IN ('MERCADO ABIERTO ELE', 'MERCADO DE VALORES D', 'MERCADO ABIERTO ELEC') AND OpPrev IS NOT NULL)
OR  Tr IN (SELECT Tr FROM PROD..FCI WITH(NOLOCK)))
AND  AdhNro <> 380109 
AND  MinManual NOT IN (SELECT MinManual 
                        FROM PROD..VW_OPERACIONES_ALL o1  WITH(NOLOCK)
                        WHERE   o1.OpPrev IS NOT NULL
                        AND     o1.Cliente IN ('MERCADO ABIERTO ELE', 'MERCADO DE VALORES D','MERCADO ABIERTO ELEC')
                        AND     FchVnc >= @PFDesde
                        AND NOT EXISTS (SELECT 1
                                            FROM PROD..VW_OPERACIONES_ALL o2 WITH(NOLOCK)
                                            WHERE o1.OpPrev = o2.MinManual))
AND EspPpal IN (SELECT EspAbrev FROM #esp)
)

/*Cargamos en la temporal las operaciones*/
SELECT  EspPpal AS Tr,
        MinManual,
        FchOrg,
        FchVnc,
        Cliente,
        Tipo,
        CPpal,
        EspPago,
        Precio,
        Precio AS PrecioPesificado,
        Precio AS Valorizado,
        EstadoCod,
        Tr AS TrEsp
INTO #tmp
FROM PROD..VW_OPERACIONES_ALL  o WITH(NOLOCK)
WHERE 1 = 1
AND (FchVnc >= @PFDesde AND  FchVnc < @FHasta)
AND NOT EXISTS (SELECT 1 FROM cmt_Excluidos m WHERE o.MinManual = m.MinManual)
AND NOT (Tipo IN ('AVnta','ACmp'))
AND NOT (MinManual IN (SELECT DISTINCT MinManual
                        FROM PROD..VW_OPERACIONES_ALL o4 WITH(NOLOCK) WHERE o4.EspPpal = o.EspPpal
                        AND Tipo IN ('TrfSal','TrfEnt','Ext') AND NOT (o4.Cliente LIKE 'CARTERA ITAU%')))
AND EspPpal IN (SELECT DISTINCT EspAbrev FROM #esp)
ORDER BY EspPpal, MinManual, FchOrg;


/*BORramos Especies y operaciones que no tenemos que tener en cuenta*/
DELETE FROM #tmp WHERE MinManual IN ( '6302159','6292492','6306466','6319121','6300779','6307032','6338027','6338465',
'6333609','6328910','6299901','6305731','6305957','6346232','6335585','6347997','6347718','6347987','6347098','6347373',
'6347380','6347716','6347720','6569314','6568897', '6569039', '6569310','6428141','6415098','6569250','6569808','6600568',
'6470243','6479165','6507719')


--DELETE FROM #tmp 

DELETE FROM #tmp WHERE Cliente = 'MERCADO DE VALORES D'

INSERT INTO #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
SELECT 'MGCGO','9572912','20230510','Cmp','50000000','$','1';

INSERT INTO #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
SELECT 'T531O','9572918','20230405','Cmp','207003290','$','1.00190084';

INSERT INTO #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
SELECT 'MGCBO','9573117','20230715','Cmp','630839354','$','1';

INSERT INTO #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
SELECT 'T2X2P  ','9599291','20230816','Cmp','36934576','$','2.62';

INSERT INTO #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
SELECT 'CP25O.','9599298','20230321','Cmp','1000000','$','173';

INSERT INTO #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
SELECT 'RCCMO','9599299','20230921','Cmp','207','$','744';
 

  --INSERT INTO #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
  --SELECT 'TX24P','9573117','20200520','Cmp','129482890','$','0.7075';
  
  --INSERT INTO #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
  --SELECT 'TX23P','9572917','20200512','Cmp',' 186372810','$','0.765';
  
  --INSERT INTO #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
  --SELECT 'TX23P','9573116','20200520','Cmp','43167535','$','0.7075' ; 
  
  --INSERT INTO #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
  --SELECT 'TX22P','9572916','20200512','Cmp','185644583','$','0.8575' ; 
  
  --INSERT INTO #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
  --SELECT 'T2X2P','9573120','20200520','Cmp','45353540','$','0.766649'  ----se corrigio especie

  -- INSERT INTO #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
  --SELECT 'TX21P','9572272','20200325','Cmp','1477932','$','0.745'  ----se corrigio especie

 

DELETE FROM #tmp WHERE Tr IN ('$','7000','U$S','AGRO','AMZN')
DELETE FROM #tmp WHERE Tipo IN ('ACmp','AVnta','CORLiq');



/*Buscamos los valores del dolar para valorizar las especies en dolares*/
WITH Cmt_EspecieFecha (EspAbrev, FchMov, FchCierr)
AS (
    SELECT C.Abrev, M.FchOrg, MAX(C.Fecha)
    FROM PROD.._Cierre C WITH(NOLOCK),
          (SELECT DISTINCT EspPago, FchOrg FROM #tmp WHERE EspPago = 'U$S') M
    WHERE 1 = 1
    AND C.Abrev = M.EspPago
    AND C.Fecha <= M.FchOrg
    GROUP BY C.Abrev, M.FchOrg
)

/*Calculamos el precio pecificado*/
UPDATE #tmp
SET PrecioPesificado = round(c.Cierr$ *m.Precio, 8)
FROM  #tmp m,
      Cmt_EspecieFecha t,
      PROD.._Cierre c WITH(NOLOCK)
WHERE 1 = 1 
AND m.FchOrg = t.FchMov
AND m.EspPago = t.EspAbrev
AND t.EspAbrev = c.Abrev
AND t.FchCierr = c.Fecha


UPDATE #tmp  SET EspPago = 'TN43O' WHERE EspPago ='TN430' 
UPDATE #tmp  SET Tr = 'TN43O' WHERE Tr = 'TN430' 
UPDATE #tmp  SET Tr = 'U30G9' WHERE Tr = 'L2DG9' 
UPDATE #tmp  SET Tr = 'U13S9' WHERE Tr = 'LTDS9' 
UPDATE #tmp  SET Tr = 'S31L0' WHERE Tr = 'LTPL0' 
UPDATE #tmp  SET Tr = 'Y10A9' WHERE Tr = 'Y10A9'
UPDATE #tmp  SET Tr = 'S13S9' WHERE Tr = 'WS13S'
UPDATE #tmp  SET Tr = 'S29Y0' WHERE Tr = 'WS29Y'


/*Calculamos el Valorizado*/
UPDATE #tmp
SET PrecioPesificado = CASE EspPago WHEN 'U$S' THEN PrecioPesificado ELSE Precio END,
    Valorizado = (CPpal*CASE EspPago WHEN 'U$S' THEN PrecioPesificado ELSE Precio END)

/*Actualizamos el Tipo  ya que el mismo se invierte*/
UPDATE #tmp
SET Tipo = (CASE Tipo
            WHEN 'Cmp' THEN 'Vnta'
            WHEN 'Vnta' THEN 'Cmp'
            ELSE Tipo END)
WHERE substring(TrEsp,1,3) <> 'Bls'
AND Cliente LIKE 'CARTERA ITAU%'
  
  
/*Operaciones Compra Venta*/
--INSERT INTO Custodia..InfFIFO_Op (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,PrecioPesificado,Valorizado)
SELECT 
    a.Tr,
    a.MinManual,
    a.FchOrg,
    a.Tipo,
    a.CPpal,
    a.EspPago,
    a.PrecioPesificado,
    a.Valorizado
FROM #tmp a
INNER JOIN PROD..VW_OPERACIONES_ALL b WITH(NOLOCK)
ON a.MinManual = b.MinManual 
WHERE a.Tipo IN ('Cmp','Vnta')
ORDER BY Tr, FchOrg, MinManual



/*Operaciones TransferenciAS, Extracciones, Cierres*/
--INSERT INTO Custodia..InfFIFO_Op (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,PrecioPesificado,Valorizado)
SELECT 
    Tr,
    MinManual,
    FchOrg,
    Tipo,
    CPpal,
    EspPago,
    PrecioPesificado,
    Valorizado
FROM #tmp p
WHERE NOT Tipo IN ('Cmp','Vnta')
ORDER BY Tr, FchOrg, MinManual

--END
--DELETE FROM Custodia..InfFIFO_Op
--drop table #esp
--drop table #tmp

------consulta PABLO OPERACIONES Y TRANSFERENCIAS

SELECT 
    a.Tr,
    a.MinManual,
    b.Cliente,
    a.FchOrg,
    a.Tipo,
    a.CPpal,
    a.EspPago,
    a.PrecioPesificado,
    a.Valorizado,
    b.Responsable
FROM #tmp a
INNER JOIN PROD..VW_OPERACIONES_ALL b
ON a.MinManual = b.MinManual 
WHERE a.Tipo IN ('Cmp','Vnta')
ORDER BY Tr,FchOrg, MinManual


SELECT  p.Tr,
        p.MinManual,
        p.FchOrg,
        p.Tipo,
        p.CPpal,
        p.EspPago,
        ''AS PrecioPesificado,
        ''AS Valorizado,
        p.EstadoCod,
        m.EstadoCod,
        m.CtaNro AS CtaCobro,
        n.CtaNro AS CtaPago,
        p.FchVnc,
        p.Cliente,
        O.Comentario
FROM #tmp p
INNER JOIN PROD..VW_OPERACIONES_ALL O WITH(NOLOCK)
ON O.MinManual = p.MinManual
LEFT OUTER JOIN PROD..VW_MOVFON_ALL m WITH(NOLOCK)
ON p.MinManual = m.MinManual
AND p.Tr = m.Abrev
AND m.TipoCod = 'CB'
LEFT OUTER JOIN  PROD..VW_MOVFON_ALL n WITH(NOLOCK)
ON p.MinManual = n.MinManual
AND p.Tr = n.Abrev
AND n.TipoCod = 'PG'
WHERE  p.Tipo NOT IN ('Cmp','Vnta')
ORDER BY p.Tr, p.FchOrg, p.FchVnc, p.MinManual

