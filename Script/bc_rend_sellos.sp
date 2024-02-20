use cob_bcradgi
go

if exists (select * from sysobjects where name = 'sp_rend_sellos')
drop proc sp_rend_sellos
go

/*<summary>

Nombre Fisico: bc_rend_sellos.sp

Operaciones del SP
@i_operacion = 'P' --> Proceso de la informacion, validacion y carga en bc_sellos_salida

Ejemplo de Ejecucion
   EXECUTE
   cob_bcradgi..sp_rend_sellos
   @i_fecha_informacion = '02/28/2009',
   @i_formulario        = 'SELLTUCUMA',
   @i_operacion         = 'P',
   @i_fecha_desde       = '02/01/2009'



</summary>*/ 
   
/*<historylog>
<log LogType="Refactor" revision="1.0" date="07/02/2011" email="matias.anivoleo@accusys.com.ar">Created</log>
<log LogType="Refactor" revision="2.0" date="06/11/2019" email="mauricio.kranevitter@accusys.com.ar">AST 53532</log>
</historylog>*/

create proc sp_rend_sellos (
--<parameters>
@i_fecha_informacion       datetime                       = null             ,--<param required ="no" description="Fecha de Informacion"/>
@i_formulario              varchar(10)                    = null             ,--<param required ="no" description="Formulario"/>
@i_operacion               char(1)                        = null             ,--<param required ="no" description="Operacio"/>
@i_fecha_desde             datetime                       = null              --<param required ="no" description="Fecha desde"/>

--</parameters>
)
as
declare
   @w_sp_name                       varchar(30) ,
   @w_mensaje                       varchar(255),
   @w_mensaje_tiempo                varchar(255),
   @w_registros                     int         ,
   @w_estado                        char(1)     ,
   @w_fecha_desde                   datetime    ,
   @w_fecha_hasta                   datetime    ,
   @w_estado_form                   catalogo    ,
   @w_retorno                       int         ,
   @w_error_str                     varchar(10) ,
   @w_error                         int         ,
   @w_obs                           varchar(255),
   @w_prefijo_dni                   char(3)     ,
   @w_codigo_regimen_vf             varchar(30) ,
   @w_valor_unitario_foja           float       ,
   @w_bc_establecimiento_tucuman    smallint    ,
   @w_formato_fecha                 smallint    ,
   
   @w_cuit_contribuyente            varchar(11) ,
   @w_espacio                       varchar(1)  ,
   @w_mes_present                   varchar(2)  ,
   @w_ano_present                   varchar(4)  ,
   @w_secuencia                     varchar(3)  ,
   @w_fecha_alta_reg                datetime    ,
   @w_cuit_cliente                  varchar(11) ,
   @w_cod_instrumento               varchar(3)  ,
   @w_alicuota                      float       ,
--   @w_es_alicuota                   char(1)     ,
   @w_cantidad                      money       ,
   @w_monto_imponible               money       ,
   @w_nro_establecimiento           catalogo    ,
   @w_id_tipo                       catalogo    ,

   @w_sucursal                      smallint    ,
   @w_nro_orden                     int         ,
   @w_diseno                        char(1)     ,
   @w_disenio_orig                  varchar(10) ,
   
--Variables del Cursor de bc_impuesto_cobro = cur_bc_impuesto_cobro
   @w_cur_ic_regimen                varchar(10) ,
   @w_cur_ic_fecha_valor            datetime    ,
   @w_cur_ic_sucursal               smallint    ,
   @w_cur_ic_monto_base_imponible   money       ,
   @w_cur_ic_alicuota               float       ,
   @w_cur_ic_importe_retenido_pes   float       ,
   @w_cur_ic_ente                   int         ,
   @w_cur_ic_datos_adicionales      varchar(255),
   @w_cur_ic_secuencial             int         ,
   @w_cur_cuit_contribuyente        varchar(11) ,
   @w_cur_Espacio                   varchar(1)  ,
   @w_cur_Mes_presenta              varchar(10) ,
   @w_cur_Ano_presenta              varchar(10) ,
   @w_cur_Secuencia_presenta        varchar(3)  ,
   @w_cur_cuit                      varchar(11) ,
   @w_cur_Tipo_pers                 catalogo    ,
   @w_cur_Desc_reg                  varchar(50) ,
   @w_cur_Es_alicuota               char(1)     ,
   @w_cur_Nro_orden                 varchar(8)  ,
   @w_cur_Fecha_emision             datetime    ,
   @w_cur_Cantidad                  float       ,
   @w_cur_REDUCCION                 float       ,
   @w_cur_Establec                  catalogo    ,
   @w_cur_Total_Control             money       ,
   @w_cur_Estado                    varchar(1)  ,
   
   --cur_bc_sellos_salida_Orden
   @cur_ss_sucursal                 smallint    ,
   @cur_ss_numero                   varchar(27) ,
   @cur_ss_identity                 numeric(8,0),
   @cur_disenio                     char(1)     ,
   @cur_estado                      char(1)     
   
   
   
   
   
--   /*BUSCO LA FECHA DE PROCESO*/
--   select @w_fecha_proceso = fp_fecha
--   from cobis..ba_fecha_proceso
   
select   @w_sp_name        = 'sp_rend_sellos' + @i_formulario,
         @w_mensaje_tiempo = convert(varchar(10),getdate(),103) + ' ' +  convert(varchar(10),getdate(),108),    -- MENSAJE DE TIEMPO SP
         @w_registros      = 0,
         @w_retorno        = 0,
         @w_fecha_hasta    = @i_fecha_informacion,
         @w_mensaje        = ''
         
/* BORRO LOS REGISTROS EXISTENTES EN LA ERRORES BATCH*/
delete from cob_bcradgi..bc_errores_batch
where    eb_sp = @w_sp_name

select @w_error = @@error

if (@w_error <> 0)
begin -- ERROR AL BORRAR LOS DATOS
   exec sp_errores_batch
      @i_sp          = @w_sp_name,
      @i_campo       = '',
      @i_dato        = '',
      @i_observacion = 'ERROR AL BORRAR LOS DATOS DE LA TABLA cob_bcradgi..bc_errores_batch'
      
   goto fin_proceso
end -- ERROR AL BORRAR LOS DATOS

/*ANALIZO EL ESTADO DE LA FORMULA*/
select @w_estado_form = ff_estado_form
from bc_fec_formulas
where ff_nro_formulario = @i_formulario
and ff_fecha_informac = @i_fecha_informacion

