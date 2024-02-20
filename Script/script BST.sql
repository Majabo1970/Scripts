select top 100 * from bc_decred_salida
select count(1), dc_cod_regimen from bc_decred_modulos group by dc_cod_regimen order by dc_cod_regimen asc
select top 100 * from bc_impuesto_alicuotas where ia_impuesto = 'DEBCRE'
select * from  bc_imp_regimen

select * from bc_tabrel_form
inner join bc_catrel_form cf 
on tf.ss_cod_tabla = cf.cs_cod_tabla
 where ss_nro_formulario = 'DECRED'
 and cs_estado = 'V'

select * from bc_tabrel_form where ss_nro_formulario = 'DECRED'

select * from bc_catrel_form where cs_cod_modulo = '149'
sp_help bc_catrel_form

select top 100 * from bc_decred_modulos
select top 100 * from bc_decred_procura
select top 100 * from bc_decred_salida

select max(ia_identity) from bc_impuesto_alicuotas
select  *  from bc_impuesto_alicuotas where ia_impuesto = 'DEBCRE'
sp_help bc_impuesto_alicuotas

DECLARE
@w_fecha			datetime,
@w_identity			int

select @w_fecha = getdate()

select @w_identity   =  isnull(max(ia_identity),0) + 1
from bc_impuesto_alicuotas
print '@w_identity (%1!)',@w_identity
print '@w_fecha (%1!)',@w_fecha

select  *  from
bc_impuesto_alicuotas_trans
-------------------------------------------------------------
declare @w_tabla_nueva    INT,
        @w_tabla        CHAR(30) 

SELECT  @w_tabla = 'bc_imp_regimen'
SELECT  @w_tabla_nueva = ss_cod_tabla
FROM    bc_tabrel_form
WHERE   ss_tabla = @w_tabla
AND 	ss_nro_formulario = 'DECRED'

print 'Tabla_nueva (%1!)',@w_tabla_nueva

select * FROM bc_catrel_form WHERE cs_cod_tabla  = 18
select * FROM bc_tabrel_form WHERE ss_cod_tabla  = 18