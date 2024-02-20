use cob_bcradgi
go

if exists (select * from sysobjects where name = 'sp_selljujuy')
   
drop proc sp_selljujuy
go

/*<summary>
RENDICION DE SELLOS DE JUJUY
Nombre Fisico: bc_sell_jujuy.sp
</summary>*/ 

/*<historylog>
<log LogType="Refactor" revision="1.0" date="21/06/2016" email="pedro.londero@accusys.com.ar">Created. AST 32550</log>
<log LogType="Refactor" revision="2.0" date="04/03/2022" email="matias.lestrade@accusys.com.ar">AST 64826 SYBASE 16</log>
<log LogType="Refactor" revision="3.0" date="28/04/2022" email="matias.lestrade@accusys.com.ar">AST 65627 - Versionado</log>
</historylog>*/

create proc sp_selljujuy (
--<parameters>
@i_formato_fecha                        tinyint                        = 103              ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_c_impuesto                           catalogo                       = 'SELLJUJUY'      ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_quien_llama                          char(1)                        = 'B'              ,--<param required ="no"      description="B back-end  F front-end"/>
@i_c_operacion                          char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_n_opcion                             tinyint                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_f_desde                              datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_f_hasta                              datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_f_fv_desde                           datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_f_fv_hasta                           datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_c_producto                           smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_m_cargo_banco                        char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_c_disenio                            varchar(1)                     = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_s_hasta                              int                            = null             ,--< param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_k_rowcount                           int                            = 30               ,--< param required ="no"      description="Variable de entrada del Stored Procedure."/>
@o_d_error                              varchar (132)                  = null out          --<param required ="no"  description="Nombre de la vista dianmica."/>
--</parameters>
)
as
declare
   @w_sp_name                           varchar(30),
   @w_c_return                          int,
   @w_c_error                           int,
   @w_d_error                           varchar (132),
   @w_c_sev                             int,
   @w_d_msg                             varchar(132),
   @w_mensaje_tiempo                    varchar(255),
   @w_f_desde                           datetime,
   @w_f_hasta                           datetime,
   @w_f_desde_segundo_dia               datetime,
   @w_f_hasta_primer_dia                datetime, 
   @w_f_desde_nopas                     datetime

/*INICIALIZO LAS VARIABLES*/
select   @w_sp_name = 'sp_sell_jujuy' + @i_c_impuesto,
         @w_mensaje_tiempo = convert(varchar(10),getdate(),@i_formato_fecha) + ' ' + convert(varchar(10),getdate(),108),
         @w_c_error = 0,
         @w_c_return = 0

