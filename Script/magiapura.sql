declare @Especie varchar(10) = 'A2E2D'
/*Tenencia*/
select * from  Custodia..InfFIFO_SaldoFch  where Abrev = @Especie
/*Operaciones*/
select * from InfFIFO_Op  where Tr = @Especie order by FchOrg,MinManual
/*Valorizado final FIFO*/
select * from InfFIFO_ValorizadoxEsp where Abrev =@Especie

/*
delete from InfFIFO_Op where Tr ='A2E2D'
delete from InfFIFO_ValorizadoxEsp
*/
