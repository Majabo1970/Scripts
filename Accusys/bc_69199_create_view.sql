use cob_bcradgi
go

print '-----------------------------------------'
print 'AST 69199 - CREACION DE VISTAS DE TRABAJO'
print '-----------------------------------------'

declare
@w_n_error           int,
@w_n_registros       int,
@w_d_error           varchar(255)

select @w_d_error = 'EL PROCESO FINALIZO CORRECTAMENTE'

---------------------------------------
--- CREAR VISTA bc_v_selljujuy ---
---------------------------------------
if exists (select 1 from sysobjects where name = 'bc_v_selljujuy')
begin
   drop view bc_v_selljujuy
end

create view bc_v_selljujuy as
select
NRO_OPER    = right(replicate('0',15) + convert(varchar(15),convert(int,ss_identity)),15),
FEC_OPER    = convert(varchar(10),ss_fecha_fv,103),
CUIT_CONT   = right(replicate('0',11) + convert(varchar(11),ss_ced_ruc),11),
AYN_CONT    = '"' + left(ss_datos_adicionales + replicate(' ',38),38) + '"',
NRO_COMP    = '"' + right(replicate('0',28) + convert(varchar(28),convert(int,ss_identity)),28) + '"',
COD_OPER    = right(replicate('0',6) + convert(varchar(6),(case when ss_modulo = 7 then 45
              else case when ss_modulo = 200 then 47
                   else 111
                   end
              end)),6),
DESC_OPER   = '"' + left(case when ss_modulo = 7 then 'PAGARES'
              else case when ss_modulo = 200 then 'CHEQUES'
                   else 'OPERACIONES MONETARIAS'
                   end
              end + replicate(' ',58),58) + '"',
IMP_OPER    = right(replicate('0',19) + convert(varchar(19),convert(decimal(16,2),isnull(ss_base_calculo,0))),19),
ALIC        = right(replicate('0',9) + convert(varchar(9),convert(decimal(6,2),isnull(ss_alicuota,0))),9),
FOJAS       = '000',
IMP_FOJA    = '000000.00',
IMP_RET     = right(replicate('0',13) + convert(varchar(13),convert(decimal(10,2),isnull(ss_imp_retencion,0))),13),
TIPO_RESOL  = 1,
RESOL_NRO   = '001605', --'000000',
RESOL_ANIO  = '2021', --'0000',
PORC_EXEN   = right(replicate('0',9) + convert(varchar(9),convert(decimal(6,2),isnull(ss_pct_exencion,0))),9),
PER_DESDE   = '000000',
PER_HASTA   = '000000'
from  bc_sellos_salida,
      bc_p_impuestos
where ss_fecha_informac = im_f_hasta
and   ss_impuesto       = im_impuesto
and   ss_disenio        = 'A'
and   im_m_disenio      = 'A'
and   ss_impuesto       = 'SELLJUJUY'

select @w_n_error     = @@error,
       @w_n_registros = @@rowcount

if @w_n_error != 0
begin
   select @w_d_error = 'ERROR AL CREAR LA VISTA bc_v_selljujuy'
   
   goto ERROR_TRAP
end
else
   print 'SE CREO CON EXITO LA VISTA bc_v_selljujuy'

---------------------------------------
--- CREAR VISTA bc_v_selljujuy_1 ---
---------------------------------------
if exists (select 1 from sysobjects where name = 'bc_v_selljujuy_1')
begin
   drop view bc_v_selljujuy_1
end

create view bc_v_selljujuy_1 as
select
NRO_OPER    = right(replicate('0',15) + convert(varchar(15),convert(int,ss_identity)),15),
FEC_OPER    = convert(varchar(10),ss_fecha_fv,103),
CUIT_CONT   = left(replicate('0',11) + convert(varchar(11),ss_ced_ruc),11),
AYN_CONT    = '"' + left(ss_datos_adicionales + replicate(' ',38),38) + '"',
NRO_COMP    = '"' + right(replicate('0',28) + convert(varchar(28),convert(int,ss_identity)),28) + '"',
COD_OPER    = right(replicate('0',6) + convert(varchar(6),(case when ss_modulo = 7 then 45
              else case when ss_modulo = 200 then 47
                   else 111
                   end
              end)),6),
DESC_OPER   = '"' + left(case when ss_modulo = 7 then 'PAGARES'
              else case when ss_modulo = 200 then 'CHEQUES'
                   else 'OPERACIONES MONETARIAS'
                   end
              end + replicate(' ',58),58) + '"',
IMP_OPER    = right(replicate('0',19) + convert(varchar(19),convert(decimal(16,2),isnull(ss_base_calculo,0))),19),
ALIC        = right(replicate('0',9) + convert(varchar(9),convert(decimal(6,2),isnull(ss_alicuota,0))),9),
FOJAS       = '000',
IMP_FOJA    = '000000.00',
IMP_RET     = right(replicate('0',13) + convert(varchar(13),convert(decimal(10,2),isnull(ss_imp_retencion,0))),13),
TIPO_RESOL  = 1,
RESOL_NRO   = '000000',
RESOL_ANIO  = '0000',
PORC_EXEN   = right(replicate('0',9) + convert(varchar(9),convert(decimal(6,2),isnull(ss_pct_exencion,0))),9),
PER_DESDE   = '000000',
PER_HASTA   = '000000'
from  bc_sellos_salida,
      bc_p_impuestos
where ss_fecha_informac = im_f_hasta
and   ss_impuesto       = im_impuesto
and   ss_disenio        = 'B'
and   im_m_disenio      = 'B'
and   ss_impuesto       = 'SELLJUJUY'

select @w_n_error     = @@error,
       @w_n_registros = @@rowcount

if @w_n_error != 0
begin
   select @w_d_error = 'ERROR AL CREAR LA VISTA bc_v_selljujuy_1'
   
   goto ERROR_TRAP
end
else
   print 'SE CREO CON EXITO LA VISTA bc_v_selljujuy_1'

ERROR_TRAP:
print @w_d_error
go
