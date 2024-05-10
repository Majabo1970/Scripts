use cob_bcradgi
go

if exists (select 1 from sysobjects where name = 'sp_sell_prov')
   
drop proc sp_sell_prov
go
        

/*<summary>


CONSULTA DE SELLOS PROVINCIALES Y OTROS (29025)

Nombre Fisico: bc_sell_prov.sp

--@i_opcion = 1   -- PARA F5 Y LOST FOCUS DE CODIGO IMPUESTO
--@i_opcion = 2   -- PARA F5 DE FECHA DESDE Y FECHA HASTA

--@i_opcion = 23  -- PARA F5 DE FECHA DESDE Y FECHA HASTA PARA SELLTUCUMA FORMULARIO FImpSellProv.frm


--@i_opcion = 3   -- F5  PARA TOTAL PERCIBIDO
--@i_opcion = 4   -- F5 DE CATEGORIA
--@i_opcion = 5   -- F5 DE MONEDA
--@i_opcion = 6   -- GRILLA RESUMEN CATEGORIA / MONEDA
--@i_opcion = 7   -- GRILLA IMPUESTO
--@i_opcion = 8   -- F5 DE ESTADOS
--@i_opcion = 9   -- CLIENTE
--@i_opcion = 10  -- REGIONES
--@i_opcion = 11  -- SUCURSALES
--@i_opcion = 12  -- TIPO DE MOVIMIENTO
--@i_opcion = 13  -- MODULOS
--@i_opcion = 14  -- TRANSACCION
--@i_opcion = 15  -- CUENTAS
--@i_opcion = 16  -- FECHA VALOR
--@i_opcion = 17  -- CBU
--@i_opcion = 18  -- AJUSTE
--@i_opcion = 19  -- GRILLA -> PANTALLA DE DETALLE
--@i_opcion = 20  -- F5 PARA FECHA INFORMACION
--@i_opcion = 21  -- PARA CALCULAR EL FIN DE MES
--@i_opcion = 22  -- PARA CALCULAR ACREDITACIONES


--@i_opcion = 50  -- PARA F5 DE FECHA VALOR DESDE Y FECHA HASTA
--@i_opcion = 52  -- PARA GENERACION DEL PLANO PARA PERIB - SELLTUCUMA - SELLSLUIS - SELLBAIRES
--@i_opcion = 53  -- F5 DE SERVICIOS
--@i_opcion = 54  -- GENERACION DEL PLANO DE CTES
--@i_opcion = 55  -- GENERACION DEL PLANO SUJETOS



</summary>*/ 
   
/*<historylog>
<log LogType="Refactor" revision="1.0" date="09/01/2009" email="pablo.mercurio@accusys.com.ar">Created</log>
<log LogType="Refactor" revision="2.0" date="25/11/2010" email="matias.anivole@accusys.com.ar">Created</log>
<log LogType="Refactor" revision="3.0" date="25/11/2010" email="matias.anivole@accusys.com.ar">Created</log>
<log LogType="Refactor" revision="4.0" date="28/02/2011" email="matias.anivole@accusys.com.ar">Created</log>
<log LogType="Refactor" revision="5.0" date="03/06/2011" email="claudio.soreyra@accusys.com.ar">Created</log>
<log LogType="Refactor" revision="6.0" date="13/02/2012" email="matias.anivole@accusys.com.ar">Created</log>
<log LogType="Refactor" revision="7.0" date="23/05/2012" email="dario.prellezo@accusys.com.ar">Modified - AST 10854</log>
<log LogType="Refactor" revision="8.0" date="30/05/2012" email="javier.lerner@accusys.com.ar">Modified - AST 10887 SELLAPAMPA</log>
<log LogType="Refactor" revision="9.0" date="21/06/2012" email="dario.prellezo@accusys.com.ar">Modified - AST 8917</log>
<log LogType="Refactor" revision="9.1" date="11/09/2012" email="pablo.mercurio@accusys.com.ar">AST 8917--> correccion </log>
<log LogType="Refactor" revision="10.0" date="01/11/2012" email="dario.prellezo@accusys.com.ar">AST 11521</log>
<log LogType="Refactor" revision="10.1" date="07/12/2012" email="dario.prellezo@accusys.com.ar">AST 11521- Cambios</log>
<log LogType="Refactor" revision="11.0" date="24/04/2013" email="dario.prellezo@accusys.com.ar">AST 13456- SELLMZA</log>
<log LogType="Refactor" revision="12.0" date="11/12/2014" email="pedro.londero@accusys.com.ar">AST 22131- SELLBAIRES</log>
<log LogType="Refactor" revision="13.0" date="15/12/2014" email="diego.justet@accusys.com.ar">AST 22266- SELLMISION</log>
<log LogType="Refactor" revision="14.0" date="17/03/2015" email="diego.justet@accusys.com.ar">AST 24485- SELLMISION</log>
<log LogType="Refactor" revision="15.0" date="17/03/2015" email="matias.anivole@accusys.com.ar">AST 27434- SELLMISION</log>
<log LogType="Refactor" revision="16.0" date="18/12/2015" email="pedro.londero@accusys.com.ar">AST 29839- PERIBMISIO</log>
<log LogType="Refactor" revision="17.0" date="27/01/2016" email="patricio.luzzi@accusys.com.ar">AST 30688</log>
<log LogType="Refactor" revision="18.0" date="21/03/2016" email="claudio.soreyra@accusys.com.ar">AST 31317</log>
<log LogType="Refactor" revision="19.0" date="13/04/2016" email="diana.diaz@accusys.com.ar">AST 31896</log>
<log LogType="Refactor" revision="20.0" date="01/12/2016" email="pablo.delgado@accusys.com.ar">AST 36251</log>
<log LogType="Refactor" revision="21.0" date="02/01/2017" email="pedro.londero@accusys.com.ar">AST 32550</log>
<log LogType="Refactor" revision="22.0" date="03/01/2017" email="pablo.delgado@accusys.com.ar">AST 35579</log>
<log LogType="Refactor" revision="23.0" date="12/01/2017" email="natalia.gamarra@accusys.com.ar">AST 36100</log>
<log LogType="Refactor" revision="23.1" date="10/02/2017" email="natalia.gamarra@accusys.com.ar">AST 36100</log>
<log LogType="Refactor" revision="24.0" date="10/04/2017" email="natalia.gamarra@accusys.com.ar">AST 38297</log>
<log LogType="Refactor" revision="25.0" date="19/02/2018" email="mauricio.kranevitter@accusys.com.ar">AST 43174</log>
<log LogType="Refactor" revision="26.0" date="01/03/2018" email="emanuel.haberkorn@accusys.com.ar">AST 41969</log>
<log LogType="Refactor" revision="27.0" date="09/09/2018" email="diego.justet@accusys.com.ar">AST 52654</log>
<log LogType="Refactor" revision="28.0" date="03/01/2020" email="osvaldo.sosa@accusys.com.ar">AST 54394</log>
<log LogType="Refactor" revision="28.0" date="20/08/2020" email="diego.justet@accusys.com.ar">AST 57325</log>
<log LogType="Refactor" revision="29.0" date="10/08/2020" email="jose.barrera@accusys.com.ar">AST 63056</log>
<log LogType="Refactor" revision="30.0" date="17/08/2021" email="andres.paredes@accusys.com.ar">AST 63086</log>
<log LogType="Refactor" revision="31.0" date="13/01/2022" email="jose.barrera@accusys.com.ar">AST 64957</log>
</historylog>*/

create proc sp_sell_prov (
--<parameters>
@s_ssn                                  int                            = null             ,--<param required ="no"      description="Numero secuencial unico dado por el monitor transaccional para la transaccion."/>
@s_user                                 varchar(8)                     = null             ,--<param required ="no"      description="Nombre del Usuario registrado que ejecuta la transaccion (login)."/>
@s_sesn                                 int                            = null             ,--<param required ="no"      description="Numero de la sesion o de registro del usuario que ejecuta la transaccion."/>
@s_term                                 varchar(30)                    = null             ,--<param required ="no"      description="Nombre o identificacion de la terminal donde se ejecuto la transaccion."/>
@s_date                                 datetime                       = null             ,--<param required ="no"      description="Fecha de proceso del servidor en que se ejecuta la transaccion."/>
@s_srv                                  varchar(30)                    = null             ,--<param required ="no"      description="Nombre del servidor donde se origina la transaccion."/>
@s_lsrv                                 varchar(30)                    = null             ,--<param required ="no"      description="Nombre del servidor donde se encuentra la transaccion."/>
@s_rol                                  smallint                       = null             ,--<param required ="no"      description="Numero del rol con el cual se encuentra registrado el usuario."/>
@s_ofi                                  smallint                       = null             ,--<param required ="no"      description="Numero de la oficina donde se encuentra registrado el usuario que ejecuta la transaccion."/>
@s_org_err                              char(1)                        = null             ,--<param required ="no"      description="Origen del error si existiera: [A]plicacion  [S]istema"/>
@s_error                                int                            = null             ,--<param required ="no"      description="Numero de error generado."/>
@s_sev                                  tinyint                        = null             ,--<param required ="no"      description="Severidad del error: [0] - No rollback  [1] - Si rollback"/>
@s_msg                                  descripcion                    = null             ,--<param required ="no"      description="Texto descriptivo del error producido."/>
@s_org                                  char(1)                        = null             ,--<param required ="no"      description="Origen de la transaccion:  [L] - Local  [R] - Resubmit  [S] - Submit"/>
@t_debug                                char(1)                        = 'N'              ,--<param required ="no"      description="Indica si la transaccion debe ser ejecutada en modo de depuracion: [S]i  [N]o"/>
@t_file                                 varchar(10)                    = null             ,--<param required ="no"      description="Nombre del archivo que contendra los resultados enviados en modo de debug."/>
@t_from                                 varchar(32)                    = null             ,--<param required ="no"      description="Stored Procedure desde el que fue llamado el programa actual."/>
@t_trn                                  smallint                       = null             ,--<param required ="no"      description="Codigo unico de transaccion Cobis."/>
@i_filial                               tinyint                        = 1                ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_informacion                    smalldatetime                  = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_formulario                           varchar(10)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_formato_fecha                        tinyint                        = 103              ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_impuesto                             catalogo                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_quien_llama                          char(1)                        = 'B'              ,--<param required ="no"      description="B back-end  F front-end"/>
@i_operacion                            char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_opcion                               tinyint                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha                                datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_desde                          datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_hasta                          datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fechahasta                           datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_fv_desde                       datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_fvhasta                        datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_fv_hasta                       datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_info                           datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_infohasta                      datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_categoria                            catalogo                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_categoria_hasta                      catalogo                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_moneda                               tinyint                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_moneda_hasta                         tinyint                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_estado                               char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cliente                              int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cliente_hasta                        int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_producto                             smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_tipo_mov                             varchar(10)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_tipo_mov_hasta                       varchar(10)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_impuesto_hasta                       catalogo                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_sucursal                             smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_sucursal_desde                       smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_sucursal_hasta                       smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_sucursalhasta                        smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cta_banco                            varchar(27)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cta_banco_hasta                      varchar(27)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_codigo_trx                           smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cbu                                  varchar(22)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cbu_hasta                            varchar(22)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_ajuste                               varchar(1)                     = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_region                               int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cant_rows                            tinyint                        = 20               ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_identity_hasta                       int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_ced_ruc                              varchar(11)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_ced_ruc_hasta                        varchar(11)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_denominacion                         varchar(96)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_denominacion_hasta                   varchar(96)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_rol                                  char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_rol_hasta                            char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_numero                               varchar(20)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_numero_hasta                         varchar(20)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cliente_com                          varchar(8)                     = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cotizacion                           float                          = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_dummy                                int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_modulo                               smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_servicio                             varchar(10)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_modulo_hasta                         smallint                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_servicio_hasta                       varchar(10)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_liquidacion_hasta              datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_liquidacion                    datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_valor_hasta                    datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_concepto_hasta                       varchar(10)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cod_alterno                          int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_secuencial                           int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_secuencial_hasta                     int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_cargo_banco                          char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_alicuota_hasta                       float                          = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_disenio                              varchar(10)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_adicionales_hasta                    varchar(40)                    = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_credito                              char(1)                        = 'N'              ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_ente                                 int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_fecha_fv                             datetime                       = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_sig_col                              int                            = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_e_ultimo_reg                         char(1)                        = null             ,--<param required ="no"      description="Variable de entrada del Stored Procedure."/>
@i_identity                             int                            = null             ,--< param required ="no"      description="Variable de entrada del Stored Procedure."/>
@o_m_impuesto_parametrizado             char (1)                       = null out          --<param required ="no"      description="Marca que indica si el impuesto esta parametrizado."/>
--</parameters>
)--with recompile
as
declare
   @w_sp_name           varchar(30),
   @w_return            int,
   @w_numeroerror       int,
   @w_sev               int,
   @w_msg               varchar(132),
   @w_mensaje_tiempo    varchar(255),
   @w_fecha_proceso     datetime,
   @w_fecha_desde       datetime,
   @w_estado_form       catalogo,
   @w_retorno           int,
   @w_mensaje           varchar(255),
   @w_error_str         varchar(10),
   @w_registros         int,
   @w_dummy             int,

   @w_tabla_bc_monedas_dgr smallint,
   @w_tabla_bc_rol_tit_dgr smallint,

   /*PARA EL CURSOR PRINCIPAL DE RETENCIONES*/
   @w_cur_ci_impuesto         catalogo,
   @w_cur_ci_categoria        catalogo,
   @w_cur_ci_producto         tinyint,
   @w_cur_ci_cliente          int,
   @w_cur_ci_cta_banco        cuenta,
   @w_cur_ci_cbu              cuenta,
   @w_cur_ci_ajuste           tinyint,
   @w_cur_ci_moneda_str       catalogo,
   @w_cur_ci_prod_banc        smallint,
   @w_cur_ci_valor_conv_pesos money,
   @w_cur_ci_base_imponible   money,
   @w_cur_ci_fecha_liquidacion   smalldatetime,
   @w_cur_count_op            smallint,
   @w_cur_ci_fecha_fv         datetime,
   @w_cur_ci_alicuota         float,
   @w_cur_ci_referencia       char(1),
   @w_moneda_dgr              varchar(2),
   @w_ci_prod_banc            smallint,
   @w_tipo_cta_dgr            varchar(2),
   @w_ci_prod_banc_str        varchar(10),

   @w_region                  int,
   @w_sucursal                smallint,
   @w_estado                  char(1),
   @w_estado_cl               char(1),

   @w_moneda                  catalogo,
   @w_tot_retenido            float,
   @w_creditos                float,
   @w_ajustes                 float,

   @w_cuit_agente             varchar(13),


   /*PARA EL CURSOR DE CLIENTES ASOCIADOS A LA CUENTA*/
   @w_cur_cl_cliente          int,
   @w_cur_rol_bcra            catalogo,
   @w_en_nombre               varchar(96),
   @w_en_ttributa             catalogo,
   @w_en_ced_ruc              varchar(20),
   @w_numero                  varchar(20),
   @w_ei_categoria_aux        catalogo,

   @w_cbu_anterior            cuenta,

   @w_cur_re_categoria        catalogo,
   @w_cur_re_cbu              cuenta,
   @w_cur_re_referencia       char(1),
   @w_cur_re_region           int,
   @w_cur_re_moneda_dgr       varchar(2),
   @w_cur_re_tipo_cta_dgr     varchar(2),
   @w_cur_re_base_calculo     money,
   @w_cur_re_imp_retencion    money,
   @w_cur_re_tipo_ajuste      tinyint,
   @w_cur_re_cant_operaciones smallint,
   @w_cur_re_estado           char(1),
   @w_cur_re_fecha_fv         datetime,
   @w_cur_re_alicuota         float,
   @w_cur_re_ente             int,
   --DMJ 
   @w_sig_col_err             int,
   @w_registros_err           int,
   @w_registros_aux           int,
   @w_e_ultimo_reg            char(1),
   @w_k_rows                  int, 
   @w_k_rows_aux              int,   
   @w_cur_sec                 int, 
   @w_cur_e_registro          char(1), 
    
   @w_ei_referencia           char(1),
   @w_rango                   smallint,

   /*VARIABLES PARA LA CONSULTA DE IMPUESTOS*/
   @w_ci_fecha_proceso                  datetime            ,
   @w_ci_retorno                        int                 ,
   @w_ci_fecha                          datetime            ,
   @w_ci_impuesto                       catalogo            ,
   @w_cw_categoria                      catalogo            ,
   @w_ci_servicio                       catalogo            ,
   @w_ci_modulo                         tinyint             ,
   @w_ci_producto                       catalogo            ,
   @w_ci_ente                           int                 ,
   @w_ci_cuenta                         varchar(16)         ,
   @w_ci_moneda                         tinyint             ,
   @w_ci_capital                        money               ,
   @w_ci_interes                        money               ,
   @w_ci_comision                       money               ,
   @w_ci_iva                            money               ,
   @w_ci_numeral                        money               ,
   @w_ci_cantidad_cheques               smallint            ,
   @w_ci_movimiento_manual              char(1)             ,
   @w_ci_sucursal_origen                smallint            ,
   @w_ci_sucursal_destino               smallint            ,
   @w_ci_cantidad_dias_pfijo            smallint            ,
   @w_ci_nemonico_impuesto              catalogo            ,
   @w_co_im_afip                        catalogo            ,
   @w_co_ei_categoria                   catalogo            ,
   @w_co_ei_numero                      varchar(20)         ,
   @w_co_ei_referencia                  varchar(20)         ,
   @w_co_ia_identity_g                  int                 ,
   @w_co_redondeo                       catalogo            ,
   @w_co_porc_base_imp                  float               ,
   @w_co_tipo_tope_min                  varchar(17)         ,
   @w_co_tipo_tope_max                  varchar(17)         ,
   @w_co_min_imp_a_cobrar               money               ,
   @w_co_max_imp_a_cobrar               money               ,
   @w_co_ia_identity_c                  int                 ,
   @w_co_ia_valor_1_c                   float               ,
   @w_co_ia_valor_2_c                   float               ,
   @w_co_ia_categoria_c                 catalogo            ,
   @w_co_ia_identity_p                  int                 ,
   @w_co_ia_valor_1_p                   float               ,
   @w_co_ia_valor_2_p                   float               ,
   @w_co_importe_a_cobrar               money               ,
   @w_co_importe_calculado              money               ,
   @w_co_monto_base_imponible           money               ,
   @w_co_cotizacion                     float               ,
   @w_co_tipo_alicuota                  int                 ,
   @w_co_tipo_periodicidad              smallint            ,
   @w_co_alicuota_aplicada              float               ,
   @w_co_ir_valor_desde                 money               ,
   @w_co_ir_alicuota                    float               ,
   @w_co_ir_valor_fijo                  money               ,
   @w_co_min_importe_a_cobrar_pes       money               ,
   @w_co_max_importe_a_cobrar_pes       money               ,
   @w_co_base_imponible                 smallint            ,
   @w_bc_impuesto_sector_exento         float               ,
   @w_bc_impuesto_producto_exento       float               ,
   @w_ci_estado                         char(1)             ,
   @w_fecha_desde_segundo_dia           datetime            ,
   @w_fecha_hasta_primer_dia            datetime            ,
   @w_tipo_direccion_legal              varchar(10)         ,
   @w_cod_tabla                         smallint            ,

   /*VARIABLES DE TRABAJO PARA EL FRONT-END*/
   @w_tabla_catalogo          smallint,
   @w_fecha                   datetime,
   @w_fecha_hasta             datetime,
   @w_jurisdiccion            char(3),
   @w_tabla_moneda_bcra       smallint

/*-- AST_64957 --*/
set compatibility_mode off

/*INICIALIZO LAS VARIABLES*/
select   @w_sp_name = 'sp_sell_prov' + @i_formulario,
         @w_mensaje_tiempo = convert(varchar(10),getdate(),@i_formato_fecha) + ' ' + convert(varchar(10),getdate(),108),
         @w_registros = 0,
         @w_numeroerror = 0,
         @w_retorno = 0

if @i_quien_llama = 'F'
begin   -- @i_quien_llama = 'F' -- LLAMA EL FRONT-END
  /* CONSULTA */
   if @i_operacion = 'Q'
   begin   -- ES UNA CONSULTA
      if @i_opcion = 1
      begin -- @i_opcion = 1 --PARA F5 Y LOST FOCUS DE CODIGO IMPUESTO
         set rowcount @i_cant_rows

         if @i_impuesto is null
         begin -- NO ME MANDAN IMPUESTO

            select 'IMPUESTO'    = im_impuesto,
                   'DESCRIPCION' = im_descripcion,
                   '#REGISTROS'  = count(1)
            from  bc_impuestos
            where ((im_impuesto like 'SELL%') or (im_impuesto like 'PER%') or (im_impuesto like 'FORPRO%') or (im_impuesto = 'GANANCIAS') )
            and im_impuesto > isnull(@i_impuesto_hasta, '')
            group by im_impuesto, im_descripcion
            order by im_impuesto, im_descripcion

            if @@rowcount = 0  and @i_impuesto_hasta is null
            begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
               select @w_numeroerror = 2900067
               goto error_trap
            end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
         end   -- NO ME MANDAN IMPUESTO
         else
         begin -- ME MANDAN IMPUESTO ES LF

            select   'IMPUESTO'     =  im_impuesto,
                     'DESCRIPCION'  =  im_descripcion,
                     '#REGISTROS'   =  count(1)
            from  bc_impuestos
            where ((im_impuesto like 'SELL%') or (im_impuesto like 'PER%')or (im_impuesto like 'FORPRO%') or (im_impuesto = 'GANANCIAS') )
            and im_impuesto = @i_impuesto
            group by im_impuesto, im_descripcion
            order by im_impuesto, im_descripcion
            
            if @@rowcount = 0
            begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
               select @w_numeroerror = 2900067
               goto error_trap
            end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
         end   -- ME MANDAN IMPUESTO ES LF

         set rowcount 0
         return 0

      end   -- @i_opcion = 1 --PARA F5 Y LOST FOCUS DE CODIGO IMPUESTO
      else
      if @i_opcion = 2
      begin  --@i_opcion = 2  --PARA F5 DE FECHA DESDE Y FECHA HASTA

         if @i_cant_rows = 1
         begin -- VIENE A BUSCAR LA MAXIMO FECHA PARA EL IMPUESTO SIN FILTRO
            select @w_fecha   = max(ic_fecha_liquidacion)
            from bc_impuesto_cobro
            where ic_impuesto = @i_impuesto
            and ic_estado  = 'L'
            and ic_importe_retenido_pesos <> 0.00
            --and ci_grupo_trx not in ('EXEN')

            if @w_fecha is null
            begin
               select @w_numeroerror = 2900067
               goto error_trap
            end
            else
            begin
               select convert(varchar(10),@w_fecha,@i_formato_fecha), 1
            end

            return 0
         end   -- VIENE A BUSCAR LA MAXIMO FECHA PARA EL IMPUESTO SIN FILTRO

         set rowcount @i_cant_rows

         select 'F_LIQ'        = convert(varchar(10),ic_fecha_liquidacion,@i_formato_fecha),
                '#REGISTROS'   = count(ic_fecha_liquidacion)
         from bc_impuesto_cobro
         where ic_impuesto = @i_impuesto
         and ic_estado = isnull(@i_estado,'L')
         and ic_importe_retenido_pesos <> 0.00
         and ic_fecha_liquidacion >= isnull(@i_fecha_desde, '01/01/1800')
         and ic_fecha_liquidacion <= isnull(@i_fecha_hasta, '01/01/3000')
         /*PARA EL SIGUIENTE*/
         and ic_fecha_liquidacion < isnull(@i_fechahasta,'01/01/3000')
         group by ic_fecha_liquidacion
         order by ic_fecha_liquidacion desc

        if @@rowcount = 0  and @i_fechahasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end   --@i_opcion = 2  --PARA F5 DE FECHA DESDE Y FECHA HASTA
      else



      if @i_opcion = 23
      begin  --@i_opcion = 23  --PARA F5 DE FECHA DESDE Y FECHA HASTA PARA SELLTUCUMA FORMULARIO FImpSellProv.frm
         
--         set rowcount @i_cant_rows
            
         select   'F_LIQ'  = convert(varchar(10),ff_fecha_informac,@i_formato_fecha),
                  'ESTADO' = convert(varchar(2),ff_estado_form)
         from cob_bcradgi..bc_fec_formulas
         where ff_nro_formulario = @i_impuesto  --'SELLTUCUMA'
         and ff_estado_form = 'FC'
         --SIGUIENTE
         --and ff_fecha_informac >= isnull(@i_fechahasta,'01/01/1900')

