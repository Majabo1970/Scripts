use cob_bcradgi
go

print '--------------------------------------------'
print 'AST 65416 - ELIMINACION DE VISTAS DE TRABAJO'
print '--------------------------------------------'

declare
@w_n_error           int,
@w_n_registros       int,
@w_d_error           varchar(255)

select @w_d_error = 'EL PROCESO FINALIZO CORRECTAMENTE'

------------------------------------------
--- ELIMINAR VISTA bc_v_selljujuy_be_1 ---
------------------------------------------
if exists (select 1 from sysobjects where name = 'bc_v_selljujuy_be_1')
begin
   drop view bc_v_selljujuy_be_1

   select @w_n_error     = @@error,
          @w_n_registros = @@rowcount

   if @w_n_error != 0
   begin
      select @w_d_error = 'ERROR AL ELIMINAR LA VISTA bc_v_selljujuy_be_1'
      
      goto ERROR_TRAP
   end
   else
      print 'SE ELIMINO CON EXITO LA VISTA bc_v_selljujuy_be_1'
end

------------------------------------------
--- ELIMINAR VISTA bc_v_selljujuy_be_2 ---
------------------------------------------
if exists (select 1 from sysobjects where name = 'bc_v_selljujuy_be_2')
begin
   drop view bc_v_selljujuy_be_2

   select @w_n_error     = @@error,
          @w_n_registros = @@rowcount

   if @w_n_error != 0
   begin
      select @w_d_error = 'ERROR AL ELIMINAR LA VISTA bc_v_selljujuy_be_2'
      
      goto ERROR_TRAP
   end
   else
      print 'SE ELIMINO CON EXITO LA VISTA bc_v_selljujuy_be_2'
end

ERROR_TRAP:
print @w_d_error
go