if @@error != 0
begin
   exec   cob_bcradgi..sp_errores_batch
          @i_sp                   = @w_sp_name,
          @i_campo                = 'bc_fec_formulas',
          @i_dato                 = 'ff_estado_form',
          @i_observacion          = 'ERROR AL CARGAR EL ESTADO DE LA FORMULA'
          
   goto fin_proceso
end

--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- REALIZA CONTROL DE ESTADO DE FORMULA PARA LAS FECHAS INGRESADAS SEGUN OPCION
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
if (@i_operacion = 'P')
begin
   if @w_estado_form <> 'FT'
   begin
      
      select @w_mensaje = 'ESTADO DE FORMULA DISTINDO DE FT'
      
      exec   cob_bcradgi..sp_errores_batch
             @i_sp                   = @w_sp_name,
             @i_campo                = '',
             @i_dato                 = 'ERROR EN ESTADO DE FORMULA',
             @i_observacion          = @w_mensaje
             
      goto fin_proceso
   end
end
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

if @i_operacion = 'P'
begin
   
   --BUSQUEDA DEL CUIT DEL BANCO -- @w_cuit_contribuyente = 30500010084
   select @w_cuit_contribuyente = pa_char 
   from cobis..cl_parametro
   where pa_producto = 'BCR'
   and   pa_nemonico = 'CUITBM'
   
   if @@rowcount != 1
   begin -- NO ESTA EL PARAMETRO REQUERIDO
      select @w_mensaje   =   'NO ESTA EN LA TABLA cobis..cl_parametro LA PARAMETRIA DE CUITBM'
      
      exec   cob_bcradgi..sp_errores_batch
             @i_sp                   = @w_sp_name,
             @i_campo                = 'pa_producto Y pa_nemonico',
             @i_dato                 = 'BCR - CUITBM',
             @i_observacion          = @w_mensaje
             
      goto fin_proceso 
   end   -- NO ESTA EL PARAMETRO REQUERIDO
   
   --BUSQUEDA PREFIJO PARA DNI -- @w_prefijo_dni = 991
   select @w_prefijo_dni = pa_char 
   from cobis..cl_parametro
   where pa_producto = 'BCR'
   and   pa_nemonico = 'PREDNI'
   
   if @@rowcount != 1
   begin -- NO ESTA EL PARAMETRO REQUERIDO
      select @w_mensaje   =   'NO ESTA EN LA TABLA cobis..cl_parametro LA PARAMETRIA DE PREDNI'
      
      exec   cob_bcradgi..sp_errores_batch
             @i_sp                   = @w_sp_name,
             @i_campo                = 'pa_producto Y pa_nemonico',
             @i_dato                 = 'BCR - PREDNI',
             @i_observacion          = @w_mensaje
             
      goto fin_proceso 
   end   -- NO ESTA EL PARAMETRO REQUERIDO
   
   --BUSQUEDA DEL CODIGO DE REGIMEN PARA EL VALOR FIJO -- @w_codigo_regimen_vf = 50
   select @w_codigo_regimen_vf = pa_char 
   from cobis..cl_parametro
   where pa_producto = 'BCR'
   and   pa_nemonico = 'CREGTU'
   
   if @@rowcount != 1
   begin -- NO ESTA EL PARAMETRO REQUERIDO
      select @w_mensaje   =   'NO ESTA EN LA TABLA cobis..cl_parametro LA PARAMETRIA DE CREGTU'
      
      exec   cob_bcradgi..sp_errores_batch
             @i_sp                   = @w_sp_name,
             @i_campo                = 'pa_producto Y pa_nemonico',
             @i_dato                 = 'BCR - CREGTU',
             @i_observacion          = @w_mensaje
             
      goto fin_proceso 
   end   -- NO ESTA EL PARAMETRO REQUERIDO
   
   --BUSQUEDA DEL VALOR UNITARIO X FOJA -- @w_valor_unitario_foja = 0.45
   select @w_valor_unitario_foja = pa_money 
   from cobis..cl_parametro
   where pa_producto = 'BCR'
   and   pa_nemonico = 'VUFOTU'
   
   if @@rowcount != 1
   begin -- NO ESTA EL PARAMETRO REQUERIDO
      select @w_mensaje   =   'NO ESTA EN LA TABLA cobis..cl_parametro LA PARAMETRIA DE VUFOTU'
      
      exec   cob_bcradgi..sp_errores_batch
             @i_sp                   = @w_sp_name,
             @i_campo                = 'pa_producto Y pa_nemonico',
             @i_dato                 = 'BCR - VUFOTU',
             @i_observacion          = @w_mensaje
             
      goto fin_proceso 
   end   -- NO ESTA EL PARAMETRO REQUERIDO
   
   /*BUSCO LOS CODIGOS DE LAS TABLAS DE RELACIONES*/
   /* bc_establecimiento_tucuma = 83 */
   select   @w_bc_establecimiento_tucuman = ss_cod_tabla
   from     bc_tabrel_form
   where    ss_tabla = 'bc_establecimiento_tucuma'
   and      ss_nro_formulario = @i_formulario
   
   if @@rowcount != 1
   begin -- NO ESTA LA TABLA DE RELACION PARAMETRIZADA
      select @w_mensaje   =   'NO ESTA LA TABLA bc_establecimiento_tucuma DE RELACION PARAMETRIZADA'

      exec   cob_bcradgi..sp_errores_batch
             @i_sp            = @w_sp_name,
             @i_campo         = 'bc_establecimiento_tucuma',
             @i_dato          = '',
             @i_observacion   = @w_mensaje
             
      goto fin_proceso
   end   -- NO ESTA LA TABLA DE RELACION PARAMETRIZADA   
   
   
   
   select   @w_fecha_desde    = convert(datetime,CONVERT(VARCHAR(3),@i_fecha_informacion ,101) + '01' + SUBSTRING(CONVERT(VARCHAR(10),@i_fecha_informacion ,101),6,5)),
            @w_formato_fecha  = 103
            
  
