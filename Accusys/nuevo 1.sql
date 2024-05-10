SQR 70592

time sqr -DEBUG -XP -XB -TB bc_pciotransf_genera_arch.sqr $login/$pwd 1 06/30/2023 T

time sqr -DEBUG -XP -XB -TB bc_pciotransf_genera.sqr $login/$pwd 02/28/2023 0 I PCIOTRANSF 1 02/28/2023
06/30/2023
0
'I'
'PCIOTRANSF'
1
06/30/2023

time sqr -DEBUG -XP -XB -TB bc_pciotransf_modulos.sqr $login/$pwd 1 I 2 06/30/2023 03/06/2018

sqr -RS -XB bc_pciotransf_modulos.sqr $login/$pwd

-------------------------------------------------------------------------
use cob_bcradgi
go


declare

@i_fecha_inf         datetime     ,
@i_c_formula         varchar(10)  ,
@i_opcion            char(1)


select @i_fecha_inf = '01/31/2023',
       @i_c_formula = 'PCIOTRANSF',
       @i_opcion    = 'P'

exec sp_pciotransf_clientes @i_fecha_inf, @i_c_formula, @i_opcion

exec sp_pciotransf_clientes 
       @i_fecha_inf = '01/31/2023',
       @i_c_formula = 'PCIOTRANSF',
       @i_opcion    = 'T'



-------------------------------------------------------------------------

03/06/2018

use cob_bcradgi
go


select A.pe_ente, B.cl_cliente
from  cob_bcradgi..bc_pciotransf_entes A,
      cobis..cl_cliente B
         
where A.pe_ente = B.cl_cliente




select top 20 A.pe_ente as ENTE, B.cl_cliente as CLIENTE, B.cl_det_producto as CLI_PRO, C.dp_det_producto as DET_PRO
from  cob_bcradgi..bc_pciotransf_entes A,
cobis..cl_cliente B,
cobis..cl_det_producto C
where A.pe_ente         = B.cl_cliente
and B.cl_det_producto   = C.dp_det_producto
and C.dp_estado_ser     = 'V'
--and C.dp_producto       not in (5,18,19)
and B.cl_fecha           between '01/01/2023' and '02/28/2023'


use cobis
go

sp_help cl_det_producto

select top 10 max(len(rtrim(dp_cuenta))) from cl_det_producto

------------------------------------- ACTIVOS ----------------------------------------------------------------------
select 
      A.pe_f_informacion         , -- 1
      A.pe_ente                  , -- 2
      C.dp_det_producto          , -- 3
      C.dp_producto              , -- 4 
      C.dp_cuenta                , -- 5
      C.dp_estado_ser            , -- 6
      B.cl_rol                   , -- 7
      C.dp_oficina               , -- 8
      C.dp_fecha                 , -- 9
      getdate()                    -- 10
   from  cob_bcradgi..bc_pciotransf_entes A,
         cobis..cl_cliente B,
         cobis..cl_det_producto C
   where A.pe_ente         = B.cl_cliente
   and B.cl_det_producto   = C.dp_det_producto
   and C.dp_estado_ser     = 'V'
   and C.dp_producto       not in (5,18,19)
   

pe_f_informacion            pe_ente     dp_det_producto dp_producto                      dp_estado_ser cl_rol dp_oficina dp_fecha                                                
--------------------------- ----------- --------------- ----------- -------------------- ------------- ------ ---------- --------------------------- --------------------------- 
Jun 30 2023 12:00AM         6915998     34335617        110         000018018            V             T      540        Dec 15 2011 12:00AM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         7347388     37715961        4           474809470583576      V             T      748        Nov 2 2012 12:00AM          Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         7347388     37725355        16          4517642480605002     V             P      748        Nov 2 2012  5:25PM          Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         7347388     55386425        104         40755                V             T      748        Mar 27 2017 12:00AM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         8381472     10748382        3           354009401396921      V             Z      540        Feb 12 2008 12:00AM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         8713023     51407125        4           432309487279473      V             T      323        May 13 2016 12:00AM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         8713023     53326399        4           232309489585781      V             T      323        Oct 17 2016 12:00AM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         8713023     53382176        16          4517644091464001     V             P      323        Oct 20 2016  5:12PM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         9032711     54650272        4           234809491245714      V             A      348        Jan 26 2017 12:00AM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         8916571     53663415        4           239909490101569      V             T      399        Nov 10 2016 12:00AM         Mar 2 2023  6:33PM          
Jun 30 2023 12:00AM         8916571     54435031        4           439909491031261      V             T      399        Jan 10 2017 12:00AM         Mar 2 2023  6:33PM          


------------------------------------- SIN RELACION----------------------------------------------------------------------

   select
      A.pe_f_informacion         , -- 1
      A.pe_ente                  , -- 2
      C.dp_det_producto          , -- 3
      C.dp_producto              , -- 4
      C.dp_cuenta                , -- 5
      C.dp_estado_ser            , -- 6
      B.hi_rol                   , -- 7
      C.dp_oficina               , -- 8
      C.dp_fecha                 , -- 9
      C.dp_fecha_modificacion      -- 10
   from  cob_bcradgi..bc_pciotransf_entes A,
         cobis..cl_cliente_his B,
         cobis..cl_det_producto C
   where A.pe_ente           = B.hi_cliente
   and   B.hi_det_producto   = C.dp_det_producto
   and   C.dp_estado_ser     = 'V'
   and   C.dp_producto       not in (5,18,19)
   and   B.hi_fecha          between '01/01/2023' and '06/30/2023'
   and   B.hi_cliente not in ( select cl_cliente from cobis..cl_cliente CL, cobis..cl_det_producto DP
                           where CL.cl_cliente        = DP.dp_cliente_ec
                           and   CL.cl_det_producto   = DP.dp_det_producto
                           and   DP.dp_producto       not in (5,18,19)
                           and   CL.cl_fecha          > B.hi_fecha)



select top 20 count(1) Q,cl_fecha from cl_cliente
group by cl_fecha
order by cl_fecha desc

Q           cl_fecha                    
----------- --------------------------- 
3           Feb 13 2023 12:00AM         
1           Feb 7 2023 12:00AM          
1           Feb 1 2023 12:00AM          
1           Jan 27 2023 12:00AM         
3           Jan 26 2023 12:00AM         
34          Jan 13 2023 12:00AM         
166         Jan 11 2023 12:00AM         
18          Jan 10 2023 12:00AM         
1           Jan 9 2023 12:00AM          
91          Jan 6 2023 12:00AM          
1           Jan 2 2023 12:00AM          
1           Dec 29 2022 12:00AM         
3           Dec 28 2022 12:00AM         
2           Dec 27 2022 12:00AM         
1           Dec 26 2022 12:00AM         
1           Dec 23 2022 12:00AM         
1           Dec 21 2022 12:00AM         
1           Dec 15 2022 12:00AM         
1           Dec 12 2022 12:00AM         
1           Dec 5 2022 12:00AM          

set nocount on

update bpe
set pe_tdoc = id_tipo,
    pe_ndoc = convert(varchar(16), id_numero)
from cob_bcradgi..bc_pciotransf_entes bpe
join cobis..cl_identificacion ci
on ci.id_ente = bpe.pe_ente
and ci.id_secuencial = (select distinct min(id_secuencial)
                        from cobis..cl_identificacion
                        where id_ente = bpe.pe_ente)
where bpe.pe_ente > @w_rowcount_actualizado