if @i_c_operacion = 'P'
begin -- @i_c_operacion = 'P' (GENERACION DE INFORMACION)
   
   select @w_f_desde       = dateadd(dd, -1, convert(datetime, convert(varchar(2),datepart(mm, @i_f_hasta)) + '/01/' + convert(varchar(24),datepart(yy, @i_f_hasta)))),
		  @w_f_desde_nopas = convert(datetime, convert(varchar(2),datepart(mm, @i_f_hasta)) + '/01/' + convert(varchar(24),datepart(yy, @i_f_hasta)))

   execute @w_c_return = cobis..sp_dias_feriados
      @i_opcion         = 1 ,
      @i_fecha_ini      = @w_f_desde,
      @i_dias_habiles   = 2 ,
      @o_fecha_nueva    = @w_f_desde_segundo_dia  out

   if @w_c_return != 0
   begin -- DEVOLVIO ERROR
      goto error_trap
   end   -- DEVOLVIO ERROR

   select @w_f_hasta = isnull(@i_f_fv_hasta, @i_f_hasta)

   execute @w_c_return = cobis..sp_dias_feriados
      @i_opcion         = 1 ,
      @i_fecha_ini      = @w_f_hasta,
      @i_dias_habiles   = 1 ,
      @o_fecha_nueva    = @w_f_hasta_primer_dia  out

   if @w_c_return != 0
   begin -- DEVOLVIO ERROR
      goto error_trap
   end   -- DEVOLVIO ERROR

   delete from bc_sellos_salida
   where ss_fecha_informac =  @w_f_hasta
   and   ss_impuesto       =  @i_c_impuesto

   if @@error != 0
   begin -- ERROR DURANTE ELIMINACION
      select
      @w_c_return = 2900131, -- 'ERROR AL ELIMINAR REGISTROS DE LA TABLA'
      @w_c_sev = 0
      goto error_trap
   end -- ERROR DURANTE ELIMINACION

   if @i_c_producto = 0
   begin
      select @i_c_producto = null
   end

   if @i_m_cargo_banco = ' '
   begin
      select @i_m_cargo_banco = null
   end
      
   /*GENERO UNA TEMPORAL*/
   select
      'MODULO'      = ic_modulo,
      'ENTE'        = ic_ente,
      'DESCRIPCION' = (select ltrim(en_nombre + ' '+ p_p_apellido)
                       from cobis..cl_ente
                       where en_ente = i.ic_ente),
      'CED_RUC'     = isnull((select isnull(en_ced_ruc,'27000000006')
                              from cobis..cl_ente
                              where en_ente = i.ic_ente),'27000000006'),
      'CUENTA'      = ic_cuenta,
      'BASE_IMP'    = sum(ic_monto_base_imponible),
      'IMP_RET'     = sum(ic_importe_retenido_pesos),
      'SUCURSAL'    = ic_sucursal,
      'FECHA_RT'    = ic_fecha_valor,
      'FECHA_FV'    = ic_fecha_valor,
      'ALICUOTA'    = ic_alicuota,
      'DISENIO'     = 'B',
      'CANT'        =  count(1)
   into #TEMPTXT
   from cob_bcradgi..bc_impuesto_cobro i
   where ic_fecha_valor between @w_f_desde_segundo_dia and @w_f_hasta_primer_dia--FECHAS DESDE HASTA
   and ic_impuesto   = @i_c_impuesto--IMPUESTO
   and ic_modulo     = isnull(@i_c_producto,ic_modulo)
   and ic_modulo     =  3
   and ic_importe_retenido_pesos <> 0
   and ic_estado     = 'L'
   and isnull(ic_cargo_banco,'N')   =  isnull(@i_m_cargo_banco,isnull(ic_cargo_banco,'N'))
   group by ic_ente, ic_fecha_valor, ic_modulo, ic_cuenta, ic_sucursal, ic_alicuota
   union all
   select
      'MODULO'      = ic_modulo,
      'ENTE'        = ic_ente,
      'DESCRIPCION' = (select ltrim(en_nombre + ' '+ p_p_apellido)
                       from cobis..cl_ente
                       where en_ente = i.ic_ente),
      'CED_RUC'     = isnull((select isnull(en_ced_ruc,'27000000006')
                              from cobis..cl_ente
                              where en_ente = i.ic_ente),'27000000006'),
      'CUENTA'      = ic_cuenta,
      'BASE_IMP'    = sum(ic_monto_base_imponible),
      'IMP_RET'     = sum(ic_importe_retenido_pesos),
      'SUCURSAL'    = ic_sucursal,
      'FECHA_RT'    = ic_fecha_valor,
      'FECHA_FV'    = ic_fecha_valor,
      'ALICUOTA'    = ic_alicuota,
      'DISENIO'     = 'A',
      'CANT'        =  count(1)
   from cob_bcradgi..bc_impuesto_cobro i
   where ic_fecha_valor             between  @w_f_desde_nopas  and  @w_f_hasta--FECHAS DESDE HASTA
   and   ic_impuesto                = @i_c_impuesto--IMPUESTO
   and   ic_modulo                  = isnull(@i_c_producto,ic_modulo)
   and   ic_modulo                  <> 3
   and   ic_importe_retenido_pesos  <> 0
   and   ic_estado                  = 'L'
   and isnull(ic_cargo_banco,'N')   =  isnull(@i_m_cargo_banco,isnull(ic_cargo_banco,'N'))
   group by ic_ente, ic_fecha_valor, ic_modulo, ic_cuenta, ic_sucursal, ic_alicuota
   order by ic_ente, ic_fecha_valor, ic_modulo, ic_cuenta, ic_sucursal, ic_alicuota--65627
   /*PASO LOS DATOS A LA SALIDA*/
   insert into bc_sellos_salida
     (ss_fecha_informac     ,
      ss_impuesto           ,
      ss_disenio            ,
      ss_ente               ,
      ss_ced_ruc            ,
      ss_modulo             ,
      ss_numero             ,
      ss_moneda             ,
      ss_importe_comprobante,
      ss_base_calculo       ,
      ss_imp_retencion      ,
      ss_fecha_fv           ,
      ss_fecha_fv_informa   ,
      ss_alicuota           ,
      ss_sucursal           ,
      ss_cargo_banco        ,
      ss_tipo_base_imponible,
      ss_regimen            ,
      ss_valor_minimo       ,
      ss_pct_exencion       ,
      ss_valor_fijo         ,
      ss_tipo_exencion      ,
      ss_datos_adicionales  ,
      ss_descripcion        ,
      ss_fecha_registro )
   select
      @w_f_hasta ,                                            --ss_fecha_informac
      @i_c_impuesto    ,                                      --ss_impuesto
      DISENIO,                                                --ss_disenio
      ENTE,                                                   --ss_ente
      CED_RUC,                                                --ss_ced_ruc (5)
      MODULO,                                                 --ss_modulo
      null,                                                   --ss_numero
      null,                                                   --ss_moneda
      null,                                                   --ss_importe_comprobante
      BASE_IMP,                                               --ss_base_calculo
      IMP_RET,                                                --ss_imp_retencion
      FECHA_FV,                                               --ss_fecha_fv
      case
         when  datepart(mm,FECHA_FV) = datepart(mm,@w_f_hasta) then FECHA_FV
         else  @w_f_hasta --(13)
      end,                                                    --ss_fecha_fv_informa
      ALICUOTA,                                               --ss_alicuota
      SUCURSAL,                                               --ss_sucursal
      null,                                                   --ss_cargo_banco
      null,                                                   --ss_tipo_base_imponible
      null,                                                   --ss_regimen
      null,                                                   --ss_valor_minimo
      null,                                                   --ss_pct_exencion
      null,                                                   --ss_valor_fijo
      null,                                                   --ss_tipo_exencion
      case when IMP_RET < 0 then 'E' else 'P' end + '|' +
      ltrim(rtrim(CUENTA)) + '|' + ltrim(rtrim(DESCRIPCION)), --ss_datos_adicionales
      convert(varchar(10), CANT),                             --ss_descripcion
      getdate()                                               --ss_fecha_registro
   from #TEMPTXT 
   where IMP_RET != 0

   if @@error <> 0
   begin
      rollback tran
      select
      @w_c_error = 168069, -- 0 'ERROR AL INSERTAR EL REGISTRO'
      @w_d_error = 'ERROR AL INSERTAR EL REGISTRO EN TABLA cob_bcradgi..bc_sellos_salida'
      goto error_trap
   end

   /* ACTUALIZO EL REGISTRO DE PARAMETRIA DE LA FORMULA EN cob_bcradgi..bc_p_impuestos */
   update cob_bcradgi..bc_p_impuestos set
   im_f_desde   = @i_f_desde,
   im_f_hasta   = @i_f_hasta
   where im_impuesto = @i_c_impuesto

   if @@error <> 0
   begin
      rollback tran
      select @w_c_error = 2900372 -- 0 'ERROR AL ACTUALIZAR REGISTRO DE PARAMETRIA'
      goto error_trap
   end