--GENERO UNA TEMPORAL CON LOS DATOS DE LA BC_CONSULTA_IMPUESTOS Y LOS VALORES FIJOS
   SELECT   ic_impuesto             ,ic_sucursal               ,ic_ente                   ,
            ic_moneda               ,ic_monto_base_imponible   ,ic_alicuota               ,
            ic_importe_retenido_me  ,ic_cotizacion             ,ic_importe_retenido_pesos ,
            ic_fecha_valor          ,ic_estado                 ,ic_datos_adicionales,
            ic_concepto             ,ic_tipo_base_imponible    ,ic_alicuota_nominal,
            ic_identity_alicuota_g  ,ic_regimen                ,ic_modulo,
            ic_producto             ,ic_secuencial             ,ic_secuencial_alterno,
            es_alicuota = 'S'
   into  #bc_selltucuma_tmp
   FROM  cob_bcradgi..bc_impuesto_cobro (index bc_impuesto_cobro_k4)
   --where ic_fecha_valor between @w_fecha_desde and @i_fecha_informacion
   where ic_fecha_valor between @i_fecha_desde and @i_fecha_informacion
   and   ic_impuesto = @i_formulario
   
   
   --ACTUALIZO EL CAMPO DATOS ADICIONALES 
   update #bc_selltucuma_tmp SET  ic_datos_adicionales =
                  "VFIJO:"    +  case when isnull(C.co_ir_valor_fijo,0.00) < -999999.99 then convert(char(10),-999999.99) else convert(char(10),isnull(C.co_ir_valor_fijo,0.00)) end + '|' +
                  "OFICINA:"  +  convert(char(40),isnull((select of_nombre from cobis..cl_oficina where of_oficina = C.ci_sucursal_origen ), ' ' )) +  '|'   +
                  "%EXEN P:"  +  convert(char(6),convert(money,(abs(isnull(C.co_ia_valor_1_p, 0.00))))) +  '|'   +
                  "%EXEN C:"  +  convert(char(6),convert(money,(abs(isnull(C.co_ia_valor_1_c, 0.00))))) +  '|'   +
                  "%EXEN S:"  +  convert(char(6),convert(money,(abs(isnull(C.bc_impuesto_sector_exento, 0.00)))))   +  '|'   +
                  "%EXEN Pr:" +  convert(char(6),convert(money,(abs(isnull(C.bc_impuesto_producto_exento, 0.00))))) 
   from bc_consulta_impuestos C, #bc_selltucuma_tmp T
   where C.co_secuencial = T.ic_secuencial
   --and T.ic_secuencial_alterno = 1
   
   select @w_error = @@error
   
   if (@w_error <> 0)
   begin -- ERROR AL UPDATE
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR AL ACTUALIZO EL CAMPO DATOS ADICIONALES'
         
      goto fin_proceso
   end -- ERROR AL UPDATE
   
   --ACTUALIZAMOS LOS REGISTROS C/VALOR FIJO DE LA TEMPORAL
   update #bc_selltucuma_tmp SET 
            ic_importe_retenido_pesos = case when ic_importe_retenido_pesos < 0.00 then (ic_importe_retenido_pesos + convert(money,(substring(ic_datos_adicionales, 7,10)))) 
                                             when ic_importe_retenido_pesos > 0.00 then (ic_importe_retenido_pesos - convert(money,(substring(ic_datos_adicionales, 7,10))))   
                                          else  0.00
                                          end
   from #bc_selltucuma_tmp
   WHERE ltrim(substring(ic_datos_adicionales, 7,10)) <> '0.00'
   
   select @w_error = @@error
   
   if (@w_error <> 0)
   begin -- ERROR AL UPDATE
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR - ACTUALIZAMOS LOS REGISTROS C/VALOR FIJO DE LA TEMPORAL'
         
      goto fin_proceso
   end -- ERROR AL UPDATE
   
   
   --DESDOBLO LOS REGISTROS CON VALOR FIJO
   INSERT INTO #bc_selltucuma_tmp (
   ic_impuesto                ,ic_sucursal                ,ic_ente                    ,
   ic_moneda                  ,ic_monto_base_imponible    ,ic_alicuota                ,
   ic_importe_retenido_me     ,ic_cotizacion              ,ic_importe_retenido_pesos  ,
   ic_fecha_valor             ,ic_estado                  ,ic_datos_adicionales       ,
   ic_concepto                ,ic_tipo_base_imponible     ,ic_alicuota_nominal        ,
   ic_identity_alicuota_g     ,ic_regimen                 ,ic_modulo                  ,
   ic_producto                ,ic_secuencial              ,ic_secuencial_alterno      ,
   es_alicuota)
   SELECT 
      ic_impuesto,
      ic_sucursal,
      ic_ente,
      80,                           --ic_moneda,
      0.00,                         -- ic_monto_base_imponible,   
      ic_alicuota = @w_valor_unitario_foja, --ic_alicuota
      0.00,                         --ic_importe_retenido_me
      0.00,                         --ic_cotizacion,
      case when ic_importe_retenido_pesos < 0 then (convert(money,(substring(ic_datos_adicionales, 7,10)))* -1)
                     else convert(money,(substring(ic_datos_adicionales, 7,10)))
      end,                          --ic_importe_retenido_pesos,
      ic_fecha_valor,
      ic_estado,
      ic_datos_adicionales + '|' + "ALIC : " +  "N" + '|',
      ic_concepto,
      ic_tipo_base_imponible,
      ic_alicuota_nominal,
      ic_identity_alicuota_g,
      ic_regimen = @w_codigo_regimen_vf,
      ic_modulo,
      ic_producto,
      ic_secuencial,
      ic_secuencial_alterno,
      'N'
   from #bc_selltucuma_tmp
   WHERE ltrim(substring(ic_datos_adicionales, 7,10)) <> '0.00'
   
   
   
   
   
   
   --PASAMOS LOS DATOS A UNA SEGUNDA TEMPORAL PARA REALIZAR ACTUALIZACIONES
   select 
      T.ic_secuencial,
      @w_cuit_contribuyente cuit_contribuyente,                                           --> Cuit del contribuyente 
      ' ' Espacio,                                                                        --> Espacio en Blanco
      substring(convert(varchar(10),T.ic_fecha_valor,@w_formato_fecha),4,2) Mes_presenta, --> Mes presentaci�n
      substring(convert(varchar(10),T.ic_fecha_valor,@w_formato_fecha),7,4) Ano_presenta, --> Ano presentaci�n
      'O00' Secuencia_presenta,                                                           --> Secuencia
      T.ic_fecha_valor,                                                                   --> Fecha de alta del registro
      T.ic_ente,                                                                          --> Cliente Cobis
      cuit  =  (select en_ced_ruc from cobis..cl_ente where en_ente = T.ic_ente),         --> Cuit del cliente
      Tipo_pers = (select en_subtipo from cobis..cl_ente where en_ente = T.ic_ente),      --> Tipo Persona
      T.ic_regimen,                                                                       --> C�digo de instrumento
      '                                                  ' Desc_reg,                      --> Descripci�n r�gimen 50 blancos
      T.ic_alicuota,                                                                      --> Al�cuota
      T.es_alicuota Es_alicuota,                                                          --> Es al�cuota : 'S' o 'N'
      '00000000' Nro_orden,                                                               --> N�mero de orden
      T.ic_fecha_valor Fecha_emision,                                                     --> Fecha emisi�n del instrumento
      case when T.es_alicuota = 'S' then 0.00
         else (T.ic_importe_retenido_pesos/isnull(case when T.ic_alicuota= 0
                                                      then 1
                                                      else T.ic_alicuota
                                                   end,1))
      end Cantidad,                                                                       --> Cantidad
      T.ic_monto_base_imponible,                                                          --> Monto imponible
      T.ic_importe_retenido_pesos,                                                        --> Total
      'REDUCCION'      =
                                 case
                                       when        convert(float,substring(T.ic_datos_adicionales,75,6)) > convert(float,substring(T.ic_datos_adicionales,90,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,75,6)) > convert(float,substring(T.ic_datos_adicionales,105,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,75,6)) > convert(float,substring(T.ic_datos_adicionales,121,6))
                                             then  convert(float,substring(T.ic_datos_adicionales,75,6))
                                       when        convert(float,substring(T.ic_datos_adicionales,90,6)) > convert(float,substring(T.ic_datos_adicionales,75,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,90,6)) > convert(float,substring(T.ic_datos_adicionales,105,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,90,6)) > convert(float,substring(T.ic_datos_adicionales,121,6))
                                             then  convert(float,substring(T.ic_datos_adicionales,90,6))
                                       when        convert(float,substring(T.ic_datos_adicionales,105,6)) > convert(float,substring(T.ic_datos_adicionales,75,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,105,6)) > convert(float,substring(T.ic_datos_adicionales,90,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,105,6)) > convert(float,substring(T.ic_datos_adicionales,121,6))
                                             then  convert(float,substring(T.ic_datos_adicionales,105,6))
                                       when        convert(float,substring(T.ic_datos_adicionales,121,6)) > convert(float,substring(T.ic_datos_adicionales,75,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,121,6)) > convert(float,substring(T.ic_datos_adicionales,90,6))
                                             and   convert(float,substring(T.ic_datos_adicionales,121,6)) > convert(float,substring(T.ic_datos_adicionales,105,6))
                                             then  convert(float,substring(T.ic_datos_adicionales,121,6))
                                       else 0.00
                                    end,
      Establec = (select max(cs_cod_bcra)
            from bc_catrel_form
            where cs_cod_tabla=  @w_bc_establecimiento_tucuman --83
            and   cs_cod_modulo  =  convert(char(3),T.ic_sucursal)
            and   cs_estado      =  'V'),
      Total_Control = convert(money,0.00),
      T.ic_datos_adicionales,
      T.ic_sucursal,
      Estado = 'I'
   into #bc_segunda_selltucuma_tmp
   from #bc_selltucuma_tmp T
   
   --ACTUALIZO VALORES Y VALIDACIONES
   --ACTUALIZO AL�CUOTAS
   UPDATE #bc_segunda_selltucuma_tmp SET 
               ic_alicuota =  case when Es_alicuota = 'N' then ic_alicuota
                              Else case when REDUCCION <> 0.0 then Round(ic_alicuota /(case when isnull((1- REDUCCION/100),1) = 0.00 then 1.0
                                                else isnull((1- REDUCCION/100),1)
                                                 end),8)/100
                              Else ic_alicuota/100
                           end
                        end
   from #bc_segunda_selltucuma_tmp
   
   select @w_error = @@error
   
   if (@w_error <> 0)
   begin -- ERROR AL UPDATE
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR - ACTUALIZO AL�CUOTAS'
         
      goto fin_proceso
   end -- ERROR AL UPDATE
   
   -- ACTUALIZO EL CAMPO TOTAL CONTROL Y EL ESTADO
   UPDATE #bc_segunda_selltucuma_tmp SET
      Total_Control = convert(money,(Case When Es_alicuota = 'N' Then ic_alicuota * Cantidad
               else Round((ic_monto_base_imponible * (ic_alicuota * (case when isnull((1- REDUCCION/100),1) = 0.00 then 1.0
                                       else isnull((1- REDUCCION/100),1)
                                       end))/100),4) * 100
             end)),
      Estado = case when (ic_importe_retenido_pesos - (convert(money,(Case When Es_alicuota = 'N' Then ic_alicuota * Cantidad
                                 else Round((ic_monto_base_imponible * (ic_alicuota * (case when isnull((1- REDUCCION/100),1) = 0.00 then 1.0
                                                            else isnull((1- REDUCCION/100),1)
                                                          end))/100),4) * 100
             end)))) > abs(0.01) then 'E'
            else 'P'
         end
   from #bc_segunda_selltucuma_tmp
   
   select @w_error = @@error
   
   if (@w_error <> 0)
   begin -- ERROR AL UPDATE
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR - ACTUALIZO EL CAMPO TOTAL CONTROL Y EL ESTADO'
         
      goto fin_proceso
   end -- ERROR AL UPDATE
   
   -- CAMBIO EL ESTADO PARA LOS QUE NO ENCONTR� NADA
   UPDATE #bc_segunda_selltucuma_tmp SET 
   Estado = 'E'
   where cuit = '991'
   
   select @w_error = @@error
   
   if (@w_error <> 0)
   begin -- ERROR AL UPDATE
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR - CAMBIO EL ESTADO PARA LOS QUE NO ENCONTR� NADA'
         
      goto fin_proceso
   end -- ERROR AL UPDATE
   
   
   /* BORRO LOS REGISTROS EXISTENTES Y MANDO EL LOG*/
   delete from cob_bcradgi..bc_sellos_salida
   where    ss_fecha_informac = convert(smalldatetime, @i_fecha_informacion)
   and      ss_impuesto = @i_formulario
   
   select   @w_error_str = convert(varchar(10),@@rowcount), 
            @w_error = @@error
            
   if (@w_error <> 0)
   begin -- ERROR AL BORRAR LOS DATOS
      rollback tran
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR AL BORRAR LOS DATOS DE LA TABLA cob_bcradgi..bc_sellos_salida'
         
      goto fin_proceso
   end -- ERROR AL BORRAR LOS DATOS
   
   exec    cob_bcradgi..sp_errores_batch
       @i_sp                   = @w_sp_name,
       @i_campo                = 'bc_sellos_salida',
       @i_dato                 = @w_error_str,
       @i_observacion          = 'SE ELIMINARON CORECTAMENTE LOS REGISTROS EXISTENTES PARA LA FECHA DE INFORMACION DE bc_sellos_salida'
   
   
   declare cur_bc_impuesto_cobro cursor for
   select
      ic_secuencial,                --> 1 
      cuit_contribuyente,           --> 2 Cuit del contribuyente 
      Espacio,                      --> 3 Espacio en Blanco
      Mes_presenta,                 --> 4 Mes presentaci�n
      Ano_presenta,                 --> 5 Ano presentaci�n
      Secuencia_presenta,           --> 6 Secuencia
      ic_fecha_valor,               --> 7 Fecha de alta del registro
      ic_ente,                      --> 8 Cliente Cobis
      cuit,                         --> 9 Cuit del cliente
      Tipo_pers,                    --> 10 Tipo Persona
      ic_regimen,                   --> 11 C�digo de instrumento
      Desc_reg,                     --> 12 Descripci�n r�gimen 50 blancos
      ic_alicuota,                  --> 13 Al�cuota
      Es_alicuota,                  --> 14 Es al�cuota : 'S' o 'N'
      Nro_orden,                    --> 15 N�mero de orden
      Fecha_emision,                --> 16 Fecha emisi�n del instrumento
      Cantidad,                     --> 17 Cantidad
      ic_monto_base_imponible,      --> 18 Monto imponible
      ic_importe_retenido_pesos,    --> 19 Total
      REDUCCION,
      Establec ,
      Total_Control ,
      ic_datos_adicionales,
      ic_sucursal,
      Estado
   from #bc_segunda_selltucuma_tmp
   order by Establec, ic_secuencial
   
   for read only
   
   open cur_bc_impuesto_cobro
   
   fetch cur_bc_impuesto_cobro into
      @w_cur_ic_secuencial,            @w_cur_cuit_contribuyente,       @w_cur_Espacio,
      @w_cur_Mes_presenta,             @w_cur_Ano_presenta,             @w_cur_Secuencia_presenta,
      @w_cur_ic_fecha_valor,           @w_cur_ic_ente,                  @w_cur_cuit,
      @w_cur_Tipo_pers,                @w_cur_ic_regimen,               @w_cur_Desc_reg,
      @w_cur_ic_alicuota,              @w_cur_Es_alicuota,              @w_cur_Nro_orden,
      @w_cur_Fecha_emision,            @w_cur_Cantidad,                 @w_cur_ic_monto_base_imponible,
      @w_cur_ic_importe_retenido_pes,  @w_cur_REDUCCION,                @w_cur_Establec ,
      @w_cur_Total_Control ,           @w_cur_ic_datos_adicionales,     @w_cur_ic_sucursal,
      @w_cur_Estado

   if @@sqlstatus = 2
   begin -- ERROR NO HAY REGISTROS A PROCESAR
      
      select @w_mensaje   =   'ERROR: NO HAY REGISTROS A PROCESAR'
      
      exec sp_errores_batch
      @i_sp          = @w_sp_name,
      @i_campo       = '',
      @i_dato        = '',
      @i_observacion = @w_mensaje
   end -- ERROR NO HAY REGISTROS A PROCESAR
   else 
   begin
      begin tran
         select   @w_registros   = 0
         
         while @@sqlstatus = 0
         begin
            select   @w_registros            = @w_registros + 1,
                     @w_estado               = 'P',
                     @w_error                = 0,
                     @w_espacio              = ' ',
                     @w_mes_present          = replicate('0',2 - datalength(ltrim(convert(VARCHAR(2),datepart(mm,@i_fecha_informacion))))) + convert(VARCHAR(2),datepart(mm,@i_fecha_informacion)),
                     @w_ano_present          = convert(VARCHAR(4),datepart(yy,@i_fecha_informacion)),
                     @w_secuencia            = 'O00',
                     @w_fecha_alta_reg       = @w_cur_ic_fecha_valor,
                     @w_cuit_cliente         = '',
                     @w_cod_instrumento      = @w_cur_ic_regimen,
                     @w_monto_imponible      = 0.00
            
            /*VALIDO LA ALICUOTA*/
            if @w_cur_ic_alicuota = 0.00
            begin
               select   @w_estado      = 'E',
                        @w_mensaje     = 'ALICUOTA CON VALOR = 0.00 - Ente:' + convert(varchar(10),@w_cur_ic_ente)
               
               exec sp_errores_batch
               @i_sp          = @w_sp_name,
               @i_campo       = 'ic_alicuota',
               @i_dato        = '',
               @i_observacion = @w_mensaje
            end
            else
            begin
