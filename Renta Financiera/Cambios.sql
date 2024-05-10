/*Selecciono los registros a borrar*/
select * from Custodia..InfFIFO_Op 
where MinManual in (6477566, 6496995, 6586120)
order by FchOrg,MinManual

/*Borro los registros seleccionados*/

delete from Custodia..InfFIFO_Op 
where MinManual in (6477566, 6496995, 6586120)

/*Luego de las modificaciones ejecuto el SP*/
EXEC SP_TENENCIA_FIFO

/*Saco las Especies valorizadas para el Excel*/
select * from Custodia..InfFIFO_ValorizadoxEsp order by Abrev 


/*********************REVERSA************************/
INSERT INTO PROD..InfFIFO_Op
      (Tr
      ,MinManual
      ,FchOrg
      ,Tipo
      ,CPpal
      ,EspPago
      ,PrecioPesificado
      ,Valorizado)
VALUES
      ('TDG24', 6477566, '2023-07-24 00:00:00.000', 'Cmp', 250000, '$', 294.103, 294.103),
      ('TDG24', 6496995, '2023-08-11 00:00:00.000', 'Vnta', 509892, '$', 349.5, 349.5),
      ('X20F4', 6586120, '2023-11-15 00:00:00.000', 'Cmp', 44040000, '$', 1.2135, 1.2135);

