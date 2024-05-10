drop table #detalle2

select distinct
        --secuencial=identity(5),
        fecha_pago =  convert(varchar(10),isnull(dp_fecha_pago,op_fecha_etapa),103),
        op_sire_cdi, 
        op_sire_codalic, 
        op_sire_acrecen, 
        op_sire_codreg, 
        dt_valor,
        op_operacion_banco,
        dp_sec_transaccion,
        /* 'Formulario'         */ '2003' +
        /* 'Version'            */ '0100' +
        /* 'Transabilidad'      */ replicate (" ", 10) +
        /* 'CUIT Agente'        */ isnull(right(replicate (" ", 11) + P1.pa_char,11), '30500011072') +
        /* 'Impuesto'           */ isnull(right(replicate (" ",  3) + P2.pa_char, 3), '218') +
        /* 'Regimen'            */ isnull(str(op_sire_codreg,3),'000') +    --PL 09/08/2019
        /* 'CUIT Ordenante'     */ right(replicate (" ", 11) + op_ced_ruc,11) +
        /* 'Fecha Retencion'    */ convert(char(10), isnull(dp_fecha_pago,op_fecha_etapa), 103) +
        /* 'Tipo Comprob.'      */ '05' +
        /* 'Fecha Comprob'      */ convert(char(10), isnull(dp_fecha_pago,op_fecha_etapa), 103) +
        /* 'Numero Comprob'     */ right(replicate (" ", 16) + op_operacion_banco,16) +
        --/* 'Importe Comprob'    */ str(dt_valor,14,2) +
        /* 'Importe Comprob'    */ replicate ("X", 14) + +
        /* 'Filler'             */ replicate (" ", 14) +
        /* 'CertifOriginal'     */ replicate (" ", 25) +
        /* 'Cert.Orig.Fecha'    */ replicate (" ", 10) +
        /* 'Cert.Orig.FechaRet' */ replicate (" ", 14) +
        /* 'Motivo NC'          */ replicate (" ", 30) +
        /* 'No Retencion'       */ '0' as campo1,
        /* 'No Ret Motivo'      */ replicate (" ", 30) +
        /* 'Aplica CDI'         */ Case when op_sire_cdi = 'S' then '1' else '0' end +
        /* 'Cod.Alicuota'       */ isnull(str(op_sire_codalic,4),'0000') +
        /* 'Aplica acrecen'     */ Case when op_sire_acrecen = 'S' then '1' else '0' end +
        /* 'Retenido Clave NIF' */ left(isnull(op_sire_nif," ")      + replicate (" ", 50),50) +
        /* 'Retenido Nombre'    */ left(isnull(op_beneficiario," ")  + replicate (" ", 60),60) +
        /* 'Retenido Direccion' */ left(isnull(op_direccion_ben," ") + replicate (" ", 60),60) +
--        /* 'Retenido Direccion' */ left(isnull(op_direccion_ben," ") + isnull((select " (" + ci_descripcion + ")" from cobis..cl_ciudad where ci_ciudad = O.op_ciudad_ben),"") + replicate (" ", 60),60) +
        /* 'Retenido Pais'      */ isnull(str(sp_pais_sire,3), '000') +
        /* 'Retenido Tipo'      */ isnull(op_sire_tipo_per,'J') +
        /* 'Retenido Nacim Pais'*/ CASE when op_sire_tipo_per = 'F' and op_sire_nac_pais  is not null then str(op_sire_nac_pais,3)                   else replicate ("1", 3)  end +
        /* 'Retenido Nacim Fech'*/ CASE when op_sire_tipo_per = 'F' and op_sire_nac_fecha is not null then convert(char(10), op_sire_nac_fecha, 103) else replicate ("2", 10) end as campo2
        --into #detalle2 
   FROM cob_comext..ce_detalle_trn DT 
        inner join cob_comext..ce_operacion O    on op_operacion = dt_operacion
        inner join cob_comext..ce_transaccion  T on tr_operacion = dt_operacion and tr_sec_transaccion = dt_sec_transaccion and tr_estado = 'C'
        inner join cob_comext..ce_detalle_pgo DP on dp_operacion = dt_operacion and dp_sec_transaccion = dt_sec_transaccion 
        left  join cob_comext..ce_conceptos_cv   on cc_concepto =  op_tcorreo
        left  join cobis..cl_ente                on en_ente = op_ordenante
        left  join cobis..cl_pais                on pa_pais = op_pais_ben
        left  join cob_comext..ce_sire_paises    on sp_pais_cobis = op_pais_ben and ((sp_fecha_baja is null or sp_fecha_baja >= dp_fecha_pago) or
                                                                                    ((sp_fecha_baja is null or sp_fecha_baja >= dp_fecha_pago) or (sp_fecha_baja is null or sp_fecha_baja >= op_fecha_etapa and dp_fecha_pago is null))) 
        left  join cobis..cl_parametro P1        on P1.pa_nemonico = 'SICUIT'
        left  join cobis..cl_parametro P2        on P2.pa_nemonico = 'SIIMPU'
  where dt_parametro IN ('A52') 
   and (dp_fecha_pago >= '10/01/2021' or (dp_fecha_pago is null and op_fecha_etapa >= '10/01/2021'))
   and (dp_fecha_pago <= '10/31/2021' or (dp_fecha_pago is null and op_fecha_etapa <= '10/31/2021'))   
   and (op_sire_rfa = 'R' or op_sire_rfa = null) and op_sire_codalic <> null
   and ((    (dp_fecha_pago >= '10/31/2021' and op_operacion_banco >= '0' and dp_sec_transaccion > 0)
        or (dp_fecha_pago >= '10/31/2021' and op_operacion_banco > '0' )
        or (dp_fecha_pago > '10/31/2021')
       )or
        (    ((dp_fecha_pago is null and op_fecha_etapa >= '10/31/2021') and op_operacion_banco >= '0' and dp_sec_transaccion > 0)
        or (dp_fecha_pago is null and op_fecha_etapa >= '10/31/2021' and op_operacion_banco > '0' )
        or (dp_fecha_pago is null and op_fecha_etapa > '10/31/2021')
        )        )



select  top 100 * from #detalle2

select len(campo1) from #detalle2
select len(campo2) from #detalle2
select sum(len(campo1) + len(campo2)) from #detalle2 where op_operacion_banco = 'TRE09921013451'


update cobis..in_login

set lo_fecha_out = getdate()

where lo_login = 'fdlt11'

and lo_fecha_out = null