--             select   @w_alicuota    = @w_cur_ic_alicuota/100,
               select   @w_alicuota    = @w_cur_ic_alicuota,
                        @w_cantidad    = 0.00
            end
            
            -- EL CAMPO ES O NO ALICUOTA
            if @w_cur_Es_alicuota = 'S'
            begin
               select   @w_cantidad    = 0.00
            end
            else
            begin
               select   @w_cantidad    = @w_cur_ic_importe_retenido_pes/isnull(case when @w_cur_ic_alicuota = 0
                                                                                    then 1
                                                                                    else @w_cur_ic_alicuota
                                                                                 end,1)
            end
            
            --CONTROLAR QUE LA BASE DE CALCULO SEA DISTINTA DE 0.00
            if @w_cur_Es_alicuota = 'S'
            begin
               if @w_cur_ic_monto_base_imponible != 0
               begin
                  select @w_monto_imponible = @w_cur_ic_monto_base_imponible
               end
               else
               begin
                  select   @w_estado      = 'E',
                           @w_monto_imponible = 0.00,
                           @w_mensaje     = 'MONTO IMPONIBLE = 0.00 - Ente:' + convert(varchar(10),@w_cur_ic_ente)
                  
                  exec sp_errores_batch
                  @i_sp          = @w_sp_name,
                  @i_campo       = 'ic_monto_base_imponible',
                  @i_dato        = '',
                  @i_observacion = @w_mensaje
               end
            end
            else
            begin
               select @w_monto_imponible = @w_cur_ic_monto_base_imponible
            end
            
    --CUIT DEL CLIENTE
            select   @w_cuit_cliente   = @w_cur_cuit,
                     @w_id_tipo        = @w_cur_Tipo_pers
            
            if @w_cuit_cliente = null or @w_cuit_cliente = '' 
            begin
               if @w_id_tipo = 'P'
               begin
                  select @w_cuit_cliente = ID.id_numero
                  from cobis..cl_identificacion ID
                  where ID.id_ente     = @w_cur_ic_ente 
                  and   ID.id_vigencia = 'S'
                  and   ID.id_tipo     = '01'
                  
                  if @@rowcount = 0
                  begin
                     select @w_cuit_cliente = @w_prefijo_dni + replicate('0',11 - datalength(@w_prefijo_dni))
                     
                     --ERROR CUIT NULL O VACIO Y NO ES PERSONA FISICA
                     select   @w_estado      = 'E',
                              @w_mensaje     = 'CUIT NULL O VACIO - Ente:' + convert(varchar(10),@w_cur_ic_ente)
                     exec sp_errores_batch
                     @i_sp          = @w_sp_name,
                     @i_campo       = 'cuit_cliente',
                     @i_dato        = '',
                     @i_observacion = @w_mensaje
                  end
                  else
                  begin
                     select @w_cuit_cliente = @w_prefijo_dni + replicate('0', 8-isnull(datalength(ltrim(ID.id_numero)),0)) + ID.id_numero
                     from cobis..cl_identificacion ID
                     where ID.id_ente     = @w_cur_ic_ente 
                     and   ID.id_vigencia = 'S'
                     and   ID.id_tipo     = '01'
                  end
               end
               else
               begin
                  select @w_cuit_cliente = '00000000000'
                  
                  --ERROR CUIT NULL O VACIO Y NO ES PERSONA FISICA
                  select   @w_estado      = 'E',
                           @w_mensaje     = 'CUIT NULL O VACIO - Ente:' + convert(varchar(10),@w_cur_ic_ente)
                  exec sp_errores_batch
                  @i_sp          = @w_sp_name,
                  @i_campo       = 'cuit_cliente',
                  @i_dato        = '',
                  @i_observacion = @w_mensaje
               end
            end

            
            /*VALIDO EL ESTABLECIMIENTO*/
            if (@w_cur_ic_sucursal) is null
            begin
               select   @w_estado      = 'E',
                        @w_mensaje     = 'LA SUCURSAL ES NULL O VACIO - Ente:' + convert(varchar(10),@w_cur_ic_ente)
            
               exec sp_errores_batch
               @i_sp          = @w_sp_name,
               @i_campo       = '@w_cur_ic_sucursal',
               @i_dato        = '',
               @i_observacion = @w_mensaje
            end
            else
            begin
               select @w_nro_establecimiento = max(cs_cod_bcra)
               from bc_catrel_form
               where cs_cod_tabla = @w_bc_establecimiento_tucuman
               and cs_cod_modulo = convert(char(3), @w_cur_ic_sucursal)
               and cs_estado = 'V'
            end
            
            -- ACTUALIZO EL ESTADO DE LAS DEVOLUCIONES, FALTA R�GIMEN O CANTIDAD
            if (@w_cur_ic_importe_retenido_pes <= 0.00 or @w_cur_ic_regimen is null or (@w_cur_ic_monto_base_imponible = 0.00 and @w_cantidad = 0)) and @w_cur_Estado = 'P'
            begin
               select   @w_estado      = 'E',
                        @w_mensaje     = 'ACTUALIZO EL ESTADO DE LAS DEVOLUCIONES, FALTA REGIMEN O CANTIDAD - Ente:' + convert(varchar(10),@w_cur_ic_ente)
            
               exec sp_errores_batch
               @i_sp          = @w_sp_name,
               @i_campo       = '@w_cur_ic_sucursal',
               @i_dato        = '',
               @i_observacion = @w_mensaje
            end
            
            
            --INSERTAR LOS RESULTADOS FINALES
            --INSERTAR EN bc_sellos_salida
            INSERT INTO bc_sellos_salida (
                                    ss_fecha_informac       ,ss_impuesto      ,ss_disenio          ,ss_ente         ,
                                    ss_ced_ruc              ,ss_modulo        ,ss_numero           ,ss_moneda       ,
                                    ss_importe_comprobante  ,ss_base_calculo  ,ss_imp_retencion    ,ss_fecha_fv     ,
                                    ss_fecha_fv_informa     ,ss_alicuota      ,ss_sucursal         ,ss_cargo_banco  ,
                                    ss_tipo_base_imponible  ,ss_regimen       ,ss_valor_minimo     ,ss_pct_exencion ,
                                    ss_valor_fijo           ,ss_tipo_exencion ,ss_datos_adicionales,ss_descripcion  ,
                                    ss_fecha_registro
                                          )
            values(
                  @i_fecha_informacion,                        --> ss_fecha_informac         smalldatetime
                  @i_formulario,                               --> ss_impuesto               varchar(10)
                  'ADET',                                      --> ss_disenio                varchar(10)
                  @w_cur_ic_ente,                              --> ss_ente                   int
                  @w_cuit_cliente,                             --> ss_ced_ruc                varchar(11)
                  null,                                        --> ss_modulo                 tinyint
                  convert(varchar(27),@w_cur_ic_secuencial),   --> ss_numero                 varchar(27)
                  null,                                        --> ss_moneda                 varchar(2)
                  null,                                        --> ss_importe_comprobante    money
                  @w_monto_imponible,                          --> ss_base_calculo           money
                  @w_cur_ic_importe_retenido_pes,              --> ss_imp_retencion          money
                  @w_cur_ic_fecha_valor,                       --> ss_fecha_fv,              datetime
                  @w_cur_ic_fecha_valor,                       --> ss_fecha_fv_informa       datetime
                  @w_alicuota,                                 --> ss_alicuota               float
                  convert(smallint,@w_nro_establecimiento),    --> ss_sucursal               smallint
                  null,                                        --> ss_cargo_banco            char(1)
                  null,                                        --> ss_tipo_base_imponible    smallint
                  @w_cod_instrumento,                          --> ss_regimen                varchar(10)
                  @w_cantidad,                                 --> ss_valor_minimo           money
                  @w_cur_REDUCCION,                            --> ss_pct_exencion           float
                  case when @w_cur_Es_alicuota = 'N' then @w_cur_ic_importe_retenido_pes
                     else 0.00
                  end,                                         --> ss_valor_fijo             money
                  null,                                        --> ss_tipo_exencion          varchar(10)
                  'ESTADO : ' + @w_estado +'|TOT CTROL : '+     
                  convert(varchar(12),replicate('',12 - datalength(ltrim(convert(varchar(12),str(abs(@w_cur_Total_Control),12,2))))) + ltrim(convert(varchar(12),str(ABS(@w_cur_Total_Control),12,2))))+'|',        --> ss_datos_adicionales   varchar(255)
                  @w_cuit_contribuyente + ' '+ 
                  substring(convert(varchar(10),@w_cur_ic_fecha_valor,@w_formato_fecha),4,2) +
                  substring(convert(varchar(10),@w_cur_ic_fecha_valor,@w_formato_fecha),7,4) + 
                  convert(varchar(3),@w_secuencia),            --> ss_descripcion   varchar(255)
                  getdate()                                    --> ss_fecha_registro         datetime
                  )
                  
            if (@@error <> 0)
            begin -- ERROR AL BORRAR LOS DATOS
               rollback tran
               exec sp_errores_batch
                  @i_sp          = @w_sp_name,
                  @i_campo       = '',
                  @i_dato        = '',
                  @i_observacion = 'ERROR AL INSERTAR LOS DATOS DE LA TABLA cob_bcradgi..bc_sellos_salida'
                  
               goto fin_proceso
            end -- ERROR AL BORRAR LOS DATOS
            
            -- COMMIT TRAN CADA 5000 REGISTROS
            if(@w_registros % 5000 = 0)
            begin
               commit tran
               begin tran
            end
            
            fetch cur_bc_impuesto_cobro into
               @w_cur_ic_secuencial,            @w_cur_cuit_contribuyente,       @w_cur_Espacio,
               @w_cur_Mes_presenta,             @w_cur_Ano_presenta,             @w_cur_Secuencia_presenta,
               @w_cur_ic_fecha_valor,           @w_cur_ic_ente,                  @w_cur_cuit,
               @w_cur_Tipo_pers,                @w_cur_ic_regimen,               @w_cur_Desc_reg,
               @w_cur_ic_alicuota,              @w_cur_Es_alicuota,              @w_cur_Nro_orden,
               @w_cur_Fecha_emision,            @w_cur_Cantidad,                 @w_cur_ic_monto_base_imponible,
               @w_cur_ic_importe_retenido_pes,  @w_cur_REDUCCION,                @w_cur_Establec ,
               @w_cur_Total_Control ,           @w_cur_ic_datos_adicionales,     @w_cur_ic_sucursal,
               @w_cur_Estado
         end
         
         INSERT INTO bc_sellos_salida (
         ss_fecha_informac       ,ss_impuesto             ,ss_disenio              ,ss_ente                 ,
         ss_ced_ruc              ,ss_modulo               ,ss_numero               ,ss_moneda               ,
         ss_importe_comprobante  ,ss_base_calculo         ,ss_imp_retencion        ,ss_fecha_fv             ,
         ss_fecha_fv_informa     ,ss_alicuota             ,ss_sucursal             ,ss_cargo_banco          ,
         ss_tipo_base_imponible  ,ss_regimen              ,ss_valor_minimo         ,ss_pct_exencion         ,
         ss_valor_fijo           ,ss_tipo_exencion        ,ss_datos_adicionales    ,ss_descripcion          ,
         ss_fecha_registro)
         select   
            ss_fecha_informac,
            ss_impuesto,
            'BCLI',           --ss_disenio
            ss_ente,
            ss_ced_ruc,
            null,             --ss_modulo
            ss_numero,
            null,             --ss_moneda
            null,             --ss_importe_comprobante
            null,             --ss_base_calculo
            null,             --ss_imp_retencion
            ss_fecha_fv,      --ss_fecha_fv
            null,             --ss_fecha_fv_informa
            null,             --ss_alicuota
            ss_sucursal,
            null,             --> ss_cargo_banco
            null,             --> ss_tipo_base_imponible
            null,             --> ss_regimen
            null,             --> ss_valor_minimo
            null,             --> ss_pct_exencion
            null,             --> ss_valor_fijo
            null,             --> ss_tipo_exencion
            substring(ss_datos_adicionales,1,11),  --> ss_datos_adicionales   
            'NOMBRE : ' + convert(char(51),ISNULL(en_nomlar,'DENOMINACION'))+ '|',  --> ss_descripcion
            getdate()
         from
            bc_sellos_salida, cobis..cl_ente E
         where ss_impuesto        = @i_formulario
         and   ss_fecha_informac  = convert(smalldatetime, @i_fecha_informacion)
         and   ss_ente           *= E.en_ente