--         set rowcount 0
         return 0
      end   --@i_opcion = 23  --PARA F5 DE FECHA DESDE Y FECHA HASTA PARA SELLTUCUMA FORMULARIO FImpSellProv.frm



      else
      if @i_opcion = 3
      begin -- if @i_opcion = 3  -- F5  PARA TOTAL PERCIBIDO
         set rowcount @i_cant_rows

         select   isnull(round(sum(ic_monto_base_imponible),2),0),
                  isnull(round(sum(ic_importe_retenido_pesos),2),0),
                  count(1)
         from bc_impuesto_cobro
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto   = @i_impuesto--IMPUESTO
         and ic_categoria  = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda     = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado     = isnull(@i_estado,'L')--ESTADO
         and ic_region     = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente       = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo     = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta     = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))


         if @@rowcount = 0
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end   -- if @i_opcion = 3  -- F5  PARA TOTAL PERCIBIDO
      else
      if @i_opcion = 4
      begin -- if @i_opcion = 4  -- F5 DE CATEGORIA

         set rowcount @i_cant_rows

         select 'CATEGORIA'   = ic_categoria,
                'DESCRIPCION' = max(isnull((select icc.ic_descripcion from bc_impuesto_categorias icc where ic.ic_categoria = icc.ic_categoria and ic.ic_impuesto = icc.ic_impuesto),'S/DESC')),
                '#REGISTROS'  = count(ic_categoria)
         from bc_impuesto_cobro ic
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto   = @i_impuesto--IMPUESTO
         and ic_categoria  = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda     = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado     = isnull(@i_estado,'L')--ESTADO
         and ic_region     = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente       = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo     = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta     = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO
         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         /* PARA EL SIG */
         and ic_categoria > isnull(@i_categoria_hasta, char(31))
         group by ic_categoria
         order by ic_categoria

         if @@rowcount = 0  and @i_categoria_hasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end   -- if @i_opcion = 4  -- F5 DE CATEGORIA
      else
      if @i_opcion = 5
      begin  -- if @i_opcion = 5  -- F5 DE MONEDA
         set rowcount @i_cant_rows

         select 'MONEDA'       = ic_moneda,
                'DESCRIPCION'  = max(( select mo_descripcion
                                       from cobis..cl_moneda
                                       where mo_moneda = i.ic_moneda
                                       and mo_estado = 'V')),
                '#REGISTROS'   = count(ic_moneda)
         from bc_impuesto_cobro i
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto  = @i_impuesto--IMPUESTO
         and ic_categoria = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda    = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado    = isnull(@i_estado,'L')--ESTADO
         and ic_region  = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente    = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo   = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         /*PARA EL SIG*/
         and ic_moneda > isnull(@i_moneda_hasta, 0)
         group by ic_moneda
         order by ic_moneda

         if @@rowcount = 0  and @i_moneda_hasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end -- if @i_opcion = 5  -- F5 DE MONEDA
      else
      if @i_opcion = 6
      begin  --@i_opcion = 6 -- GRILLA RESUMEN CATEGORIA / MONEDA

         set rowcount @i_cant_rows

         select   'SUCURSAL'     =  ic_sucursal,
                  'MODULO'       =  ic_modulo,
                  'CATEGORIA'    =  ic_categoria,
                  'MONEDA'       =  ic_moneda,
                  'SERVICIO'     =  ic_concepto,
                  'B.IMPONIBLE'  =  round(sum(ic_monto_base_imponible),2),
                  'PERCIBIDO'    =  round(sum(  case sign(ic_importe_retenido_pesos)
                                          when 1 then ic_importe_retenido_pesos
                                          else 0
                                          end
                                        ),2),
                  'CREDITOS'     =  round(sum(  case sign(ic_importe_retenido_pesos)
                                          when -1 then ic_importe_retenido_pesos
                                          else 0
                                          end
                                        ),2),
                  'NETO'         =  round(sum(ic_importe_retenido_pesos),2),
                  'IMPUESTO'     =  ic_impuesto,
                  count(count(1)),
                  'CANT'         =  count(1)
         from bc_impuesto_cobro
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto   = @i_impuesto--IMPUESTO
         and ic_categoria  = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda     = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado     = isnull(@i_estado,'L')--ESTADO
         and ic_region     = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente       = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo     = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,ic_sucursal) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto  = isnull(@i_servicio,ic_concepto) --SERVICIO
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         /*PARA LOS SIGUIENTES*/
         and   (  (      ic_sucursal    =  isnull(  @i_sucursal_hasta ,ic_sucursal)
                     and ic_modulo      =  isnull(  @i_modulo_hasta   ,ic_modulo)
                     and ic_categoria   =  isnull(  @i_categoria_hasta,ic_categoria)
                     and ic_moneda      =  isnull(  @i_moneda_hasta   ,ic_moneda)
                     and ic_concepto    >  isnull(  @i_servicio_hasta ,'')
                  )
               or
                  (      ic_sucursal    =  isnull(  @i_sucursal_hasta ,ic_sucursal)
                     and ic_modulo      =  isnull(  @i_modulo_hasta   ,ic_modulo)
                     and ic_categoria   =  isnull(  @i_categoria_hasta,ic_categoria)
                     and ic_moneda      >  isnull(  @i_moneda_hasta   ,0)
                  )
               or
                  (      ic_sucursal    =  isnull(  @i_sucursal_hasta ,ic_sucursal)
                     and ic_modulo      =  isnull(  @i_modulo_hasta   ,ic_modulo)
                     and ic_categoria   >  isnull(  @i_categoria_hasta,'')
                  )
               or
                  (      ic_sucursal    =  isnull(  @i_sucursal_hasta ,ic_sucursal)
                     and ic_modulo      >  isnull(  @i_modulo_hasta   ,0)
                  )
               or
                  (      ic_sucursal    >  isnull(  @i_sucursal_hasta ,0)
                  )
               )
         group by ic_sucursal,ic_modulo,ic_categoria,ic_moneda,ic_concepto,ic_impuesto
         order by ic_sucursal,ic_modulo,ic_categoria,ic_moneda,ic_concepto,ic_impuesto


         if @@rowcount = 0  and @i_categoria_hasta is null and @i_sucursal_hasta is null and @i_modulo_hasta is null and @i_servicio_hasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end --@i_opcion = 6 -- GRILLA RESUMEN CATEGORIA / MONEDA
      else

      if @i_opcion = 7
      begin  --@i_opcion = 7 -- GRILLA IMPUESTO
         set rowcount @i_cant_rows

         select
            'SUCURSAL'     =  ic_sucursal,
            'MODULO'       =  ic_modulo,
            'F_LIQUIDAC'   =  convert(varchar(10), ic_fecha_liquidacion, @i_formato_fecha),
            'F_VALOR'      =  convert(varchar(10), ic_fecha_valor  , @i_formato_fecha),
            'CATEGORIA'    =  ic_categoria,
            'MONEDA'       =  ic_moneda,
            'SERVICIO'     =  ic_concepto,
            'B.IMPONIBLE'  =  round(sum(ic_monto_base_imponible ),2),
            'PERCIBIDO'    =  round(sum(  case sign(ic_importe_retenido_pesos)
                                    when 1 then ic_importe_retenido_pesos
                                    else 0
                                    end
                                  ),2),
            'CREDITOS'     =  round(sum(  case sign(ic_importe_retenido_pesos)
                                    when -1 then ic_importe_retenido_pesos
                                    else 0
                                    end
                                  ),2),
            'NETO'         =  round(sum(ic_importe_retenido_pesos),2),
            'IMPUESTO'     =  ic_impuesto,
            count(count(1)),
            'CANT'         =  count(1)
         from  cob_bcradgi..bc_impuesto_cobro
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto  = @i_impuesto--IMPUESTO
         and ic_categoria = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda    = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado    = isnull(@i_estado,'L')--ESTADO
         and ic_region  = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente    = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo   = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto  = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))

         /*AHORA PARA EL SIGUIENTE*/
         and   (  (        ic_sucursal          =  isnull(@i_sucursal_hasta         ,ic_sucursal          )
                     and   ic_modulo            =  isnull(@i_modulo_hasta           ,ic_modulo            )
                     and   ic_fecha_liquidacion =  isnull(@i_fecha_liquidacion_hasta,ic_fecha_liquidacion )
                     and   ic_fecha_valor       =  isnull(@i_fecha_valor_hasta      ,ic_fecha_valor       )
                     and   ic_categoria         =  isnull(@i_categoria_hasta        ,ic_categoria         )
                     and   ic_moneda            =  isnull(@i_moneda_hasta           ,ic_moneda            )
                     and   ic_concepto          >  isnull(@i_concepto_hasta         ,'')
                  )
                  or
                  (        ic_sucursal          =  isnull(@i_sucursal_hasta         ,ic_sucursal          )
                     and   ic_modulo            =  isnull(@i_modulo_hasta           ,ic_modulo            )
                     and   ic_fecha_liquidacion =  isnull(@i_fecha_liquidacion_hasta,ic_fecha_liquidacion )
                     and   ic_fecha_valor       =  isnull(@i_fecha_valor_hasta      ,ic_fecha_valor       )
                     and   ic_categoria         =  isnull(@i_categoria_hasta        ,ic_categoria         )
                     and   ic_moneda            >  isnull(@i_moneda_hasta           ,0)
                  )
                  or
                  (        ic_sucursal          =  isnull(@i_sucursal_hasta         ,ic_sucursal          )
                     and   ic_modulo            =  isnull(@i_modulo_hasta           ,ic_modulo            )
                     and   ic_fecha_liquidacion =  isnull(@i_fecha_liquidacion_hasta,ic_fecha_liquidacion )
                     and   ic_fecha_valor       =  isnull(@i_fecha_valor_hasta      ,ic_fecha_valor       )
                     and   ic_categoria         =  isnull(@i_categoria_hasta        ,ic_categoria         )
                     and   ic_moneda            >  isnull(@i_moneda_hasta           ,0)
                  )
                  or
                  (        ic_sucursal          =  isnull(@i_sucursal_hasta         ,ic_sucursal          )
                     and   ic_modulo            =  isnull(@i_modulo_hasta           ,ic_modulo            )
                     and   ic_fecha_liquidacion =  isnull(@i_fecha_liquidacion_hasta,ic_fecha_liquidacion )
                     and   ic_fecha_valor       =  isnull(@i_fecha_valor_hasta      ,ic_fecha_valor       )
                     and   ic_categoria         >  isnull(@i_categoria_hasta        ,'')
                  )
                  or
                  (        ic_sucursal          =  isnull(@i_sucursal_hasta         ,ic_sucursal          )
                     and   ic_modulo            =  isnull(@i_modulo_hasta           ,ic_modulo            )
                     and   ic_fecha_liquidacion =  isnull(@i_fecha_liquidacion_hasta,ic_fecha_liquidacion )
                     and   ic_fecha_valor       >  isnull(@i_fecha_valor_hasta      ,'01/01/1900')
                  )
                  or
                  (        ic_sucursal          =  isnull(@i_sucursal_hasta         ,ic_sucursal          )
                     and   ic_modulo            =  isnull(@i_modulo_hasta           ,ic_modulo            )
                     and   ic_fecha_liquidacion >  isnull(@i_fecha_liquidacion_hasta,'01/01/1900')
                  )
                  or
                  (        ic_sucursal          =  isnull(@i_sucursal_hasta         ,ic_sucursal          )
                     and   ic_modulo            >  isnull(@i_modulo_hasta           ,0)
                  )
                  or
                  (        ic_sucursal          >  isnull(@i_sucursal_hasta         ,0)
                  )
               )

         group by ic_sucursal,ic_modulo,ic_fecha_liquidacion,ic_fecha_valor,ic_categoria,ic_moneda,ic_concepto,ic_impuesto
         order by ic_sucursal,ic_modulo,ic_fecha_liquidacion,ic_fecha_valor,ic_categoria,ic_moneda,ic_concepto,ic_impuesto


         if @@rowcount = 0  and @i_categoria_hasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end --@i_opcion = 7 -- GRILLA IMPUESTO
      else
      if @i_opcion = 8
      begin  --@i_opcion = 8   --F5 DE ESTADOS
         set rowcount @i_cant_rows

         select @w_tabla_catalogo = codigo
         from cobis..cl_tabla
         where tabla = 'bc_estados_iibb'

         select   'ESTADO'       = ic_estado,
                  'DESCRIPCION'  = max(isnull(( select valor
                                                from cobis..cl_catalogo
                                                where tabla = @w_tabla_catalogo
                                                and codigo = ci.ic_estado)
                                                               ,'DESCONOCIDO')),
                  '#REGISTROS'   = count(ic_estado)
         from  cob_bcradgi..bc_impuesto_cobro ci
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto  = @i_impuesto--IMPUESTO
         and ic_categoria = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda    = isnull(@i_moneda,ic_moneda)--MONEDA
         --and ic_estado    = isnull(@i_estado,'L')--ESTADO
         and ic_region  = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente    = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo   = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         group by ic_estado
         order by ic_estado

         if @@rowcount = 0
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            if @i_dummy is null
            begin
               select @w_numeroerror = 2900067
               goto error_trap
            end
            else
            begin
               return 2900067
            end
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end  --@i_opcion = 8   --F5 DE ESTADOS
      else
      if @i_opcion = 9
      begin  --@i_opcion = 9  --CLIENTE
         set rowcount @i_cant_rows

         select 'CLIENTE'     = ic_ente,
                'DESCRIPCION' = isnull((  select ltrim(en_nombre + ' '+ p_p_apellido)
                                          from cobis..cl_ente
                                          where en_ente = ci.ic_ente),
                                                                           'NO_DEFINIDO'),
                'CUIT'        = (select en_ced_ruc
                                 from cobis..cl_ente
                                 where en_ente = ci.ic_ente),
                'CATEGORIA'   = ic_categoria,
                '#REGISTROS'  = count(ic_ente)
         from  cob_bcradgi..bc_impuesto_cobro ci
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto   = @i_impuesto--IMPUESTO
         and ic_categoria  = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda     = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado     = isnull(@i_estado,'L')--ESTADO
         and ic_region     = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente       = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo     = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta     = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO
         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))

         /*PARA LOS SIG 20*/
         and (  (   ic_ente   = isnull(@i_cliente_hasta,ic_ente)
                and ic_categoria > isnull(@i_categoria_hasta,'')
                )
             or (   ic_ente > isnull(@i_cliente_hasta,0)
                )
             )
         group by ic_ente, ic_categoria
         order by ic_ente, ic_categoria

         if @@rowcount = 0 and @i_cliente_hasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end  --@i_opcion = 9  --CLIENTE
      else
      if @i_opcion = 10
      begin  --@i_opcion = 10   --REGIONES
         set rowcount @i_cant_rows

         select   'REGION'       = ic_region,
                  'DESCRIPCION'  = max(ltrim(of_descripcion)),
                  '#REGISTROS'   = count(ic_region)
         from  cob_bcradgi..bc_impuesto_cobro , cob_conta..cb_oficina
         where ic_region   = of_oficina
         and ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto  = @i_impuesto--IMPUESTO
         and ic_categoria = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda    = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado    = isnull(@i_estado,'L')--ESTADO
         and ic_region  = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente    = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo   = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         group by ic_region
         order by ic_region

         if @@rowcount = 0
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end  --@i_opcion = 10   --REGIONES
      else
      if @i_opcion = 11
      begin  --@i_opcion = 11   --SUCURSALES
         set rowcount @i_cant_rows

         select 'SUCURSAL'     = ic_sucursal,
                'DESCRIPCION'  = isnull((  select of_nombre
                                    from cobis..cl_oficina
                                    where of_oficina = i.ic_sucursal
                                    and of_filial = @i_filial),'S/DESC'),
                '#REGISTROS'   = count(1)
         from bc_impuesto_cobro i
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto  = @i_impuesto--IMPUESTO
         and ic_categoria = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda    = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado    = isnull(@i_estado,'L')--ESTADO
         and ic_region  = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente    = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo   = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         /*PARA EVALUAR EL LOST FOCUS*/
         and   ic_sucursal =  isnull(@i_sucursal,ic_sucursal)
         /*AHORA PARA EL SIG*/
         and ic_sucursal > isnull(@i_sucursal_hasta,-1)
         group by ic_sucursal
         order by ic_sucursal

         if @@rowcount = 0 and @i_sucursal_hasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end  --@i_opcion = 11   --SUCURSALES

      else
      if @i_opcion = 12
      begin   --@i_opcion = 12   --TIPO DE MOVIMIENTO
         set rowcount @i_cant_rows

         select @w_tabla_catalogo = codigo
         from cobis..cl_tabla
         where tabla = 'bc_grupo_trx'

         select   'T_MOVIM'      = ic_grupo_trx,
                  'DESCRIPCION'  = max(isnull(( select valor
                                                from cobis..cl_catalogo
                                                where tabla = @w_tabla_catalogo
                                                and codigo = i.ic_grupo_trx),
                                                                  'NO_DEF')),
                  '#REGISTROS'   = count(ic_grupo_trx)
         from bc_impuesto_cobro i
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto  = @i_impuesto--IMPUESTO
         and ic_categoria = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda    = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado    = isnull(@i_estado,'L')--ESTADO
         and ic_region  = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente    = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo   = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         group by ic_grupo_trx
         order by ic_grupo_trx

         if @@rowcount = 0
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end  --@i_opcion = 12   --TIPO DE MOVIMIENTO
      else
      if @i_opcion = 13
      begin  --@i_opcion = 13   --MODULOS
         set rowcount @i_cant_rows

         select 'MODULOS'     = ic_modulo,
                'DESCRIPCION' = max((  select pd_descripcion
                                       from cobis..cl_producto
                                       where pd_producto = i.ic_modulo
                                       and pd_estado = 'V')),
                '#REGISTROS'  = count(ic_modulo)
         from bc_impuesto_cobro i
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto   = @i_impuesto--IMPUESTO
         and ic_categoria  = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda     = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado     = isnull(@i_estado,'L')--ESTADO
         and ic_region     = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente       = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo     = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         group by ic_modulo
         order by ic_modulo

         if @@rowcount = 0
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end  --@i_opcion = 13   --MODULOS
      else



      if @i_opcion = 15
      begin  --@i_opcion = 15    --CUENTAS
         set rowcount @i_cant_rows

         select 'CUENTA'      = ic_cuenta,
                '#REGISTROS'  = count(ic_cuenta)
         from bc_impuesto_cobro i
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto   = @i_impuesto--IMPUESTO
         and ic_categoria  = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda     = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado     = isnull(@i_estado,'L')--ESTADO
         and ic_region     = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente       = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo     = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO
         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))

         /*PARA EVALUAR EL LOST FOCUS*/
         and ic_cuenta  like '%' + @i_cta_banco + '%'    --CUENTA
         /*PARA EL SIGUIENTE*/
         and ic_cuenta > isnull(@i_cta_banco_hasta,'')
         group by ic_cuenta
         order by ic_cuenta

         if @@rowcount = 0
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end  --@i_opcion = 15    --CUENTAS
      else
      if @i_opcion = 19
      begin  --@i_opcion = 19  --GRILLA -> PANTALLA DE DETALLE
         
         if @i_identity_hasta is null
         begin
         
            delete from bc_t_impuesto_cobro
            where ti_u_consulta = @s_user
            
            if @@error != 0
            begin -- ERROR DURANTE ELIMINACION
               select 
               @w_return = 2900131, -- 'ERROR AL ELIMINAR REGISTROS DE LA TABLA'
               @w_sev    = 0
               
               goto error_trap
            end -- ERROR DURANTE ELIMINACION
            
            insert into bc_t_impuesto_cobro (
            ti_n_sucursal     ,
            ti_n_cliente      ,
            ti_d_cliente      ,
            ti_n_modulo       ,
            ti_c_servicio     ,
            ti_c_producto     ,
            ti_n_oper         ,
            ti_f_liq          ,
            ti_f_valor        ,
            ti_n_moneda       ,
            ti_i_base_imp_mn  ,
            ti_i_percibido    ,
            ti_p_alic_ap      ,
            ti_p_alic_nom     ,
            ti_s_cobro        ,
            ti_c_id_alic      ,
            ti_c_tip_base_imp ,
            ti_c_impuesto     ,
            ti_n_identity     ,
            ti_k_count        ,
            ti_p_cotizacion   ,
            ti_n_cuit         ,
            ti_c_cargo_banco  ,
            ti_c_cod_regimen  ,
            ti_d_datos_adic   ,
            ti_u_consulta     )
            select 
            ic_sucursal,
            ic_ente,
            isnull((select en_nomlar
                  from cobis..cl_ente
                  where en_ente = i.ic_ente),'S/DESC'),
            ic_modulo,
            ic_concepto,
            ic_producto,
            ic_cuenta,--ic_nro_operacion_comprobante,
            ic_fecha_liquidacion,
            ic_fecha_valor,
            ic_moneda,
            ic_monto_base_imponible ,
            ic_importe_retenido_pesos,
            ic_alicuota,
            ic_alicuota_nominal,
            ic_secuencial,
            ic_identity_alicuota_g,
            ic_tipo_base_imponible,
            ic_impuesto,-- ESTA VARIABLE SE MAPEA PERO NO SE MUESTRA EN LA GRILLA
            ic_identity,
            count(count(1)),
            ic_cotizacion  ,
            isnull(( select isnull(substring(en_ced_ruc,1,2),'27') +'-'+  isnull(substring(en_ced_ruc,3,8),'00000000')+'-'+  isnull(substring(en_ced_ruc,11,1),'6')
                      from cobis..cl_ente
                      where en_ente = i.ic_ente),'27-00000000-6'),
            ic_cargo_banco  ,
            ic_regimen      ,
            ic_datos_adicionales,
            @s_user
            from bc_impuesto_cobro i
            where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
            and ic_impuesto   = @i_impuesto--IMPUESTO
            and ic_categoria  = isnull(@i_categoria,ic_categoria)--CATEGORIA
            and ic_moneda     = isnull(@i_moneda,ic_moneda)--MONEDA
            and ic_estado     = isnull(@i_estado,'L')--ESTADO
            and ic_region     = isnull(@i_region,ic_region)--REGION
            and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
            and ic_ente       = isnull(@i_cliente,ic_ente)--CLIENTE
            and ic_modulo     = isnull(@i_producto,ic_modulo)--MODULO
            and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
            and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
            and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
            and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
            and ic_concepto  = isnull(@i_servicio,ic_concepto) --SERVICIO
            and
               (
                  (        isnull(ic_grupo_trx,'') <>   'EXEN'
                     and   (
                              (
                                 ic_importe_retenido_pesos <> 0.00
                                 and  @i_credito  <> 'S'
                              )
                              or
                              (
                                 ic_importe_retenido_pesos < 0.00
                                 and  @i_credito  = 'S'
                              )
                           )
                  )
                  or
                  (        isnull(ic_grupo_trx,'') =    'EXEN'
                     and   ic_importe_retenido_pesos =  0.00
                     and   @i_credito  <> 'S'
                  )
               )
            and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
            group by ic_sucursal,ic_ente,ic_modulo,ic_concepto,ic_producto,ic_cuenta,ic_fecha_liquidacion,ic_fecha_valor,ic_moneda,ic_monto_base_imponible,
                     ic_importe_retenido_pesos,ic_alicuota,ic_alicuota_nominal,ic_secuencial,ic_identity_alicuota_g,ic_tipo_base_imponible,ic_impuesto,
                     ic_identity,ic_cotizacion,ic_cargo_banco,ic_regimen,ic_datos_adicionales
            
            select 
            @w_k_rows      = @@rowcount,
            @w_numeroerror = @@error

            if @w_k_rows = 0 and @i_identity_hasta is null
            begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
               select @w_numeroerror = 2900067
               
               goto error_trap
            end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            
            if @w_numeroerror <> 0
            begin -- ERROR DURANTE INSERCION
               select
               @w_return = 2809066, -- 'ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO'
               @w_sev    = 0
               
               goto error_trap
            end -- ERROR DURANTE INSERCION
            
         end
         
         set rowcount @i_cant_rows         
         
         select
         'SUCURSAL'       = ti_n_sucursal     ,
         'CLIENTE'        = ti_n_cliente      ,
         'DESC_CLI'       = ti_d_cliente      ,
         'MODULO'         = ti_n_modulo       ,
         'SERVICIO'       = ti_c_servicio     ,
         'PRODUCTO'       = ti_c_producto     ,
         'NRO_OPER'       = ti_n_oper         ,
         'F_LIQ'          = convert(varchar(10), ti_f_liq,   @i_formato_fecha),
         'F_VALOR'        = convert(varchar(10), ti_f_valor, @i_formato_fecha),
         'MONEDA'         = ti_n_moneda       ,
         'BASE_IMP_MN'    = ti_i_base_imp_mn  ,
         'IMP_PERCIBIDO'  = ti_i_percibido    ,
         'ALIC_AP'        = ti_p_alic_ap      ,
         'ALIC_NOM'       = ti_p_alic_nom     ,
         'SECUENCIAL_COB' = ti_s_cobro        ,
         'ID_ALIC'        = ti_c_id_alic      ,
         'TIP_BASE_IMP'   = ti_c_tip_base_imp ,
         'IMPUESTO'       = ti_c_impuesto     ,
         'IDENTITY'       = convert(int, ti_n_identity)     ,
         'COUNT'          = ti_k_count        ,
         'COTIZACION'     = ti_p_cotizacion   ,
         'CUIT'           = ti_n_cuit         ,
         'CARGO_BANCO'    = ti_c_cargo_banco  ,
         'COD_REGIMEN'    = ti_c_cod_regimen  ,
         'DATOS_ADIC'     = ti_d_datos_adic   
         from bc_t_impuesto_cobro
         where ti_u_consulta = @s_user
         and   ( ( ti_f_liq < isnull(@i_fechahasta,'01/01/3000')
                   )
                    or
                  (ti_f_liq   = isnull(@i_fechahasta,ti_f_liq)
                  and
                   ti_n_identity  > isnull(@i_identity_hasta,0))
               )         
         order by ti_u_consulta, ti_f_liq desc, ti_n_identity
         
         set rowcount 0

         return 0
      end  --@i_opcion = 19  --GRILLA -> PANTALLA DE DETALLE
      else
      if @i_opcion = 50
      begin  --@i_opcion = 50  -- PARA F5 DE FECHA VALOR DESDE Y FECHA HASTA
         set rowcount @i_cant_rows

         select 'F_VALOR'        = convert(varchar(10),ic_fecha_valor,@i_formato_fecha),
                '#REGISTROS'     = count(ic_fecha_valor)
         from bc_impuesto_cobro
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta--FECHAS DESDE HASTA
         and ic_impuesto  = @i_impuesto--IMPUESTO
         and ic_categoria = isnull(@i_categoria,ic_categoria)--CATEGORIA
         and ic_moneda    = isnull(@i_moneda,ic_moneda)--MONEDA
         and ic_estado    = isnull(@i_estado,'L')--ESTADO
         and ic_region  = isnull(@i_region,ic_region)--REGION
         and ic_fecha_valor  between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente    = isnull(@i_cliente,ic_ente)--CLIENTE
         and ic_modulo   = isnull(@i_producto,ic_modulo)--MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,''))     --TIPO MOV
         and ic_cuenta    = isnull(@i_cta_banco,ic_cuenta)    --CUENTA
         /*PARA EL SIGUIENTE*/
         and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         and ic_fecha_valor < isnull(@i_fecha_fv_hasta,'01/01/3000')
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO

         and
            (
               (        isnull(ic_grupo_trx,'') <>   'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito  <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito  = 'S'
                            )
                         )
               )
               or
               (        isnull(ic_grupo_trx,'') =    'EXEN'
                  and   ic_importe_retenido_pesos =  0.00
                  and   @i_credito  <> 'S'
               )
            )
         group by ic_fecha_valor
         order by ic_fecha_valor desc

        if @@rowcount = 0  and @i_fecha_fvhasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end   --@i_opcion = 50  -- PARA F5 DE FECHA VALOR DESDE Y FECHA HASTA
      else /*ANIDADO DE OPCION*/
      if @i_opcion = 52
      begin --@i_opcion = 52  -- PARA GENERACION DEL PLANO PARA PERIB
          

         select @w_fecha_desde = isnull(@i_fecha_fv_desde, @i_fecha_desde)
         select @w_fecha_hasta = isnull(@i_fecha_fvhasta, @i_fecha_hasta)

         if exists (select 1
                    from  cob_bcradgi..bc_p_impuestos
                    where im_impuesto = @i_impuesto)
         begin -- IMPUESTO PARAMETRIZADO
            if isnull (@i_identity_hasta, 0) = 0
            begin
               /* VALIDO QUE EL IMPUESTO ESTE PARAMETRIZADO EN LAS TABLAS CORRESPONDIENTES Y QUE EL ESTADO DE LA FORMULA SEA EL CORRECTO */
               exec @w_return = cob_bcradgi..sp_validaciones_periibb -- ESTE SP ES GENERICO PARA LAS PERCEPCIONES DE INGRESOS BRUTOS DE TODAS LAS PROVINCIAS
               @i_c_operacion   = 'V',
               @i_n_opcion      = 1,
               @i_m_quien_llama = 'F',
               @i_c_impuesto    = @i_impuesto,
               @i_f_desde       = @w_fecha_desde,
               @i_f_hasta       = @w_fecha_hasta

               if @w_return <> 0
               begin
                  return @w_return
               end
            end
         end-- IMPUESTO PARAMETRIZADO

         if @i_impuesto = 'PERIBBSAS'
         begin -- ES PERCEPCION DE BUENOS AIRES

            if exists (select 1
                       from  cob_bcradgi..bc_p_impuestos
                       where im_impuesto = @i_impuesto)
            begin -- IMPUESTO PARAMETRIZADO

               /* OBTENGO LOS DATOS DE LA PRESENTACION */
               exec @w_return = cob_bcradgi..sp_peribbsas -- ESTE SP ES EXCLUSIVO PARA LAS PERCEPCIONES DE INGRESOS BRUTOS DE BUENOS AIRES
               @i_c_operacion   = 'Q',
               @i_n_opcion      = 1,
               @i_m_quien_llama = 'F',
               @i_f_desde       = @w_fecha_desde,
               @i_f_hasta       = @w_fecha_hasta,
               @i_k_rowcount    = @i_cant_rows,
               @i_s_hasta       = @i_identity_hasta

               if @w_return <> 0
               begin
                  return @w_return
               end

            end
            else -- IMPUESTO NO PARAMETRIZADO
            begin

               set rowcount @i_cant_rows

               select
                  'CUIT'      =  substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1),
                  'BASE_IMP'  =  (case
                                    when  ss_base_calculo >= 0   then '0'
                                    else '-'
                                  end)+ convert(char(11),replicate('0',11 - datalength(ltrim(convert(varchar(11),str(abs(ss_base_calculo),11,2))))) + ltrim(convert(varchar(11),str(abs(ss_base_calculo),11,2)))),
                  'IMP_RET'   =  (case
                                    when ss_imp_retencion >= 0 then '0'
                                    else '-'
                                 end) +   convert(char(10),replicate('0',10 - datalength(ltrim(str(abs(ss_imp_retencion),10,2)))) + ltrim(str(abs(ss_imp_retencion),10,2))),
                  'FECHA'     =  convert(varchar(10),ss_fecha_fv_informa,103),
                  'T_OPERACION' = ss_disenio,
                  'CANT'      =  ss_descripcion ,
                  'ID'        =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   ss_disenio        =  @i_disenio
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity

            end -- IMPUESTO NO PARAMETRIZADO

         end -- ES PERCEPCION DE BUENOS AIRES
         else
         if @i_impuesto = 'PERIBMISIO'
         begin -- ES PERCEPCION DE MISIONES
            select @w_jurisdiccion = replicate ('0', 3 - datalength (ltrim (convert (varchar (3), im_afip)))) + ltrim (convert (varchar (3), im_afip))
            from  cob_bcradgi..bc_impuestos
            where im_impuesto = @i_impuesto
            and   im_estado   = 'V'

            if @@rowcount = 0
            begin 
               select @w_jurisdiccion = '000'
            end
            
            set rowcount @i_cant_rows
            
            if @i_disenio  =  'A'
            begin -- PLANO DE OPERACIONES DE MISIONES (PANTALLA DE PRESENTACION DE INFORMACION)
               select
                  'RENGLON'   =  convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),ss_descripcion)))) + ltrim(ss_descripcion)),
                  'TIPO_COMP' =  case
                                    when ss_imp_retencion > 0 then '020'
                                    else '120'
                                 end   ,
                  'LETRA'     =  'Z'   ,
                  'NUMERO'    =  convert(char(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),convert(varchar(12), convert(varchar(3),ss_sucursal) + substring(ss_datos_adicionales,2,datalength(ltrim(ss_datos_adicionales)))))))) + ltrim(convert(varchar(12),convert(varchar(12), convert(varchar(3),ss_sucursal) + substring(ss_datos_adicionales,2,datalength(ltrim(ss_datos_adicionales))))))),
                  'CUIT'      =  convert(char(11),ss_ced_ruc)  ,
                  'FECHA'     =  convert(varchar(10),ss_fecha_fv_informa,103),
                  'BASE_IMP'  =(case
                                 when (ss_base_calculo) >= 0 then '0'
                                 else '-'
                               end) + convert(char(11),replicate('0',11 - datalength(ltrim(convert(varchar(11),str(abs((ss_base_calculo)),11,2))))) + ltrim(convert(varchar(11),str(abs((ss_base_calculo)),11,2)))),
                  'ALICUOTA'  =convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),str(ss_alicuota,5,2))))) + ltrim(convert(varchar(5),str(ss_alicuota,5,2)))),
                  'IMP_RET'   =(case
                                    when (ss_imp_retencion) >= 0 then '0'
                                    else '-'
                                 end) +   convert(char(11),replicate('0',11 - datalength(ltrim(str(abs((ss_imp_retencion )),11,2)))) + 
                                 ltrim(str(abs((ss_imp_retencion)),11,2))),
                  'REGIMEN'      = replicate ('0', 3 - datalength (ltrim (convert (varchar (3), ss_regimen)))) + ltrim (convert (varchar (3), ss_regimen)),
                  'JURISDICCION' = @w_jurisdiccion,
                  'ID'           =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   ss_disenio        =  'A'
               and   substring(ss_datos_adicionales,1,1) = 'P'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
            end   -- PLANO DE OPERAICONES DE SANLUIS (PANTALLA DE PRESENTACION DE INFORMACION)
         end -- ES PERCEPCION DE MISIONES
         else
         
         
         if @i_impuesto = 'PERIBSLUIS'                                                             -- ES PERCEPCION DE SAN LUIS
         begin
            if exists (select 1 from  cob_bcradgi..bc_p_impuestos where im_impuesto = @i_impuesto) -- AST 31896
            begin 
               exec @w_return   = cob_bcradgi..sp_peribsluis                                       
               @i_c_operacion   = 'Q',
               @i_n_opcion      = 1,
               @i_m_quien_llama = 'F',
               @i_f_desde       = @w_fecha_desde,
               @i_f_hasta       = @w_fecha_hasta,
               @i_k_rowcount    = @i_cant_rows,
               @i_s_hasta       = @i_identity_hasta
            
               if @w_return <> 0
               begin
                  return @w_return
               end            
            end
            else       
            begin                                                                                  -- ES PERCEPCION DE SAN LUIS
               select @w_jurisdiccion = '000'
   
               select @w_jurisdiccion = replicate ('0', 3 - datalength (ltrim (convert (varchar (3), im_afip)))) + ltrim (convert (varchar (3), im_afip))
               from  cob_bcradgi..bc_impuestos
               where im_impuesto = 'PERIBSLUIS'
               and   im_estado   = 'V'
   
               set rowcount @i_cant_rows
               
               if @i_disenio  =  'A'
               begin -- PLANO DE OPERAICONES DE SANLUIS (PANTALLA DE PRESENTACION DE INFORMACION)
                  select
                     'RENGLON'   =  convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),ss_descripcion)))) + ltrim(ss_descripcion)),
                     'TIPO_COMP' =  case
                                       when ss_imp_retencion > 0 then '20'
                                       else '120'
                                    end   ,
                     'LETRA'     =  'Z'   ,
                     'NUMERO'    =  convert(char(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),convert(varchar(12), convert(varchar(3),ss_sucursal) + ss_datos_adicionales))))) + ltrim(convert(varchar(12),convert(varchar(12), convert(varchar(3),ss_sucursal) + ss_datos_adicionales)))),
                     'CUIT'      =  convert(char(11),ss_ced_ruc)  ,
                     'FECHA'     =  convert(varchar(10),ss_fecha_fv_informa,103),
                     'BASE_IMP' =(case
                                    when (ss_base_calculo) >= 0 then '0'
                                    else '-'
                                 end) + convert(char(11),replicate('0',11 - datalength(ltrim(convert(varchar(11),str(abs((ss_base_calculo)),11,2))))) + ltrim(convert(varchar(11),str(abs((ss_base_calculo)),11,2)))),
                     'ALICUOTA'  =  convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),str(ss_alicuota,5,2))))) + ltrim(convert(varchar(5),str(ss_alicuota,5,2)))),
                     'IMP_RET'   =  (case
                                       when (ss_imp_retencion) >= 0 then '0'
                                       else '-'
                                    end) +   convert(char(11),replicate('0',11 - datalength(ltrim(str(abs((ss_imp_retencion )),11,2)))) + 
                                    ltrim(str(abs((ss_imp_retencion)),11,2))),
                     'REGIMEN'      = replicate ('0', 3 - datalength (ltrim (convert (varchar (3), ss_regimen)))) + ltrim (convert (varchar (3), ss_regimen)),
                     'JURISDICCION' = @w_jurisdiccion,
                     'ID'        =  convert(int,ss_identity)
                  from bc_sellos_salida
                  where ss_fecha_informac =  @w_fecha_hasta
                  and   ss_impuesto       =  @i_impuesto
                  and   ss_disenio        =  'A'
                  and   ss_identity >  isnull(@i_identity_hasta,  0  )
                  order by ss_identity
               end   -- PLANO DE OPERAICONES DE SANLUIS (PANTALLA DE PRESENTACION DE INFORMACION)
   
               if @i_disenio  =  'B'
               begin -- PLANO DE SUJETOS DE SANLUIS
   
                  select
                     --'COD_ENTE'     =  ss_ente, -- PARA EL SIGUIENTE, NO QUEDA EN EL PLANO
                     'CUIT'         =  ss_ced_ruc  ,
                     'NOM_LARG'     =  ss_descripcion,
                     'ING_BRUTOS'   =  '12' + ss_ced_ruc ,
                     'DOMICILIO'    =  substring(ss_datos_adicionales  ,1 , 52),
                     'LOCALIDAD'    =  substring(ss_datos_adicionales  ,53, 31),
                     'COD_POSTAL'   =  substring(ss_datos_adicionales  ,84,  4),
                     'PROVINCIA'    =  substring(ss_datos_adicionales  ,88, 22),
                     'ID'           =  convert(int,ss_identity)
                  from bc_sellos_salida
                  where ss_fecha_informac =  @w_fecha_hasta
                  and   ss_impuesto       =  @i_impuesto
                  and   ss_disenio        =  'B'
                  and   ss_identity >  isnull(@i_identity_hasta,  0  )
                  order by ss_identity
   
               end    -- PLANO DE OPERAICONES DE SANLUIS
            end       -- IMPUESTO PARAMETRIZADO
         end -- ES PERCEPCION DE SAN LUIS
         else


         if @i_impuesto = 'SELLTUCUMA'
         begin -- ES PERCEPCION DE SELLTUCUMA

            set rowcount @i_cant_rows

            if @i_disenio  =  'A'
            begin -- PLANO DE OPERAICONES DE SELLTUCUMA
               
               select
               'CUIT CONT'  = substring(ss_descripcion,1,11),
               '_'          = ' ',
               'MES PRES'   = substring(convert(varchar(10),ss_fecha_fv,103),4,2),
               'ANIO PRES'  = substring(convert(varchar(10),ss_fecha_fv,103),7,4),
               'SEC'        = 'O00',
               'F ALTA'     = substring(convert(varchar(10),ss_fecha_fv,103),1,2)+substring(convert(varchar(10),ss_fecha_fv,103),4,2)+substring(convert(varchar(10),ss_fecha_fv,103),7,4),
               'CUIT CLI'   = ltrim(ss_ced_ruc) + replicate('0', 11-isnull(datalength(ltrim(ss_ced_ruc)),0)),
               'COD INSTR'  = replicate('0', 3-isnull(char_length(ltrim(rtrim(ss_regimen))),0))+ ltrim(rtrim(ss_regimen)),
               'DESC INSTR' = ' ',
               'ALICUOTA'   = convert(varchar(10),replicate('0',10 - datalength(ltrim(str(ABS(ss_alicuota * 10000),10,0)))) + ltrim(str(ABS(ss_alicuota * 10000),10,0))),
               'ES ALIC'    = case when isnull(ss_valor_minimo, 0.00) = 0.00 then 'S' else 'N' end,
               'NRO ORDEN'  = convert(varchar(8),substring(ss_descripcion,22,8)),
               'F EM INSTR' = substring(convert(varchar(10),ss_fecha_fv,103),1,2)+substring(convert(varchar(10),ss_fecha_fv,103),4,2)+substring(convert(varchar(10),ss_fecha_fv,103),7,4),
               'CANTIDAD'   = convert(varchar(8),replicate('0',8 - datalength(ltrim(str(ABS(ss_valor_minimo),8,0)))) + ltrim(str(ABS(ss_valor_minimo),8,0))),
               'MONTO IMP'  = convert(varchar(18),replicate('0',18 - datalength(ltrim(str(ABS(ss_base_calculo * 100),18,0)))) + ltrim(str(ABS(ss_base_calculo * 100),18,0))),
               'TOTAL'      = convert(varchar(18),replicate('0',18 - datalength(ltrim(str(ABS(ss_imp_retencion * 100),18,0)))) + ltrim(str(ABS(ss_imp_retencion * 100),18,0))),
               'REDUCCION'  = convert(varchar(4),replicate('0',4 - datalength(ltrim(str(ABS(ss_pct_exencion),4,0)))) + ltrim(str(ABS(ss_pct_exencion),4,0))),
               'NRO ESTAB'  = replicate('0', 2-datalength(ltrim(convert(varchar(2),ss_sucursal))))+ltrim(convert(varchar(2),ss_sucursal)),
               'ID'         = convert(int,ss_identity)               
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto --'SELLTUCUMA'
               and   ss_fecha_informac = @w_fecha_hasta --'02/28/2009'
               and   substring(ss_disenio,1,1) = 'A'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
               
            end   -- PLANO DE OPERAICONES DE SELLTUCUMA

            if @i_disenio  =  'B'
            begin -- PLANO DE SUJETOS DE SELLTUCUMA
               
               select
               'CUIT CLI' = replicate('0', 11-isnull(datalength(ltrim(ss_ced_ruc)),0))+ltrim(ss_ced_ruc),
               'AP y NOM' = rtrim(convert(varchar(50),substring(ss_descripcion,10,50)))+replicate(' ', 50-datalength(rtrim(convert(varchar(50),substring(ss_descripcion,10,50))))),
               'ID'       =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto --'SELLTUCUMA'
               and   ss_fecha_informac = @w_fecha_hasta --'02/28/2009'
               and   substring(ss_disenio,1,1) = 'B'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
               
            end    -- PLANO DE OPERAICONES DE SELLTUCUMA
            
            if @i_disenio  =  'X'
            begin 
               
               select
               substring(ss_descripcion,1,11)+                                                                    --01 - Cuit del Contribuyente
               replicate(' ', 1)+                                                                                 --02 - Espacio en blanco
               substring(convert(varchar(10),ss_fecha_fv,103),4,2)+                                               --03 - Mes de Presentacion
               substring(convert(varchar(10),ss_fecha_fv,103),7,4)+                                               --04 - Año de Presentacion
               'O00'+                                                                                             --05 - Secuencia
               substring(convert(varchar(10),ss_fecha_fv,103),1,2)+substring(convert(varchar(10),ss_fecha_fv,103),4,2)+substring(convert(varchar(10),ss_fecha_fv,103),7,4)+   --06 - Fecha de alta del Registro
               ltrim(ss_ced_ruc) + replicate('0', 11-isnull(datalength(ltrim(ss_ced_ruc)),0))+                    --07 - Cuit del Cliente
               replicate('0', 3-isnull(char_length(ltrim(rtrim(ss_regimen))),0))+ ltrim(rtrim(ss_regimen))+       --08 - Codigo de Instrumento
               replicate(' ',50)+                                                                                 --09 - Descripcion del Instrumento
               convert(varchar(10),replicate('0',10 - datalength(ltrim(str(ABS(ss_alicuota * 10000),10,0)))) + ltrim(str(ABS(ss_alicuota * 10000),10,0)))+                    --10 - Alicuota
               case when isnull(ss_valor_minimo, 0.00) = 0.00 then 'S' else 'N' end+                              --11 - Es Alicuota: S o N
               convert(varchar(8),substring(ss_descripcion,22,8))+                                                                    --12 - Numero de Orden
               substring(convert(varchar(10),ss_fecha_fv,103),1,2)+substring(convert(varchar(10),ss_fecha_fv,103),4,2)+substring(convert(varchar(10),ss_fecha_fv,103),7,4)+   --13 - Fecha de Emision del Instrumento
               convert(varchar(8),replicate('0',8 - datalength(ltrim(str(ABS(ss_valor_minimo),8,0)))) + ltrim(str(ABS(ss_valor_minimo),8,0)))+                                --14 - Cantidad
               convert(varchar(18),replicate('0',18 - datalength(ltrim(str(ABS(ss_base_calculo * 100),18,0)))) + ltrim(str(ABS(ss_base_calculo * 100),18,0)))+                --15 - Monto Imponible
               convert(varchar(18),replicate('0',18 - datalength(ltrim(str(ABS(ss_imp_retencion * 100),18,0)))) + ltrim(str(ABS(ss_imp_retencion * 100),18,0)))+              --16 - Total
               convert(varchar(4),replicate('0',4 - datalength(ltrim(str(ABS(ss_pct_exencion),4,0)))) + ltrim(str(ABS(ss_pct_exencion),4,0)))+                                --17 - Reduccion
               replicate('0', 2-datalength(ltrim(convert(varchar(2),ss_sucursal))))+ltrim(convert(varchar(2),ss_sucursal)),                                                    --18 - Numero de Establecimiento
               'DISENIO'  = substring(ss_disenio,1,1),
               'ESTADO'   = substring(ss_datos_adicionales,10,1),
               'SUC'      = ss_sucursal,
               'ID'       = convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto
               and   ss_fecha_informac = @w_fecha_hasta
               and   substring(ss_disenio,1,1) = 'A'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               union
               select
               replicate('0', 11-isnull(datalength(ltrim(ss_ced_ruc)),0))+ltrim(ss_ced_ruc)+   
               rtrim(convert(varchar(50),substring(ss_descripcion,10,50)))+replicate(' ', 50-datalength(rtrim(convert(varchar(50),substring(ss_descripcion,10,50))))),
               'DISENIO'  = substring(ss_disenio,1,1),
               'ESTADO'   = substring(ss_datos_adicionales,10,1),
               'SUC'      = ss_sucursal,
               'ID'       = convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto
               and   ss_fecha_informac = @w_fecha_hasta
               and   substring(ss_disenio,1,1) = 'B'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by convert(int,ss_identity)
               
            end
            
         end -- ES PERCEPCION DE SELLTUCUMA
         else


         if @i_impuesto = 'PERIBCABA'
         begin -- ES PERCEPCION DE PERIBCABA

            set rowcount @i_cant_rows

            if @i_disenio  =  'A'
            begin -- PLANO DE OPERAICONES DE PERIBCABA
               select 
               'T OPER'     = '2',
               'COD NORMA'  = '014',
               'F PERCEP'   = convert(varchar,ss_fecha_fv,103),
               'T COMP'     = '09',
               'LETRA COMP' = ' ',
               'NRO COMP'   = REPLICATE("0", 15-isnull(char_length(ltrim(rtrim(ss_numero))),0))+  ltrim(rtrim(ss_numero)),
               'F COMP'     = convert(varchar,ss_fecha_fv,103),
               'MONTO'      = convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_importe_comprobante),patindex('%.%',abs(ss_importe_comprobante)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_importe_comprobante),patindex('%.%',abs(ss_importe_comprobante)),1,','))),
               'NRO CERT'   = ' ',
               'T DOC'      = substring(ss_datos_adicionales,26,1),
               'NRO DOC'    = ss_ced_ruc,
               'SIT IIBB'   = '4',
               'NRO INSC'   = '0000000000',
               'SIT IVA'    = substring(ss_datos_adicionales,41,1),
               'RAZ SOC'    = ss_descripcion,
               'OT CONCEP'  = '0000000,00',
               'IVA'        = '0000000,00',
               'BASE IMP'   = convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_base_calculo),patindex('%.%',abs(ss_base_calculo)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_base_calculo),patindex('%.%',abs(ss_base_calculo)),1,','))),
               'ALICUOTA'   = convert(varchar(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),stuff(convert(money,ss_alicuota),patindex('%.%',convert(money,ss_alicuota)),1,','))))))+ ltrim(convert(varchar(5),stuff(convert(money,ss_alicuota),patindex('%.%',convert(money,ss_alicuota)),1,','))),
               'IMP RET'    = convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))),
               'TOT RET'    = convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))),
               'ID'         = ss_identity
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   substring(ss_disenio,1,1)= 'A'
               and   substring(ss_disenio,2,3) = 'PER'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity,substring(ss_datos_adicionales,51,1) 
            end   -- PLANO DE OPERAICONES DE PERIBCABA

            if @i_disenio  =  'B'
            begin -- PLANO DE SUJETOS DE PERIBCABA

               select 
               'T OPER'     = '2',
               'NRO NC'     = REPLICATE("0", 12-isnull(char_length(ltrim(rtrim(convert(varchar(12),ss_identity)))),0))+  ltrim(rtrim(convert(varchar(12),ss_identity))),
               'F NC'       = convert(varchar,ss_fecha_fv,103),
               'MONTO NC'   = convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))),
               'NRO CERT'   = ' ',
               'T COMP OR'  = '09',
               'LETRA COMP' = ' ',
               'NRO COMP'   = REPLICATE("0", 15-isnull(char_length(ltrim(rtrim(ss_numero))),0))+  ltrim(rtrim(ss_numero)),
               'ID'         = ss_identity
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   substring(ss_disenio,1,1)= 'B'
               and   substring(ss_disenio,2,3) = 'NCR'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity,substring(ss_datos_adicionales,51,1) 

            end    -- PLANO DE OPERAICONES DE PERIBCABA

            if @i_disenio  =  'X'
            begin -- PLANO DE SUJETOS DE PERIBCABA
               select   
               'REGISTROS' ='2'+                                  -- Toperac
               '014'+                                             -- Cnorma
               convert(varchar,ss_fecha_fv,103)+                  -- Fpercepcion
               '09'+                                              -- TCbte
               ' '+                                               -- Letra Cbte
               REPLICATE("0", 15-isnull(char_length(ltrim(rtrim(ss_numero))),0))+  ltrim(rtrim(ss_numero))+  -- NRO_CBTE
               convert(varchar,ss_fecha_fv,103)+                  -- FECHA_CBTE
               convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_importe_comprobante),patindex('%.%',abs(ss_importe_comprobante)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_importe_comprobante),patindex('%.%',abs(ss_importe_comprobante)),1,',')))+ -- MONTO c/separador decimal coma
               '                '+                                -- Certificado Ppio
               substring(ss_datos_adicionales,26,1)+              -- Tipo Doc
               ss_ced_ruc+                                        -- Nro Doc
               '4'+                                               -- Sit IIBB
               '0000000000'+                                      -- Nro IIBB
               substring(ss_datos_adicionales,41,1)+              -- Sit IVA
               ss_descripcion+   replicate(" ", 30-datalength(ss_descripcion))+     -- Razón Social
               '0000000,00'+                                      -- Otros Conceptos
               '0000000,00'+                                      -- IVA
               convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_base_calculo),patindex('%.%',abs(ss_base_calculo)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_base_calculo),patindex('%.%',abs(ss_base_calculo)),1,',')))+                     -- Base Imponible c/separador decimal coma
               convert(varchar(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),stuff(convert(money,ss_alicuota),patindex('%.%',convert(money,ss_alicuota)),1,','))))))+ ltrim(convert(varchar(5),stuff(convert(money,ss_alicuota),patindex('%.%',convert(money,ss_alicuota)),1,',')))+ --Alícuota c/separador coma
               convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,',')))+                 -- Imp Retenido c/separador decimal coma
               convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))),                 -- Tot Retenido c/separador decimal coma
               'DISENIO'  = substring(ss_disenio,1,1),
               'ESTADO'   = substring(ss_datos_adicionales,51,1),
               'IDENTITY' = ss_identity
               
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   substring(ss_disenio,1,1)= 'A'
               and   substring(ss_disenio,2,3) = 'PER'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               union
               select
               'REGISTROS' ='2'+
               REPLICATE("0", 12-isnull(char_length(ltrim(rtrim(convert(varchar(12),ss_identity)))),0))+  ltrim(rtrim(convert(varchar(12),ss_identity)))+
               convert(varchar,ss_fecha_fv,103)+
               convert(varchar(12),replicate('0',12 - datalength(ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,','))))))+ ltrim(convert(varchar(12),stuff(abs(ss_imp_retencion),patindex('%.%',abs(ss_imp_retencion)),1,',')))+
               '                '+
               '09'+
               ' '+
               REPLICATE("0", 15-isnull(char_length(ltrim(rtrim(ss_numero))),0))+  ltrim(rtrim(ss_numero)),
               'DISENIO'  = substring(ss_disenio,1,1),
               'ESTADO'   = substring(ss_datos_adicionales,51,1),
               'IDENTITY' = ss_identity
               
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   substring(ss_disenio,1,1)= 'B'
               and   substring(ss_disenio,2,3) = 'NCR'
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity,substring(ss_datos_adicionales,51,1) 

            end    -- PLANO DE OPERAICONES DE PERIBCABA
         end -- ES PERCEPCION DE PERIBCABA
         else


         if @i_impuesto = 'SELLBAIRES'
         begin -- ES SELLOS DE BUENOS AIRES

            set rowcount @i_cant_rows

            select
               'CUIT'           =  ss_ced_ruc,
               'FECHA'          =  convert(varchar(10),ss_fecha_fv_informa,103),
               'TIPO_MONEDA'    =  case when ss_moneda = '01' then '1' else '2' end,
               'MONEDA'         =  ss_moneda,
               'BASE_IMP'       =  case when  ss_base_calculo >= 0 then '0' else '-' end +
                                   replicate('0', 12 - len(convert(varchar(12), isnull(ss_base_calculo,0)))) + convert(varchar(12), isnull(ss_base_calculo,0)),
               'ALICUOTA'       =  convert(char(7),
                                                   replicate('0', 3 - len(convert(varchar, convert(int, isnull(ss_alicuota, 0.0))))) + convert(varchar, convert(int, isnull(ss_alicuota, 0.0))) + '.' +
                                                   replicate('0', 3 - len(convert(varchar, convert(int, round(abs(convert(int, isnull(ss_alicuota, 0.0)) - isnull(ss_alicuota, 0.0)), 3) * 1000)))) + 
                                                   convert(varchar, convert(int, round(abs(convert(int, isnull(ss_alicuota, 0.0)) - isnull(ss_alicuota, 0.0)), 3) * 1000))
                                   ),
               'EXEN'           =  convert(char(6),
                                                   replicate('0', 3 - len(convert(varchar, convert(int, ss_pct_exencion*100)))) + convert(varchar, convert(int, ss_pct_exencion*100)) + '.' +
                                                   replicate('0', 2 - len(convert(varchar, convert(int, round(abs(convert(int, ss_pct_exencion*100) - ss_pct_exencion*100), 2) * 100)))) + 
                                                   convert(varchar, convert(int, round(abs(convert(int, ss_pct_exencion*100) - ss_pct_exencion*100), 2) * 100))
                                   ),
               'TIPO_OPERACION' = 'A',
               'ID'             =  convert(int,ss_identity)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        =  @i_disenio
            and   ss_identity >  isnull(@i_identity_hasta,  0  )
            order by ss_identity

            set rowcount 0


         end -- ES SELLOS DE BUENOS AIRES
         else
         if @i_impuesto = 'SELLSLUIS'
         begin -- ES SELLOS DE SAN LUIS

            set rowcount @i_cant_rows

            if @i_disenio  like ('A%')
            begin -- ES EL DISENIO DE OPERACIONES
               select
                  case  substring(ss_disenio,2,2)
                     when  'O1'  then
                        substring(ss_disenio,2,2) +
                        convert(char(7),  isnull(ss_regimen,'0000999') )   +
                        convert(varchar(10), ss_fecha_fv_informa,103) +
                        convert(char(60), isnull(ss_descripcion,' ' )) +
                        (  case
                              when (ss_base_calculo) >= 0 then '0'
                              else '-'
                           end)  + convert(char(14),replicate('0',14 - datalength(ltrim(convert(varchar(14),stuff(str(abs((ss_base_calculo)),15,2),13,1,null))))) + ltrim(convert(varchar(14),stuff(str(abs((ss_base_calculo)),15,2),13,1,null)))) +
                        convert(char(1),ss_tipo_exencion) + 
                        convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null))))) + ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null)))) +
                        replicate(' ',10) +
                        replicate(' ',30) +                  
                        (  case
                              when (ss_valor_minimo) >= 0 then '0'
                              else '-'
                           end)  + convert(char(14),replicate('0',14 - datalength(ltrim(convert(varchar(14),stuff(str(abs((ss_valor_minimo)),15,2),13,1,null))))) + ltrim(convert(varchar(14),stuff(str(abs((ss_valor_minimo)),15,2),13,1,null))))
                     when  'O2'  then
                        substring(ss_disenio,2,2) +
                        convert(char(12), isnull(ss_descripcion, ' ' )) +
                        convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null))))) + ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null)))) +
                        replicate(' ',10) +
                        replicate(' ',30) +
                        replicate(' ',94)
                     else
                        replicate(' ',155)
                  end,
                  ss_datos_adicionales
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   ss_disenio        like  ('A%')
               and   ss_datos_adicionales >  isnull(@i_adicionales_hasta, '' )
               order by ss_datos_adicionales
            end   -- ES EL DISENIO DE OPERACIONES

            if @i_disenio  like ('B%')
            begin -- ES EL DISENIO DE OPERACIONES FINANCIERAS
               select
                  case  substring(ss_disenio,2,2)
                      when  'O1'  then  
                        substring(ss_disenio,2,2) + 
                        convert(char(7),  isnull(ss_regimen,'0000999'))   +
                        convert(varchar(10), ss_fecha_fv_informa,103) + 
                        convert(char(60), isnull(ss_descripcion, ' ' )) + 
                        (  case
                              when (ss_base_calculo) >= 0 then '0'
                              else '-'
                           end)  + convert(char(14),replicate('0',14 - datalength(ltrim(convert(varchar(14),stuff(str(abs((ss_base_calculo)),15,2),13,1,null))))) + ltrim(convert(varchar(14),stuff(str(abs((ss_base_calculo)),15,2),13,1,null)))) +
                        convert(char(1),ss_tipo_exencion) + 
                        convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null))))) + ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null)))) +
                        replicate(' ',10) +
                        replicate(' ',30) +                  
                        (  case
                              when (ss_valor_minimo) >= 0 then '0'
                              else '-'
                           end)  + convert(char(14),replicate('0',14 - datalength(ltrim(convert(varchar(14),stuff(str(abs((ss_valor_minimo)),15,2),13,1,null))))) + ltrim(convert(varchar(14),stuff(str(abs((ss_valor_minimo)),15,2),13,1,null)))) +
                        (  case
                              when (ss_imp_retencion) >= 0 then '0'
                              else '-'
                           end)  + convert(char(14),replicate('0',14 - datalength(ltrim(convert(varchar(14),stuff(str(abs((ss_imp_retencion)),15,2),13,1,null))))) + ltrim(convert(varchar(14),stuff(str(abs((ss_imp_retencion)),15,2),13,1,null))))
                     when  'O2'  then
                        substring(ss_disenio,2,2) +
                        convert(char(12), isnull(ss_descripcion,' ' )) +
                        convert(char(5),replicate('0',5 - datalength(ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null))))) + ltrim(convert(varchar(5),stuff(str(abs(ss_pct_exencion),6,2),4,1,null)))) +
                        replicate(' ',10) +
                        replicate(' ',30) +
                        replicate(' ',109)
                     else
                        replicate(' ',170)
                  end,
                  ss_datos_adicionales
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   ss_disenio        like  ('B%')
               and   ss_datos_adicionales >  isnull(@i_adicionales_hasta, '' )
               order by ss_datos_adicionales

            end   -- ES EL DISENIO DE OPERACIONES FINANCIERAS

            if @i_disenio  = 'C'
            begin -- ES EL DISENIO DE SUJETOS

               select
                  'NOMBRE_DOC'   =  ss_datos_adicionales ,
                  'DIRECCION'    =  ss_descripcion       ,
                  'ID'           =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   ss_disenio        =  'C'
               and   ss_identity >  isnull(@i_identity_hasta, 0)
               order by ss_identity

            end   -- ES EL DISENIO DE SUJETOS
         end   -- ES SELLOS DE SAN LUIS
         else
         if @i_impuesto = 'SELLCTES'
         begin -- ES SELLOS DE CORRIENTES

            set rowcount @i_cant_rows

            /*BUSCO EL CUIT DE AGENTE DEL BANCO*/
            select @w_cuit_agente   =  pa_char
            from cobis..cl_parametro
            where pa_producto = 'CTE'
            and pa_nemonico = 'CUBM'

            select
               'NRO_LIQUIDACION'    =  convert(char(10),ss_datos_adicionales) ,
               'PERIODO'            =  substring(convert(varchar(10),ss_fecha_fv,112),1,6),
               'CUIT_AGENTE'        =  substring(@w_cuit_agente,1,2) + substring(@w_cuit_agente,4,8) + substring(@w_cuit_agente,13,1),
               'ESTABLECIMIENTO'    =  convert(char(2),replicate('0',2 - datalength(ltrim(str(ss_sucursal,2,0)))) + ltrim(str(ss_sucursal,2,0))),
               'FECHA_INTRUMENTO'   =  convert(varchar(10),ss_fecha_fv,103),
               'COD_INSTRUMENTO'    =  convert(char(6),isnull(ss_regimen,' ' )),
               'CDAD_DOCUMENTOS'    =  '001',
               'BASE_IMPONIBLE'     =  convert(char(12),substring(convert(money,round((ss_base_calculo),2)),1,datalength(ltrim(convert(money,round((ss_base_calculo),2)))) -3) +','+   substring(convert(money,round((ss_base_calculo),2)),datalength(ltrim(convert(money,round((ss_base_calculo),2)))) -1,2)),
               'ALICUOTA_NOMINAL'   =  convert(char(6),substring(convert(money,isnull(ss_alicuota,0)),1,datalength(ltrim(convert(money,isnull(ss_alicuota,0)))) -3)+','+  substring(convert(money,isnull(ss_alicuota,0)),datalength(ltrim(convert(money,isnull(ss_alicuota,0)))) -1,2)),
               'RETENIDO'           =  convert(char(12),substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion)) -3) +','+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) -1,2)),
               'CUIT'               =  convert(varchar(11),isnull(ss_ced_ruc,' ' )),
               'NOMBRE'             =  convert(varchar(30),isnull(ltrim(rtrim(substring(ss_descripcion, charindex('|NOM:',ss_descripcion) + 5 ,len(ltrim(rtrim(ss_descripcion)))- charindex('|NOM:',ss_descripcion)))),' ')),
               'ID'                 =  convert(int,ss_identity)
            from  bc_sellos_salida, 
                  bc_p_impuestos
            where ss_fecha_informac = im_f_hasta
            and   ss_impuesto       = im_impuesto
            and   ss_disenio        = @i_disenio
            and   im_m_disenio      = @i_disenio
            and   ss_impuesto       = @i_impuesto
            and   ss_identity       > isnull(@i_identity_hasta, 0)
            order by ss_identity

         end   -- ES SELLOS DE CORRIENTES
         else
         if @i_impuesto = 'SELLCORDOB'
         begin -- ES PERCEPCION DE SELLCORDOB

            set rowcount @i_cant_rows

            if @i_disenio  =  'A'
            begin -- PLANO DE OPERACIONES DE SELLCORDOB PROCESADAS

                  select
                  '01' +      ---   1  Identificador  2
                  replicate('0', 5-isnull(len(ltrim(rtrim(convert(varchar(5),ss_sucursal)))),0))+ ltrim(rtrim(convert(varchar(5),ss_sucursal))) +      ---   2  Código Sucursal   5
                  '0' +     ---   3  Retención Actos Propios 1
                  '1' +     ---   4  Retención. Actos Terceros  1
                  replicate('0', 2 - isnull(len(ltrim(rtrim(ss_regimen))),0))+ ltrim(rtrim(ss_regimen))+      ---   5  Concepto Operación   2
                  convert(varchar(10),ss_fecha_fv,103)   +      ---   6  Fecha Retención   10
                  convert(varchar(10),ss_fecha_fv,103)   +      ---   7  Fecha Operación   10
                  isnull(substring(ss_datos_adicionales,8,1),' ') +         ---   8  Tipo Documento 1
                  case substring(ss_datos_adicionales,2,5)
                     when 'TTRIB'   then substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1)
                     when 'TDOCP'   then replicate('0', 13 - isnull(len(ltrim(rtrim(ss_ced_ruc))),0)) + ltrim(rtrim(ss_ced_ruc))
                  else '0000000000000'
                  end +       ---   9  CUIT Cliente   13
                  replicate('0',10  - (datalength(ltrim(ss_base_calculo)) -3) ) + substring(ss_base_calculo,1,datalength(ltrim(ss_base_calculo)) -3) +','+ substring(ss_base_calculo,datalength(ltrim(ss_base_calculo)) -1,2) +      ---   10 Base Retención 10
                  replicate('0',8   - (datalength(rtrim(ltrim(str(ss_alicuota,8,4))))) ) + substring(ltrim(rtrim(str(ss_alicuota,8,4))),1,len(ltrim(rtrim(str(ss_alicuota,8,4))))-5  )+','+ substring(ltrim(rtrim(str(ss_alicuota,8,4))),len(ltrim(rtrim(str(ss_alicuota,8,4))))-3 ,4 )  +     ---   11 Alícuota 3
                  replicate('0',5   - (datalength(rtrim(ltrim(isnull(substring(ss_descripcion,7,5),'1')))))) + rtrim(ltrim(isnull(substring(ss_descripcion,7,5),'1'))) + ---   12 Cantidad    5
                  replicate('0',4   - (datalength(ltrim(isnull(ss_valor_fijo,0.00))) - 3)) + substring(isnull(ss_valor_fijo,0.00),1,datalength(ltrim(isnull(ss_valor_fijo,0.00)))-3) +','+ substring(isnull(ss_valor_fijo,0.00),datalength(ltrim(isnull(ss_valor_fijo,0.00))) -1,2) +      ---   13 Fijo  4
                  ltrim(rtrim(substring(ss_numero,1,25))) +  replicate(' ', 25 - datalength(ltrim(rtrim(substring(ss_numero,1,25))))) + ---   14 Dato Referencial  25
                  replicate('0',10  - (datalength(ltrim(substring(ss_datos_adicionales,16,10))))) + ltrim(substring(ss_datos_adicionales,16,10)) +','+ ltrim(substring(ss_datos_adicionales,27,2)) +            ---   15 Monto Exento   10
                  replicate('0',8   - (datalength(ltrim(ss_imp_retencion))-3)) + substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion))-3) +','+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) - 1,2) ,     ---   16 Importe total retenido  8              
                  'ID'           =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto 
               and   ss_fecha_informac = @w_fecha_hasta                
               and   substring(ss_disenio,1,1) = @i_disenio -- EL DISEÑO A DEBIERAN DE SER LOS PROCESADOS
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
               
            end   -- PLANO DE OPERACIONES DE SELLCORDOB PROCESADAS
            else
            if @i_disenio  =  'B'
            begin -- PLANO DE OPERACIONES DE SELLCORDOB PROCESADAS

               select
                  '01' +      ---   1  Identificador  2
                  replicate('0', 5-isnull(len(ltrim(rtrim(convert(varchar(5),ss_sucursal)))),0))+ ltrim(rtrim(convert(varchar(5),ss_sucursal))) +      ---   2  Código Sucursal   5
                  '0' +     ---   3  Retención Actos Propios 1
                  '1' +     ---   4  Retención. Actos Terceros  1
                  replicate('0', 2 - isnull(len(ltrim(rtrim(ss_regimen))),0))+ ltrim(rtrim(ss_regimen))+      ---   5  Concepto Operación   2
                  convert(varchar(10),ss_fecha_fv,103)   +      ---   6  Fecha Retención   10
                  convert(varchar(10),ss_fecha_fv,103)   +      ---   7  Fecha Operación   10
                  isnull(substring(ss_datos_adicionales,8,1),' ') +         ---   8  Tipo Documento 1
                  case substring(ss_datos_adicionales,2,5)
                     when 'TTRIB'   then substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1)
                     when 'TDOCP'   then replicate('0', 13 - isnull(len(ltrim(rtrim(ss_ced_ruc))),0)) + ltrim(rtrim(ss_ced_ruc))
                  else '0000000000000'
                  end +       ---   9  CUIT Cliente   13
                  replicate('0',10  - (datalength(ltrim(ss_base_calculo)) -3) ) + substring(ss_base_calculo,1,datalength(ltrim(ss_base_calculo)) -3) +','+ substring(ss_base_calculo,datalength(ltrim(ss_base_calculo)) -1,2) +      ---   10 Base Retención 10
                  replicate('0',8   - (datalength(rtrim(ltrim(str(ss_alicuota,8,4))))) ) + substring(ltrim(rtrim(str(ss_alicuota,8,4))),1,len(ltrim(rtrim(str(ss_alicuota,8,4))))-5  )+','+ substring(ltrim(rtrim(str(ss_alicuota,8,4))),len(ltrim(rtrim(str(ss_alicuota,8,4))))-3 ,4 )  +     ---   11 Alícuota 3
                  replicate('0',5   - (datalength(rtrim(ltrim(isnull(substring(ss_descripcion,7,5),'1')))))) + rtrim(ltrim(isnull(substring(ss_descripcion,7,5),'1'))) + ---   12 Cantidad    5
                  replicate('0',4   - (datalength(ltrim(isnull(ss_valor_fijo,0.00))) - 3)) + substring(isnull(ss_valor_fijo,0.00),1,datalength(ltrim(isnull(ss_valor_fijo,0.00)))-3) +','+ substring(isnull(ss_valor_fijo,0.00),datalength(ltrim(isnull(ss_valor_fijo,0.00))) -1,2) +      ---   13 Fijo  4
                  ltrim(rtrim(substring(ss_numero,1,25))) +  replicate(' ', 25 - datalength(ltrim(rtrim(substring(ss_numero,1,25))))) + ---   14 Dato Referencial  25
                  replicate('0',10  - (datalength(ltrim(substring(ss_datos_adicionales,16,10))))) + ltrim(substring(ss_datos_adicionales,16,10)) +','+ ltrim(substring(ss_datos_adicionales,27,2)) +            ---   15 Monto Exento   10
                  replicate('0',8   - (datalength(ltrim(ss_imp_retencion))-3)) + substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion))-3) +','+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) - 1,2) ,     ---   16 Importe total retenido  8              
                  'ID'           =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto 
               and   ss_fecha_informac = @w_fecha_hasta 
               and   substring(ss_disenio,1,1) = @i_disenio -- EL DISEÑO A DEBIERAN DE SER LOS CON ERROR
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
               
            end   -- PLANO DE OPERACIONES DE SELLCORDOB PROCESADAS
         end -- ES PERCEPCION DE SELLCORDOB
         else
         
         if @i_impuesto = 'SELLMISION'
         begin -- ES PERCEPCION DE SELLMISION

            if @i_disenio  =  'B' 
            begin -- PLANO DE OPERACIONES DE SELLMISION A CARGO DEL CLIENTE 
               select @i_sig_col = isnull(@i_sig_col,0)               
               
               create table #Tmp (
               tm_id    int  ,
               tm_ss_id numeric(8), 
               tm_e_reg int)

               create table #Tmp_Ok (
               tm_id    int  identity,
               tm_ss_id float)

               create table #Tmp_ER (
               tm_id    int  identity,
               tm_ss_id float)
                  

               select @w_registros = 0 
               select @w_registros_err = 0

               --BUSCO EL ESTADO DEL ULTIMO REGISTRO 
               select @w_e_ultimo_reg = @i_e_ultimo_reg
               
               select @w_k_rows  = @i_cant_rows * 2
               select @w_k_rows_aux = 0
               
               set rowcount @w_k_rows 
               
               declare  cur_secuenciales cursor for
               --DMJ EL TOP 40 ES IMPORTANTISIMO HAY QUE TENERLO EN CUENTA SI SE CAMBIA EL VALOR DEL @i_cant_rows SIEMPRE EL TOP XXX TIENE QUE TENER AL MENOS EL DOBLE DEL @i_cant_rows
               --PARA ASEGURAR QUE NO SE PIERDAN RTEGISTROS INNECESARIAMENTE
               select top 40
               ss_identity , substring(ss_datos_adicionales, 74,1)
               from bc_sellos_salida 
               --where ss_cargo_banco                        = 'N'
               where ss_tipo_base_imponible                <> 16
               and   ss_fecha_informac                     = @w_fecha_hasta
               and   ss_impuesto                           = @i_impuesto
               and   ss_identity                           > isnull(@i_identity_hasta,0)
               order by ss_identity, substring(ss_datos_adicionales, 74,1)

               for read only
               open  cur_secuenciales
         
               fetch cur_secuenciales into
               @w_cur_sec, @w_cur_e_registro
         
         
               while @@sqlstatus = 0
               begin --RECORRO CURSOR
                  
                  if @w_cur_e_registro = 'P'
                  begin
                     insert into #Tmp_Ok
                     values (@w_cur_sec)
                  end 

                  if @w_cur_e_registro = 'E'
                  begin
                     insert into #Tmp_ER
                     values (@w_cur_sec)
                  end 
                  fetch cur_secuenciales into
                  @w_cur_sec, @w_cur_e_registro
                  
               end --RECORRO CURSOR
               close cur_secuenciales
               deallocate cursor cur_secuenciales

               set rowcount 0
               
               select @w_registros = count(1) from #Tmp_Ok 
               select @w_registros_err = count(1) from #Tmp_ER 
               
               --EVALUO QUE DEVOLVER 
               -- TRES CASOS 
               -- 0 ERR
               -- ALGUNOS ERR Y NINGUNO OK
               -- ALGUNOS ERR Y ALGUNO  OK
               --SI NO HAY ERRONEOS
               if  @w_registros_err = 0 
               begin
                  
                  set rowcount @i_cant_rows
                  
                  insert into #Tmp (
                  tm_id    , tm_ss_id , tm_e_reg)
                  select 
                  tm_id    + @i_sig_col , tm_ss_id, 0
                  from #Tmp_Ok
                  
                  set rowcount 0
               end
               else
               begin
                  --SI NO HAY OK
                  if  @w_registros = 0 
                  begin 
                     --SI EL ESTADO DEL ULTIMO REGISTRO ENVIADO ES P
                     --ENTONCES TENGO QUE REINICIAR LA NUMERACION EN ESTE SINO TENGO QUE SEGUIR ACUMULANDOLA
                     
                     if @w_e_ultimo_reg = 'P'
                     begin
                        select @i_sig_col = 0
                     end   
                     set rowcount @i_cant_rows
                        
                     insert into #Tmp (
                     tm_id    , tm_ss_id, tm_e_reg )
                     select 
                     tm_id    + @i_sig_col , tm_ss_id, 1
                     from #Tmp_ER
                     
                     set rowcount 0
                  
                  end
                  else
                  begin --SI HAY OK Y HAY ERRORES 
                     --SI HAY MAS OK DE LOS QUE TENGO Q DEVOLVER DEVUELVO TODOS OK
                     if @w_registros >= @i_cant_rows
                     begin
                        set rowcount @i_cant_rows
                                              
                        insert into #Tmp (
                        tm_id    , tm_ss_id, tm_e_reg )
                        select 
                        tm_id    + @i_sig_col , tm_ss_id, 0
                        from #Tmp_Ok
                        
                        set rowcount 0
                     end 
                     else --HAY MENOS OK DE LOS QUE TENGO QUE DEVOLVER
                     begin
                        --PONGO TODOS LOS OK
                        insert into #Tmp (
                        tm_id    , tm_ss_id, tm_e_reg )
                        select 
                        tm_id    + @i_sig_col , tm_ss_id, 0
                        from #Tmp_Ok
                        
                        select @w_registros = @@rowcount
                        
                        select @w_registros = @i_cant_rows - @@rowcount
                        --completo con erroneos
                        set rowcount @w_registros 
                        
                        insert into #Tmp (
                        tm_id    , tm_ss_id, tm_e_reg )
                        select 
                        tm_id, tm_ss_id, 1
                        from #Tmp_ER
                        
                        set rowcount 0
                        
                     end
                  end
               end
               
               set rowcount @i_cant_rows
               
               select
               'NUMERO DE ORDEN'  = tm_id ,              
               'NAT. JURIDICA'    = ss_regimen,
               'NOMBRE '          = ltrim(rtrim(substring(ss_datos_adicionales, 15,50))) ,
               'FECHA RETENCION'  = str_replace(convert(varchar(10), ss_fecha_fv,103),'/','-'),
               'BASE IMPONIBLE'   = convert(varchar(16), ss_base_calculo),
               'ALICUOTA'         = ss_alicuota/100, 
               'IMPORTE RETENIDO' = convert(varchar(16), ss_base_calculo),
               'IMPORTE INGRESADO'= convert(varchar(16), ss_base_calculo),
               'NUMERO DE CUIT'   = case ss_regimen when '0098' then substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1) end ,
               substring(ss_datos_adicionales, 74,1),
               convert(int,ss_identity)
               from bc_sellos_salida , #Tmp 
               where ss_identity       = tm_ss_id 
               and   ss_fecha_informac = @w_fecha_hasta
               and   ss_impuesto       = @i_impuesto
               order by ss_identity, tm_e_reg 
               
               set rowcount 0
            end -- PLANO DE OPERACIONES DE SELLMISION A CARGO DEL CLIENTE
            else
            if @i_disenio  =  'A' 
            begin -- PLANO DE OPERACIONES DE SELLMISION A CARGO DEL BANCO
               set rowcount @i_cant_rows
               select
               'REGIMEN'             = ss_regimen,
               'NUMERO DE OPERACION' = left(ss_numero,20), 
               'FECHA RETENCION'     = str_replace(convert(char(10), ss_fecha_fv,103),'/','-'),
               'CUIT/CUIL'           = case when substring(ss_datos_adicionales, 7,2) <> '09' then substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1) end,
               'CDI'                 = case when substring(ss_datos_adicionales, 7,2) = '09'  then substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1) end,
               'NOMBRE'              = ltrim(rtrim(substring(ss_datos_adicionales, 15,50))) ,
               'BASE IMPONIBLE'      = convert(varchar(16), ss_base_calculo),
               'ALICOTA'             = ss_alicuota/100,
               substring(ss_datos_adicionales, 74,1),
               convert(int,ss_identity)
               from bc_sellos_salida 
               --where ss_cargo_banco      = 'S'
               where ss_tipo_base_imponible  = 16
               and   ss_fecha_informac   = @w_fecha_hasta
               and   ss_impuesto         = @i_impuesto
               and   ss_identity         > isnull(@i_identity_hasta,0)
               order by ss_identity 
               
            end -- PLANO DE OPERACIONES DE SELLMISION A CARGO DEL BANCO
            set rowcount 0
         end ---- ES PERCEPCION DE SELLMISION
         else
         if @i_impuesto = 'SELLCHUBUT'
         begin
            set rowcount @i_cant_rows
            
            select
            "TIPO OPERACION"    = isnull(ss_regimen, ''),
            "FECHA OPERACION"   = isnull(convert(varchar(8), ss_fecha_fv, 112), ''),
            "CUIT"              = isnull(ss_ced_ruc, ''),
            "BASE IMPONIBLE"    = isnull(convert(varchar, 
                                  case 
                                  when isnull(ss_regimen, '') = '2' then 
                                       case 
                                       when 
                                       (case when ss_imp_retencion > 0 then  ss_alicuota  else
                                       isnull(convert(bigint, (convert(money, rtrim(ltrim(substring(ss_datos_adicionales,
                                                                                                    charindex('ALI:', ss_datos_adicionales) + 4,
                                                                                                    charindex('|',
                                                                                                              substring(ss_datos_adicionales,
                                                                                                                        charindex('ALI:', ss_datos_adicionales) + 4,
                                                                                                                        len(ss_datos_adicionales)
                                                                                                                        )
                                                                                                              ) - 1
                                                                                                    )
                                                                                          )
                                                                               )
                                                                  ) 
                                                          )
                                                     ),
                                              0)
                                       end) > 0 then 
                                          convert(bigint, 
                                          ( 
                                          isnull(convert(bigint, ss_imp_retencion * 100), 0) /
                                          (case when ss_imp_retencion > 0 then  ss_alicuota  else
                                          isnull(convert(bigint, (convert(money, rtrim(ltrim(substring(ss_datos_adicionales,
                                                                                                       charindex('ALI:', ss_datos_adicionales) + 4,
                                                                                                       charindex('|',
                                                                                                                 substring(ss_datos_adicionales,
                                                                                                                           charindex('ALI:', ss_datos_adicionales) + 4,
                                                                                                                           len(ss_datos_adicionales)
                                                                                                                           )
                                                                                                                 ) - 1
                                                                                                       )
                                                                                             )
                                                                                  )
                                                                     ) 
                                                             )
                                                        ),
                                                 0)
                                          end)                              
                                          )* 100)
                                       else
                                          convert(bigint, ss_base_calculo * 100)
                                       end 
                                  else
                                     convert(bigint, ss_base_calculo * 100)
                                  end 
                                  ),''),
            "TIPO CALCULO"      = case when ss_alicuota > 0.00 then '1' else '2' end,
            "ALICUOTA"          = str_replace(                      
                                  (case when ss_imp_retencion > 0 then convert(varchar(30), ss_alicuota * 10) else
                                  isnull(convert(varchar(30), convert(bigint, (convert(money, rtrim(ltrim(substring(ss_datos_adicionales, 
                                                                                                             charindex('ALI:', ss_datos_adicionales) + 4, 
                                                                                                             charindex('|', 
                                                                                                                       substring(ss_datos_adicionales, 
                                                                                                                                 charindex('ALI:', ss_datos_adicionales) + 4, 
                                                                                                                                 len(ss_datos_adicionales)
                                                                                                                                 )
                                                                                                                       ) - 1
                                                                                                             )
                                                                                                   )
                                                                                        )
                                                                           ) * 10
                                                                   )
                                                          )
                                         ),
                                  '')
                                  end),'.0', null),
            "IMPUESTO"          = str_replace(
                                 (case when ss_imp_retencion > 0 then convert(varchar(30), ss_imp_retencion * 100) else
                                  isnull(convert(varchar(30), convert(bigint, (convert(money, rtrim(ltrim(substring(ss_datos_adicionales, 
                                                                                                             charindex('IMP:', ss_datos_adicionales) + 4, 
                                                                                                             charindex('|', 
                                                                                                                       substring(ss_datos_adicionales, 
                                                                                                                                 charindex('IMP:', ss_datos_adicionales) + 4, 
                                                                                                                                 len(ss_datos_adicionales)
                                                                                                                                 )
                                                                                                                       ) - 1
                                                                                                             )
                                                                                                   )
                                                                                        )
                                                                           ) * 100
                                                                   )
                                                          )
                                         ),
                                  '')
                                  end),'.00', null),
            "EXENCIONES"        = case when convert(money, substring(ss_datos_adicionales, charindex('IMP:', ss_datos_adicionales) + 4, 10)) > 0.00 then
                                                                   isnull(convert(varchar(30), convert(bigint, (convert(money, rtrim(ltrim(substring(ss_datos_adicionales, 
                                                                                                                                            charindex('IMP:', ss_datos_adicionales) + 4, 
                                                                                                                                            charindex('|', 
                                                                                                                                                      substring(ss_datos_adicionales, 
                                                                                                                                                                charindex('IMP:', ss_datos_adicionales) + 4, 
                                                                                                                                                                len(ss_datos_adicionales)
                                                                                                                                                                )
                                                                                                                                                       ) - 1
                                                                                                                                            )
                                                                                                                                   )
                                                                                                                       )
                                                                                                       ) - ss_imp_retencion) * 100
                                                                                               )
                                                                        ),
                                                                 '')
                                                               else '0'
                                  end,
            "IMPUESTO RETENIDO" = isnull(convert(varchar(30), convert(bigint, ss_imp_retencion * 100)), ''),
            "DENOM. CUENTA"     = substring(ss_datos_adicionales, charindex('CTA:', ss_datos_adicionales) + 4,  len(ss_datos_adicionales)),
            "TARJ. DE CREDITO"  = 'NO APLICA',
            "SECUENCIAL"        = ss_identity
            from  bc_sellos_salida, 
                  bc_p_impuestos
            where ss_fecha_informac = im_f_hasta
            and   ss_impuesto       = im_impuesto
            and   ss_disenio        = @i_disenio
            and   im_m_disenio      = @i_disenio
            and   ss_impuesto       = @i_impuesto
            and   ss_identity       > isnull(@i_identity_hasta, 0)
			and   ss_imp_retencion <> 0
            order by ss_identity
            
            set rowcount 0
         end  -- ES SELLOS DE CHUBUT
         else
         if @i_impuesto = 'SELLCABA'
         begin
            set rowcount @i_cant_rows
            
            select
            "CUIT 1"             = convert(varchar(11),ss_ced_ruc),
            "CUIT 2"             = null,
            "MONTO DEL CONTRATO" = convert(varchar(14),ss_base_calculo),
            "BASE IMPONIBLE"     = convert(varchar(14),ss_base_calculo),
            "IMPORTE RETENIDO"   = convert(varchar(11),ss_imp_retencion),
            "COD. DE EXENCION"   = '139000',
            "COD. DE ACTOS"      = convert(varchar(6),ss_regimen),
            "FECHA CONTRATO"     = convert(varchar(10),ss_fecha_fv,103),
            "POLIZA TRANSACCION" = convert (varchar(15),ss_numero),
            "CBU"                = ltrim(rtrim(convert(varchar(22),substring(ss_datos_adicionales,charindex('CBU:',ss_datos_adicionales) + 4, len(ss_datos_adicionales)- 4)))),
            "SECUENCIAL"         = ss_identity
            from  bc_sellos_salida, 
                  bc_p_impuestos
            where ss_fecha_informac = im_f_hasta
            and   ss_impuesto       = im_impuesto
            and   ss_disenio        = @i_disenio
            and   im_m_disenio      = @i_disenio
            and   ss_impuesto       = @i_impuesto
            and   ss_identity       > isnull(@i_identity_hasta, 0)
            order by ss_identity
            
            set rowcount 0
         end  -- ES SELLOS DE CABA
         else
         if @i_impuesto in ('FORPROEXP','FORPROEXR','GANANCIAS','SELLCATAMA','SELLNEUQUE','SELLRNEGRO','SELLSCRUZ','SELLSJUAN','SELLASOCIA','SELLLHOGAR','SELLSTAFE','SELLSTGO','SELLTFUEGO')
         begin
            set rowcount @i_cant_rows
            
            select
            "FECHA DE PRESENTACION" = isnull(convert(varchar(10), ss_fecha_fv , 103), ''),
            "RAZON SOCIAL"          = ltrim(rtrim(convert(varchar(60),substring(ss_datos_adicionales,charindex('|NOM:',ss_datos_adicionales) + 5,charindex('|DOM:',ss_datos_adicionales) - charindex('|NOM:',ss_datos_adicionales)- 5)))),
            "DOMICILIO CLIENTE"     = ltrim(rtrim(convert(varchar(60),case when ss_impuesto = 'SELLSTAFE' then substring(ss_datos_adicionales, charindex('|DOM:',ss_datos_adicionales) + 5 ,charindex('VFIJO:',ss_datos_adicionales) - charindex('|DOM:',ss_datos_adicionales)-5)
                                      else ltrim(rtrim(substring(ss_datos_adicionales, charindex('|DOM:',ss_datos_adicionales) + 5,len(ss_datos_adicionales)))) end))),
            "CUIT"                  = ltrim(rtrim(convert(varchar(11),ss_ced_ruc))),
            "NUMERO DE OPERACION"   = ltrim(rtrim( convert(varchar(15),ss_numero))),
            "MONTO DE OPERACIONES"  = ltrim(rtrim(convert(varchar(19),ss_base_calculo))),
            "ALICUOTA"              = convert(varchar(9), replicate('0', 2 - len(convert(varchar(10),convert(int, ss_alicuota)))) + convert(varchar(9), convert(decimal(10, 6), ss_alicuota))),
            "IMPORTE RETENIDO"      = ltrim(rtrim(convert(varchar(19),ss_imp_retencion))),
            "REGIMEN"	            = ltrim(rtrim(convert(varchar(8),isnull(ss_regimen,'0')))),
            "VALOR FIJO"            = ss_valor_fijo,
            "SUCURSAL"              = case when ss_impuesto = 'SELLSTAFE' then convert(varchar(30),ltrim(rtrim(substring(ss_datos_adicionales, charindex('|OFICINA:',ss_datos_adicionales) + 9, charindex('|%EXEN',ss_datos_adicionales) - charindex('|OFICINA:',ss_datos_adicionales) - 9))))
                                      else null end,
            "SECUENCIAL"            = ss_identity
            from  bc_sellos_salida, 
                  bc_p_impuestos
            where ss_fecha_informac = im_f_hasta
            and   ss_impuesto       = im_impuesto
            and   ss_disenio        = @i_disenio
            and   im_m_disenio      = @i_disenio
            and   ss_impuesto       = @i_impuesto
            and   ss_identity       > isnull(@i_identity_hasta, 0)
            order by ss_identity
            
            set rowcount 0
         end  -- ES SELLOS DE GENERICO
         else
         if @i_impuesto = 'SELLCHACO'
         begin -- ES SELLADO DE SELLCHACO
            set rowcount @i_cant_rows
         
            select
            "REGISTRO" = convert(char(235),
                         isnull((select convert(varchar(11), pa_char) from cobis..cl_parametro where pa_producto = 'BCR' and pa_nemonico = 'CUITBM'), '00000000000') +
                         convert(char(20), isnull(ss_numero, replicate('X', 20))) +
                         convert(varchar(10),ss_fecha_fv,112) +
                         convert(char(10), isnull(ss_regimen, replicate('X', 10))) +
                         '5' +
                         convert(char(11), isnull(ss_ced_ruc, replicate('0', 11))) +
                         convert(char(25), isnull(ltrim(rtrim(substring(ss_descripcion, charindex('|NOM:',ss_descripcion) + 5 ,len(ltrim(rtrim(ss_descripcion)))- charindex('|NOM:',ss_descripcion)))),replicate('X', 25))) +
                         case when isnull(ss_base_calculo,0) < 0 then '-' + right(replicate('0', 11 - len(convert(varchar(20), str_replace(convert(varchar(20),abs(isnull(ss_base_calculo,0))),'.', null)))) + convert(varchar(20), str_replace(convert(varchar(20),abs(isnull(ss_base_calculo,0))),'.', null)),11)
                              else right(replicate('0', 12 - len(convert(varchar(20), str_replace(convert(varchar(20),abs(isnull(ss_base_calculo,0))),'.', null)))) + convert(varchar(20), str_replace(convert(varchar(20),abs(isnull(ss_base_calculo,0))),'.', null)),12) end +
                         convert(char(1), ss_tipo_exencion) +
                         convert(char(4), isnull(ltrim(rtrim(substring(ss_datos_adicionales, charindex('|FOJAS:',ss_datos_adicionales) + 7 ,len(ltrim(rtrim(ss_datos_adicionales)))- charindex('|FOJAS:',ss_datos_adicionales)))),' ')) +
                         replicate(' ', 50) +
                         replicate(' ', 50) +
                         case when isnull(ss_imp_retencion,0) - isnull(ss_valor_fijo,0) < 0 then '-' + right(replicate('0', 11 - len(convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0) - isnull(ss_valor_fijo,0))),'.', null)))) + convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0) - isnull(ss_valor_fijo,0))),'.', null)),11)
                              else right(replicate('0', 12 - len(convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0) - isnull(ss_valor_fijo,0))),'.', null)))) + convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0) - isnull(ss_valor_fijo,0))),'.', null)),12) end +
                         case when isnull(ss_valor_fijo,0) < 0 then '-' + right(replicate('0', 7 - len(convert(varchar(8), str_replace(convert(varchar(8),abs(isnull(ss_valor_fijo,0)/1000.00)),'.', null)))) + convert(varchar(8), str_replace(convert(varchar(8),abs(isnull(ss_valor_fijo,0)/1000.00)),'.', null)),7)
                              else right(replicate('0', 8 - len(convert(varchar(8), str_replace(convert(varchar(8),abs(isnull(ss_valor_fijo,0)/1000.00)),'.', null)))) + convert(varchar(8), str_replace(convert(varchar(8),abs(isnull(ss_valor_fijo,0)/1000.00)),'.', null)),8) end +
                         case when isnull(ss_imp_retencion,0) < 0 then '-' + right(replicate('0', 11 - len(convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0))),'.', null)))) + convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0))),'.', null)),11)
                              else right(replicate('0', 12 - len(convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0))),'.', null)))) + convert(varchar(12), str_replace(convert(varchar(12),abs(isnull(ss_imp_retencion,0))),'.', null)),12) end),
            "SECUENCIAL" = ss_identity
            from  bc_sellos_salida
            where ss_fecha_informac = @w_fecha_hasta




            and   ss_impuesto       = @i_impuesto
            and   ss_disenio        = @i_disenio
            and   ss_identity       > isnull(@i_identity_hasta, 0)
            order by ss_identity
            
            set rowcount 0
         end -- ES SELLADO DE SELLCHACO
         else
         if @i_impuesto = 'SELLARIOJA'
         begin -- ES PERCEPCION DE SELLARIOJA

            set rowcount @i_cant_rows

            if @i_disenio  in ( 'A','B') 
            begin -- PLANO DE OPERACIONES DE SELLARIOJA PROCESADAS

               select
               'NRO COMPROBANTE' = convert(varchar(30),ltrim(rtrim(substring(ss_numero,1,30))) +  replicate(' ', 30 - datalength(ltrim(rtrim(substring(ss_numero,1,30)))))),
               'FECHA OPERACION' = convert(varchar(16), ss_fecha_fv,103),
               'NOMBRE'          = substring(ss_datos_adicionales,13,80),
               'TIPO DOCUMENTO'  = substring(ss_datos_adicionales,7,1),  
               'NRO DOCUMENTO'   = right(ltrim(rtrim(ss_ced_ruc)) + replicate(' ', 15 - isnull(len(ltrim(rtrim(ss_ced_ruc))),0)),15),
               'DOMICILIO'       = substring(ss_descripcion,17,80),
               'COD. REGIMEN'    = ss_regimen,
               'BASE/CANTIDAD'   = right(replicate('0',18  - (datalength(ltrim(ss_base_calculo)) -3)) + substring(ss_base_calculo,1,datalength(ltrim(ss_base_calculo)) -3) +','+ substring(ss_base_calculo,datalength(ltrim(ss_base_calculo)) -1,2),18),
               'IMPORTE'         = right(replicate('0',18  - (datalength(ltrim(ss_imp_retencion))-3)) + substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion))-3) +','+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) - 1,2),18),
               'DETALLE'         = substring(ss_datos_adicionales,98,80),
               'ID'           =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto 
               and   ss_fecha_informac = @w_fecha_hasta                
               and   substring(ss_disenio,1,1) = @i_disenio 
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
               
            end   -- PLANO DE OPERACIONES DE SELLARIOJA PROCESADAS
         end -- ES PERCEPCION DE SELLARIOJA
         else
         if @i_impuesto = 'SELLAPAMPA'
         begin -- ES PERCEPCION DE SELLAPAMPA
            set rowcount @i_cant_rows

            if @i_disenio  =  'A'
            begin -- MAPEO A LA GRILLA DE SELLPAMPA ADET
             select 
               'SECUENCIAL'     = ADET.ss_numero,                                  
               'FECHA RET.'     = convert(varchar(10),ADET.ss_fecha_fv,103),
               'COD.ALIC.'= ADET.ss_regimen,
               '% ALIC.' = isnull(ADET.ss_alicuota,0) ,
               'BASE IMP.' = isnull(ADET.ss_base_calculo,0) ,
               '% EXENCION' = isnull(ADET.ss_pct_exencion,0),
               'IMP.RET.' = isnull(ADET.ss_imp_retencion,0) ,
               'ID'              =  convert(int,ADET.ss_numero)
              from cob_bcradgi..bc_sellos_salida ADET 
              where ADET.ss_impuesto       = @i_impuesto 
              and   ADET.ss_disenio        = 'ADET' 
              and   ADET.ss_fecha_informac = @w_fecha_hasta                
              and   convert(int,ADET.ss_numero)    >  isnull(@i_identity_hasta,  0  )
              order by ADET.ss_numero 
               
            end   -- MAPEO A LA GRILLA DE SELLPAMPA DETALLE
            else
            if @i_disenio  =  'B'
            begin -- MAPEO A LA GRILLA DE SELLPAMPA BCLI
             select 
              'SECUENCIAL'          = BCLI.ss_numero,
              'CUIT'                = convert(char(11),isnull(BCLI.ss_ced_ruc,'0')),
              'NOMBRE'              = substring(BCLI.ss_descripcion,27,40),
              'DIRECCION'           = substring(BCLI.ss_descripcion,78,100),
              'CARACTER INVESTIDO'  = substring(BCLI.ss_datos_adicionales,31,2),
              'ID'                  = convert(int,BCLI.ss_numero)
              from cob_bcradgi..bc_sellos_salida BCLI
              where BCLI.ss_impuesto       = @i_impuesto 
              and   BCLI.ss_disenio        = 'BCLI' 
              and   BCLI.ss_fecha_informac = @w_fecha_hasta                
              and   convert(int,BCLI.ss_numero)       >  isnull(@i_identity_hasta,  0  )
              order by BCLI.ss_numero
               
            end   -- MAPEO A LA GRILLA DE SELLPAMPA BCLI
            else
            if @i_disenio  =  'CAB'
            begin -- MAPEO A LA GRILLA CABECERA DE ARCHIVO 
               
               SELECT 
               convert(char(2),'01')    +
               right('00' + (SELECT pa_char from cobis..cl_parametro where pa_producto = 'BCR' and pa_nemonico = 'CTCULP'),2) +
               convert(char(10),replicate(' ',9) + '1' )            +
               convert(char(10),convert(varchar,getdate(),103))   +
               convert(char(4),datepart(year, min(ADET.ss_fecha_informac) )) + right('00' + convert(varchar,datepart(month,min(ADET.ss_fecha_informac) ) ) ,2) +
               right('000000000' + (SELECT pa_char from cobis..cl_parametro where pa_producto = 'BCR' and pa_nemonico = 'AGEREN'),9 )  +
               replicate('0',9)  +
               '00'   +
               right(replicate('0',13) + convert(varchar,convert(int,sum(ADET.ss_imp_retencion) * 100)),13) +
               right(replicate('0',13) + convert(varchar,convert(int,sum(ADET.ss_base_calculo) * 100)),13) +
               right(replicate('0',13) + convert(varchar,count(1)),5)
               from   cob_bcradgi..bc_sellos_salida ADET
               where ADET.ss_impuesto      = @i_impuesto 
               and  ADET.ss_fecha_informac = @w_fecha_hasta                
               and  substring(ADET.ss_datos_adicionales,9,1) = @i_estado
               and   ADET.ss_disenio       = 'ADET'


            end   -- MAPEO A LA GRILLA DE SELLPAMPA BCLI
            else
            if @i_disenio  =  'X'   -- MAPEO A LA GRILLA PARA EXPORTA
            begin
                
                
                select 
                isnull(direccion,' ')         +  ' ' +
                isnull(ci_descripcion,' ')    +  ' ' +
                isnull(pv_descripcion,' ')    +  ' ' +
                isnull(postal,' ')   db_direccion ,
                isnull((select pa_char  from cobis..cl_parametro where pa_nemonico = 'CUITBM' and pa_producto = 'BCR'),' ') db_cuit ,
                isnull((select pa_char from cobis..cl_parametro where pa_nemonico = 'NDGI'and pa_producto = 'ADM'),'') db_nombre ,
                case isnull((select pa_char from cobis..cl_parametro where pa_producto = 'BCR' and   pa_nemonico = 'INFBCO'),'N') when 'S' then 'S' else 'N' end db_informa
                into #tmp_datos_bco 
                from    cobis..cl_sucursal SUC,
                        cobis..cl_ciudad CI,
                        cobis..cl_provincia PV
                where   CI.ci_ciudad  = SUC.ciudad
                and     CI.ci_provincia  = PV.pv_provincia 
                and     SUC.sucursal  in (select pa_smallint from cobis..cl_parametro where pa_producto = 'BCR' and   pa_nemonico = 'INFSUC')                
                
                set rowcount @i_cant_rows
                select 
                convert(int,ss_numero) ss_numero,
                ss_fecha_fv,
                ss_regimen,
                ss_alicuota,
                ss_base_calculo,
                ss_pct_exencion,
                ss_tipo_exencion,
                ss_imp_retencion,
                ss_descripcion,
                ss_identity,
                ss_disenio,
                ss_impuesto,
                ss_ced_ruc,
                ss_fecha_informac,
                ss_datos_adicionales
                into #pre_salida_ADET 
                from bc_sellos_salida
                where ss_impuesto      = 'SELLAPAMPA'
                and  ss_fecha_informac = @w_fecha_hasta
                AND  ss_disenio = 'ADET'
                and  convert(int,ss_numero)  > isnull(@i_identity_hasta,0)
                order by ss_numero
                 
                select 
                convert(int,ss_numero) ss_numero,
                ss_fecha_fv,
                ss_regimen,
                ss_alicuota,
                ss_base_calculo,
                ss_pct_exencion,
                ss_tipo_exencion,
                ss_imp_retencion,
                ss_descripcion,
                ss_identity,
                ss_disenio,
                ss_impuesto,
                ss_ced_ruc,
                ss_fecha_informac,
                ss_datos_adicionales
                into #pre_salida_BCLI 
                from bc_sellos_salida
                where ss_impuesto      = 'SELLAPAMPA'
                and  ss_fecha_informac = @w_fecha_hasta
                AND  ss_disenio = 'BCLI'
                and  convert(int,ss_numero) >  isnull(@i_identity_hasta,0)
                order by ss_numero


 
                  set rowcount @i_cant_rows
                       select 
                 '1'=  right(replicate('0',9) +  convert(varchar,ADET.ss_numero),9)  +                                                      
                       convert(char(10),' ')           +                             
                       convert(char(10),convert(varchar(10),isnull(ADET.ss_fecha_fv,' '),103)) +
                       right(replicate('0',11) + convert(varchar,ADET.ss_regimen),4)                 +   
                       right(replicate('0',11) + convert(varchar,convert(int,isnull(ADET.ss_alicuota,0) * 1000)) ,11)  +
                       right(replicate('0',15) + convert(varchar,convert(int,isnull(ADET.ss_base_calculo,0) * 100)) ,13) +
                       right(replicate('0',11) + convert(varchar,convert(int,isnull(ADET.ss_pct_exencion,0) * 100)) ,5) +
                       convert(char(30),isnull(ADET.ss_tipo_exencion,' '))                  +
                       right(replicate('0',11) + convert(varchar,convert(int,isnull(ADET.ss_imp_retencion,0) * 100)) ,11) + 
                       replicate('0',11)                   + 
                       right(replicate('0',11) + convert(varchar,isnull(BCLI.ss_ced_ruc,' ')) ,11)  +
                       str_replace(str_replace(convert(char(40),isnull(substring(BCLI.ss_descripcion,27,40),replicate(' ',200))) ,'¥','Ñ'),'Ð','Ñ')    ,
                  '2'= str_replace(str_replace(convert(char(100),isnull(substring(BCLI.ss_descripcion,78,100),replicate(' ',200)))  ,'¥','Ñ'),'Ð','Ñ') +
                       right(replicate('0',11) + convert(varchar,isnull(substring(BCLI.ss_datos_adicionales,31,2),replicate(' ',200))),3)  +
                       right(replicate(' ',11) + convert(varchar,isnull((select db_cuit from #tmp_datos_bco where db_informa = 'S'), ' ')),11) +
                       convert(char(40),isnull((select db_nombre from #tmp_datos_bco where db_informa = 'S'), ' ')) ,
                  '3'= str_replace(str_replace(convert(char(100),isnull((select db_direccion from #tmp_datos_bco where db_informa = 'S'), ' ')),'¥','Ñ'),'Ð','Ñ') +
                       case when isnull((select db_direccion from #tmp_datos_bco where db_informa = 'S'),'N') = 'S' then right(replicate('0',11) + convert(varchar,isnull(substring(ADET.ss_datos_adicionales,33,2),replicate(' ',200))),3) else '000' end   ,
                  '4' =  substring(ADET.ss_datos_adicionales,9,1)   ,
                 'ID' =  convert(int,ADET.ss_numero)
               from   #pre_salida_ADET ADET,
                      #pre_salida_BCLI BCLI
                where ADET.ss_numero        = BCLI.ss_numero 
                order by ADET.ss_identity 
          
            end   -- MAPEO A LA GRILLA PARA EXPORTA
         
         end -- ES PERCEPCION DE SELLAPAMPA
         else
         if @i_impuesto = 'SELLSALTA'
         begin -- ES PERCEPCION DE SELLSALTA

            set rowcount @i_cant_rows

            if @i_disenio  in ( 'A','B') 
            begin -- PLANO DE OPERACIONES DE SELLARIOJA PROCESADAS

               select
               'DIA'             = right(replicate('0', 2) + convert(varchar(2), datepart(dd, ss_fecha_fv)),2),
               'NRO INSTRUMENTO' = right(replicate('0', 20) + convert(varchar(20),ltrim(rtrim(substring(ss_numero,1,20)))),20),
               'NOMBRE'          = str_replace(substring(ss_datos_adicionales,17,60), char(165), char(209)),
               'DOMICILIO'       = str_replace(str_replace(substring(ss_descripcion,6,60), char(165), char(209)), char(124), char(167)),
               'CUIT'            = right(ltrim(rtrim(ss_ced_ruc)) + replicate(' ', 11 - isnull(len(ltrim(rtrim(ss_ced_ruc))),0)),11),
               'MONTO'           = right(replicate('0',16  - (datalength(ltrim(ss_base_calculo)) -3)) + substring(ss_base_calculo,1,datalength(ltrim(ss_base_calculo)) -3) +'.'+ substring(ss_base_calculo,datalength(ltrim(ss_base_calculo)) -1,2),16),
               'ALICUOTA'        = replicate('0',4  - (datalength(rtrim(ltrim(str(ss_alicuota,4,2))))) ) + substring(ltrim(rtrim(str(ss_alicuota,4,2))),1,len(ltrim(rtrim(str(ss_alicuota,4,2))))-3  )+'.'+ substring(ltrim(rtrim(str(ss_alicuota,4,2))),len(ltrim(rtrim(str(ss_alicuota,4,2))))-1 ,2),
               'EXENTO'          = replicate('0',5  - (datalength(rtrim(ltrim(str(ss_pct_exencion,5,2))))) ) + substring(ltrim(rtrim(str(ss_pct_exencion,5,2))),1,len(ltrim(rtrim(str(ss_pct_exencion,5,2))))-3  )+'.'+ substring(ltrim(rtrim(str(ss_pct_exencion,5,2))),len(ltrim(rtrim(str(ss_pct_exencion,5,2))))-1 ,2),
               'IMPORTE RET'     = right(replicate('0',16  - (datalength(ltrim(ss_imp_retencion))-3)) + substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion))-3) +'.'+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) - 1,2),16),
               'CANT FOJAS'      = str_replace(substring(ss_datos_adicionales,8,4), char(165), char(209)),
               'IMPORTE FOJAS'   = right(replicate('0',16  - (datalength(ltrim(isnull(ss_valor_fijo,0.00))) - 3)) + substring(isnull(ss_valor_fijo,0.00),1,datalength(ltrim(isnull(ss_valor_fijo,0.00)))-3) +'.'+ substring(isnull(ss_valor_fijo,0.00),datalength(ltrim(isnull(ss_valor_fijo,0.00))) -1,2),16),
               'SUBTOTAL'        = right(replicate('0',16  - (datalength(ltrim(isnull(ss_imp_retencion+ss_valor_fijo,0.00))) - 3)) + substring(isnull(ss_imp_retencion+ss_valor_fijo,0.00),1,datalength(ltrim(isnull(ss_imp_retencion+ss_valor_fijo,0.00)))-3) +'.'+ substring(isnull(ss_imp_retencion+ss_valor_fijo,0.00),datalength(ltrim(isnull(ss_imp_retencion+ss_valor_fijo,0.00))) -1,2),16),
               'TIPO TASA'       = 'S',
               'COD ACTO'        = right(replicate('0',4) + ss_regimen,4),
               'TIPO ACTO'       = replicate(' ',10),
               'ID'              = convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto 
               and   ss_fecha_informac = @w_fecha_hasta                
               and   ss_disenio = @i_disenio 
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
               
            end   -- PLANO DE OPERACIONES DE SELLARIOJA PROCESADAS
            else
            if @i_disenio  = 'X' 
            begin -- PLANO DE OPERACIONES DE SELLARIOJA PROCESADAS

               select
               'D1'     =  right(replicate('0', 2) + convert(varchar(2), datepart(dd, ss_fecha_fv)),2) + 
                           right(replicate('0', 20) + convert(varchar(20),ltrim(rtrim(substring(ss_numero,1,20)))),20) +
                           str_replace(substring(ss_datos_adicionales,17,60), char(165), char(209)) +
                           str_replace(str_replace(substring(ss_descripcion,6,60), char(165), char(209)), char(124), char(167)) +
                           right(ltrim(rtrim(ss_ced_ruc)) + replicate(' ', 11 - isnull(len(ltrim(rtrim(ss_ced_ruc))),0)),11) +
                           right(replicate('0',16  - (datalength(ltrim(ss_base_calculo)) -3)) + substring(ss_base_calculo,1,datalength(ltrim(ss_base_calculo)) -3) +'.'+ substring(ss_base_calculo,datalength(ltrim(ss_base_calculo)) -1,2),16) +
                           right(replicate('0',4  - (datalength(rtrim(ltrim(str(ss_alicuota,4,2))))) ) + substring(ltrim(rtrim(str(ss_alicuota,4,2))),1,len(ltrim(rtrim(str(ss_alicuota,4,2))))-3  )+'.'+ substring(ltrim(rtrim(str(ss_alicuota,4,2))),len(ltrim(rtrim(str(ss_alicuota,4,2))))-1 ,2),4) +
                           right(replicate('0',5  - (datalength(rtrim(ltrim(str(ss_pct_exencion,5,2))))) ) + substring(ltrim(rtrim(str(ss_pct_exencion,5,2))),1,len(ltrim(rtrim(str(ss_pct_exencion,5,2))))-3  )+'.'+ substring(ltrim(rtrim(str(ss_pct_exencion,5,2))),len(ltrim(rtrim(str(ss_pct_exencion,5,2))))-1 ,2),5) +
                           right(replicate('0',16  - (datalength(ltrim(ss_imp_retencion))-3)) + substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion))-3) +'.'+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) - 1,2),16) +
                           right(replicate('0',4)  + rtrim(str_replace(substring(ss_datos_adicionales,8,4), char(165), char(209))),4)  +
                           right(replicate('0',16   - (datalength(ltrim(isnull(ss_valor_fijo,0.00))) - 3)) + substring(isnull(ss_valor_fijo,0.00),1,datalength(ltrim(isnull(ss_valor_fijo,0.00)))-3) +'.'+ substring(isnull(ss_valor_fijo,0.00),datalength(ltrim(isnull(ss_valor_fijo,0.00))) -1,2),16) +
                           right(replicate('0',16   - (datalength(ltrim(isnull(ss_imp_retencion+ss_valor_fijo,0.00))) - 3)) + substring(isnull(ss_imp_retencion+ss_valor_fijo,0.00),1,datalength(ltrim(isnull(ss_imp_retencion+ss_valor_fijo,0.00)))-3) +'.'+ substring(isnull(ss_imp_retencion+ss_valor_fijo,0.00),datalength(ltrim(isnull(ss_imp_retencion+ss_valor_fijo,0.00))) -1,2),16) +
                           'S' +
                           right(replicate('0',4) + ss_regimen,4),
               'D2'      = replicate(' ',100) + '|' ,
               'ESTADO'  = substring(ss_descripcion,74,1),
               'ID'      = convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto 
               and   ss_fecha_informac = @w_fecha_hasta                
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity, substring(ss_descripcion,74,1)
               
            end   -- PLANO DE OPERACIONES DE SELLARIOJA PROCESADAS
         end -- ES PERCEPCION DE SELLSALTA
         else
         if @i_impuesto = 'SELLMZA'
         begin -- ES PERCEPCION DE SELLMZA

            set rowcount @i_cant_rows

            if @i_disenio  in ( 'A','B') 
            begin -- PLANO DE OPERACIONES DE SELLMZA PROCESADAS

               select
               'NRO CUIT'        = case 
                                      when ss_ced_ruc = null then '             '
                                      else substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1)
                                   end,
               'DENOMINACION'    = str_replace(substring(ss_datos_adicionales,6,60), char(165), char(209)),
               'FECHA RET.'      = convert(varchar(10),ss_fecha_fv,103),
               'NATURALEZA'      = '',
               'DESTINO'         = '',
               'MONTO OP.'       = case 
                                      when ss_valor_fijo = 0 then right(replicate(' ',15  - (datalength (ltrim(ss_base_calculo)) -3)) + substring(ss_base_calculo,1,datalength(ltrim(ss_base_calculo)) -3) +'.'+ substring(ss_base_calculo,datalength(ltrim(ss_base_calculo)) -1,2),15)
                                      else replicate(' ',15)
                                   end,           
               'ALICUOTA'        = case 
                                      when ss_valor_fijo = 0 then replicate(' ',5  - (datalength(rtrim(ltrim(str(ss_alicuota,5,2))))) ) + substring(ltrim(rtrim(str(ss_alicuota,5,2))),1,len(ltrim(rtrim(str(ss_alicuota,5,2))))-3  )+'.'+ substring(ltrim(rtrim(str(ss_alicuota,5,2))),len(ltrim(rtrim(str(ss_alicuota,5,2))))-1 ,2)
                                      else '     '
                                   end,                                      
               'IMPUESTO'        = right(replicate(' ',15  - (datalength(ltrim(ss_imp_retencion))-3)) + substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion))-3) +'.'+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) - 1,2),15),
               'OBSERVACIONES'   = '',
               'ID'              = convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto 
               and   ss_fecha_informac = @w_fecha_hasta                
               and   ss_disenio = @i_disenio 
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity
               
            end   -- PLANO DE OPERACIONES DE SELLMZA PROCESADAS
            else
            if @i_disenio  = 'X' 
            begin -- PLANO DE OPERACIONES DE SELLMZA PROCESADAS

               select
               'D1'     =  left(substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1) + replicate(' ',13),13) +
                           left(str_replace(substring(ss_datos_adicionales,6,60), char(165), char(209)) + replicate(' ',80),80)  + 
                           str_replace(convert(varchar(10),ss_fecha_fv,103),'/',ltrim(rtrim(''))) +
                           replicate(' ',40) +
                           replicate(' ',15) +
                           case 
                              when ss_valor_fijo = 0 then right(replicate(' ',15  - (datalength(ltrim(ss_base_calculo)) -3)) + substring(ss_base_calculo,1,datalength(ltrim(ss_base_calculo)) -3) +'.'+ substring(ss_base_calculo,datalength(ltrim(ss_base_calculo)) -1,2),15) 
                              else '     '
                           end +
                           case 
                              when ss_valor_fijo = 0 then replicate(' ',5  - (datalength(rtrim(ltrim(str(ss_alicuota,5,2))))) ) + substring(ltrim(rtrim(str(ss_alicuota,5,2))),1,len(ltrim(rtrim(str(ss_alicuota,5,2))))-3  )+'.'+ substring(ltrim(rtrim(str(ss_alicuota,5,2))),len(ltrim(rtrim(str(ss_alicuota,5,2))))-1 ,2) 
                              else replicate(' ',15)
                           end +
                           right(replicate(' ',15  - (datalength(ltrim(ss_imp_retencion))-3)) + substring(ss_imp_retencion,1,datalength(ltrim(ss_imp_retencion))-3) +'.'+ substring(ss_imp_retencion,datalength(ltrim(ss_imp_retencion)) - 1,2),15),
               'D2'      = replicate(' ',100) + '|' ,
               'ESTADO'  = substring(ss_descripcion,9,1),
               'ID'      = convert(int,ss_identity)
               from bc_sellos_salida
               where ss_impuesto = @i_impuesto 
               and   ss_fecha_informac = @w_fecha_hasta                
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity, substring(ss_descripcion,9,1)
               
            end   -- PLANO DE OPERACIONES DE SELLARIOJA PROCESADAS
         end -- ES PERCEPCION DE SELLSALTA
         else  
         if @i_impuesto = 'SELLERIOS'
         begin -- ES SELLADO DE ENTRE RIOS
            set rowcount @i_cant_rows
            if @i_disenio  = 'A' 
            begin -- PLANO DE CABECERA y DETALLE OPERACIONES OK
               select 
               'RUBRO'	           = ss_regimen,
               'IDENTIFICACION'    = ss_numero,
               'CUIT'              = ss_ced_ruc,
               'FECHA_ACTO'	     = convert(varchar(20),ss_fecha_fv,103),
               'BASE_IMPONIBLE'    = str_replace(str_replace(convert(varchar(40), ss_base_calculo), ',', null), '.', ','),
               'ALICUOTA'          = str_replace(str_replace(convert(varchar(40), round(convert(money,ss_alicuota),2)), ',', null), '.', ','),
               'IMPORTE_RET_PER'   = str_replace(str_replace(convert(varchar(40), ss_imp_retencion), ',', null), '.', ','),
               'EN_CONDICION_DE'   = ltrim(rtrim(convert(varchar(100),substring(ss_datos_adicionales,charindex('EN CONDICION DE: ',ss_datos_adicionales) + 17, charindex('|',ss_datos_adicionales)-18)))),
               'CUIT_EN_CONDICION' = ss_ced_ruc, 
               'SECUENCIAL'        = convert(int,ss_identity)
                from  bc_sellos_salida
                where ss_fecha_informac = @w_fecha_hasta                
                and   ss_disenio        = 'A'
                and   ss_impuesto       = 'SELLERIOS'
                --and   ss_descripcion    = 'ESTADO: P'
                and   ss_identity >  isnull(@i_identity_hasta,  0  )
                order by ss_identity

            end
            else
            if @i_disenio  = 'B' 
            begin -- DETALLE OPERACIONES ERROR
               select 
               'RUBRO'	           = ss_regimen,
               'IDENTIFICACION'    = ss_numero,
               'CUIT'              = ss_ced_ruc,
               'FECHA_ACTO'	     = convert(varchar(20),ss_fecha_fv,103),
               'BASE_IMPONIBLE'    = str_replace(str_replace(convert(varchar(40), ss_base_calculo), ',', null), '.', ','),
               'ALICUOTA'          = str_replace(str_replace(convert(varchar(40), round(convert(money,ss_alicuota),2)), ',', null), '.', ','),
               'IMPORTE_RET_PER'   = str_replace(str_replace(convert(varchar(40), ss_imp_retencion), ',', null), '.', ','),
               'EN_CONDICION_DE'   = ltrim(rtrim(convert(varchar(100),substring(ss_datos_adicionales,charindex('EN CONDICION DE: ',ss_datos_adicionales) + 17, charindex('|',ss_datos_adicionales)-18)))),
               'CUIT_EN_CONDICION' = ss_ced_ruc,
               'SECUENCIAL'        = convert(int,ss_identity)
                from  bc_sellos_salida
                where ss_fecha_informac = @w_fecha_hasta                
                and   ss_disenio        = 'B'
                and   ss_impuesto       = 'SELLERIOS'
                --and   ss_descripcion    = 'ESTADO: E'
                and   ss_identity >  isnull(@i_identity_hasta,  0  )
                order by ss_identity
          
            end
            set rowcount 0
         end --ES SELLADO DE ENTRE RIOS
         else
         if @i_impuesto = 'SELLJUJUY'
         begin -- ES SELLADO DE JUJUY
            if exists (select 1
                       from  cob_bcradgi..bc_p_impuestos
                       where im_impuesto = @i_impuesto)
            begin -- IMPUESTO PARAMETRIZADO
               /* OBTENGO LOS DATOS DE LA PRESENTACION */
               exec @w_return = cob_bcradgi..sp_selljujuy 
               @i_c_operacion   = 'Q',
               @i_c_disenio     = @i_disenio,
               @i_n_opcion      = 1,
               @i_m_quien_llama = 'F',
               @i_f_desde       = @w_fecha_desde,
               @i_f_hasta       = @w_fecha_hasta,
               @i_k_rowcount    = @i_cant_rows,
               @i_s_hasta       = @i_identity_hasta

               if @w_return <> 0
               begin
                  return @w_return
               end
            end -- IMPUESTO PARAMETRIZADO
            else -- IMPUESTO NO PARAMETRIZADO
            begin
               set rowcount @i_cant_rows
               select
                  'CUIT'      =  substring(ss_ced_ruc,1,2)+'-'+ substring(ss_ced_ruc,3,8)+ '-' + substring(ss_ced_ruc,11,1),
                  'BASE_IMP'  =  (case
                                    when  ss_base_calculo >= 0   then '0'
                                    else '-'
                                  end)+ convert(char(11),replicate('0',11 - datalength(ltrim(convert(varchar(11),str(abs(ss_base_calculo),11,2))))) + ltrim(convert(varchar(11),str(abs(ss_base_calculo),11,2)))),
                  'IMP_RET'   =  (case
                                    when ss_imp_retencion >= 0 then '0'
                                    else '-'
                                 end) +   convert(char(10),replicate('0',10 - datalength(ltrim(str(abs(ss_imp_retencion),10,2)))) + ltrim(str(abs(ss_imp_retencion),10,2))),
                  'FECHA'     =  convert(varchar(10),ss_fecha_fv_informa,103),
                  'T_OPERACION' = ss_disenio,
                  'CANT'      =  ss_descripcion ,
                  'ID'        =  convert(int,ss_identity)
               from bc_sellos_salida
               where ss_fecha_informac =  @w_fecha_hasta
               and   ss_impuesto       =  @i_impuesto
               and   ss_disenio        =  @i_disenio
               and   ss_identity >  isnull(@i_identity_hasta,  0  )
               order by ss_identity

            end -- IMPUESTO NO PARAMETRIZADO
         end -- ES SELLADO DE JUJUY
         
         
         set rowcount 0

         return 0

      end   --@i_opcion = 52  -- PARA GENERACION DEL PLANO PARA PERIB
      else /*ANIDADO DE OPCION*/
      if @i_opcion = 53
      begin   --@i_opcion = 53  -- F5 DE SERVICIOS
         set rowcount @i_cant_rows

         select 'SERVICIO'    = ic_concepto,
                'DESCRIPCION' = case ic_modulo 
                                when 19 then isnull(( select fo_descripcion 
                                                      from cob_custodia..cu_formulario_garantia
                                                      where fo_formulario  = ic.ic_concepto ),'S/DESC')
                                else isnull(( select se_descripcion 
                                              from   bc_servicios
                                              where  se_servicio = ic.ic_concepto),'S/DESC')
                                end,
                '#REGISTROS'  = count(1)
         from bc_impuesto_cobro ic
         where ic_fecha_liquidacion between @i_fecha_desde and @i_fecha_hasta --FECHAS DESDE HASTA
         and ic_impuesto   = @i_impuesto --IMPUESTO
         and ic_categoria  = isnull(@i_categoria,ic_categoria) --CATEGORIA
         and ic_moneda     = isnull(@i_moneda,ic_moneda) --MONEDA
         and ic_estado     = isnull(@i_estado,'L') --ESTADO
         and ic_region     = isnull(@i_region,ic_region) --REGION
         and ic_fecha_valor between isnull(@i_fecha_fv_desde,ic_fecha_valor) and isnull(@i_fecha_fvhasta,ic_fecha_valor)--FECHA VALOR
         and ic_ente       = isnull(@i_cliente,ic_ente) --CLIENTE
         and ic_modulo     = isnull(@i_producto,ic_modulo) --MODULO
         and ic_sucursal   between isnull(@i_sucursal_desde,convert(int,ic_sucursal)) and isnull(@i_sucursalhasta,ic_sucursal)
         and ic_sucursal   = isnull(@i_sucursal,ic_sucursal)
         and isnull(ic_grupo_trx,'')  = isnull(@i_tipo_mov,isnull(ic_grupo_trx,'')) --TIPO MOV
         and ic_cuenta     = isnull(@i_cta_banco,ic_cuenta) --CUENTA
         and ic_concepto   = isnull(@i_servicio,ic_concepto) --SERVICIO
         and
            (
               (  isnull(ic_grupo_trx,'') <> 'EXEN'
                  and   (
                           (
                              ic_importe_retenido_pesos <> 0.00
                              and  @i_credito <> 'S'
                            )
                            or
                            (
                              ic_importe_retenido_pesos < 0.00
                              and  @i_credito = 'S'
                            )
                         )
               )
               or
               (  isnull(ic_grupo_trx,'') = 'EXEN'
                  and   ic_importe_retenido_pesos = 0.00
                  and   @i_credito  <> 'S'
               )
            )
         and isnull(ic_cargo_banco,'N') = isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
         /* PARA EL SIG */
         and ic_concepto > isnull(@i_concepto_hasta, char(31)) --SERVICIO
         group by ic_concepto, ic_modulo
         order by ic_concepto, ic_modulo

         if @@rowcount = 0  and @i_concepto_hasta is null
         begin  -- NO HAY DATOS QUE CUMPLAN LA CONDICION
            select @w_numeroerror = 2900067
            goto error_trap
         end  -- NO HAY DATOS QUE CUMPLAN LA CONDICION

         set rowcount 0
         return 0
      end   --@i_opcion = 53  -- F5 DE SERVICIOS
      else
      if @i_opcion = 56
      begin -- @i_opcion = 56  -- PROCESO DE GENERACION DE LA TABLA DE SALIDA PARA SELLADOS

         select @w_fecha_desde = isnull(@i_fecha_fv_desde, @i_fecha_desde)

         execute @w_return = cobis..sp_dias_feriados
            @i_opcion         = 1 ,
            @i_fecha_ini      = @w_fecha_desde,
            @i_dias_habiles   = 2 ,
            @o_fecha_nueva    = @w_fecha_desde_segundo_dia  out

         if @w_return != 0
         begin -- DEVOLVIO ERROR
            goto error_trap
         end   -- DEVOLVIO ERROR

         select @w_fecha_hasta = isnull(@i_fecha_fvhasta, @i_fecha_hasta)

         execute @w_return = cobis..sp_dias_feriados
            @i_opcion         = 1 ,
            @i_fecha_ini      = @w_fecha_hasta,
            @i_dias_habiles   = 1 ,
            @o_fecha_nueva    = @w_fecha_hasta_primer_dia  out

         if @w_return != 0
         begin -- DEVOLVIO ERROR
            goto error_trap
         end   -- DEVOLVIO ERROR

         delete from bc_sellos_salida
         where ss_fecha_informac =  @w_fecha_hasta
         and   ss_impuesto       =  @i_impuesto

         if @@error != 0
         begin -- ERROR DURANTE ELIMINACION
            select
               @w_return = 2900131, -- 'ERROR AL ELIMINAR REGISTROS DE LA TABLA'
               @w_sev = 0
            goto error_trap
         end -- ERROR DURANTE ELIMINACION

         if @i_impuesto = 'PERIBBSAS'
         begin -- ES PERCEPCION DE BUENOS AIRES

            /*GENERO UNA TEMPORAL*/
            select
               'ENTE'      =  ic_ente  ,
               'CED_RUC'   =  isnull(( select isnull(en_ced_ruc,'27000000006')
                                       from cobis..cl_ente
                                       where en_ente = i.ic_ente),'27000000006'),
               'BASE_IMP'  =  sum(ic_monto_base_imponible),
               'IMP_RET'   =  sum(ic_importe_retenido_pesos),
               'FECHA_FV'  =  ic_fecha_valor,
               'CANT'      =  count(1)
            into #TEMPTXT
            from cob_bcradgi..bc_impuesto_cobro i
            where ic_fecha_valor between @w_fecha_desde_segundo_dia and @w_fecha_hasta_primer_dia--FECHAS DESDE HASTA
            and ic_impuesto   = @i_impuesto--IMPUESTO
            and ic_modulo     = isnull(@i_producto,ic_modulo)
            and ic_modulo     =  3
            and ic_importe_retenido_pesos <> 0
            and ic_estado     = 'L'
            and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
            group by ic_ente, ic_fecha_valor 
            union all
            select
               'ENTE'      =  ic_ente  ,
               'CED_RUC'   =  isnull(( select isnull(en_ced_ruc,'27000000006')
                                       from cobis..cl_ente
                                       where en_ente = i.ic_ente),'27000000006'),
               'BASE_IMP'  =  sum(ic_monto_base_imponible),
               'IMP_RET'   =  sum(ic_importe_retenido_pesos),
               'FECHA_FV'  =  ic_fecha_valor, 
               'CANT'      =  count(1)
            from cob_bcradgi..bc_impuesto_cobro i
            where ic_fecha_valor             between  @w_fecha_desde  and      @w_fecha_hasta--FECHAS DESDE HASTA
            and   ic_impuesto                = @i_impuesto--IMPUESTO
            and   ic_modulo                  = isnull(@i_producto,ic_modulo)
            and   ic_modulo                  <>  3
            and   ic_importe_retenido_pesos  <> 0
            and   ic_estado                  = 'L'
            and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
            group by ic_ente, ic_fecha_valor 

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'A',              --ss_disenio
               max(ENTE),        --ss_ente
               CED_RUC,          --ss_ced_ruc (5)
               null,             --ss_modulo
               null,             --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               sum(BASE_IMP),    --ss_base_calculo
               sum(IMP_RET),     --ss_imp_retencion
               max(FECHA_FV),    --ss_fecha_fv
               case
                  when  datepart(mm,FECHA_FV) = datepart(mm,@w_fecha_hasta) then FECHA_FV
                  else  @w_fecha_hasta --(13)
               end   ,           --ss_fecha_fv_informa
               null,             --ss_alicuota
               null,                  --ss_sucursal
               null,                  --ss_cargo_banco
               null,                  --ss_tipo_base_imponible
               null,                  --ss_regimen
               null,                  --ss_valor_minimo
               null,                  --ss_pct_exencion
               null,                  --ss_valor_fijo
               null,                  --ss_tipo_exencion
               null,                  --ss_datos_adicionales
               convert(varchar(10),sum(CANT)),             --ss_descripcion
               getdate()              --ss_fecha_registro
            from #TEMPTXT
            group by CED_RUC, --FECHA_FV
                  case
                     when  datepart(mm,FECHA_FV) = datepart(mm,@w_fecha_hasta) then FECHA_FV
                     else  @w_fecha_hasta
                  end
            HAVING sum(IMP_RET) <> 0.00
            order by 5, --(CED_RUC)
                     13 -- (FECHA_FV)
            
         end -- ES PERCEPCION DE BUENOS AIRES
         else

         if @i_impuesto = 'PERIBSLUIS'
         begin -- ES PERCEPCION DE SAN LUIS

            select
               'CED_RUC'   =  isnull(( select isnull(en_ced_ruc,'27000000006')
                                       from cobis..cl_ente
                                       where en_ente = i.ic_ente),'27000000006'),
               'BASE_IMP'  =  ic_monto_base_imponible,
               'IMP_RET'   =  ic_importe_retenido_pesos,
               'FECHA_FV'  =  ic_fecha_valor,
               'ALICUOTA'  =  ic_alicuota,
               'IDE'       =  convert(int,ic_identity),
               'ENTE'      =  ic_ente,
               'SUCURSAL'  =  ic_sucursal,
               'CUENTA'    =  ic_cuenta,
               'REGIMEN'   =
                  case
                     when ic_regimen is null then (select ig_regimen
                                                   from  cob_bcradgi..bc_impuesto_regimen
                                                   where ig_impuesto            = 'PERIBSLUIS'
                                                   and   i.ic_fecha_valor between ig_vigencia and isnull (ig_fin_vigencia, i.ic_fecha_valor)
                                                   and   ig_modulo              = i.ic_modulo
                                                   and   ig_cargo_banco         = i.ic_cargo_banco
                                                   and   ig_estado             in ('V', 'C'))
                     else ic_regimen
                  end,
               RENGLON     =  identity(6)
            into #TEMPTXT2
            from cob_bcradgi..bc_impuesto_cobro i
            where ic_fecha_valor between @w_fecha_desde_segundo_dia and @w_fecha_hasta_primer_dia--FECHAS DESDE HASTA
            and ic_impuesto   = @i_impuesto--IMPUESTO
            and ic_modulo     = isnull(@i_producto,ic_modulo)
            and ic_modulo     =  3
            and ic_importe_retenido_pesos <> 0
            and ic_estado     = 'L'
            and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))

            if @@error != 0
            begin -- ERROR DURANTE INSERCION
               select
                  @w_return = 2809066, -- 'ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO'
                  @w_sev = 0
               goto error_trap
            end -- ERROR DURANTE INSERCION

            insert into #TEMPTXT2
            select
               'CED_RUC'   =  isnull(( select isnull(en_ced_ruc,'27000000006')
                                       from cobis..cl_ente
                                       where en_ente = i.ic_ente),'27000000006'),
               'BASE_IMP'  =  ic_monto_base_imponible,
               'IMP_RET'   =  ic_importe_retenido_pesos,
               'FECHA_FV'  =  ic_fecha_valor,
               'ALICUOTA'  =  ic_alicuota,
               'IDE'       =  convert(int,ic_identity),
               'ENTE'      =  ic_ente,
               'SUCURSAL'  =  ic_sucursal,
               'CUENTA'    =  ic_cuenta,
               'REGIMEN'   =
                  case
                     when ic_regimen is null then (select ig_regimen
                                                   from  cob_bcradgi..bc_impuesto_regimen
                                                   where ig_impuesto            = 'PERIBSLUIS'
                                                   and   i.ic_fecha_valor between ig_vigencia and isnull (ig_fin_vigencia, i.ic_fecha_valor)
                                                   and   ig_modulo              = i.ic_modulo
                                                   and   ig_cargo_banco         = i.ic_cargo_banco
                                                   and   ig_estado             in ('V', 'C'))
                     else ic_regimen
                  end
            from cob_bcradgi..bc_impuesto_cobro i
            where ic_fecha_valor between @w_fecha_desde and @w_fecha_hasta--FECHAS DESDE HASTA
            and ic_impuesto   = @i_impuesto--IMPUESTO
            and ic_modulo     = isnull(@i_producto,ic_modulo)
            and ic_modulo     <> 3
            and ic_importe_retenido_pesos <> 0
            and ic_estado     = 'L'
            and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))

            if @@error != 0
            begin -- ERROR DURANTE INSERCION
               select
                  @w_return = 2809066, -- 'ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO'
                  @w_sev = 0
               goto error_trap
            end -- ERROR DURANTE INSERCION

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'A',              --ss_disenio
               ENTE,             --ss_ente
               CED_RUC,          --ss_ced_ruc
               null,             --ss_modulo
               CUENTA,           --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               BASE_IMP    ,    --ss_base_calculo
               IMP_RET     ,     --ss_imp_retencion
               FECHA_FV  ,       --ss_fecha_fv
               case
                  when  datepart(mm,FECHA_FV) = datepart(mm,@w_fecha_hasta) then FECHA_FV
                  else  @w_fecha_hasta
               end   ,           --ss_fecha_fv_informa
               ALICUOTA,              --ss_alicuota
               SUCURSAL,              --ss_sucursal
               null,                  --ss_cargo_banco
               null,                  --ss_tipo_base_imponible
               REGIMEN,               --ss_regimen
               null,                  --ss_valor_minimo
               null,                  --ss_pct_exencion
               null,                  --ss_valor_fijo
               null,                  --ss_tipo_exencion
               convert(varchar(12),convert(int,IDE)), --ss_datos_adicionales
               convert(varchar(12),convert(int,RENGLON)), --ss_descripcion
               getdate()              --ss_fecha_registro
            from #TEMPTXT2

            if @@error != 0
            begin -- ERROR DURANTE INSERCION
               select
                  @w_return = 2809066, -- 'ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO'
                  @w_sev = 0
               goto error_trap
            end -- ERROR DURANTE INSERCION

            /*GENERO EL ARCHIVO DE CLIENTES*/
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
               ss_fecha_informac     ,
               ss_impuesto           ,
               'B'                   ,
               max(ss_ente)          ,
               convert(char(11),ss_ced_ruc),
               max(ss_modulo)        ,
               max(ss_numero)        ,
               max(ss_moneda)        ,
               sum(ss_importe_comprobante),
               null                       ,
               null                       ,
               max(ss_fecha_fv)           ,
               max(ss_fecha_fv_informa)   ,
               max(ss_alicuota)           ,
               max(ss_sucursal)           ,
               max(ss_cargo_banco)        ,
               max(ss_tipo_base_imponible),
               max(ss_regimen)            ,
               max(ss_valor_minimo)       ,
               max(ss_pct_exencion)       ,
               max(ss_valor_fijo)         ,
               max(ss_tipo_exencion)      ,
               max((  select
                     max(  convert(char(52), di_descripcion + ' ' +
                                             convert(varchar(6),  di_numero      ) + ' ' +
                                             convert(varchar(3),  di_depto       ) + ' ' +
                                             convert(varchar(2),  di_piso        )
                                  ) +
                           convert(char(31), ci_descripcion ) +
                           convert(char(4),  di_postal      ) +
                           convert(char(31), pv_descripcion )
                     )
                  from  cobis..cl_direccion w, cobis..cl_ciudad x ,cobis..cl_provincia y
                  where di_ente        = SS.ss_ente
                  and   di_tipo        = @w_tipo_direccion_legal
                  and   ci_ciudad      =  di_ciudad
                  and   pv_provincia   =  di_provincia
                  and   pv_estado      =  'V'
                  and   ci_estado      =  'V'
               )) ,
               max((  select convert(char(52), en_nomlar)
                  from  cobis..cl_ente
                  where en_ente  =  SS.ss_ente
               )),
               getdate()
            from bc_sellos_salida SS
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        =  'A'
            group by
               ss_fecha_informac     ,
               ss_impuesto           ,
               convert(char(11),ss_ced_ruc)
            order by
               ss_fecha_informac     ,
               ss_impuesto           ,
               convert(char(11),ss_ced_ruc)   

            if @@error != 0
            begin -- ERROR DURANTE INSERCION
               select
                  @w_return = 2809066, -- 'ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO'
                  @w_sev = 0
               goto error_trap
            end -- ERROR DURANTE INSERCION

         end   -- ES PERCEPCION DE SAN LUIS
         else
         
         if @i_impuesto = 'SELLBAIRES'
         begin -- ES SELLADOS DE BUENOS AIRES

               select @w_tabla_moneda_bcra = tb_cod_tabla
               from bc_tablas_bcra
               where tb_tabla = 'bc_moneda_arba'

               select
               'CED_RUC'   =  isnull(( select isnull(en_ced_ruc,'27000000006')
                                       from cobis..cl_ente
                                       where en_ente = i.ic_ente),'27000000006'),
               'MONEDA'      = (select isnull(cr_cod_modulo, '')
                                from bc_catlg_rel
                                where cr_cod_tabla = @w_tabla_moneda_bcra
                                and cr_cod_bcra = convert(char(10), i.ic_moneda)),
               'BASE_IMP'  =  sum(  ic_monto_base_imponible )  ,
               'IMP_RET'   =  sum(  ic_importe_retenido_pesos  )  ,
               'FECHA_FV'  =  ic_fecha_valor ,
               'ALICUOTA'  =  ic_alicuota_nominal      ,
               'ENTE'      =  ic_ente        ,
               'EXEN'      =
                              case
                                    when        convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          and   convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,74,6))

                                    when        convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          and   convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,89,6))

                                    when        convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,104,6))

                                    when        convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          then  convert(float,substring(ic_datos_adicionales,120,6))
                                    else 0.00
                                 end         
                                 
               into #TEMPTXT4
               from cob_bcradgi..bc_impuesto_cobro i
               where ic_fecha_valor between @w_fecha_desde and @w_fecha_hasta--FECHAS DESDE HASTA
               and ic_impuesto   = @i_impuesto--IMPUESTO
               and ic_modulo     = isnull(@i_producto,ic_modulo)
               and
                  (
                     (ic_importe_retenido_pesos <> 0)
                     or
                     (ic_importe_retenido_pesos = 0.0 and isnull(ic_grupo_trx,'') = 'EXEN')
                  )
               and ic_estado     = 'L'
               group by ic_ente, ic_fecha_valor, ic_alicuota_nominal, case
                                    when        convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          and   convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,74,6))

                                    when        convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          and   convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,89,6))

                                    when        convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,104,6))

                                    when        convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          then  convert(float,substring(ic_datos_adicionales,120,6))
                                    else 0.00
                                 end
               order by ic_ente  ,  ic_fecha_valor ,  ic_alicuota_nominal  , case
                                    when        convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          and   convert(float,substring(ic_datos_adicionales,74,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,74,6))

                                    when        convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          and   convert(float,substring(ic_datos_adicionales,89,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,89,6))

                                    when        convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,104,6)) > convert(float,substring(ic_datos_adicionales,120,6))
                                          then  convert(float,substring(ic_datos_adicionales,104,6))

                                    when        convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,74,6))
                                          and   convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,89,6))
                                          and   convert(float,substring(ic_datos_adicionales,120,6)) > convert(float,substring(ic_datos_adicionales,104,6))
                                          then  convert(float,substring(ic_datos_adicionales,120,6))
                                    else 0.00
                                 end                                 

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'A',              --ss_disenio
               max(ENTE),        --ss_ente
               CED_RUC,          --ss_ced_ruc
               null,             --ss_modulo
               null,             --ss_numero
               MONEDA,           --ss_moneda
               null,             --ss_importe_comprobante
               sum(BASE_IMP),    --ss_base_calculo
               sum(IMP_RET),     --ss_imp_retencion
               FECHA_FV  ,       --ss_fecha_fv
               FECHA_FV  ,       --ss_fecha_fv_informa
               ALICUOTA,              --ss_alicuota
               null,                  --ss_sucursal
               null,                  --ss_cargo_banco
               null,                  --ss_tipo_base_imponible
               null,                  --ss_regimen
               null,                  --ss_valor_minimo
               (EXEN/100.0),          --ss_pct_exencion
               null,                  --ss_valor_fijo
               null,                  --ss_tipo_exencion
               null,                  --ss_datos_adicionales
               null,                  --ss_descripcion
               getdate()              --ss_fecha_registro
            from #TEMPTXT4
            group by CED_RUC, MONEDA, FECHA_FV, ALICUOTA, (EXEN/100.0)
            order by CED_RUC, MONEDA, FECHA_FV, ALICUOTA, (EXEN/100.0)

         end   -- ES SELLADOS DE BUENOS AIRES

         if @i_impuesto = 'SELLSLUIS'
         begin -- ES SELLADOS DE SAN LUIS

            select
               'ENCABEZADO'= 'O1'   ,
               'ENTE'      =  ic_ente  ,
               'REGIMEN'   =  ic_regimen  ,
               'FECHA_FV'  =  ic_fecha_valor ,
               'SUCURSAL'  =  substring(ic_datos_adicionales,26,40),
               'BASE_IMP'  =  ic_monto_base_imponible ,
               'IMP_RET'   =  ic_importe_retenido_pesos ,
               'EXEN'      =  case
                                 when     (convert(float,substring(ic_datos_adicionales,90,6)) > 0
                                       or convert(float,substring(ic_datos_adicionales,105,6)) > 0
                                       or convert(float,substring(ic_datos_adicionales,121,6))> 0
                                       or convert(float,substring(ic_datos_adicionales,75,6))> 0 ) then 'S'
                                 else  'N'
                              end,
               'PORC_EXEN' =
                          case
                                 when        convert(float,substring(ic_datos_adicionales,75,6)) > convert(float,substring(ic_datos_adicionales,90,6) )
                                       and   convert(float,substring(ic_datos_adicionales,75,6)) > convert(float,substring(ic_datos_adicionales,105,6) )
                                       and   convert(float,substring(ic_datos_adicionales,75,6)) > convert(float,substring(ic_datos_adicionales,121,6))
                                       then  convert(float,substring(ic_datos_adicionales,75,6))

                                 when        convert(float,substring(ic_datos_adicionales,90,6)) > convert(float,substring(ic_datos_adicionales,75,6))
                                       and   convert(float,substring(ic_datos_adicionales,90,6)) > convert(float,substring(ic_datos_adicionales,105,6))
                                       and   convert(float,substring(ic_datos_adicionales,90,6)) > convert(float,substring(ic_datos_adicionales,121,6))
                                       then  convert(float,substring(ic_datos_adicionales,90,6))

                                 when        convert(float,substring(ic_datos_adicionales,105,6)) > convert(float,substring(ic_datos_adicionales,75,6))
                                       and   convert(float,substring(ic_datos_adicionales,105,6)) > convert(float,substring(ic_datos_adicionales,90,6))
                                       and   convert(float,substring(ic_datos_adicionales,105,6)) > convert(float,substring(ic_datos_adicionales,121,6))
                                       then  convert(float,substring(ic_datos_adicionales,105,6))

                                 when        convert(float,substring(ic_datos_adicionales,121,6)) > convert(float,substring(ic_datos_adicionales,75,6))
                                       and   convert(float,substring(ic_datos_adicionales,121,6)) > convert(float,substring(ic_datos_adicionales,90,6))
                                       and   convert(float,substring(ic_datos_adicionales,121,6)) > convert(float,substring(ic_datos_adicionales,105,6))
                                       then  convert(float,substring(ic_datos_adicionales,121,6))
                                 else 0.00
                              end   ,
               'VMIN'      =  convert(float,substring(ic_datos_adicionales,7,10))
            into #TEMPTXT5
            from cob_bcradgi..bc_impuesto_cobro i
            where ic_fecha_valor between @w_fecha_desde and @w_fecha_hasta--FECHAS DESDE HASTA
            and ic_impuesto   = @i_impuesto--IMPUESTO
            and ic_modulo     = isnull(@i_producto,ic_modulo)
            and ic_tipo_base_imponible <> 16
            and
               (
                  (ic_importe_retenido_pesos <> 0)
                  or
                  (ic_importe_retenido_pesos = 0.0 and isnull(ic_grupo_trx,'') = 'EXEN')
               )
            and ic_estado     = 'L'

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'A' + ENCABEZADO, --ss_disenio
               ENTE,             --ss_ente
               null,             --ss_ced_ruc
               null,             --ss_modulo
               null,             --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               BASE_IMP,         --ss_base_calculo
               IMP_RET,             --ss_imp_retencion
               FECHA_FV  ,       --ss_fecha_fv
               FECHA_FV  ,       --ss_fecha_fv_informa
               null,             --ss_alicuota
               null,                  --ss_sucursal
               null,                  --ss_cargo_banco
               null,                  --ss_tipo_base_imponible
               REGIMEN,               --ss_regimen
               VMIN,                  --ss_valor_minimo
               PORC_EXEN,             --ss_pct_exencion
               null,                  --ss_valor_fijo
               EXEN,                  --ss_tipo_exencion
               null,                  --ss_datos_adicionales
               SUCURSAL,              --ss_descripcion
               getdate()              --ss_fecha_registro
            from #TEMPTXT5

            update bc_sellos_salida set ss_datos_adicionales   =  convert(varchar(11),convert(int,ss_identity) ) + 'A'
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        =  'AO1'

            select   @w_cod_tabla   =  tb_cod_tabla
            from bc_tablas_bcra
            where tb_tabla = 'bc_iddoc_sellsluis'

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'AO2'          , --ss_disenio
               ss_ente,          --ss_ente
               ss_ced_ruc,       --ss_ced_ruc
               null,             --ss_modulo
               null,             --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               null,             --ss_base_calculo
               null,             --ss_imp_retencion
               ss_fecha_fv,      --ss_fecha_fv
               ss_fecha_fv_informa,--ss_fecha_fv_informa
               ss_alicuota,      --ss_alicuota
               null,             --ss_sucursal
               null,             --ss_cargo_banco
               null,             --ss_tipo_base_imponible
               null,             --ss_regimen
               null,             --ss_valor_minimo
               ss_pct_exencion,  --ss_pct_exencion
               null,             --ss_valor_fijo
               null,             --ss_tipo_exencion
               convert(varchar(11),convert(int,ss_identity)) + 'B' ,   --ss_datos_adicionales
               case
                  when EN.en_ttributa is not null then 'C' + convert(varchar(15),EN.en_ced_ruc)
                  else(select (  select max(cr_cod_bcra)
                                 from bc_catlg_rel
                                 where cr_cod_tabla   =  @w_cod_tabla
                                 and   cr_cod_modulo  =  ID.id_tipo
                                 and   cr_estado      =  'V') + convert(varchar(15),ID.id_numero)
                       from   cobis..cl_identificacion ID
                       where  SS.ss_ente     =  ID.id_ente
                       and    ID.id_vigencia =  'S'
                       and    ID.id_secuencial = 1
                        )
               end  , -- ss_descripcion
               getdate()              --ss_fecha_registro
            from bc_sellos_salida SS , cobis..cl_ente EN
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        =  'AO1'
            and   ss_ente           *=  en_ente

            /*OPERACIONES FINANCIERAS DISEÑO B*/
            select
               'ENCABEZADO'= 'O1'   ,
               'ENTE'      =  ic_ente  ,
               'REGIMEN'   =  ic_regimen  ,
               'FECHA_FV'  =  ic_fecha_valor ,
               'SUCURSAL'  =  substring(ic_datos_adicionales,26,40),
               'BASE_IMP'  =  ic_monto_base_imponible ,
               'EXEN'      =  case
                                 when     (convert(float,substring(ic_datos_adicionales,90,6)) > 0
                                       or convert(float,substring(ic_datos_adicionales,105,6)) > 0
                                       or convert(float,substring(ic_datos_adicionales,121,6))> 0
                                       or convert(float,substring(ic_datos_adicionales,75,6))> 0 ) then 'S'
                                 else  'N'
                              end,
               'PORC_EXEN' =
                          case
                                 when        convert(float,substring(ic_datos_adicionales,75,6)) > convert(float,substring(ic_datos_adicionales,90,6) )
                                       and   convert(float,substring(ic_datos_adicionales,75,6)) > convert(float,substring(ic_datos_adicionales,105,6) )
                                       and   convert(float,substring(ic_datos_adicionales,75,6)) > convert(float,substring(ic_datos_adicionales,121,6))
                                       then  convert(float,substring(ic_datos_adicionales,75,6))

                                 when        convert(float,substring(ic_datos_adicionales,90,6)) > convert(float,substring(ic_datos_adicionales,75,6))
                                       and   convert(float,substring(ic_datos_adicionales,90,6)) > convert(float,substring(ic_datos_adicionales,105,6))
                                       and   convert(float,substring(ic_datos_adicionales,90,6)) > convert(float,substring(ic_datos_adicionales,121,6))
                                       then  convert(float,substring(ic_datos_adicionales,90,6))

                                 when        convert(float,substring(ic_datos_adicionales,105,6)) > convert(float,substring(ic_datos_adicionales,75,6))
                                       and   convert(float,substring(ic_datos_adicionales,105,6)) > convert(float,substring(ic_datos_adicionales,90,6))
                                       and   convert(float,substring(ic_datos_adicionales,105,6)) > convert(float,substring(ic_datos_adicionales,121,6))
                                       then  convert(float,substring(ic_datos_adicionales,105,6))

                                 when        convert(float,substring(ic_datos_adicionales,121,6)) > convert(float,substring(ic_datos_adicionales,75,6))
                                       and   convert(float,substring(ic_datos_adicionales,121,6)) > convert(float,substring(ic_datos_adicionales,90,6))
                                       and   convert(float,substring(ic_datos_adicionales,121,6)) > convert(float,substring(ic_datos_adicionales,105,6))
                                       then  convert(float,substring(ic_datos_adicionales,121,6))
                                 else 0.00
                              end   ,
               'VMIN'      =  convert(float,substring(ic_datos_adicionales,7,10)),
               'IMPRET'    =  ic_importe_retenido_pesos
            into #TEMPTXT6
            from cob_bcradgi..bc_impuesto_cobro i
            where ic_fecha_valor between @w_fecha_desde and @w_fecha_hasta--FECHAS DESDE HASTA
            and ic_impuesto   = @i_impuesto--IMPUESTO
            and ic_modulo     = isnull(@i_producto,ic_modulo)
            and ic_tipo_base_imponible = 16
            and
               (
                  (ic_importe_retenido_pesos <> 0)
                  or
                  (ic_importe_retenido_pesos = 0.0 and isnull(ic_grupo_trx,'') = 'EXEN')
               )
            and ic_estado     = 'L'

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'B' + ENCABEZADO, --ss_disenio
               ENTE,             --ss_ente
               null,             --ss_ced_ruc
               null,             --ss_modulo
               null,             --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               BASE_IMP,         --ss_base_calculo
               IMPRET,           --ss_imp_retencion
               FECHA_FV  ,       --ss_fecha_fv
               FECHA_FV  ,       --ss_fecha_fv_informa
               null,             --ss_alicuota
               null,                  --ss_sucursal
               null,                  --ss_cargo_banco
               null,                  --ss_tipo_base_imponible
               REGIMEN,               --ss_regimen
               VMIN,                  --ss_valor_minimo
               PORC_EXEN,             --ss_pct_exencion
               null,                  --ss_valor_fijo
               EXEN,                  --ss_tipo_exencion
               null,                  --ss_datos_adicionales
               SUCURSAL,              --ss_descripcion
               getdate()              --ss_fecha_registro
            from #TEMPTXT6

            update bc_sellos_salida set ss_datos_adicionales   =  convert(varchar(11),convert(int,ss_identity) ) + 'A'
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        =  'BO1'

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'BO2'          , --ss_disenio
               ss_ente,          --ss_ente
               ss_ced_ruc,       --ss_ced_ruc
               null,             --ss_modulo
               null,             --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               null,             --ss_base_calculo
               null,             --ss_imp_retencion
               ss_fecha_fv,      --ss_fecha_fv
               ss_fecha_fv_informa,--ss_fecha_fv_informa
               ss_alicuota,      --ss_alicuota
               null,             --ss_sucursal
               null,             --ss_cargo_banco
               null,             --ss_tipo_base_imponible
               null,             --ss_regimen
               null,             --ss_valor_minimo
               ss_pct_exencion,  --ss_pct_exencion
               null,             --ss_valor_fijo
               null,             --ss_tipo_exencion
               convert(varchar(11),convert(int,ss_identity)) + 'B' ,   --ss_datos_adicionales
               case
                  when EN.en_ttributa is not null then 'C' + convert(varchar(15),EN.en_ced_ruc)
                  else(select (  select max(cr_cod_bcra)
                                 from bc_catlg_rel
                                 where cr_cod_tabla   =  @w_cod_tabla
                                 and   cr_cod_modulo  =  ID.id_tipo
                                 and   cr_estado      =  'V') + convert(varchar(15),ID.id_numero)
                       from   cobis..cl_identificacion ID
                       where  SS.ss_ente     =  ID.id_ente
                       and    ID.id_vigencia =  'S'
                       and    ID.id_secuencial = 1
                        )
               end  , -- ss_descripcion
               getdate()              --ss_fecha_registro
            from bc_sellos_salida SS , cobis..cl_ente EN
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        =  'BO1'
            and   ss_ente           *=  en_ente


            /*BUSCO EL NEMONICO PARA LA DIRECCION LEGAL*/
            select   @w_tipo_direccion_legal = null

            select   @w_tipo_direccion_legal = pa_char
            from     cobis..cl_parametro
            where    pa_producto = 'MIS'
            and      pa_nemonico = 'TDLE'

            select @w_tipo_direccion_legal = isnull(@w_tipo_direccion_legal, 'LE')



            /*OPERACIONES FINANCIERAS DISEÑO C*/
            select
               'ENTE'      =  ic_ente  ,
               'NOM'       =  (convert(char(60),EN.en_nomlar)),
               'DOC'       =  case
                                 when EN.en_ttributa is not null then 'C'
                                 else  (
                                          select cr_cod_bcra
                                          from bc_catlg_rel
                                          where cr_cod_tabla   =  @w_cod_tabla
                                          and   cr_cod_modulo  =  ID.id_tipo
                                          and   cr_estado = 'V'
                                       )
                              end +
                              convert(varchar(15)  ,  case
                                                         when EN.en_ttributa is not null then en_ced_ruc
                                                         else  ID.id_numero
                                                      end) ,
               'DIR' =  isnull((  select
                                 max(  convert(char(60), di_descripcion + ' ' +
                                                         convert(varchar(6),  di_numero      ) + ' ' +
                                                         convert(varchar(3),  di_depto       ) + ' ' +
                                                         convert(varchar(2),  di_piso        )
                                              ) +
                                       convert(char(30), ci_descripcion ) +
                                       convert(char(30), pv_descripcion ) +
                                       convert(char(4),  di_postal      )
                                 )
                              from  cobis..cl_direccion w, cobis..cl_ciudad x ,cobis..cl_provincia y
                              where di_ente        = IC.ic_ente
                              and   di_tipo        = @w_tipo_direccion_legal
                              and   ci_ciudad      =  di_ciudad
                              and   pv_provincia   =  di_provincia
                              and   pv_estado      =  'V'
                              and   ci_estado      =  'V'
                           ),
                           (
                           select
                                 max(  convert(char(60), di_descripcion + ' ' +
                                                         convert(varchar(6),  di_numero      ) + ' ' +
                                                         convert(varchar(3),  di_depto       ) + ' ' +
                                                         convert(varchar(2),  di_piso        )
                                              ) +
                                       convert(char(30), ci_descripcion ) +
                                       convert(char(30), pv_descripcion ) +
                                       convert(char(4),  di_postal      )
                                 )
                              from  cobis..cl_direccion w, cobis..cl_ciudad x ,cobis..cl_provincia y
                              where di_ente        = IC.ic_ente
                              and   ci_ciudad      =  di_ciudad
                              and   pv_provincia   =  di_provincia
                              and   pv_estado      =  'V'
                              and   ci_estado      =  'V')) ,
               'FECHA_FV'  =  ic_fecha_valor
            into #TEMPTXT7
            from cob_bcradgi..bc_impuesto_cobro IC , cobis..cl_ente EN, cobis..cl_identificacion ID
            where ic_fecha_valor between @w_fecha_desde and @w_fecha_hasta--FECHAS DESDE HASTA
            and ic_impuesto   =  @i_impuesto--IMPUESTO
            and ic_modulo     =  isnull(@i_producto,ic_modulo)
            and
               (
                  (ic_importe_retenido_pesos <> 0)
                  or
                  (ic_importe_retenido_pesos = 0.0 and isnull(ic_grupo_trx,'') = 'EXEN')
               )
            and   ic_estado   =  'L'
            and   ic_ente     =  en_ente
            and   ic_ente     *=  id_ente

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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'C',              --ss_disenio
               ENTE,             --ss_ente
               null,             --ss_ced_ruc
               null,             --ss_modulo
               null,             --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               null,             --ss_base_calculo
               null,             --ss_imp_retencion
               max(FECHA_FV)  ,  --ss_fecha_fv
               max(FECHA_FV)  ,  --ss_fecha_fv_informa
               null,             --ss_alicuota
               null,                  --ss_sucursal
               null,                  --ss_cargo_banco
               null,                  --ss_tipo_base_imponible
               null,                  --ss_regimen
               null,                  --ss_valor_minimo
               null,                  --ss_pct_exencion
               null,                  --ss_valor_fijo
               null,                  --ss_tipo_exencion
               max(convert(char(60),NOM) + convert(char(12),DOC)),                  --ss_datos_adicionales
               max(DIR),              --ss_descripcion
               getdate()             --ss_fecha_registro
            from #TEMPTXT7
            group by ENTE
            order by ENTE

         end   -- ES SELLADOS DE SAN LUIS

         if @i_impuesto = 'SELLCTES'
         begin -- ES SELLADOS DE CORRIENTES


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
               @w_fecha_hasta ,  --ss_fecha_informac
               @i_impuesto    ,  --ss_impuesto
               'A',              --ss_disenio
               ic_ente,          --ss_ente
               en_ced_ruc,       --ss_ced_ruc
               null,             --ss_modulo
               null,             --ss_numero
               null,             --ss_moneda
               null,             --ss_importe_comprobante
               ic_monto_base_imponible,  --ss_base_calculo
               ic_importe_retenido_pesos,--ss_imp_retencion
               ic_fecha_valor,         --ss_fecha_fv
               ic_fecha_valor,         --ss_fecha_fv_informa
               ic_alicuota_nominal,   --ss_alicuota
               ic_sucursal,           --ss_sucursal
               null,                  --ss_cargo_banco
               ic_tipo_base_imponible,--ss_tipo_base_imponible
               ic_regimen,            --ss_regimen
               null,                  --ss_valor_minimo
               null,                  --ss_pct_exencion
               null,                  --ss_valor_fijo
               null,                  --ss_tipo_exencion
               convert(char(10),replicate('0',10 - datalength(ltrim(str(ic_secuencial,10,0)))) + ltrim(str(ic_secuencial,10,0))),   --ss_datos_adicionales
               isnull(en_nomlar,en_nombre),--ss_descripcion
               getdate()             --ss_fecha_registro
            from  cob_bcradgi..bc_impuesto_cobro,  cobis..cl_ente
            where ic_impuesto    =  @i_impuesto --IMPUESTO
            and   ic_fecha_valor between @w_fecha_desde  and   @w_fecha_hasta
            and   ic_modulo      = isnull(@i_producto,ic_modulo)
            and   ic_ente        *= en_ente
            and   ic_estado      = 'L'
            and   ic_importe_retenido_pesos <> 0.00
            and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N'))
            order by ic_secuencial

         end   -- ES SELLADOS DE CORRIENTES

         return 0

      end   -- @i_opcion = 56  -- PROCESO DE GENERACION DE LA TABLA DE SALIDA PARA SELLADOS
      else
      if @i_opcion = 57
      begin -- @i_opcion = 57  -- RESUMEN DE LOS PLANOS


         select   @w_fecha_desde = isnull(@i_fecha_fv_desde, @i_fecha_desde)  ,
                  @w_fecha_hasta = isnull(@i_fecha_fvhasta, @i_fecha_hasta)

         if @i_impuesto = 'PERIBBSAS'
         begin 
            select
               'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ss_imp_retencion), 0.00),
               'CANT'      =  count(1)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        like (@i_disenio + '%' )
         end
         else
         if @i_impuesto = 'SELLAPAMPA'
         begin 
           
            
            select
               'BASE_IMP'  =  isnull(sum(ADET.ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ADET.ss_imp_retencion), 0.00),
               'CANT'      =  count(1)
              from cob_bcradgi..bc_sellos_salida ADET  
              where ADET.ss_impuesto       = @i_impuesto 
              and   ADET.ss_fecha_informac = @w_fecha_hasta    
              and   ADET.ss_disenio        = 'ADET'            
          end
         else
         if @i_impuesto = 'SELLTUCUMA'
         begin 
            select
               'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ss_imp_retencion), 0.00),
               'CANT'      =  count(1)
            from bc_sellos_salida
            where ss_fecha_informac  =  @w_fecha_hasta
            and   ss_impuesto        =  @i_impuesto
            and   ss_disenio        like (@i_disenio + '%' )
 

         end
         else
         if @i_impuesto = 'SELLSALTA'
         begin 
            select
               'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ss_imp_retencion+ss_valor_fijo), 0.00),
               'CANT'      =  count(1)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        like (@i_disenio + '%' )         
         end         
         else
         if @i_impuesto = 'SELLMZA'
         begin 
            select
               'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ss_imp_retencion+ss_valor_fijo), 0.00),
               'CANT'      =  count(1)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        like (@i_disenio + '%' )         
         end
         else
         if @i_impuesto = 'SELLCHUBUT'
         begin 
            select
               'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ss_imp_retencion+ss_valor_fijo), 0.00),
               'CANT'      =  count(1)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        like (@i_disenio + '%' )
            and   ss_imp_retencion <> 0
         end         
         else
         if @i_impuesto = 'PERIBMISIO'
         begin 
            select
               'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ss_imp_retencion), 0.00),
               'CANT'      =  count(1)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   substring(ss_datos_adicionales,1,1) = 'P'
         end
         else
         if @i_impuesto = 'SELLJUJUY'
         begin
            /* OBTENGO LOS DATOS DE LA PRESENTACION */
               exec @w_return = cob_bcradgi..sp_selljujuy 
               @i_c_operacion   = 'Q',
               @i_c_disenio     = @i_disenio,
               @i_m_quien_llama = 'F',
               @i_f_hasta       = @w_fecha_hasta,
               @i_n_opcion      = 2

               if @w_return <> 0
               begin
                  return @w_return
               end
         end
         else
         begin 
            select
               'BASE_IMP'  =  isnull(sum(ss_base_calculo),  0.00),
               'IMP_RET'   =  isnull(sum(ss_imp_retencion), 0.00),
               'CANT'      =  count(1)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
            and   ss_disenio        like (@i_disenio + '%' )
         end
         
         return 0

      end   -- @i_opcion = 57  -- RESUMEN DE LOS PLANOS
      else
      if @i_opcion = 58
      begin -- @i_opcion = 58  -- RESUMEN DE LOS PLANOS


         select   @w_fecha_desde = isnull(@i_fecha_fv_desde, @i_fecha_desde)  ,
                  @w_fecha_hasta = isnull(@i_fecha_fvhasta, @i_fecha_hasta)

         if @i_impuesto = 'PERIBBSAS'
         begin 
            select   'ULT_FECHA_REG'   =  convert(varchar(20),max(ss_fecha_registro),103)  + ' ' + convert(char(8),max(ss_fecha_registro),108)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
         end
         else
         begin 
            select   'ULT_FECHA_REG'   =  convert(varchar(20),max(ss_fecha_registro),103)  + ' ' + convert(char(8),max(ss_fecha_registro),108)
            from bc_sellos_salida
            where ss_fecha_informac =  @w_fecha_hasta
            and   ss_impuesto       =  @i_impuesto
         end

         return 0

      end   -- @i_opcion = 58  -- RESUMEN DE LOS PLANOS
      else
      if @i_opcion = 59
      begin -- @i_opcion = 59  -- DATA POR CEDRUC DE LA SALIDA

         set rowcount @i_cant_rows

         select
            convert(varchar(10),ss_fecha_informac,@i_formato_fecha),
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
            convert(varchar(10),ss_fecha_fv           )  ,
            convert(varchar(10),ss_fecha_fv_informa   )  ,
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
            convert(int,ss_identity),
            convert(varchar(10),ss_fecha_registro,103)
         from bc_sellos_salida
         where ss_fecha_informac =  isnull(@i_fecha_informacion, ss_fecha_informac)
         and   ss_impuesto       =  @i_impuesto
         and   ss_disenio        =  isnull(@i_disenio ,  ss_disenio )
         and   ss_ente           =  isnull(@i_ente    ,  ss_ente    )
         and   ss_ced_ruc        =  isnull(@i_ced_ruc ,  ss_ced_ruc )
         and   ss_modulo         =  isnull(@i_modulo  ,  ss_modulo  )
         and   ss_numero         =  isnull(@i_numero  ,  ss_numero  )
         and   ss_moneda         =  isnull(convert(varchar(2),@i_moneda)   ,  ss_moneda  )
         and   ss_fecha_fv_informa  =  isnull(@i_fecha_fv,  ss_fecha_fv_informa  )
         and   ss_identity       =  isnull(@i_identity,  ss_identity)

         return 0

      end   -- @i_opcion = 59  -- DATA POR CEDRUC DE LA SALIDA
      else
      if @i_opcion = 60
      begin --@i_opcion = 60  --CONSULTA PARA CONSTATAR EL RANGO DE DIAS DE CONSULTA DEL IMPUESTO.
         
         exec @w_return = sp_definfor
            @i_operacion   = 'Q',
            @i_opcion      = 2,
            @i_formula     = @i_impuesto,
            @o_rango       = @w_rango out
   
         select @w_rango
   
         if @w_return != 0
         begin -- DIO ERROR EL SP
            exec cobis..sp_cerror
               @t_debug        = @t_debug,
               @t_file         = @t_file,
               @t_from         = @w_sp_name,
               @i_num          = @w_return
   
            return @w_return
         end   -- DIO ERROR EL SP
   
         return 0
      end   --@i_opcion = 60  --CONSULTA PARA CONSTATAR EL RANGO DE DIAS DE CONSULTA DEL IMPUESTO.

      if @i_opcion = 61
      begin
         select @o_m_impuesto_parametrizado = 'N'
         select @o_m_impuesto_parametrizado = 'S'
         from  cob_bcradgi..bc_p_impuestos
         where im_impuesto = @i_impuesto

         return 0
      end

      if @i_opcion = 62
      begin

         select  
         'CUIT_BM'               =  (select pa_char from cobis..cl_parametro where pa_nemonico = 'CUITBM' and  pa_producto = 'BCR'), 
         'REGIMEN'               = '8602',
         'ANIO'                  = datepart(yy,ss_fecha_informac),
         'PERIODO'               = case when datepart(dd,ss_fecha_informac ) < 16 then 
                                        case when datepart(mm,ss_fecha_informac ) = 1 then 1
                                             else (datepart(mm,ss_fecha_informac) * 2) - 1  
                                        end 
                                   else
                                        case when datepart(mm,ss_fecha_informac ) = 1 then 2
                                             else datepart(mm,ss_fecha_informac) * 2 
                                        end 
                                   end, 
         'CANTIDAD_FILAS'        = count(1),
         'TOTAL_BASE_IMPONIBLE'  = str_replace(str_replace(convert(varchar(40), sum(ss_base_calculo)), ',', null), '.', ',') ,
         'TOTAL_IMPORTE_RET_PER' = str_replace(str_replace(convert(varchar(40), sum(ss_imp_retencion)), ',', null), '.', ',') 
         into #tmp_total 
         from  bc_sellos_salida
         where ss_fecha_informac = @i_fecha_fv
         and   ss_disenio        = 'A'
         and   ss_impuesto       = @i_impuesto
         and   ss_descripcion    = 'ESTADO: P'
         group by datepart(yy,ss_fecha_informac), 
         case when datepart(dd,ss_fecha_informac ) < 16 then 
             case when datepart(mm,ss_fecha_informac ) = 1 then 1
                  else (datepart(mm,ss_fecha_informac) * 2) - 1  
             end 
         else
             case when datepart(mm,ss_fecha_informac ) = 1 then 2
                  else datepart(mm,ss_fecha_informac) * 2 
             end 
         end

         select @w_return = @@error
         
         if @w_return != 0
         begin -- DIO ERROR EL SP
            exec cobis..sp_cerror
               @t_debug        = @t_debug,
               @t_file         = @t_file,
               @t_from         = @w_sp_name,
               @i_num          = @w_return
   
            return @w_return
         end   -- DIO ERROR EL SP

         select 
         CUIT_BM + ';' + convert(varchar(20),REGIMEN) + ';' + convert(varchar(20),ANIO) + ';' + convert(varchar(20),PERIODO) + ';' + convert(varchar(20),CANTIDAD_FILAS) + ';' + convert(varchar(30),TOTAL_BASE_IMPONIBLE) + ';' + convert(varchar(30),TOTAL_IMPORTE_RET_PER)
         from #tmp_total 

         return 0
      end

   end  -- ES UNA CONSULTA