end  -- @i_c_operacion = 'P' (GENERACION DE INFORMACION)

if @i_c_operacion = 'Q'
begin -- @i_c_operacion = 'Q' (CONSULTAS)
   if @i_n_opcion = 1
   begin --OPCION DE GRILLA
      if @i_c_disenio = 'A'
      begin
         set rowcount @i_k_rowcount
         select
         MODULO,               ENTE,                   DESCRIPCION,
         CUIT,                 CUENTA,                 BASE_IMP,
         IMP_RET,              SUCURSAL,               FECHA_RT,
         FECHA_FV,             ALICUOTA,               ID
         from  cob_bcradgi..bc_v_selljujuy_1
         where ID                                > isnull (@i_s_hasta, 0)
         order by ID
   
         set rowcount 0
         return 0
      end 
      
      if @i_c_disenio = 'B'
      begin
         set rowcount @i_k_rowcount
         select
         MODULO,               ENTE,                   DESCRIPCION,
         CUIT,                 CUENTA,                 BASE_IMP,
         IMP_RET,              SUCURSAL,               FECHA_RT,
         FECHA_FV,             ALICUOTA,               ID
         from  cob_bcradgi..bc_v_selljujuy_2
         where ID                                > isnull (@i_s_hasta, 0)
         order by ID
      
         set rowcount 0
         return 0
      
      end
   end --OPCION DE GRILLA
   if @i_n_opcion = 2
   begin --OPCION DE TOTALES
      select   @w_f_desde = isnull(@i_f_fv_desde, @i_f_desde)  ,
               @w_f_hasta = isnull(@i_f_fv_hasta, @i_f_hasta)

      select
         'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
         'IMP_RET'   =  isnull(sum(ss_imp_retencion), 0.00),
         'CANT'      =  count(1)
      from  bc_sellos_salida, 
      bc_p_modulo_producto, 
      bc_p_impuestos
      where ss_fecha_informac =  im_f_hasta
      and   ss_impuesto       =  im_impuesto
      and   ss_disenio        =  im_m_disenio
      and   ss_disenio        =  mp_m_disenio
      and   ss_modulo         =  mp_n_modulo
      and   ss_impuesto       =  @i_c_impuesto
      and   substring(ss_datos_adicionales,1,1) = 'P'
      and   mp_m_disenio      =  @i_c_disenio
      and   ss_fecha_informac =  @i_f_hasta
   end --OPCION DE TOTALES
