use cob_cuentas
go

print ' '
print '*** INICIO DE INSERCION DE NUEVO CAMPO cob_cuentas..cc_calificacion_cuentas.cc_c_beneficio  ***'
print ' '

if exists (select 1 from syscolumns where id = object_id ('cc_calificacion_cuentas') and name = 'cc_c_beneficio')
begin
   exec ('alter table cc_calificacion_cuentas drop cc_c_beneficio')

   if @@error <> 0
   begin
      print 'ERROR AL BORRAR CAMPO cc_c_beneficio'
   end
end
go

print ' '
print 'AGREGANDO EL CAMPO cc_c_beneficio DE LA TABLA cc_calificacion_cuentas.'
print ' '

exec ("alter table cc_calificacion_cuentas add cc_c_beneficio  catalogo  null")

if @@error <> 0
begin
   print 'ERROR AL AGREGAR NUEVOS CAMPOS cc_c_beneficio'
end
go  
  
/* ******************************************************************************************* */
use cob_cuentas_his
go

print ' '
print '*** INICIO DE INSERCION DE NUEVO CAMPO cob_cuentas_his..cc_calificacion_cuentas_his.cc_c_beneficio  ***'
print ' '

if exists (select 1 from syscolumns where id = object_id ('cc_calificacion_cuentas_his') and name = 'cc_c_beneficio')
begin
   exec ('alter table cc_calificacion_cuentas_his drop cc_c_beneficio')

   if @@error <> 0
   begin
      print 'ERROR AL BORRAR CAMPO cc_c_beneficio'
   end
end
go

print ' '
print 'AGREGANDO EL CAMPO cc_c_beneficio DE LA TABLA cc_calificacion_cuentas_his.'
print ' '

exec ("alter table cc_calificacion_cuentas_his add cc_c_beneficio  catalogo  null")

if @@error <> 0
begin
   print 'ERROR AL AGREGAR NUEVOS CAMPOS cc_c_beneficio'
end
go 

/* ******************************************************************************************* */
use cob_cuentas
go

print ' '
print '*** INICIO DE INSERCION DE NUEVO CAMPO cob_cuentas..cc_d_calificacion_cuentas_log.cc_c_beneficio  ***'
print ' '

if exists (select 1 from syscolumns where id = object_id ('cc_d_calificacion_cuentas_log') and name = 'cc_c_beneficio')
begin
   exec ('alter table cc_d_calificacion_cuentas_log drop cc_c_beneficio')  

   if @@error <> 0
   begin
      print 'ERROR AL BORRAR CAMPO cc_c_beneficio'
   end
end
go

print ' '
print 'AGREGANDO EL CAMPO cc_c_beneficio DE LA TABLA cc_d_calificacion_cuentas_log.'
print ' '

exec ("alter table cc_d_calificacion_cuentas_log add cc_c_beneficio  catalogo  null")

if @@error <> 0
begin
   print 'ERROR AL AGREGAR NUEVOS CAMPOS cc_c_beneficio'
end
go

/* ******************************************************************************************* */
use cob_ahorros
go

print ' '
print '*** INICIO DE INSERCION DE NUEVO CAMPO cob_ahorros..ah_calificacion_cuentas.ah_c_beneficio  ***'
print ' '

if exists (select 1 from syscolumns where id = object_id ('ah_calificacion_cuentas') and name = 'ah_c_beneficio')
begin
   exec ('alter table ah_calificacion_cuentas drop ah_c_beneficio')

   if @@error <> 0
   begin
      print 'ERROR AL BORRAR CAMPO ah_c_beneficio'
   end
end
go

print ' '
print 'AGREGANDO EL CAMPO ah_c_beneficio DE LA TABLA ah_calificacion_cuentas.'
print ' '

exec ("alter table ah_calificacion_cuentas add ah_c_beneficio  catalogo  null")

if @@error <> 0
begin
   print 'ERROR AL AGREGAR NUEVOS CAMPOS ah_c_beneficio'
end
go  
  
/* ******************************************************************************************* */

use cob_ahorros_his
go

print ' '
print '*** INICIO DE INSERCION DE NUEVO CAMPO cob_ahorros_his..ah_calificacion_cuentas_his.ah_c_beneficio  ***'
print ' '

if exists (select 1 from syscolumns where id = object_id ('ah_calificacion_cuentas_his') and name = 'ah_c_beneficio')
begin
   exec ('alter table ah_calificacion_cuentas_his drop ah_c_beneficio')

   if @@error <> 0
   begin
      print 'ERROR AL BORRAR CAMPO ah_c_beneficio'
   end
end
go

print ' '
print 'AGREGANDO EL CAMPO ah_c_beneficio DE LA TABLA ah_calificacion_cuentas_his.'
print ' '

exec ("alter table ah_calificacion_cuentas_his add ah_c_beneficio  catalogo  null")

if @@error <> 0
begin
   print 'ERROR AL AGREGAR NUEVOS CAMPOS ah_c_beneficio'
end
go 

/* ******************************************************************************************* */
use cob_ahorros
go

print ' '
print '*** INICIO DE INSERCION DE NUEVO CAMPO cob_ahorros..ah_d_calificacion_cuentas_log.ah_c_beneficio  ***'
print ' '

if exists (select 1 from syscolumns where id = object_id ('ah_d_calificacion_cuentas_log') and name = 'ah_c_beneficio')
begin
   exec ('alter table ah_d_calificacion_cuentas_log drop ah_c_beneficio')

   if @@error <> 0
   begin
      print 'ERROR AL BORRAR CAMPO ah_c_beneficio'
   end
end
go

print ' '
print 'AGREGANDO EL CAMPO ah_c_beneficio DE LA TABLA ah_d_calificacion_cuentas_log.'
print ' '

exec ("alter table ah_d_calificacion_cuentas_log add ah_c_beneficio  catalogo  null")

if @@error <> 0
begin
   print 'ERROR AL AGREGAR NUEVOS CAMPOS ah_c_beneficio'
end
go

