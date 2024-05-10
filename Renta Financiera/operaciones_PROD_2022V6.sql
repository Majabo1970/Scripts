declare @PFDesde datetime ='20230101', @PMes int =1
--as
--BEGIN 

DECLARE @mes int = 12
Declare @Fecha datetime = '20230101'
Select @PFDesde = @Fecha, @PMes = @mes

declare @FHasta datetime = (select dateadd(second,-1,dateadd(month,@PMes,@PFDesde)))

/*Obtenemos las especies que son Titulos y Acciones*/
SELECT  EspAbrev 
into #esp
FROM  Custodia.._RelEspGrupo  r WITH(NOLOCK) , 
      Custodia.._ItemsDeTablas i  
WHERE r.GrEspCod = i.ItemCod 
      and r.CptoCod = 1
      AND i.TablaId = 221  
      and ItemCod in (1,2);

/*Identificamos todas las operaciones a excluir, Pases, de Mercado etc..*/
with cmt_Excluidos (MinManual) 
      as (SELECT distinct MinManual
            FROM PROD..VW_OPERACIONES_ALL  o WITH(NOLOCK) 
            WHERE  1=1
            AND FchVnc >= @PFDesde
            AND Tipo in ('Cmp','Vnta')
            and (MinManual in (select distinct NroOperacion from PROD..OPERACIONES_EXTRADATA  WITH(NOLOCK)  where  NroOrden IS NOT NULL and FchVnc between @PFDesde and  @FHasta)
            OR MinManual in ( select distinct minmanual from PROD..PasesOp WITH(NOLOCK))
            or (Cliente ='MERCADO DE VALORES D')
            OR MinManual in (select isnull(o2.OpPrev,-1) from PROD..VW_OPERACIONES_ALL  o2 WITH(NOLOCK)  where o2.EspPpal =o.EspPpal and FchVnc between @PFDesde and  @FHasta)
            OR (Cliente in('MERCADO ABIERTO ELE', 'MERCADO DE VALORES D','MERCADO ABIERTO ELEC') and OpPrev IS NOT NULL)
            or Tr in ( select Tr from PROD..FCI WITH(NOLOCK)))
            and AdhNro <> 380109
            and MinManual not in (select MinManual 
                                    from PROD..VW_OPERACIONES_ALL o1  WITH(NOLOCK)
                                    where o1.OpPrev is not null
                                    and o1.Cliente in ('MERCADO ABIERTO ELE', 'MERCADO DE VALORES D','MERCADO ABIERTO ELEC')
                                    and FchVnc >= @PFDesde
                                    and not exists (select 1 from PROD..VW_OPERACIONES_ALL o2 WITH(NOLOCK) 
                                                      where o1.OpPrev = o2.MinManual))
            and EspPpal in (select EspAbrev from #esp))

/*Cargamos en la temporal las operaciones*/
SELECT  EspPpal as Tr,
        MinManual,
        FchOrg,
        FchVnc,
        Cliente,
        Tipo,
        CPpal,
        EspPago,
        Precio,
        Precio as PrecioPesificado,
        Precio as Valorizado,
        EstadoCod,
        Tr as TrEsp
into  #tmp
FROM PROD..VW_OPERACIONES_ALL  o WITH(NOLOCK) 
WHERE  1 = 1
    AND (FchVnc >= @PFDesde and  FchVnc < @FHasta)
    AND not exists (select 1 from cmt_Excluidos m where o.MinManual = m.MinManual)
    AND not (Tipo in ( 'AVnta','ACmp'))
    And not (MinManual in (select distinct MinManual from PROD..VW_OPERACIONES_ALL o4 WITH(NOLOCK)
                            where o4.EspPpal = o.EspPpal
                            and Tipo in ('TrfSal','TrfEnt','Ext')
                            and not (o4.Cliente like 'CARTERA ITAU%')))
    and EspPpal in (select distinct EspAbrev from #esp)
    Order by EspPpal,MinManual,FchOrg;
    

/*Borramos Especies y operaciones que no tenemos que tener en cuenta*/
delete from #tmp where MinManual in ( '6302159','6292492','6306466','6319121','6300779','6307032','6338027','6338465',
'6333609','6328910','6299901','6305731','6305957','6346232','6335585','6347997','6347718','6347987','6347098','6347373'
,'6347380','6347716','6347720','6569314','6568897', '6569039', '6569310','6428141','6415098','6569250','6569808','6600568',
'6470243','6479165','6507719')

--delete from #tmp 

delete from #tmp where Cliente = 'MERCADO DE VALORES D' 

insert into #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'MGCGO','9572912','20230510','Cmp','50000000','$','1';

insert into #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'T531O','9572918','20230405','Cmp','207003290','$','1.00190084';

insert into #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'MGCBO','9573117','20230715','Cmp','630839354','$','1';

Insert into #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'T2X2P  ','9599291','20230816','Cmp','36934576','$','2.62';

Insert into #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'CP25O.','9599298','20230321','Cmp','1000000','$','173';

Insert into #tmp (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'RCCMO','9599299','20230921','Cmp','207','$','744';
 

insert into #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'TX24P','9573117','20200520','Cmp','129482890','$','0.7075';
insert into #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'TX23P','9572917','20200512','Cmp',' 186372810','$','0.765';

insert into #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'TX23P','9573116','20200520','Cmp','43167535','$','0.7075' ; 

insert into #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'TX22P','9572916','20200512','Cmp','185644583','$','0.8575' ; 

insert into #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'T2X2P','9573120','20200520','Cmp','45353540','$','0.766649'     --se corrigio especie insert into #tmp(Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,Precio)
select 'TX21P','9572272','20200325','Cmp','1477932','$','0.745'         --se corrigio especie

 
delete from #tmp where Tr in ('$','7000','U$S','AGRO','AMZN')
delete from #tmp where Tipo in ('ACmp','AVnta','CorLiq');


/*Buscamos los valores del dolar para valorizar las especies en dolares*/
With Cmt_EspecieFecha (EspAbrev, FchMov, FchCierr) AS (
    SELECT C.Abrev, M.FchOrg , MAX(C.Fecha)
    FROM PROD.._Cierre C WITH(NOLOCK),
        (select Distinct EspPago, FchOrg  from #tmp where EspPago='U$S') M
    WHERE 1=1
    AND C.Abrev = M.EspPago
    AND C.Fecha <= M.FchOrg
    GROUP BY C.Abrev, M.FchOrg)

/*Calculamos el precio pecificado*/
UPDATE #tmp
SET PrecioPesificado = round( c.Cierr$ *m.Precio,8)
FROM  #tmp m, 
      Cmt_EspecieFecha t,
      PROD.._Cierre c WITH(NOLOCK) 
WHERE 1=1 
AND m.FchOrg = t.FchMov
AND m.EspPago = t.EspAbrev
and t.EspAbrev = c.Abrev
and t.FchCierr = c.Fecha

UPDATE #tmp  set EspPago='TN43O' where EspPago='TN430' 
UPDATE #tmp  set Tr='TN43O' where Tr='TN430' 
UPDATE #tmp  set Tr='U30G9' where Tr='L2DG9' 
UPDATE #tmp  set Tr='U13S9' where Tr='LTDS9' 
UPDATE #tmp  set Tr='S31L0' where Tr='LTPL0' 
UPDATE #tmp  set Tr='Y10A9' where Tr='Y10A9'
UPDATE #tmp  set Tr='S13S9' where Tr='WS13S'
UPDATE #tmp  set Tr='S29Y0' where Tr='WS29Y'

/*Calculamos el Valorizado*/    
update #tmp
Set PrecioPesificado = case EspPago when 'U$S' then PrecioPesificado else  Precio  end ,
      Valorizado = (CPpal*case  EspPago when 'U$S' then PrecioPesificado else  Precio  end)

/*Actualizamos el Tipo  ya que el mismo se invierte cuando */
update #tmp
set Tipo = (case Tipo when 'Cmp' then 'Vnta'
                      when 'Vnta' then 'Cmp'
                      else Tipo end)
where substring(TrEsp,1,3) <> 'Bls'
and Cliente like 'CARTERA ITAU%'

/*Operaciones Compra Venta*/
--Insert into Custodia..InfFIFO_Op (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,PrecioPesificado,Valorizado)
select
    a.Tr,
    a.MinManual,
    a.FchOrg,
    a.Tipo,
    a.CPpal,
    a.EspPago,
    a.PrecioPesificado,
    a.Valorizado
from #tmp a
inner Join  PROD..VW_OPERACIONES_ALL b WITH(NOLOCK)
on a.MinManual = b.MinManual 
where a.Tipo in ('Cmp','Vnta')
order by Tr, FchOrg, MinManual

/*Operaciones Transferencias, Extracciones, Cierres*/
--Insert into Custodia..InfFIFO_Op (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,PrecioPesificado,Valorizado)
select 
    Tr,
    MinManual,
    FchOrg,
    Tipo,
    CPpal,
    EspPago,
    PrecioPesificado,
    Valorizado
from #tmp p
where not Tipo in ('Cmp','Vnta')
order by Tr,FchOrg , MinManual

--END
--delete from Custodia..InfFIFO_Op
--drop table #esp
--drop table #tmp

------consulta PABLO OPERACIONES Y TRANSFERENCIAS

select
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
from #tmp a
inner Join  PROD..VW_OPERACIONES_ALL b
on a.MinManual=b.MinManual 
where a.Tipo in ('Cmp','Vnta')
order by Tr,FchOrg , MinManual

select  p.Tr,
        p.MinManual,
        p.FchOrg,
        p.Tipo,
        p.CPpal,
        p.EspPago,
        ''as PrecioPesificado,
        ''as Valorizado,
        p.EstadoCod,
        m.EstadoCod,
        m.CtaNro as CtaCobro,
        n.CtaNro as CtaPago,
        p.FchVnc,
        p.Cliente,
        O.Comentario
from #tmp p
INNER JOIN PROD..VW_OPERACIONES_ALL O WITH(NOLOCK)
ON O.MinManual = p.MinManual
left outer join PROD..VW_MOVFON_ALL m WITH(NOLOCK)
on p.MinManual = m.MinManual
and p.Tr = m.Abrev
and m.TipoCod = 'CB'
left outer join  PROD..VW_MOVFON_ALL n WITH(NOLOCK)
on p.MinManual = n.MinManual
and p.Tr = n.Abrev
and n.TipoCod = 'PG'
where  p.Tipo not in ('Cmp','Vnta')
order by p.Tr,p.FchOrg,p.FchVnc, p.MinManual