end  -- @i_quien_llama = 'F' -- LLAMA EL FRONT-END

if @i_quien_llama = 'B' -- @i_quien_llama = 'B' -- LLAMA EL BACK-END
begin

   /* BORRO LOS REGISTROS EXISTENTES EN LA ERRORES BATCH*/
   delete from cob_bcradgi..bc_errores_batch
   where    eb_sp = @w_sp_name

   select @w_fecha_desde = @i_fecha_desde

   execute @w_return = cobis..sp_dias_feriados
      @i_opcion         = 1 ,
      @i_fecha_ini      = @w_fecha_desde,
      @i_dias_habiles   = 2 ,
      @o_fecha_nueva    = @w_fecha_desde_segundo_dia  out

   if @w_return != 0
   begin -- DEVOLVIO ERROR
      goto error_trap
   end   -- DEVOLVIO ERROR

   select @w_fecha_hasta = @i_fecha_hasta

   execute @w_return = cobis..sp_dias_feriados
      @i_opcion         = 1 ,
      @i_fecha_ini      = @w_fecha_hasta,
      @i_dias_habiles   = 1 ,
      @o_fecha_nueva    = @w_fecha_hasta_primer_dia  out

   if @w_return != 0
   begin -- DEVOLVIO ERROR
      goto error_trap
   end   -- DEVOLVIO ERROR

   delete from bc_sellos_salida
   where ss_fecha_informac = @i_fecha_informacion 
   and   ss_impuesto       = @i_impuesto
   
   if @@error != 0
   begin -- ERROR DURANTE ELIMINACION
      select
         @w_return = 2900131, -- 'ERROR AL ELIMINAR REGISTROS DE LA TABLA'
         @w_sev = 0
      goto error_trap
   end -- ERROR DURANTE ELIMINACION
   
   select @w_numeroerror = @@error
   
   if (@w_numeroerror <> 0)
   begin -- ERROR AL BORRAR LOS DATOS
      exec sp_errores_batch
         @i_sp          = @w_sp_name,
         @i_campo       = '',
         @i_dato        = '',
         @i_observacion = 'ERROR AL LIMPIAR bc_error_batch. SE ABORTA EL PROCESO.'
         
      goto error_trap
   end -- ERROR AL BORRAR LOS DATOS
   
   /*ANALIZO EL ESTADO DE LA FORMULA*/
   select @w_estado_form = ff_estado_form
   from bc_fec_formulas
   where ff_nro_formulario = @i_impuesto
   and ff_fecha_informac = @w_fecha_hasta

   if @w_retorno != 0
   begin
      exec   cob_bcradgi..sp_errores_batch
             @i_sp                   = @w_sp_name,
             @i_campo                = 'bc_fec_formulas',
             @i_dato                 = 'ff_estado_form',
             @i_observacion          = 'ERROR AL CARGAR EL ESTADO DE LA FORMULA'
      goto error_trap
   end
   
   /* REALIZA CONTROL DE ESTADO DE FORMULA PARA LAS FECHAS INGRESADAS SEGUN OPCION */
   select @w_fecha_desde = convert(datetime,CONVERT(VARCHAR(3),@w_fecha_hasta ,101) + '01' + SUBSTRING(CONVERT(VARCHAR(10),@w_fecha_hasta ,101),6,5))

   if @w_estado_form <> 'FT'
   begin
      select @w_mensaje = 'ESTADO DE FORMULA DISTINDO DE FT'
      
      exec   cob_bcradgi..sp_errores_batch
             @i_sp                   = @w_sp_name,
             @i_campo                = '@w_fecha_desde',
             @i_dato                 = 'ERROR EN ESTADO DE FORMULA',
             @i_observacion          = @w_mensaje

      goto error_trap
   end

   if @i_impuesto = 'PERIBMISIO'
   begin -- ES PERCEPCION DE MISIONES
      select
         'CED_RUC'   =  isnull(( select isnull(en_ced_ruc,'27000000006')
                                 from cobis..cl_ente
                                 where en_ente = i.ic_ente),'27000000006'),
         'BASE_IMP'  =  ic_monto_base_imponible,
         'IMP_RET'   =  ic_importe_retenido_pesos,
         'FECHA_FV'  =  ic_fecha_valor,
         'ALICUOTA'  =  ic_alicuota,
         'IDE'       =  convert(int,ic_identity),
         'ENTE'      =  ic_ente,
         'SUCURSAL'  =  ic_sucursal,
         'CUENTA'    =  ic_cuenta,
         'REGIMEN'   =
            case
               when ic_regimen is null then (select ig_regimen
                                             from  cob_bcradgi..bc_impuesto_regimen
                                             where ig_impuesto            = @i_impuesto
                                             and   i.ic_fecha_valor between ig_vigencia and isnull (ig_fin_vigencia, i.ic_fecha_valor)
                                             and   ig_modulo              = i.ic_modulo
                                             and   ig_cargo_banco         = i.ic_cargo_banco
                                             and   ig_estado             in ('V', 'C'))
               else ic_regimen
            end,
         RENGLON   =  identity(6)
      into #TEMPTXT2_MISIO
      from cob_bcradgi..bc_impuesto_cobro i
      where ic_fecha_valor between @w_fecha_desde and @w_fecha_hasta--FECHAS DESDE HASTA
      and ic_impuesto   = @i_impuesto--IMPUESTO
      and ic_modulo     = isnull(@i_producto,ic_modulo)
      and ic_importe_retenido_pesos <> 0
      and ic_estado     = 'L'
      and isnull(ic_cargo_banco,'N')   =  isnull(@i_cargo_banco,isnull(ic_cargo_banco,'N')) 

      if @@error != 0
      begin -- ERROR DURANTE INSERCION
         select
         @w_mensaje = 'ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO'
         
         exec   cob_bcradgi..sp_errores_batch
            @i_sp                   = @w_sp_name,
            @i_campo                = '',
            @i_dato                 = '',
            @i_observacion          = @w_mensaje

         goto error_trap
      end -- ERROR DURANTE INSERCION

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
         @i_fecha_informacion ,  --ss_fecha_informac
         @i_impuesto    ,  --ss_impuesto
         'A',              --ss_disenio
         ENTE,             --ss_ente
         CED_RUC,          --ss_ced_ruc
         null,             --ss_modulo
         CUENTA,           --ss_numero
         null,             --ss_moneda
         null,             --ss_importe_comprobante
         BASE_IMP    ,    --ss_base_calculo
         IMP_RET     ,     --ss_imp_retencion
         FECHA_FV  ,       --ss_fecha_fv
         case
            when  datepart(mm,FECHA_FV) = datepart(mm,@w_fecha_hasta) then FECHA_FV
            else  @w_fecha_hasta
         end   ,           --ss_fecha_fv_informa
         ALICUOTA,              --ss_alicuota
         SUCURSAL,              --ss_sucursal
         null,                  --ss_cargo_banco
         null,                  --ss_tipo_base_imponible
         REGIMEN,               --ss_regimen
         null,                  --ss_valor_minimo
         null,                  --ss_pct_exencion
         null,                  --ss_valor_fijo
         null,                  --ss_tipo_exencion
         case CED_RUC when '27000000006' then 'E' + convert(varchar(12),convert(int,IDE))
                      else 'P' + convert(varchar(12),convert(int,IDE))
         end, --ss_datos_adicionales
         convert(varchar(12),convert(int,RENGLON)), --ss_descripcion
         getdate()              --ss_fecha_registro
      from #TEMPTXT2_MISIO

      if @@error != 0
      begin -- ERROR DURANTE INSERCION
         select
         @w_mensaje = 'ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO'
         
         exec   cob_bcradgi..sp_errores_batch
            @i_sp                   = @w_sp_name,
            @i_campo                = '',
            @i_dato                 = '',
            @i_observacion          = @w_mensaje

         goto error_trap
         
      end -- ERROR DURANTE INSERCION
      
      /*ACTUALIZO LA FORMULA A FC*/
      update bc_fec_formulas set
      ff_estado_form = 'FC'
      where ff_nro_formulario = @i_impuesto
      and ff_fecha_informac = @w_fecha_hasta
      
      if @@error != 0
      begin -- ERROR DURANTE ACTUALIZACION
         select
         @w_mensaje = 'ERROR ACTUALIZANDO DATOS EN bc_fec_formula'
         
         exec   cob_bcradgi..sp_errores_batch
            @i_sp                   = @w_sp_name,
            @i_campo                = '',
            @i_dato                 = '',
            @i_observacion          = @w_mensaje

         goto error_trap
         
      end -- ERROR DURANTE ACTUALIZACION
      
   end   -- ES PERCEPCION DE MISIONES