--         order by ss_sucursal, ss_numero
         
         
         if (@@error <> 0)
         begin -- ERROR AL BORRAR LOS DATOS
            rollback tran
            exec sp_errores_batch
               @i_sp          = @w_sp_name,
               @i_campo       = '',
               @i_dato        = '',
               @i_observacion = 'ERROR AL INSERTAR LOS DATOS DE LA TABLA cob_bcradgi..bc_sellos_salida'
               
            goto fin_proceso
         end -- ERROR AL BORRAR LOS DATOS
         
         select @w_mensaje    = 'SE PROCESO LA TABLA cob_bcradgi..bc_impuesto_cobro - FECHA DE PROCESO:'+ convert(varchar(10),@i_fecha_informacion,103) + ' - #REG:' + convert(varchar(10),@w_registros)
         
         exec sp_errores_batch
            @i_sp             = @w_sp_name,
            @i_campo          = '',
            @i_dato           = '',
            @i_observacion    = @w_mensaje
         
         close cur_bc_impuesto_cobro
         deallocate cursor cur_bc_impuesto_cobro
      
      commit tran
   end
   
   select
   ss_fecha_informac,
   ss_impuesto,
   ss_disenio,
   ss_ente,
   ss_ced_ruc,
   ss_modulo,
   ss_numero,
   ss_moneda,
   ss_importe_comprobante,
   ss_base_calculo,
   ss_imp_retencion,
   ss_fecha_fv,
   ss_fecha_fv_informa,
   ss_alicuota,
   ss_sucursal,
   ss_cargo_banco,
   ss_tipo_base_imponible,
   ss_regimen,
   ss_valor_minimo,
   ss_pct_exencion,
   ss_valor_fijo,
   ss_tipo_exencion,
   ss_datos_adicionales,
   ss_descripcion,
   ss_identity,
   ss_fecha_registro
   into #bc_sellos_salida
   from bc_sellos_salida
   where ss_impuesto       = @i_formulario
   and   ss_fecha_informac = convert(smalldatetime, @i_fecha_informacion)
   
   create index id1 on #bc_sellos_salida (ss_identity)
   
   --NUMERACION DE LA BASE DE DATOS bc_sellos_salida
   select
   ss_sucursal,
   ss_numero,
   ss_identity,
   substring(ss_disenio,1,1)            as ss_disenio, 
   substring(ss_datos_adicionales,10,1) as ss_datos_adicionales   
   into  #sello_salida
   from  #bc_sellos_salida
   where ss_impuesto             = @i_formulario
   and   ss_fecha_informac between convert(smalldatetime, @i_fecha_desde) and convert(smalldatetime, @i_fecha_informacion)
   
   declare cur_bc_sellos_salida_Orden cursor for
   select
         ss_sucursal,
         ss_numero,
         ss_identity,
         ss_disenio,
         ss_datos_adicionales
   from  #sello_salida
   order by  ss_sucursal, ss_disenio, ss_datos_adicionales, ss_numero
   for read only
   
   open cur_bc_sellos_salida_Orden
   fetch cur_bc_sellos_salida_Orden into
         @cur_ss_sucursal,
         @cur_ss_numero,
         @cur_ss_identity,
         @cur_disenio,
         @cur_estado
   
   select   @w_nro_orden   = 0,
            @w_sucursal    = @cur_ss_sucursal,
            @w_diseno      = @cur_disenio,
            @w_estado      = @cur_estado

   while @@sqlstatus = 0
   begin
      if @cur_disenio = 'A'
      begin
         select @w_disenio_orig = 'ADET'
      end
      else
      begin
         select @w_disenio_orig = 'BCLI'
      end

      --Control por Sucursal
      if @w_sucursal = @cur_ss_sucursal
      begin
         --Control por Dise�o
         if @w_diseno = @cur_disenio
         begin
            --Control por Estado
            if @w_estado = @cur_estado
            begin
               select @w_nro_orden   = @w_nro_orden + 1
            end
            else --Cambio de estado
            begin
               select @w_nro_orden   = 1,
                      @w_sucursal    = @cur_ss_sucursal,
                      @w_diseno      = @cur_disenio,
                      @w_estado      = @cur_estado
            end --Control por Estado
         end
         else --Cambio de Dise�o
         begin
            select @w_nro_orden   = 1,
                   @w_sucursal    = @cur_ss_sucursal,
                   @w_diseno      = @cur_disenio,
                   @w_estado      = @cur_estado
         end --Control por Dise�o
      end
      else --Cambio de Sucursal
      begin
         select @w_nro_orden   = 1,
                @w_sucursal    = @cur_ss_sucursal,
                @w_diseno      = @cur_disenio,
                @w_estado      = @cur_estado
      end --Control por Sucursal
      
      update #bc_sellos_salida set
      ss_descripcion = ss_descripcion + right('00000000' + convert(varchar(8),@w_nro_orden), 8)
      where ss_identity     = @cur_ss_identity
      and ss_impuesto       = @i_formulario
      and ss_fecha_informac = convert(smalldatetime, @i_fecha_informacion)
      and ss_disenio        = @w_disenio_orig
      
      if (@@error <> 0)
      begin -- ERROR AL HACER UPDATE
         exec sp_errores_batch
            @i_sp          = @w_sp_name,
            @i_campo       = '',
            @i_dato        = '',
            @i_observacion = 'ERROR AL HACER UPDATE A LA TABLA cob_bcradgi..bc_sellos_salida'
            
         goto fin_proceso
      end
   
      fetch cur_bc_sellos_salida_Orden into
         @cur_ss_sucursal,
         @cur_ss_numero,
         @cur_ss_identity,
         @cur_disenio,
         @cur_estado
      
   end
   
   close cur_bc_sellos_salida_Orden
   deallocate cursor cur_bc_sellos_salida_Orden
   
   update bc_sellos_salida set
   ss_descripcion = B.ss_descripcion
   from bc_sellos_salida A, #bc_sellos_salida B
   where A.ss_identity       = B.ss_identity
   and   A.ss_impuesto       = @i_formulario
   and   A.ss_fecha_informac = convert(smalldatetime, @i_fecha_informacion)
   and   A.ss_disenio        = B.ss_disenio
   and   A.ss_impuesto       = B.ss_impuesto      
   and   A.ss_fecha_informac = B.ss_fecha_informac
   
   if (@@error <> 0)
   begin -- ERROR AL HACER UPDATE
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR AL HACER UPDATE A LA TABLA cob_bcradgi..bc_sellos_salida'
         
      goto fin_proceso
   end
   
   /* ACTUALIZO EL ESTADO DE LA FORMULA */
   update cob_bcradgi..bc_fec_formulas
   set   ff_estado_form       = 'FC',
         ff_fecha_registro    = getdate()
   where ff_nro_formulario    = @i_formulario
     and ff_fecha_informac    between @w_fecha_desde and @i_fecha_informacion
   
   select @w_error      = @@error
   
   if @w_error <> 0
   begin -- ERROR EN EL UPDATE DEL ESTADO
      exec sp_errores_batch
         @i_sp             = @w_sp_name,
         @i_campo          = '',
         @i_dato           = '',
         @i_observacion    = 'ERROR AL REALIZAR EL UPDATE DEL ESTADO DE cob_bcradgi..bc_fec_formulas'
      goto fin_proceso
   end   -- ERROR EN EL UPDATE DEL ESTADO
   
   -- INSERTO UN REGISTRO DE EXITO
   exec sp_errores_batch
      @i_sp          = @w_sp_name,
      @i_campo       = '',
      @i_dato        = '',
      @i_observacion = 'PROCESO CORRECTO DE LA TABLA cob_bcradgi..bc_impuesto_cobro'
      
   -- CALCULO TIEMPO DE EJECUCION
   /* MANDO COMO MENSAJE EL TIEMPO DE EJECUCION (COMO ULTIMA INSTRUCCION)*/
   select @w_mensaje_tiempo = '||INICIO DE EJECUCION: ' + @w_mensaje_tiempo + ' - FIN DE EJECUCION: ' + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(10),getdate(),108)+ '||'
   exec sp_errores_batch
      @i_sp          = @w_sp_name,
      @i_campo       = '',
      @i_dato        = '',
      @i_observacion = @w_mensaje_tiempo
   
   return  0
