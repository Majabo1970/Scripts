use cob_bcradgi
go

select * from bc_tabrel_form where ss_tabla = 'bc_tributa_afip'

select *
from    bc_tabrel_form
where ss_tabla          = 'bc_imp_regimen'

select *
from    bc_tabrel_form
where ss_cod_tabla = 24

select * from bc_catrel_form where cs_cod_tabla = 24

select  top 1000 count(1), ex_modulo from bc_exentas_dc
group by ex_modulo

select * from bc_exentas_dc

select top 100 * 
from  cobis..cl_parametro
where pa_producto = 'BCR'
and   pa_nemonico = 'TIDC'

select top 1000 * from cobis..cl_ente

select *
            from bc_catrel_form
            where cs_cod_tabla  = 24
            and   cs_cod_modulo = '08'
            and   cs_estado     = 'V'

select * from bc_impuesto_alicuotas
where ia_impuesto = 'DEBCRE'
order by ia_servicio

SELECT ss_cod_tabla
FROM   bc_tabrel_form
WHERE  ss_tabla = 'bc_imp_regimen'
AND    ss_nro_formulario = 'DECRED'

select top 10 * from bc_fec_formulas

cob_bcradgi..sp_help bc_decred_modulos
cob_bcradgi..sp_help bc_decred_procura
cob_bcradgi..sp_help bc_decred_salida

cob_bcradgi..sp_helptext bc_v_crm_impuesto, null, null, showsql

select count(1) from cob_bcradgi..bc_decred_modulos
where dc_modalidad <> null

select count(1) from cob_bcradgi..bc_decred_modulos
where dc_modalidad <> null
and   dc_estado in ('I','E')

select top 20 * from cob_bcradgi..bc_decred_modulos
where dc_modalidad <> null
and   dc_estado in ('I','E')

select * from cob_bcradgi..bc_decred_modulos
where dc_nro_identif in ('33709965579','30710831099','30568457451')
and   dc_modalidad <> null

update cob_bcradgi..bc_decred_modulos set
dc_estado = 'I'
where dc_modalidad <> null

select top 20 * from cob_bcradgi..bc_decred_salida
where sa_modalidad <> null

select top 20 * from cob_bcradgi..bc_conc_2627
where co_modulo in (3,4)

use cob_concent
go

cob_concent..sp_help

select top 20 * from cob_bcradgi..bc_conc_2627
where co_modulo = 4

select top 20 * from cobis..cl_tabla
select top 20 * from cobis..cl_catalogo

select top 20 * from bc_fec_formulas
where ff_nro_formulario = 'DECRED'
order by ff_fecha_informac desc

update bc_fec_formulas set
ff_estado_form = 'FD'
where ff_nro_formulario = 'DECRED'
and   ff_fecha_informac = '01/31/2022'

select top 20 * from bc_decred_salida
where sa_modalidad <> null

select top 20 * from bc_decred_modulos
where dc_modalidad <> null
and   dc_estado <> 'P'

use cob_bcradgi_his
go

select top 20 * from bc_decred_modulos_his
where dc_modalidad <> null

      select codigo
      from  cobis..cl_tabla
      where tabla = 'bc_DECRED_CC'

      select codigo
      from  cobis..cl_tabla
      where tabla = 'bc_DECRED_AH'

      select codigo, valor
      from  cobis..cl_catalogo
      where tabla = 3878
      order by valor

select count(1) from  bc_decred_modulos 
where dc_fecha_valor between '01/01/2022' and '01/31/2022'
and   dc_modalidad <> null
and   dc_estado in ('I','E')

select top 50 * from  bc_decred_modulos 
where dc_fecha_valor between '01/01/2022' and '01/31/2022'
and   dc_modalidad <> null
and   dc_estado in ('I','E')

update top 500 bc_decred_modulos set
dc_modalidad = '3'
where dc_fecha_valor between '01/01/2022' and '01/31/2022'
and   dc_modalidad = null