end -- @i_quien_llama = 'B' -- LLAMA EL BACK-END

/*NO ENTRO EN NINGUNA OPERACION O LA TRANSACCION ES INCORRECTA*/
select @w_numeroerror = 2900067
/*ACA NUNCA DEBERIA LLEGAR*/

/*-- AST_64957 --*/
set compatibility_mode on

return 0

error_trap:

   if @w_numeroerror <> 0
      select @w_return = @w_numeroerror

   select   @w_msg         = isnull(@w_msg, mensaje),
            @w_sev         = isnull(@w_sev, severidad)
   from  cobis..cl_errores
   where numero = @w_return

   select @w_msg = isnull(@w_msg,'NO EXISTE MENSAJE ASOCIADO')

   select @w_msg = '[' + @w_sp_name + ']   ' + upper(@w_msg)

   /*EN EL UNICO CASO QUE HAGO ROLLBACK ES CUANDO YO INICIE LA TRANSACCION*/

   begin -- ME VOY SIN HACER NADA
      if @i_quien_llama = 'F'
      begin -- EL SP FUE LLAMADO DESDE EL FRONT-END ===> NECESITO QUE SAQUE EL MENSAJE POR PANTALLA
         exec cobis..sp_cerror
         @t_from = @w_sp_name,
         @i_num  = @w_return,
         @i_sev  = 0,
         @i_msg  = @w_msg
      end -- EL SP FUE LLAMADO DESDE EL FRONT-END ===> NECESITO QUE SAQUE EL MENSAJE POR PANTALLA
   end -- ME VOY SIN HACER NADA

   /*SEA LO QUE SEA EL RETURN DEBE VOLVER CON EL NUMERO DE ERROR*/
   return @w_return

/*<returns>
<return value = "0" description="EJECUCION EXITOSA" />
<error value = "@w_return" description="VARIABLE GENERICA/DEVOLUCION SP" />
<error value = "@w_numeroerror" description="VARIABLE GENERICA/DEVOLUCION SP" />
<error value = "2900067" description="LA OPERACION ES INVALIDA O NO EXISTE CON LOS PARAMETROS INGRESADOS" />
<error value = "2900131" description="ERROR AL ELIMINAR REGISTROS DE LA TABLA" />
<error value = "2809066" description="ERROR INSERTANDO DATOS PARA LA GENERACION DE LISTADO" />

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