end -- if (@i_operacion = 'P')

fin_proceso:

select @w_mensaje_tiempo = '||INICIO DE EJECUCION: ' + @w_mensaje_tiempo + ' - FIN DE EJECUCION: ' + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(10),getdate(),108)+ '||'
exec sp_errores_batch
   @i_sp           = @w_sp_name,
   @i_campo        = @i_formulario ,
   @i_dato         = 'TIEMPO DE EJECUCION',
   @i_observacion  = @w_mensaje_tiempo

return @w_retorno

/*<returns>
<return value="" description="" />
<error value="" code="" />
<column name="" datatype="" datalength="" description="" />

<return value = "0" description="EJECUCION EXITOSA" />
<error value = "@w_retorno" description="VARIABLE GENERICA/DEVOLUCION SP" />

<recordset>
</recordset>
</returns>*/

--<keyword>sp_rend_sellos</keyword>

/*
<dependency ObjName="" xtype="" dependentObjectName="" dependentObjectType="" />
<dependency ObjName="cob_bcradgi..sp_errores_batch" xtype="P" dependentObjectName="cob_bcradgi..sp_rend_sellos" dependentObjectType="P" />                                                                                                                      
<dependency ObjName=" cob_bcradgi..sp_errores_batch" xtype="P" dependentObjectName="cob_bcradgi..sp_rend_sellos" dependentObjectType="P" />                                                                                                                     
*/

go