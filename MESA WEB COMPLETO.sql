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