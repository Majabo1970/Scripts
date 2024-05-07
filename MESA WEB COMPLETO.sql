--**************************************************************************************************************************
--OPERACIONES DIRECTAS PARA CARTERA PROPIA NO SE PUEDEN CARGAR EN MESA WEB (SE CARGAN DIRECTAMENTE EN SINAC O SIOPEL)
--SOLO PARA CLIENTES SE PUEDEN CARGAR OPERACIONES DIRECTAS

--***ROMPERIA TODA LA CONTABILIDAD****

--***********************TABLAS  UTILES DE MESA WEB*************************************************************************
--DATOS DE CLIENTES
SELECT * FROM .._Arch                           -- Operaciones (historico=
SELECT * FROM .._Op                             -- Operaciones ( 5 dias o no liquidadas)
SELECT * FROM [dbo].[VW_OPERACIONES_ALL]        -- Todas
SELECT * FROM .._Cli                            -- Datos Cliente
SELECT * FROM .._Esp                            -- Datos Especies
SELECT * FROM .._MovArch                        -- Mov Operaciones
SELECT * FROM .._MovFon                         -- Mov Fondos ( 5 dias o no liquidadas)
SELECT * FROM  [dbo].[VW_MOVFON_ALL]            -- Movimietnos completos todas

SELECT * FROM ..COMISIONES                      -- Comisiones
SELECT * FROM ..DOTBRTIT                        -- Relacion Raiz-CliNum
SELECT * FROM ..MndMesa                         -- Operaciones Mesa por mANDato (ORDENES)
SELECT * FROM ..OPERACIONES_EXTRADATA
SELECT * FROM ..ORDENES_EXTRADATA
SELECT * FROM ..RUEDAS                          -- Ruedas
SELECT * FROM ..SEGMENTO                        -- Segmentos
SELECT * FROM .._Cierre                         -- Precios Cierre
SELECT * FROM dbo.CATIVOS_VALORES               -- Bloqueos por cativos

INSIOb
SELECT * FROM ..INSIO_MESSAGES ORDER BY FECHA desc
SELECT * FROM ..INSIO_NODE_ACTIVE
SELECT * FROM  SIOConfirmOp                     -- Para revisar operaciones rechazadas

MESIO
SELECT * FROM ..MESIO_NODE_ACTIVE
SELECT * FROM ..MESIO_OPERACION
SELECT * FROM ..MESIO_ORDEN


CUSTODIA
SELECT * FROM .._Adhesion                       -- Clientes
SELECT top 10 * FROM .._Cuent                   -- Datos de Cuenta
SELECT top 10 * FROM .._SaldoCtaEsp


COMISIONES
SELECT * FROM COMISIONES
SELECT * FROM dbo.COMISIONES _GRUPO_RAICES


SELECT g.nroRaiz, c.*
FROM COMISIONES c
LEFT JOIN COMISIONES_GRUPO_RAICES g ON c.id=g.idComision
ORDER BY c.id, nroRaiz


---COSNULTA PARA SISTEMA ABIERTO

 SELECT CierreOInicio FROM Cte                  -- cero es abierto general

 SELECT EstadoBls FROM ParamBrk                 -- cero es cerrado sucursal

----------------------------ESPECIES FILTROS POR CONCEPTOS--GRUPOS------------------------------

--ESPECIES CON CATEGORIAS 1: TITULOS, 2:ACCIONES, 4:ON

SELECT r.GrEspCod, e.Abrev, e.Nombre
FROM _Esp e
JOIN Custodia.._RelEspGrupo r ON r.EspAbrev = e.Abrev AND r.CptoCod = 1
WHERE e.EstadoCod = 'Hab'
AND r.GrEspCod in (1,2,4)

-- CONCEPTOS
SELECT * FROM Custodia.._ItemsDeTablas
WHERE TablaId = 29

-- 101      SwiMer      Switch Mercados

-- GRUPOS
SELECT * FROM Custodia.._ItemsDeTablas
WHERE TablaId = 221

--RelacionConceptoGrupo
SELECT * FROM [Custodia]..[_ConceptoGrupo]
WHERE CptoCod = 101

INSERT INTO [Custodia]..[_ConceptoGrupo] (CptoCod,GrEspCod,UMUsrCod,IntervAltaNro,IndiAAut)
values (101, 1 , null, null, 'N' )

INSERT INTO [Custodia]..[_ConceptoGrupo] (CptoCod,GrEspCod,UMUsrCod,IntervAltaNro,IndiAAut)
values (101, 2 , null, null, 'N' )
INSERT INTO [Custodia]..[_ConceptoGrupo] (CptoCod,GrEspCod,UMUsrCod,IntervAltaNro,IndiAAut)
values (101, 4 , null, null, 'N' )

--Les comparto script para nuevos conceptos de especies en Items de Tablas.

-- AGREGA NUEVO CONCEPTO PARA Switch Mercados - RelEspGrupo: Conceptos:
IF NOT EXISTS (SELECT 1 FROM Custodia.._ItemsDeTablas WHERE TablaId = 29 AND ItemCod = 101)
BEGIN
     INSERT INTO Custodia.._ItemsDeTablas (TablaId, ItemCod, ItemAlfaCod, ItemDenom, ItemValor, FHUltMod, UMUsrCod, ItemAbrev, Orden)
     VALUES (29, 101, 'SwiMer', 'Switch Mercados', 1.00, GETDATE(), 1, NULL, NULL)
END
GO

--AGREGA NUEVO CONCEPTO PARA Tipo de Tasas - RelEspGrupo: Conceptos:
IF NOT EXISTS (SELECT 1 FROM Custodia.._ItemsDeTablas WHERE TablaId = 29 AND ItemCod = 102)
BEGIN
     INSERT INTO Custodia.._ItemsDeTablas (TablaId, ItemCod, ItemAlfaCod, ItemDenom, ItemValor, FHUltMod, UMUsrCod, ItemAbrev, Orden)
     VALUES (29, 102, 'TipTas', 'Tipo de Tasa', 1.00, GETDATE(), 1, NULL, NULL)
END
GO

--******************CONSULTAS UTILES DE MESA WEB*********************************************************
--------------------responsable de una operacion-----------------------------
SELECT * FROM MndMesa WHERE FCargaMnd >= '20170113' AND Responsable = '4aHomeBank' AND TipoOp = 'Cmp'

--confimar si entro un operacion de fondos
SELECT * FROM _Op WHERE AdhNro = 375768

--------------------------------------------OPERACIONES BORRADAS------------------------------------------
--confirmar si se borro una operacion de fondos
SELECT * FROM OpBorradas WHERE Cliente  = 'UBIRIA JUAN MANUEL' AND FHBaja >= '20170116'

------------------------------------ESPECIE-----------------------------------------------------------------

--***************** Merval tiene que estar cargada la moneda en que se eta operANDo para la especie en la siguiente tabla para MERVAL $ y USD
SELECT * FROM  [dbo].[RELACION_ESPECIE_MONEDA] WHERE EspecieCodigo='AA17D'

--******************** Tanto para MAE COMO MERVAL tiene que estar cargada el mercado para la especie en la siguiente tabla para MERVAL(BlsPiso en talon) y MAE (talon BrkBolNum)
SELECT * FROM  [dbo].Tr WHERE EspPpal  ='L2DE7'

--********************* REVISAR EN LA ESPECIE

SELECT * FROM  _Esp WHERE Abrev  ='L2DE7' -- Cargado el codigo MAE y el Codigo CV para MERVAL

--********************** REVISAR PRECIOS
SELECT TOP 1000 [CodEspecie],[IdGrupo]
FROM [PROD].[dbo].[GRUPOS_ESPECIE_PIZARRA_LIST] WHERE CodEspecie='L2DE7'

SELECT TOP 1000 [Id],[Descripcion]
FROM [PROD].[dbo].[GRUPOS_ESPECIE_PIZARRA]

SELECT IdGrupoEspecie, * FROM SPREAD_PIZARRA

--****************para saber si una operacion viajo a SIOPEL
SELECT RefNum, * FROM PROD.._Op
WHERE MinManual = '2078722'

--*****************para saber motivo de rechazo DE UNA ORDEN*

SELECT MotivoRechazo,* FROM PROD..MndMesa m,PROD..ORDENES_EXTRADATA e
WHERE m.MndNro = e.MndNro AND e.MndNro > 50000001
AND FCargaMnd >= '20150120'

--ejemplo
SELECT * FROM MndMesa WHERE EspPpal = 'I15M7'  AND FCargaMnd >= '20170126 15:12'
SELECT * FROM ORDENES_EXTRADATA WHERE MndNro = 50011817

--***************comom se agrupa conceptos/grupos/categorias  para 1 especie

--Parametros especies
-- conceptos
SELECT * FROM _ItemsDeTablas WHERE TablaId = 29

-- grupos
SELECT * FROM _ItemsDeTablas WHERE TablaId = 221

-- rel. cptos/grupos
SELECT * FROM _ConceptoGrupo

--Conceptos grupos de 1 especie
SELECT * FROM [Custodia].[dbo].[_RelEspGrupo] WHERE EspAbrev = 'xxxx'

--******************FCI QUE NO VIAJAN A SIOPEL POR NRO DE CNV  INCOMPLETO y CODIGO DE BANCA 403 FCI*******************************************
SELECT * FROM PROD.._Op
WHERE MinManual in ('2077991','2078000')

SELECT * FROM _Cli WHERE AdhNro in ('100848')

SELECT * FROM Custodia.._Adhesion  WHERE Numero ='3170584'

SELECT * FROM Custodia..RelRaizCliente  WHERE RaizNro ='683847'

SELECT * FROM RAICES_CLIENTE_EXTRADATA  WHERE NroRaiz in('3069562','3069489')

SELECT * FROM Custodia.._Banca

SELECT * FROM Custodia.._Adhesion WHERE BancaCod ='403'

----------------------------operaciones desde SIOPEL A MESA WEB

SELECT * FROM _Cli WHERE CodMae = '142'                     -- "agente":"142", revisar contraparte si esta cargada

SELECT * FROM _Esp WHERE CodMAE ='AO20D'                    -- "especie":"1c 003003D1"revisar especie

SELECT * FROM Custodia.._Derecho WHERE EspAbrev = 'AO20'    -- "especie":"1c 003003D1", revisar cupon

SELECT * FROM Custodia.._ItemsDeTablas WHERE TablaId = 3022 -- no existe tal ente de liquidador "enteLiquidador":"U",
                                                            -- revisar enteliquidador

--*************************PIZARRA DE PRECIOS*************************************************************************************

SELECT TOP 1000 [CodEspecie],[IdGrupo]
FROM [PROD].[dbo].[GRUPOS_ESPECIE_PIZARRA_LIST]

SELECT TOP 1000 [Id],[Descripcion]
FROM [PROD].[dbo].[GRUPOS_ESPECIE_PIZARRA]

SELECT IdGrupoEspecie, * FROM SPREAD_PIZARRA
WHERE IdGrupoEspecie = 1
AND Moneda = 2
ORDER BY 1

--*************************PROBLEMAS CON CLINETE REVISAR**************************************************************************

-- [Custodia].[dbo].[_Cuenta]                --Cuenta comitente (CtaNro) y raiz (AdhNro)
-- [PROD].[dbo].[_Cli]                       --Banca Patrimonial y clientes fondos

-- --Contiene:  Raiz (AdhNro), clinum (HostNro)

-- [Custodia].[dbo].[RelRaizCliente]         --Relación raiz/clinum-

-- --Contiene:  Raiz (RaizNro), clinum (ClienteNro), documento (DocTipo, DocNro) cuit,

-- [Custodia].[dbo].[_Adhesion]              --Raiz (Numero)


SELECT * FROM
[Custodia].[dbo].[_Adhesion] WHERE  Numero='375768'

SELECT * FROM [Custodia].[dbo].[RelRaizCliente] WHERE RaizNro='375768'
SELECT * FROM Custodia.dbo._Cuenta WHERE AdhNro='375768'
SELECT * FROM _SaldoCtaEsp WHERE CtaNro='500015108' AND IndiVigencia='S'


--******************************ARREGLO POR TIPO DE DOCUMENTO DIFERE DE AS400 Y MESA WEB*******************************

--UPDATE Custodia..RelRaizCliente set DocTipo = 3  WHERE RaizNro = 207661

--*****************************MESANJES DEL INSIO***************************************************************************

SELECT *
FROM [PROD].[dbo].[INSIO_MESSAGES]
WHERE FECHA > '2015-08-17 10:16:06.110'
ORDER BY FECHA desc

SELECT * FROM dbo.INSIO_MESSAGES ORDER BY FECHA desc
SELECT * FROM dbo.INSIO_NODE_ACTIVE
SELECT * FROM dbo.INSIO_NODE_AVAILABLE

SELECT ESTADO,SUBSTRING(SIOPEL_MESSAGE,28,4),* FROM [PROD].[dbo].[INSIO_MESSAGES]
WHERE FECHA > '20150119' --AND SIOPEL_MESSAGE like '88663' --ESTADO = 'ERROR'
--AND ( SUBSTRING(SIOPEL_MESSAGE,28,4) = '7020' OR SUBSTRING(SIOPEL_MESSAGE,28,4) = '0105'  OR SUBSTRING(SIOPEL_MESSAGE,28,4) = '0205' )
ORDER BY FECHA DESC

SELECT MotivoRechazo,* FROM PROD..MndMesa m,PROD..ORDENES_EXTRADATA e
WHERE m.MndNro = e.MndNro AND e.MndNro > 50000001
AND FCargaMnd >= '20150120'

--***********************-LOG SIOPEL CON ERROR  RETURNS 2 ELEMNTS O MAS *****************************************************************

--VER SOLUCION COMPLETA EN \\FSPW02\EQUIPO TESORERIA\INCIDENCIAS\LOG INSIO- ERROR 4 ELEMENTOS

--1.EL CÓDIGO DE AGENTE  ESTA MAS DE DOS VECES

--REVISAR  AGENTE":"600" EN EL LOG  Y CORRER LA SIGUIENTE CONSULTA EN MESA WEB

SELECT * FROM _Cli WHERE CodMae='600'

--2.EL CÓDIGO DE LA ESPECIE  ESTA MAS DE DOS VECES

--REVISAR  ESPECIE EN LOG "ESPECIE":"7I10Y7 Y CORRER LA SIGUIENTE CONSULTA EN MESA WEB

SELECT top 10* FROM _Esp WHERE CodMAE='I10Y7'

---------------------ARREGLO PROBLEMAS DE CUPONES POR  EL BOOF BAJAR Y SUBIR MANUALMENTE-----------------------------------------------

--TENER EN CUENTA QUE EL CUPON SIGUIENTE ES EL INMEDIATO ANTERIOR AL QUE ESTA EN LA TABLA DE DERECHOS. SI ESTA EN 172 CALCULA EL 173

--VER DETALLE COMPLETO EN \\FSPW02\EQUIPO TESORERIA\INCIDENCIAS\PROBLEMAS CUPONES

--COMPARAR LOS CUPONES EN LAS SIGUIENTES TABLAS:

-- 1	PROD.dbo._MovFon              CupNro
-- 2	PROD.dbo.Tr                   Cupon
-- 3	PROD.dbo._Esp                 CuponActual
-- 4	Custodia.._Derecho            CupNro
-- 5	PROD.dbo._Op                  Cupon

--SE DEBE BUSCAR PARA LA CUENTA TÍTIULOS EN CUESTIÓN TODAS LOS MOVIMIENTOS DE FONDOS PENDIENTES ( TABLA MOVFOND)

SELECT * FROM dbo._MovFon WHERE CtaNro='500017847' AND EstadoCod='Pend'

--SE DEBE BUSCAR PARA LA ESPECIE CUESTIÓN TODAS LAS FECHAS DE LOS PAGOS CARGADOS ( TABLA CUSTODIA.._DERECHO)

SELECT * FROM Custodia.._Derecho WHERE EspAbrev = 'BOGAR 18'

--**********************************COMISIONES****************************************************************

/* CASO ANALISIS #1 COMISION COBRADA CLIENTE */
SELECT * FROM COMISIONES
SELECT * FROM _Cli WHERE Nombre = 'FINELLI FERRAZZINI J'
SELECT * FROM dbo.MndMesa WHERE MndNro in ('50007837')
SELECT * FROM ORDENES_EXTRADATA WHERE MndNro in ('50007837')
SELECT * FROM dbo.MndMesaComis WHERE MndNro in ('50007837')
SELECT * FROM _Op WHERE MinManual = '6055318'
SELECT * FROM dbo.OpComImp WHERE MinManual in ('6055318')
SELECT * FROM _Esp WHERE Abrev = 'APBR'
SELECT * FROM Tr WHERE Nombre = 'Bls APBR'

SELECT *
--ArancelMesa,Imp
FROM  GtosComis g, Tr t
WHERE  t.Nombre = 'Bls APBR'
AND g.Categ  = t.Categ

/* CASO ANALISIS #2 COMISION NO COBRADA CLIENTE */
/* NO ES CLIENTE EN MESA */
SELECT * FROM COMISIONES
SELECT * FROM dbo.MndMesa WHERE MndNro in ('50007819')
SELECT * FROM ORDENES_EXTRADATA WHERE MndNro in ('50007819')
SELECT * FROM dbo.MndMesaComis WHERE MndNro in ('50007819')
SELECT * FROM _Op WHERE MinManual = '6055290'
SELECT * FROM dbo.OpComImp WHERE MinManual in ('6055290')
SELECT * FROM _Esp WHERE Abrev = 'PR13'
SELECT * FROM Tr WHERE Nombre = 'Bls PR13'

SELECT *
--ArancelMesa,Imp
FROM  GtosComis g, Tr t
WHERE  t.Nombre = 'Bls PR13'
AND g.Categ  = t.Categ

--************************ ACTUALIZO USUARIOS POR PROBLEMA IntervAltaNro en 1****************************************

--(ACTUALIZADOS MASIVAMENTE DESDE EL MODULO DE SEGURIDAD)

 --ESTOS USUAIOS TIENE INTERNOS  QUE ESTAR CON cero eN PERFILCOD
  SELECT * FROM  _Usuario WHERE Codigo in ('0','1')

 --script para actualizarlos

 --Update _Usuario  set PerfilCod='0', EstadoCod='xAct',PerfilTrade='188',PerfilCodXtr='0' WHERE Codigo in ('0','1')

--ACTIVO USUARIOS POR PROBLEMA CAMPO INTERVALTANRO EN 1 (ACTUALIZADOS MASIVAMENTE DESDE EL MODULO DE SEGURIDAD)

--Update _Usuario set EstadoCod='Acti' WHERE Codigo in
--('1635',
--'1596')

--ACTUALIZO USUARIOS DE SUCURSALES POR PROBLEMA CAMPO INTERVALTANRO EN 1 (ACTUALIZADOS MASIVAMENTE DESDE EL MODULO DE SEGURIDAD)

--Update _Usuario set PerfilCod = NUll, PerfilCodXtr=NUll,SucSectorCod='Suc' WHERE Codigo in ('1660')

--ACTUALIZO USUARIO DE MESA DE DINERO POR PROBLEMA CAMPO INTERVALTANRO EN 1 (ACTUALIZADOS MASIVAMENTE DESDE EL MODULO DE SEGURIDAD)

--Update _Usuario set PerfilCod = NUll, PerfilCodXtr=NUll,SucSectorCod='MesaDi' WHERE Codigo in ('1692','1567')

--********************************PARA DESBLOQUEAR USUARIOS **********************************************************
SELECT * FROM ControlAccesoUsuarios

--UPDATE ControlAccesoUsuarios set bloqueado = 0 WHERE usuario = 'ME431064'

--QUERYS PARA CAMBIAR EL HORARIO DEL SERVICIO QUE RECIBIMOS DEL MESIO...CON ESTO RECIBIMOS OPERACIONES QUE CARGA DIRETAMENTE
--LA MESA EN DESARROLLO

SELECT TOP 1000 [param_key],[param_value]
FROM [PROD].[dbo].[MESIO_PARAMETERS] WHERE param_key IN ('sinac.scheduled.time.FROM','sinac.scheduled.time.to')

UPDATE [PROD].[dbo].[MESIO_PARAMETERS]
SET param_value = '00:02'
WHERE param_key = 'sinac.scheduled.time.FROM'

UPDATE [PROD].[dbo].[MESIO_PARAMETERS]
SET param_value = '00:01'
WHERE param_key = 'sinac.scheduled.time.to'

SELECT TOP 1000 [param_key],[param_value]
FROM [PROD].[dbo].[MESIO_PARAMETERS]
WHERE param_key IN ('sinac.scheduled.time.FROM','sinac.scheduled.time.to')

--*******************************-CCONSULTAS VARIAS Y UTILES*****************************************************************

--COTIZACIÓN VENCIDA
SELECT * FROM MonAltam
SELECT * FROM dbo.COMISIONES
SELECT * FROM PARAM_GLOBAL
SELECT * FROM _Esp WHERE Abrev like '%BODEN 2015%'
SELECT * FROM Tr WHERE EspPpal = 'BODEN 2015'
SELECT * FROM Str WHERE Nombre like '%PlzLiqBolsa%'
SELECT * FROM Precios WHERE EspPpal = 'BODEN 2017'

update Precios
SET Plazo = '3'
WHERE EspPpal = 'AA17D'

SELECT * FROM Tr WHERE EspPpal = 'BODEN 2015'
SELECT * FROM Custodia.._Adhesion WHERE Numero = '863559'
SELECT * FROM Custodia..RelRaizCliente WHERE RaizNro = '863559'

-- SI NO SE PUEDE CERRAR MESA POR FALTA DE PRECIOS EN LOS FONDOS  precio fci
SELECT * FROM _Op WHERE Tr in (SELECT Tr FROM FCI) AND Precio = 0

--update _Op SET Precio = CPago / CPpal, Testigo  = CPago / CPpal  WHERE Tr in (SELECT Tr FROM FCI) AND Precio = 0

SELECT * FROM _Op WHERE Tr in (SELECT Tr FROM FCI) AND Precio = 0

-- SI NO SE PUEDE CERRAR MESA PORQUE LAS OPERACIONES QUEDARON SIN CUENTA FORMAL

--UPDATE _Op SET Precio = 1, Testigo = 1 WHERE Tr IN (SELECT Tr FROM FCI) AND Precio = 0

SELECT * FROM _Op WHERE MinManual IN (SELECT MinManual FROM _MovFon WHERE CtaFormal = '0' AND CodMov = 'CtaMon') AND
Tr IN (SELECT Tr FROM FCI)

--********************************** AMBIENTE PRUEBAS INTEGRACION ACTUALIZACIONES Y DATOS UTILES **********************************

/* ESTADO CIERRE MESA
fchCte

Sumar Dias
fchCte 0,1

sp_helptext 'fchCte'

update Cte set CierreOInicio = 0
SELECT * FROM Cte
BUSCO  CierreOInicio*/

/*<<<<<<<<<<<<<<<<<<<<<<<<< -- Apertura Sucursal -- >>>>>>>>>>>>>>>>>>>>>>*/
SELECT * FROM ParamBrk
--update  ParamBrk set EstadoBls = 1

SELECT * FROM Precios
--update Precios set PrecioCmp = 3.7, PrecioVnta = 3.9
--update Precios set PrecioCmp = 0.955, PrecioVnta = 0.955 WHERE EspPpal = 'BODEN 2015'

/* INSERT dbo.Precios (
      EspPpal,
      EspPago,
      Plazo,
      PrecioCmp,
      CantMaxCmp,
      PrecioVnta,
      CantMaxVnta,
      OldCantMax,
      Cupon,
      PrecioCmpBP,
      PrecioVntaBP,
      VariacionBP)
VALUES (
      N'BFC9O',
      N'$',
       3,
      13.50,
      0, 13.30,
      0,
      0,
      2,
      1.2,
      1.2,
      0) */

/*<<<<<<<<<<<<<<<<<<<<<<< -- COTIZACIONES -- >>>>>>>>>>>>>>>>>>>>>>>>>>>*/

SELECT * FROM MonAltam
--update MonAltam set FHUltAct = GETDATE()
--update MonAltam set FHAltam = GETDATE()

SELECT * FROM _Cierre ORDER BY Fecha desc
SELECT * FROM _Cierre WHERE Abrev = 'BFC9O'                                   -- 'BODEN 2015' ORDER BY Fecha desc
SELECT * FROM _Cierre WHERE Abrev = 'TS' ORDER BY Fecha desc
SELECT * FROM _Cierre WHERE Abrev = 'MIRG' ORDER BY Fecha desc
SELECT * FROM _Cierre WHERE Abrev = 'MIRG' ORDER BY Fecha desc                -- AND cast(Fecha As Date) = '20150213'
SELECT * FROM _Cierre WHERE Abrev = 'BODEN 2015' AND cast(Fecha As Date) = '20150610'

/*
update _Cierre set Fecha = cast(getDate()-1 As Date) WHERE Abrev = 'MIRG' AND cast(Fecha As Date) = '20150213'
update _Cierre set Fecha = cast(getDate()-1 As Date) WHERE Abrev = 'TS' AND cast(Fecha As Date) = '20150617'
update _Cierre set Fecha = cast(getDate()-1 As Date) WHERE Abrev = 'BODEN 2015' AND cast(Fecha As Date) = '20150617'
update _Cierre set Fecha = cast(getDate()-1 As Date) WHERE Abrev = 'MIRG' AND cast(Fecha As Date) = '20150213'
update _Cierre set Cierr = 16.416 WHERE Abrev = 'TS' AND cast(Fecha As Date) = '20150611'
*/

SELECT 16.416 + 0.001
SELECT trunc_date()

SELECT * FROM _Cierre WHERE Abrev='VALE'

--UPDATE  _Cierre SET Fecha = '2017-05-22'
--WHERE Abrev = 'VALE' AND Fecha = '2017-05-17'

SELECT * FROM  _Cierre WHERE Abrev = 'AA17D' AND Fecha = '2016-11-17'

--UPDATE Precios
--SET Cupon  = 20
--WHERE EspPpal = 'AA17D'

SELECT * FROM Precios
WHERE EspPpal = ''

SELECT * FROM PRECIOS_MERCADO ORDER BY fecha desc

SELECT MndNro,CliNombre,Responsable,Mercado,EspPpal
FROM MndMesa WHERE FchOrg > '20150629'

--update MonAltam set FHAltam = GETDATE(),FHUltAct = GETDATE()

SELECT * FROM MonAltam

SELECT * FROM _Op
ORDER BY FHCarga desc

SELECT * FROM Custodia.dbo._AutPendiente
ORDER BY IntervAltaNro desc


--update Custodia.dbo._AutPendiente
--set UMUsrCod = 5
--WHERE IntervAltaNro = 1009066798

SELECT * FROM _Cierre
WHERE Abrev  = 'AA17D' ORDER BY Fecha desc

SELECT * FROM Precios
WHERE EspPpal = 'TECO2'

--INSERT _Cierre (Abrev,Cupon,Cierr,Fecha,CierrO,Cierr$)
--VALUES ('BFC9O',11,1.00,'2016-09-26',1.00,1.00)
--INSERT _Cierre (Abrev,Cupon,Cierr,Fecha,CierrO,Cierr$)
--VALUES ('AF17D',2,13.505,'2016-05-30',13.505,13.505)
--INSERT _Cierre (Abrev,Cupon,Cierr,Fecha,CierrO,Cierr$)
--VALUES ('AA17D',19,10.505,'2016-05-30',10.505,10.505)
--INSERT _Cierre (Abrev,Cupon,Cierr,Fecha,CierrO,Cierr$)
--VALUES ('AM17P',9,15.505,'2016-05-30',15.505,15.505)
--INSERT _Cierre (Abrev,Cupon,Cierr,Fecha,CierrO,Cierr$)
--VALUES ('TR13',2,15.20,'2016-05-30',15.20,15.20)
--INSERT _Cierre (Abrev,Cupon,Cierr,Fecha,CierrO,Cierr$)
--VALUES ('TECO2',18,10.66,'2016-05-30',10.66,10.66)

--UPDATE _Cierre SET Abrev = 1
--WHERE Abrev = 'TECO2'

--COTIZACIÓN
--SELECT * FROM MonAltam
--UPDATE MonAltam
--SET FHUltAct = '2016-05-23 11:44:00'

--fchCte

--MAIL DE FRECUENCIA
/*INSERT MAIL_CLIENTE_FRECUENCIA (
      NroCliente,
      Frecuencia,
      Email,
      CodSegmento,
      CuitCuil,
      TipoPersona,
      ClasificacionCNV,
      Nombre,
      TelefonoCodigoArea,
      TelefonoNumero)
--VALUES (
      '000660',
       '1',
       'Maria.Enrich@itau.com.ar',
       '4000',
       '20043029445',
       '1',
       '1',
       ' QA RO QA UEL MARTIN',
       '011',
       '49976655')*/

/*<<<<<<<<<<<<<<<--- ESPECIES --->>>>>>>>>>>>>>>*/
--update PROD.._Esp
--SET CuponActual = 18
--WHERE Abrev = 'AA17D'
--AND CuponActual = 17

SELECT *  FROM PROD.._Esp
WHERE Abrev = 'AA17D'

SELECT * FROM _Esp
WHERE Abrev like  'AA17D'
SELECT * FROM _Esp
WHERE Abrev like '%TECO2%'

/*
Update  Custodia.._SaldoCtaEsp
SET CupNro = 18
WHERE EspAbrev = 'AA17D'
AND CtaNro = '500000005'
AND IndiVigencia = 'S'
*/

SELECT * FROM Custodia.._SaldoCtaEsp
WHERE EspAbrev = 'AA17D'
AND CtaNro = '500000005'
AND IndiVigencia = 'S'


-- Update  PROD..Tr
-- SET Cupon = 18
-- WHERE EspPpal  = 'AA17D'

SELECT * FROM PROD..Tr
WHERE EspPpal  = 'BODEN2015'

-- Update  PROD..Residuales
-- SET Cupon = 18
-- WHERE Esp      = 'AA17D'

SELECT * FROM PROD..Residuales
WHERE Esp = 'AA17D'

-- UPDATE _Esp
-- Set CodSIB = 'TECO2'
-- WHERE Abrev= 'TECO2'

SELECT * FROM Tr WHERE EspPpal = 'TECO2'

/*Comparto los querys al equipo! Mñana vemos en la daily algo que pidió OMI! Para que estén al tanto ¡ abz */


SELECT AdhNro, -CantAprox cant
INTO #t
FROM MndMesa
WHERE EspPpal = 'AL30'
AND Plazo = 0
AND Status = 'E'
AND TipoOp = 'Cmp'
AND FCargaMnd >= '20240304'

INSERT #t
SELECT AdhNro, CantAprox cant
FROM MndMesa
WHERE EspPpal = 'AL30'
AND Plazo = 0
AND Status = 'E'
AND TipoOp = 'Vnta'
AND FCargaMnd BETWEEN '20240301' AND '20240307'

SELECT AdhNro, sum(cant)
FROM #t
GROUP BY AdhNro
HAVING sum(cant) > 0
ORDER BY AdhNro

--drop table #t

SELECT Status, * FROM MndMesa  WHERE EspPpal = 'AL30' 
AND AdhNro IN (######)
AND FCargaMnd >= '20240304' AND Plazo = 0
ORDER BY AdhNro, FCargaMnd DESC


/*********Cancelación cf - Job: CFSGAE - tabla CFTBMWCR***********************/
--Verificar operaciones del mes anterior que no esten en estado pendiente

Select * from VW_OPERACIONES_ALL where Tipo like '%TOM%' order by FchVnc desc

Select * from VW_OPERACIONES_ALL where Tipo like '%COLAL%' order by FchVnc desc


/*las cuentas comitentes que no tengan movimientos en los últimos 180 días y que no tengan saldos
Que solo sean Titulos y no tengan ni pesos ni dolares*/

SELECT DISTINCT CtaFormal, FConcil
FROM PROD..VW_MOVFON_ALL M
INNER JOIN PROD..Cte C
ON 1=1
WHERE M.FConcil <= DATEADD(DAY,-180,C.UltimoIni)
AND M.CodMov = 'CtaTit'
ORDER BY M.FConcil DESC

SELECT TOP 10 *
--INTO #tmp
FROM Custodia.._Cuenta
WHERE EstadoCod <> 'nAct'
AND CtaFormal NOT IN (
			      SELECT DISTINCT CtaFormal
			      FROM PROD..VW_MOVFON_ALL M
			      INNER JOIN PROD..Cte C
			      ON 1 = 1
			      WHERE M.FConcil > DATEADD(DAY,-180,C.UltimoIni)
			      AND M.CodMov = 'CtaTit')


SELECT DISTINCT *
FROM #tmp t
WHERE t.CtaFormal NOT IN (
				  SELECT CtaFormal FROM Custodia.._SaldoCtaEsp
				  WHERE (IndiVigencia = 'S'
				  AND Cantidad > 0)
				  OR EspAbrev IN (SELECT Tr FROM PROD..FCI)
				  OR EspAbrev not in ('$', 'U$S')
				  )

UPDATE Custodia.._Cuenta
SET EstadoCod = 'nAct'
WHERE CtaNro in (1);

/*NECESITO SACAR SOLO LAS EXCLUSIVAS CON FCI O, CON $ Y u$s*/

SELECT * 
into #temp
FROM Custodia.._SaldoCtaEsp
Where IndiVigencia = 'S'
and Cantidad > 0

delete from #temp
where EspAbrev in (select Tr from PROD..FCI)

delete from #temp
where EspAbrev in ('$', 'U$S')

select count(distinct CtaNro) from #temp

select * 
into #temp_7000_8000
from #temp
where EspAbrev in ('7000','8000')

delete from #temp
where EspAbrev in ('7000','8000')


 select distinct e.CtaNro,
                  'TIPO DE REGISTRO' = '1', 
                  'NUMERO DE CONDOMINO' = '00',
                  'NUMERO DE COMITENTE' = + RIGHT('000000000' + Ltrim(Rtrim(cast(e.CtaNro as varchar))),9),
                  'TIPO COMITENTE' = '0',
                  'FECHA DE ALTA' = CONVERT(varchar(8), GETDATE(), 112),
                  'ESTADO' = CASE 
                              WHEN c.EstadoCod = 'Acti' THEN '0'
                              ELSE '3' END,
                  'MARCA DE CONJUNTA' = '0',
                  'MARCA BLOQUEO'= CASE 
                                    WHEN c.EstadoCod = 'Acti' THEN '0'
                                    ELSE '2'END
from #temp e
inner join Custodia.._Cuenta c
on e.CtaNro=c.CtaNro
inner join Custodia.._Adhesion h
on c.AdhNro=h.Numero
left join Custodia..ASCtasMon a
on a.RaizNro=c.AdhNro



/*
sselect * 
into #tmp
from Custodia..RelRaizCliente 
where ClienteNro in (
'020854','020892','021589','023164','023559','023732','045629','045786','046930','047598','097509','097512',
'137535','173439','174657','174749','204784','207047','245665','246526','294877','447508','449025','449106',
'484156','484448','485028','485557','486975','536316','536506','536902','537500','537642','537746','537925',
'587499','587689','587752','587875','587958','588112','588266','588463','589378','589407','589418','637707',
'638009','638038','638044','638119','638276','638375','638563','638591','638715','638850','639386','639474',
'639493','639499','639532','639594','639642','639780','639831','639853','639935','640025','640037','640338',
'640448','640509','640708','640799','684022','684184','684217','684467','685190','685653','685697','685907',
'686070','686119','686121','686195','686208','686210','686275','686467','686523','687001','687139','687157',
'687335','687403','687783','687890','688215','688271','688320','688327','688339','688385','688389','688390',
'688393','726508','726939','727045','727233','727236','727350','727559','727566','727704','728039','728247',
'728331','728384','728494','728664','728734','728991','729099','729330','730000','730402','730414','730444',
'730722','730824','730904','780223','780466','780555','780662','780667','780754','780757','780768','780993',
'781012','781033','781404','781412','781413','781415','781450','781517','781519','781730','781802','781921',
'782102','782128','782132','782495','782517','782539','782557','782817','782827','782831','783040','783157',
'783173','783341','783365','783415','783424','784191','784333','821931','822127','822512','822619','823054',
'823060','823248','823389','824016','824447','824512','824598','824735','824771','824836','824922','825024',
'825031','825462','825480','853497','853505','853567','854171','854188','854629','854995','855053','855141',
'855576','856154','906652','906705','906721','906788','906798','906881','906904','907066','907353','907444',
'907478','907858','907864','907908','907911','908168','909009','909035','946933','947119','947224','947720',
'948421','948460','948491','949064','949350','971345','971590','971629','971770','971785','971830','972273',
'972837','972889','972973','973217','973391','973404','973417','973426','973434','556648','557427','557511',
'559195','560804','562420','562444','565057','703670','703746','706791','707723','B01104','B01384','B01878',
'B01961','B02260','B02725','B23793','B23828','B24283','B24406','B24492','B24507','B25245','B25306','B25684',
'B25688','B26291','B26295','D17430','D17600','D17790','D17843','D18026','D18542','D18615','D18723','D18990',
'D19160','D19486','D19626','D19677','D20280','D20400','D51428','D51526','D52167','D52505','D52850','D53360',
'D53416','D53427','D53458','D54137','D88645','D89179','D89424','D89438','D89453','D89721','D89784','D89786',
'D90635','D90705','D90853','D90919','F67753','F68331','G01570','G01593','G01696','G02260','G02939','G03085',
'G03093','G03401','G03469','G03660','G03839','G44745','G44754','G44758','G85261','H26759','H52343','H52597',
'J05244','K14808','K63556','K63563','L72966','L98844','L99659','G95099','M37868','N25830','Q25470','R04517',
'W37509','X91681','X91692','BV6310','CK6505','CP2304','CT0510','031409','032435','033515','072226','072757',
'160719','162033','162315','208870','209201','263523','465504','466228','539058','543355','603811','603945',
'604174','604525','604526','604914','605176','605527','606021','606158','606495','606539','606628','606684',
'606699','607363','607488','607495','607867','679302','679637','679934','680165','680224','680863','680905',
'681726','681790','681816','681971','682011','682382','682906','682929','683215','683514','683551','683607',
'749273','749324','749688','750146','750351','750509','750791','751268','751309','752236','752576','752868',
'752886','752898','753124','753226','753278','753494','753556','753593','884667','884720','884894','885277',
'886399','886614','887342','887371','887381','887522','887566','887679','887923','888082','888175','928123',
'928307','928426','928707','928753','987581','987681','988003','988107','988550','988651','988734','988972',
'989297','989522','989671','989880','989963','989988','990058','990065','990236','990395','990432','990475',
'990794','634081','634306','635263','635293','635511','B00056','636876','636988','637822','638917','640097',
'640297','642272','643209','643249','643912','B37596','B37933','B38122','B38361','B38445','B39141','B39224',
'B39414','B39528','B39631','B39989','B40096','B40151','B40301','B40342','C93669','C94308','C94744','C95049',
'C95255','C95714','C95815','C96435','D38063','D38194','D39391','D39405','D39637','D40131','D40212','D40503',
'D40673','D40857','D40889','D40932','D40986','D95470','D95491','D96082','D96148','D96715','D97219','D98724',
'F80487','F81447','F81462','F81521','F81772','F81832','F81837','F81893','F82167','F82177','F82186','F82198',
'F82355','F82732','F82971','F82976','G40030','G86963','G88819','H40682','K05242','L13168','L55930','V03445',
'CX0855','CX1409','025051','027040','065022','067072','133124','177319','178213','178794','221047','221940',
'221946','377836','377837','377842','378045','409018','410880','449675','449999','450893','452451','495592',
'496162','496967','497648','548255','548679','548876','549276','549824','549871','550455','550864','551016',
'551994','552347','552417','594940','595833','597103','597470','598234','598589','598919','599340','599355',
'650991','651309','651627','651767','651913','652156','652206','652468','652610','652815','652831','653446',
'653726','653800','654320','654801','654853','655490','655617','717234','717420','717422','717622','717963',
'718434','719066','719352','719505','720265','720711','721055','721302','753926','753978','754275','754445',
'754455','754639','754640','754757','755094','755239','755317','755863','755865','756163','756226','756358',
'756389','756933','757089','757168','757178','757252','757307','757311','757350','757825','801323','801330',
'801519','801696','801759','801778','801782','801963','802127','802152','802399','802414','802816','802835',
'803002','803010','803622','803741','803746','804076','804128','804345','804683','804684','804685','805207',
'805294','851757','852198','852283','852302','852565','852654','853008','853206','899310','899883','900464',
'900471','900619','900631','900807','901032','901043','901053','901224','901321','901432','901511','901561',
'901771','901854','901957','901959','942322','974274','974576','975038','975607','975891','976222','976230',
'976631','977173','977199','977234','582077','582349','583939','584542','584544','584601','584841','584963',
'585603','587620','587638','588197','588210','589079','589134','589474','590330','590359','590720','590885',
'591016','592287','592464','592913','593416','594429','B03331','B03448','B04043','B04449','B04761','B04794',
'B05033','B05234','B05243','B05307','B05428','B05434','B05978','B06007','B06027','B06136','B06156','B06365',
'B32140','B32243','B32442','B32474','B32491','B33009','B33079','B33377','B33413','C89061','C89218','C89947',
'D34241','D34578','D35093','D35143','D35217','D35401','D35430','D35449','D35457','D35461','D35765','D35899',
'D35980','D36216','D37076','D37606','D75198','D75949','D76069','D76249','D76976','D78217','F09402','F10203',
'F10830','F11074','F11126','F11173','F11190','F11284','F11286','F12297','F12359','F12425','F43287','F43349',
'F43361','F43725','F44086','F44626','F44650','F44690','F44702','F45398','F90728','F91245','F91678','F91736',
'F91742','F91906','F92832','G26012','G26014','G26016','G26495','G57567','G58291','G97352','G97965','G98614',
'H32117','H33098','H83640','J20476','J58946','J59781','J59784','J61481','J61489','K44672','M11622','Q23760',
'T90491','V28740','W30072','W61671','BL8321','BL8550','001310','002438','041053','042052','043707','082848',
'083506','083960','084026','147627','147985','224915','225292','225660','256651','329427','363707','426262',
'427300','428639','453744','454237','455381','455428','456244','492996','493233','531362','532585','532626',
'533400','533596','572689','573017','573938','574365','574412','574681','574738','574742','575107','575298',
'575413','575688','575825','622938','623628','623653','624217','624566','624912','625181','625233','625397',
'625711','626177','626196','626820','665090','665341','665380','665693','665706','666338','666469','666850',
'666949','667249','667418','667816','668406','668654','669045','669087','669245','669393','712529','712563',
'712607','712625','712636','712669','713049','713279','713297','713323','713407','713474','713481','713545',
'713622','713708','713723','713892','714070','714251','714545','714565','714566','714801','714812','714867',
'715105','715183','715316','715422','715445','715701','715757','715767','716178','716187','716383','745108',
'745396','745428','745457','746669','746677','746714','746741','746874','747428','747433','747440','747501',
'747556','747561','747705','747842','747986','748073','748137','748919','792862','793204','793279','793366',
'793384','793562','794233','794374','794510','794558','794696','794840','795017','795225','795282','795884',
'795986','796205','796348','796398','796421','796482','796505','796595','796932','825901','826070','826208',
'860940','860975','861015','861053','861325','861374','861411','861705','861730','861779','861907','862070',
'862095','863189','863413','863584','863939','864145','864156','864216','864249','864286','864311','864720',
'864779','902682','902712','903179','903278','903561','903630','903946','903951','904049','904091','904343',
'904501','904899','905191','905387','905574','905788','905878','935612','967603','514238','514245','514757',
'515364','517836','518642','520052','520076','520082','520135','609776','612226','612749','613119','613632',
'613706','615117','615850','616263','617245','618221','618663','620064','620095','620300','B13500','B13578',
'B13837','B13940','B14082','B14168','B14450','B14510','B14750','B14982','B15029','B15607','B15682','B15711',
'B16084','B16313','C85866','D10466','D10981','D11699','D12271','D12315','D12387','D12469','D12541','D13095',
'D13559','D44439','D45164','D45173','D45979','D46510','D46613','D46669','D46685','D46955','D47041','D47094',
'D47251','D47410','D47459','D82853','D83482','D83921','D83991','D83994','D84344','D84796','D84990','F24016',
'F24645','F24663','F24826','F25171','F25244','F25321','F25524','F25717','F25761','F25835','F49937','F50163',
'F50638','F50732','F51118','F51614','F52368','F52375','F52981','F53096','F87263','F87554','F87649','F88169',
'F88429','F88595','F89357','F90609','G22149','G22444','G22682','G23530','G89410','G92708','H92375','H92532',
'J33298','J62197','J63423','K30159','K30228','K30916','K67433','K93700','K96720','L25831','L62021','M43302',
'M46501','M46543','M87062','N31743','N74626','Q96057','R36321','T15218','T97439','T98200','T98725','V32720',
'X22088','CL5385','CV0057','014574','059451','060089','060429','060594','102482','103981','103983','104827',
'105009','144293','181051','182654','182679','183437','281824','281870','352537','430171','431037','431411',
'467729','469465','511669','562954','563817','563837','563920','564234','564381','564510','564666','564686',
'565063','565065','565110','565149','565209','565406','565665','565793','618033','618284','618428','618464',
'618892','619658','619733','620261','620823','621570','669814','669882','670716','671097','671160','671230',
'671657','671788','672115','672125','672438','673284','673504','673553','673580','673584','673641','674124',
'674131','731601','731886','731941','731985','732133','732163','732166','732181','732371','732521','732524',
'732533','732568','732581','732675','732774','732803','732835','733121','733138','733141','733336','733418',
'733539','733541','733554','733745','733802','734070','734344','734361','734584','734698','734709','734759',
'734830','735005','735036','735055','735532','735713','735741','788783','788843','788903','788944','789211',
'789266','789412','789518','789610','789694','790149','790391','790721','791042','791118','791628','791695',
'791718','791740','792332','792561','792576','813808','814133','814189','814294','814553','814683','814757',
'815047','815192','815425','815432','815448','815708','815881','816008','816815','816824','817124','817315',
'817466','857414','857501','857659','857800','858475','858526','858528','858877','859308','859651','859724',
'859775','859970','860087','860370','860440','860757','910961','911367','911397','911435','912367','912718',
'950384','950495','951006','951383','951482','951583','951751','952310','952357','952861','953315','991441',
'991539','991863','992357','992989','993328','993790','994268','597247','597489','598062','598760','603176',
'605533','605816','606703','606732','606956','608737','B06498','B06614','B06821','B06864','B07390','B07510',
'B08025','B08115','B08364','B08920','B09276','B09282','B09411','B09484','B09519','B09556','B26918','B26955',
'B26994','B27203','B27552','B27702','B27755','B27831','B27851','B28217','B28219','B28468','B28771','B28794',
'B28818','B28868','B28878','B28879','B29424','B29514','B30068','D07109','D07525','D07538','D07605','D07619',
'D07704','D08595','D08788','D09277','D09426','D09602','D41327','D42437','D42888','D42941','D43501','D43819',
'D43841','D43885','D78754','D79784','D79832','D80644','D81150','D81305','D81489','F13462','F13539','F13595',
'F14090','F14571','F14868','F14895','F15001','F15663','F54546','F55447','F55525','F56009','F56065','F56155',
'F56273','F56523','F56524','F56557','G35764','G36251','G36361','G37758','G38317','H45540','H87307','J10226',
'K62107','L03280','P16993','Q19935','R42862','S92208','T71379','W94043','X36090','BN7771','CH4022','CH5490',
'CM0095','027615','027787','029489','054840','055393','055526','056153','101565','130634','131621','132056',
'132331','132400','156557','157767','157769','158277','195388','220452','251714','288705','314400','383588',
'404188','444756','446104','470255','470272','471319','472842','473109','499354','499654','500076','501776',
'502213','503161','553355','553400','553401','553580','553591','554263','555380','555418','555842','555858',
'555941','556421','557275','557353','557454','557491','557675','590396','590637','590692','590695','590709',
'590889','591113','591983','591999','592134','593236','593291','593295','593302','593414','593761','627149',
'627152','627709','628374','628390','628475','630044','630062','630896','631037','631156','631226','656017',
'656055','656348','657342','657792','658048','658087','658260','658513','658537','659265','659290','659353',
'659362','659565','659647','659894','697848','697907','698959','699218','699225','699486','699506','699624',
'700357','700455','700574','700611','700772','700798','701193','701489','702005','702051','702060','702197',
'702215','702294','702478','702538','702614','735772','735773','735966','736059','736325','736574','736767',
'737024','737036','737469','737514','737763','737827','737867','737900','738550','738614','738781','738921',
'739053','739105','739206','739219','739225','739378','739433','739541','739614','739619','739623','739681',
'739802','740073','740203','775648','775899','775900','775927','775961','775974','776010','776181','776354',
'776443','776534','776702','776784','776968','776977','777213','777397','777476','777558','777684','777715',
'777808','777811','777816','777818','777824','777865','777908','777935','778160','778267','778296','778837',
'779087','779222','779336','779340','779504','779518','779591','779619','779690','779788','779794','779904',
'797376','797436','798026','798063','798376','798583','798589','798826','798848','799160','799284','799320',
'799589','799677','799696','800032','800037','800061','800226','800663','801148','801164','841540','841556',
'841948','864918','864994','865077','865271','865294','865567','865685','865727','866109','866122','866236',
'866242','866266','866342','866345','866561','866617','866648','866879','866932','867266','867298','867305',
'867329','867594','867643','868020','868237','868282','868339','868455','868481','868565','895885','896077',
'896130','896453','896571','896768','896802','896870','896885','897121','897172','897509','897558','897797',
'897798','897807','897850','897858','897877','897888','897926','897964','898206','898570','898580','898632',
'898684','898931','920668','922716','954069','954213','954378','954567','954635','955028','955155','955323',
'955324','955440','955591','955817','955837','955982','955998','956394','956781','977702','977757','978004',
'978425','978691','978906','979294','979334','979484','979862','980153','980366','980631','545545','546357',
'546475','548674','549549','550562','551009','551230','551285','552266','552472','553511','554660','555759',
'B16754','B17166','B17765','B17805','B17828','B17878','B18102','B18386','B19199','B19713','B19761','B19780',
'B19786','B19821','C96866','C97028','C97068','C97367','C98189','C98214','C98631','C98859','C99265','C99390',
'C99473','D31084','D31419','D31555','D32110','D32504','D32523','D32631','D32760','D32919','D33053','D33080',
'D33086','D33254','D33297','D33635','D34196','D58255','D58404','D58816','D59091','D59106','D59193','D59299',
'D59372','D59766','D59898','D60213','D60315','D60329','D60396','D60434','D60577','D85569','D86267','D86619',
'D86623','D86728','D87029','D87706','D87879','D88192','D88297','D88315','F35153','F35219','F61378','F61786',
'F62081','F62791','F85830','F86276','F86282','F86538','F86791','F87154','G16673','G45291','G45896','G81460',
'H39124','H61120','H63627','J55123','J55303','J57088','J57978','K45011','L84292','L84391','L84435','M32699',
'M32762','M71421','N14619','P19444','W27429','W99946','BQ4304','CF2127','CV5216','018226','019545','127571',
'128527','163855','190486','190648','191626','192143','192228','192349','302850','302873','378065','378468',
'378663','439990','440181','440791','477151','478665','479480','479659','504869','505033','507781','508260',
'568018','568107','568156','568175','568214','569269','570286','570757','570759','571194','571323','612651',
'613723','613820','614167','614172','614303','614813','615197','615613','615672','616300','616707','660494',
'660500','660693','660717','661048','661120','661536','661911','662552','662559','662694','662754','662755',
'662797','662905','662910','663459','663865','663916','663921','663927','664036','664319','664723','721895',
'721915','722087','722109','722198','722211','722491','722680','722810','722854','723054','723100','723265',
'723448','723643','723759','723763','723765','723767','723768','723771','723772','723776','723778','723848',
'723994','724503','724589','724708','724782','724842','725082','725409','725691','725798','725956','726073',
'726178','726204','726216','771329','771462','771693','772000','772006','772276','772380','772416','772436',
'772860','773071','773268','773307','773368','773435','773470','773635','774107','774259','774456','774664',
'774994','775022','775165','775258','805370','805383','805680','805705','805885','805910','805981','806290',
'806451','806559','806571','806754','806922','806964','807123','807182','807257','807347','807457','807524',
'807602','807831','807872','808157','808511','808652','808847','880512','880684','880808','880865','881168',
'881303','881469','881472','881674','881796','881798','882229','882260','882463','882588','882782','882790',
'882875','883173','883232','883391','883399','883426','883471','883526','883822','884371','884418','925285',
'925567','957855','957893','958310','958322','958785','959784','959824','959834','959924','959931','959941',
'959964','959982','960173','960244','981317','981401','981428','982297','982439','982619','982658','982674',
'982726','983600','983641','983943','569600','569939','570345','571768','572408','572791','573102','573346',
'573736','575634','575653','578141','578347','581867','682666','683730','683764','684202','684745','685063',
'685723','686987','687062','688829','B00130','B00340','B00351','B00356','B00681','B20402','B20453','B20711',
'B20771','B20806','B20855','B20899','B21247','B21551','B21650','B21686','B21695','B22050','B22347','B22560',
'B22955','B23009','B23104','B23299','B23382','B23410','B23415','C89999','C90130','C90161','C90510','C90933',
'C91297','C91387','C92204','C93135','C93150','D27542','D28117','D28659','D29745','D29895','D29913','D29969',
'D61745','D61749','D61768','D61775','D62608','D63295','D63562','D64123','D64270','D92909','D92923','D92945',
'D92997','D93001','D93219','D93347','D93372','D93779','D93809','D93875','D93877','D94055','D95182','D95307',
'F26354','F27025','F27207','F27337','F27799','F27990','F63484','F64219','F64565','F64895','F64959','F65838',
'F65860','G33428','G33790','H03584','H04061','H04299','H47718','H49893','H75349','H75743','K50794','K91621',
'L94392','L94404','M28618','N46362','R20045','CN2934','CW2065','039668','040159','040280','080046','081620',
'123009','123169','123769','123954','124009','124567','125533','171036','171241','172680','272686','273232',
'273972','424568','425396','474627','475673','475710','543822','543963','547146','608941','610051','610382',
'688536','688721','688862','689141','689210','689249','689550','689907','689974','690124','690138','690140',
'690144','690254','690516','690663','690816','691022','691088','691830','691996','692566','758112','758252',
'758298','758299','758303','758305','758563','758568','758750','759239','759364','759595','759610','760322',
'760343','760376','760516','760520','760549','760628','760674','760684','760757','760885','760909','760910',
'761273','761276','761492','761616','761621','761921','762037','762288','762382','836366','888701','888800',
'888901','888987','888992','889068','889129','889141','889142','889475','889548','890377','890510','890634',
'890664','890755','890969','891135','891140','891253','891568','891613','943551','944431','944567','945508',
'945687','946019','946280','946368','946472','946629','946699','994979','324515','492923','494258','494974',
'495100','495650','496950','498958','B47676','B47710','B47794','B48098','B48104','B48205','B48221','B48233',
'B48239','B48244','B48258','B48280','B48728','B49444','B49839','B49870','B49946','B50589','D20826','D20919',
'D21376','D21690','D21947','D22004','D22315','D22548','D22708','D22791','D22899','D23223','D68648','D68699',
'D69706','D70117','D70197','D70393','D70896','D71180','D71208','F19834','F20073','F20118','F20530','F22016',
'G19891','G77187','G78280','G78281','G78284','G78288','G78290','G78741','H26880','H28315','M74951','M76994',
'N21415','P89988','Q29818','Q68027','R09349','S95385','BW1926','CY1413','003461','004687','005290','005408',
'005454','062455','062685','107781','108454','153941','154961','155756','156285','211024','212553','212963',
'312891','420869','421698','461883','522052','523484','524127','599775','600849','600854','602297','602298',
'674382','675481','676194','676547','676754','676790','677045','677055','677154','677334','677937','678205',
'678470','678491','678557','678943','741083','741331','741801','742034','742193','742194','742315','742495',
'742815','743012','743485','743715','744544','744603','876567','876787','877139','877375','877399','877567',
'877623','877857','877861','878372','878658','878853','879064','879080','879129','879149','879388','879644',
'879731','880108','880193','880379','930299','930376','930990','932905','502124','503554','504144','504166',
'505767','506545','507019','507077','507146','508113','508192','508356','509210','509631','510512','510559',
'510712','510717','673410','673523','673533','675145','675261','676520','677879','678235','679817','D13880',
'D13910','D13958','D14260','D15197','D15596','D15705','D15710','D17040','D68189','F17014','F18925','F18977',
'F19216','F19247','G07738','G07739','G10838','G10922','G59804','G60374','G60971','H13819','H15415','H16031',
'H16066','H65896','J16246','J16925','K25624','N10493','Q44023','V21051','V67825','W71427','BP1212','BP1258',
'CG8288','CM7623','007204','008261','009197','009615','051167','052525','086146','139495','140881','186324',
'230916','271407','437543','437946','481545','481640','482156','483298','526320','526826','527089','527162',
'577812','641488','642123','642203','642212','642287','642290','642292','643056','643061','643190','643469',
'643999','644439','644493','644511','644526','644666','644975','645223','645323','645442','645589','693264',
'693629','693905','693951','694022','694077','694316','694581','694588','694812','694844','694908','695005',
'695029','695042','695047','695055','695092','695155','695300','695409','695738','695781','696021','696150',
'696817','696889','696890','696940','697299','697434','762522','762956','763345','763667','764005','764021',
'764026','764077','764992','765489','765497','765552','765693','765947','766076','766102','766506','809537',
'809708','809710','809896','809968','810219','810317','810397','810885','810937','811300','811518','811616',
'811659','811840','811960','812049','812224','812225','812278','812367','812408','812489','812565','812842',
'813042','813176','813208','813236','813257','813594','872667','873184','873390','873599','873710','873885',
'873920','873938','874357','874435','874709','875598','875663','875746','875839','875942','876015','912990',
'913278','960671','961547','961807','961930','962767','963129','963530','963752','522102','522539','523499',
'523595','524888','525294','525335','525448','526522','526594','527323','529998','530191','530447','532238',
'693136','693452','694060','694301','695899','697300','697322','697401','697827','697841','698581','702027',
'702175','702439','702553','703089','703239','B34168','B34207','B34323','B34656','B35037','B36825','B36921',
'B82747','B82752','D03926','D04037','D04493','D04967','D05328','D05596','D05834','D05874','D06454','D06875',
'D06912','D47864','D47883','D48114','D48517','D48747','D49224','D49501','D49821','D50056','D50143','D50450',
'D51114','D99034','D99051','D99174','D99181','D99219','D99241','D99470','D99604','D99825','D99925','F00334',
'F00814','F01003','F01150','F01170','F01184','F01511','F01525','F01529','F01747','F01794','F02060','F42197',
'F42208','F42254','F42380','F42574','F42625','F42925','F78317','F78515','G28612','G28869','G29281','G29324',
'G30844','H11056','H12162','H12373','H12415','J41189','J41357','J43272','J44389','J87809','K71955','L15874',
'M14735','R31498','S43828','S87676','T67049','T67286','BP4919','CD9030','CN7476','CS1821','075822','076180',
'150917','197847','238724','239091','323428','415741','417718','418155','418218','457108','457942','459594',
'518176','519493','581148','581316','581317','581737','582067','582355','582362','582744','583563','583721',
'583725','583813','583854','584440','584532','585124','646085','646222','646725','646911','646971','646972',
'647444','647628','647754','648034','648352','648809','648811','648813','649298','649676','650006','650397',
'650445','650918','702650','702694','702736','702741','702797','702957','702967','703044','703061','703065',
'703107','703143','703323','703798','703814','704281','704920','704931','705392','705411','705675','706217',
'706296','706347','706465','706531','706536','706609','706867','766791','766884','766897','767308','767311',
'767748','767841','767987','768033','768115','768171','768234','768246','768413','768433','768440','768514',
'768520','768621','768634','768669','768857','769049','769080','769272','769273','769824','769877','769941',
'769983','769993','770122','770139','770265','770345','770693','770753','817933','818500','818552','818560',
'818585','818681','818929','819016','819045','819356','819433','819453','819877','820064','820361','820789',
'820812','821042','821106','821160','821190','821269','821528','821588','869061','869647','869858','869860',
'869913','870011','870015','870123','870157','870272','870538','870600','870675','870694','870748','870953',
'871044','871165','871202','871205','871247','871585','871594','871870','871968','871973','871994','872191',
'872254','872322','917326','917627','918720','919288','964274','965671','965991','966306','966355','966357',
'966679','966747','966863','534485','536281','536315','537837','538110','538284','538312','538911','539341',
'539622','540902','544361','B09870','B10753','B11141','B11978','B11979','B12077','B12390','B44482','B44952',
'B45019','B45513','B45584','B45901','B45945','B46726','B47055','D24043','D24244','D24269','D24415','D24673',
'D24733','D24841','D24869','D26241','D26291','D26918','D26954','D27222','D27257','D71787','D72070','D72535',
'D72673','D72836','D72868','D73160','D73210','D73393','D73510','D74319','D74633','F02519','F02581','F04584',
'F05251','F05474','F05538','F05549','F48258','F49413','F49801','G04280','G05018','G05026','G05855','G48595',
'G48619','G48668','G49798','G95741','G96011','J24179','J25855','J67863','K56140','M41835','M42217','M82456',
'M84952','N54351','Q79402','R54507','T12387','T59366','W14751','CM6057','CM6908','CW7599','010805','011766',
'012763','012911','013241','070933','122247','168527','168646','169034','169858','237237','386861','432982',
'434869','487423','489274','489423','489929','558000','558380','558426','558870','558998','559688','559796',
'559802','560619','560622','560808','560814','560875','561330','561373','561383','561392','631651','632075',
'632078','632158','632648','632824','632928','633726','634087','634094','634358','634472','634501','634533',
'634826','634896','634946','635157','635199','635295','635311','635356','635680','635726','635801','635838',
'636203','636327','707509','707544','707814','707831','707844','707900','707916','708066','708091','708133',
'708486','708804','708866','708873','709063','709141','709397','709577','710139','710439','710455','710457',
'710479','710486','710632','710745','710811','710813','710898','711103','711115','711194','711195','711196',
'711343','711535','711721','711819','711868','712006','712133','712245','712252','712254','712283','784410',
'784424','784661','784774','784947','785084','785212','785228','785391','785466','785649','785819','786113',
'786152','786208','786257','786259','786287','786494','786603','786608','786609','786919','786934','786954',
'787188','787192','787194','787344','787393','787402','787444','787823','787830','788080','788267','788366',
'788585','788633','892414','892418','892426','892434','892569','892570','893247','893795','894155','894260',
'894331','894369','894427','894626','894723','894801','894804','894940','895729','895822','936868','937468',
'984461','984578','984719','984922','985078','985109','985848','986791','987337','623181','623583','623611',
'624257','625446','627443','631089','631593','B40521','B40523','B40614','B40621','B40658','B40711','B41215',
'B42279','B42294','B42630','B42958','B43367','B43697','D01321','D01865','D02610','D03442','D03506','D54712',
'D54738','D55584','D56106','D56177','D56309','D56430','D56447','D56530','D56631','D56632','D56906','D57152',
'D57294','D57402','F05720','F05786','F05812','F06659','F07175','F07438','F08700','F08897','F08927','F56850',
'F56946','F57624','F58004','F59093','F59144','F59698','F60010','G11175','G11969','G12586','G12952','G13024',
'G13148','G13808','G13815','G13857','G13864','G13871','G13959','G14164','G14196','G66334','G66338','H16734',
'H17731','J74692','L36536','M61352','M62681','M63428','N08515','P62183','S29849','X30476','DB7199'
)

/*
2) se busca a los clientes en la base de Mesa WEB
2.1) con el query select * from Custodia..RelRaizCliente where ClienteNro = 'xxxxxx' ===> se busca la raíz para el cliente
2.2) con la raíz se busca la cuenta custodia ==>  select * from Custodia.._Cuenta where AdhNro = xxxxx
2.3) con la cuenta comitente obtenida del query anterior se busca el saldo ===>  select * from Custodia.._SaldoCtaEsp
where CtaNro = 500019169 and IndiVigencia = 'S'  
and FSaldo >= '2022-01-01'
and FSaldo <= '2022-12-31' order by FSaldo desc

3) si tuviesen saldo, se informan los clientes cuyo saldo es:
 
     Persona Física con saldo al 31/12/2022 de + 50000 dolares
     Persona Jurídica con saldo al 31/12/2022 de + 200000 dolares
*/

select *
from #tmp t
inner join Custodia.._Cuenta c
on t.RaizNro = c.AdhNro
inner join Custodia.._SaldoCtaEsp s
on c.CtaNro = s.CtaNro
where --s.CtaNro = 500019169 and
s.IndiVigencia = 'S'  
and s.FSaldo between '2022-01-01' and '2022-12-31'
order by s.FSaldo desc

*/