end -- @i_c_operacion = 'Q' (CONSULTAS)

return 0

error_trap:

   if @w_c_error <> 0
      select @w_c_return = @w_c_error

   select   @w_d_msg         = isnull(@w_d_msg, mensaje),
            @w_c_sev         = isnull(@w_c_sev, severidad)
   from  cobis..cl_errores
   where numero = @w_c_return

   select @w_d_msg = isnull(@w_d_msg,'NO EXISTE MENSAJE ASOCIADO')

   select @w_d_msg = '[' + @w_sp_name + ']   ' + upper(@w_d_msg)

   /*EN EL UNICO CASO QUE HAGO ROLLBACK ES CUANDO YO INICIE LA TRANSACCION*/

   begin -- ME VOY SIN HACER NADA
      if @i_quien_llama = 'F'
      begin -- EL SP FUE LLAMADO DESDE EL FRONT-END ===> NECESITO QUE SAQUE EL MENSAJE POR PANTALLA
         exec cobis..sp_cerror
         @t_from = @w_sp_name,
         @i_num  = @w_c_return,
         @i_sev  = 0,
         @i_msg  = @w_d_msg
      end -- EL SP FUE LLAMADO DESDE EL FRONT-END ===> NECESITO QUE SAQUE EL MENSAJE POR PANTALLA
   end -- ME VOY SIN HACER NADA

   /*SEA LO QUE SEA EL RETURN DEBE VOLVER CON EL NUMERO DE ERROR*/

   return @w_c_return

/*<returns>
<return value = "0" description="EJECUCION EXITOSA" />
<error value = "@w_c_return" description="VARIABLE GENERICA/DEVOLUCION SP" />
<error value = "@w_c_error" description="VARIABLE GENERICA/DEVOLUCION SP" />
<error value = "2900067" description="LA OPERACION ES INVALIDA O NO EXISTE CON LOS PARAMETROS INGRESADOS" />
<error value = "2900131" description="ERROR AL ELIMINAR REGISTROS DE LA TABLA" />
<error value = "2900372" code="ERROR AL ACTUALIZAR REGISTRO DE PARAMETRIA" />

<recordset>
<column name="" datatype="" datalength="" description="" />
<column name="" datatype="" datalength="" description="" />
</recordset>

</returns>  */

--<keyword>29025</keyword>
--<keyword>CONSULTA DE SELLOS PROVINCIALES Y OTROS</keyword>

--<keyword>sp_sell_prov</keyword>

/*
<dependency ObjName="cobis..sp_cerror" xtype="P" dependentObjectName="cob_bcradgi..sp_sell_prov" dependentObjectType="P" />
<dependency ObjName="cobis..sp_dias_feriados" xtype="P" dependentObjectName="cob_bcradgi..sp_sell_prov" dependentObjectType="P" />
<dependency ObjName="cobis..sp_errores_batch" xtype="P" dependentObjectName="cob_bcradgi..sp_sell_prov" dependentObjectType="P" />
<dependency ObjName="cob_bcradgi..sp_definfor" xtype="P" dependentObjectName="cob_bcradgi..sp_sell_prov" dependentObjectType="P" />


*/
          
go







