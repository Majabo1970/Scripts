insert into bc_d_lfip_cliente_destino_bkp
select * from bc_d_lfip_cliente_destino
where cd_f_inf = '04/30/2021'

select top 20 * from bc_d_lfip_cliente_destino
order by cd_f_inf desc

insert into bc_d_lfip_salida_miles_bkp
select * from bc_d_lfip_salida_miles
where sm_f_periodo = '04/30/2021'

select top 20 * from bc_d_lfip_salida_miles
order by sm_f_periodo desc

select top 20 * from bc_d_lfip_numerales_promedios
order by pr_f_inf desc

select top 20 * from bc_d_lfip_cr_saldos_diarios
order by sd_f_inf desc

select top 20 * from bc_d_lfip_stock_operaciones
order by so_f_inf desc

select top 20 * from bc_d_lfip_resumen_acuerdos
order by ra_f_inf desc

select top 20 * from bc_d_lfip_stock_acuerdos
order by sa_f_inf desc

select top 20 * from bc_d_lfip_novedades_op
order by no_f_inf desc

select top 20 * from bc_d_lfip_cabecera

update bc_d_lfip_salida_miles
set sm_f_periodo   = '04/30/2021'
where sm_f_periodo = '05/31/2021'
and sm_c_formula   = 'LFIPCUPO21'

update bc_d_lfip_cliente_destino
set cd_f_inf     = '04/30/2021'
where cd_f_inf   = '05/31/2021'
and cd_c_formula = 'LFIPCUPO21'

update bc_d_lfip_novedades_op
set no_f_inf 	 = '02/28/2021'
where no_f_inf 	 = '04/30/2021'
and no_c_formula = 'LFIPCUPO21'

select top 20 * from cob_bcradgi_his..bc_h_lfip_cliente_destino
order by cd_f_inf 

select top 20 * from bc_d_lfip_salida_miles
order by sm_f_periodo 

select top 20 * from bc_errores_batch
where eb_sp = 'sp_bc_lfip_proc_his'

select top 20 * from bc_fec_formulas
where ff_nro_formulario = 'LFIPCUPO21'

update bc_fec_formulas
set ff_estado_form = 'FC'
where ff_nro_formulario = 'LFIPCUPO21'
and ff_fecha_informac   = '04/30/2021'