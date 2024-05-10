SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_TENENCIA_FIFO] 
AS 
/*Se genera un procedimiento que realiza el calculo fifo de las operaciones cargadas en InfFIFO_Op */
BEGIN

SET NOCOUNT ON

CREATE TABLE  #tmpEstados 
 ( 
	[Tr] [varchar](22) NULL,
	[MinManual] [int] NULL,
	[FchOrg] [datetime] NULL,
	[Tipo] [varchar](10) NULL,
	[CPpal] [float] NULL,
	[EspPago] [varchar](10) NULL,
	[PrecioPesificado] [float] NULL,
	[Valorizado] [float] NULL
	)

declare @tmpVnta table
 (
	[Tr] [varchar](22) NULL,
	[MinManual] [int] NULL,
	[FchOrg] [datetime] NULL,
	[Tipo] [varchar](8) NULL,
	[CPpal] [float] NULL,
	[EspPago] [varchar](10) NULL,
	[PrecioPesificado] [float] NULL,
	[Valorizado] [float] NULL
	)
declare @tmpCmp table
 (
	[Tr] [varchar](22) NULL,
	[MinManual] [int] NULL,
	[FchOrg] [datetime] NULL,
	[Tipo] [varchar](8) NULL,
	[CPpal] [float] NULL,
	[EspPago] [varchar](10) NULL,
	[PrecioPesificado] [float] NULL,
	[Valorizado] [float] NULL
	)

declare @Tr varchar(11),
		@flag  int = 1

/*Blanqueamos la tabla de Valorizados*/
DELETE from Custodia..InfFIFO_ValorizadoxEsp
/*Obtenemos todas las especies que fueron operadas*/
DECLARE cur_Ctas CURSOR FOR 
	select distinct Tr  
	from Custodia..InfFIFO_Op o 
	order by Tr

OPEN cur_Ctas  
	FETCH NEXT FROM cur_Ctas
	INTO @Tr; 
	WHILE @@FETCH_STATUS = 0  
	BEGIN
		IF @flag = 1
		BEGIN
			/*Cargamos las temporales de compras y ventas, en la de compras se incluye el stock del año anterior*/
			insert into  @tmpVnta
			select 
				Tr,
				MinManual,
				FchOrg,
				Tipo,
				CPpal,
				EspPago,
				PrecioPesificado,
				Valorizado
			from Custodia..InfFIFO_Op 
			where Tr=@Tr 
			and Tipo= 'Vnta'
			order by Tr,FchOrg,MinManual

			insert into  @tmpCmp
			select 
				Tr,
				MinManual,
				FchOrg,
				Tipo,
				CPpal,
				EspPago,
				PrecioPesificado,
				Valorizado
			from Custodia..InfFIFO_Op 
			where Tr=@Tr 
				and Tipo= 'Cmp'
			union all
			select 
				Abrev,
				 1,
				 FECHA_SALDO,
				'Cmp',
				CANTIDAD2,
				MONEDA,
				PRECIO2,
				VALORIZADO2	
			from Custodia..InfFIFO_SaldoFch 
			where Abrev = @Tr  
			order by Tr,FchOrg,MinManual
				
			Select @flag = 0
		END
		
		/*Se declaran las variables para realizar los calculos de cantidades y precio*/
		Declare @MinManualCmp int,
				@MinManualC int,
				@CantidadCmp float ,
				@CantidadC float,
				@PrecioCmp float,
				@PrecioC float,
				@Valorizado float=0
		/*Si no hay compra y venta no ingresamos en el proceso */
		IF (Select count(1) from @tmpVnta ) >0 and (select count(1) from @tmpCmp) > 0
		BEGIN
		/*Ingresamos en el cursor de compras por cada compra se empareja con una o varias ventas hasta que cada compra quede en 0*/
		Declare cur_compras cursor for 
			Select 
				MinManual,
				CPpal,
				PrecioPesificado
			from @tmpCmp 
			Where CPpal >0
			order by FchOrg,MinManual;

		OPEN cur_compras;
		fetch next from cur_compras into 	@MinManualCmp, @CantidadCmp,@PrecioCmp
			While @@fetch_status=0
			BEGIN
				/*Ingresamos en el cursor de las ventas, en caso de que la cantidad vendida supere a la compra, se resta la cantidad disponible y se actualiza la cantidad de la venta */
				Declare cur_vnta cursor for 
							Select 
								MinManual as asdsad,
								CPpal,
								PrecioPesificado
							from @tmpVnta 
							Where CPpal >0
							order by FchOrg,MinManual;
					OPEN cur_vnta
					fetch next from cur_vnta into 	@MinManualC, @CantidadC,@PrecioC
					While @@fetch_status=0
					BEGIN
				
						IF   @CantidadCmp <>0 
						BEGIN 
						/*Si la cantidad comprada es mayor o igual a la vendida*/
						IF @CantidadCmp >= @CantidadC   
						BEGIN
				
							SET @Valorizado = @Valorizado + ((@CantidadC*@PrecioCmp)-(@CantidadC* @PrecioC) )
							SET @CantidadCmp =  @CantidadCmp-@CantidadC
										
							update @tmpVnta
							set CPpal = 0 
							where  Tr = @Tr and MinManual = @MinManualC

							update @tmpCmp
							set CPpal = @CantidadCmp
							where Tr = @Tr and  MinManual = @MinManualCmp
										
							If not exists (select 1 from Custodia..InfFIFO_ValorizadoxEsp where Abrev = @Tr)
							BEGIN
								Insert INTO Custodia..InfFIFO_ValorizadoxEsp(Abrev,VALORIZADO)
								VALUES (@Tr,@Valorizado)
							END
							ELSE
							BEGIN 
								update Custodia..InfFIFO_ValorizadoxEsp
								set VALORIZADO = VALORIZADO + @Valorizado
								where Abrev = @Tr
							END
							END

						ELSE
						BEGIN
													
							SET @Valorizado = @Valorizado + ((@CantidadCmp*@PrecioCmp)-(@CantidadCmp* @PrecioC) )
							SET @CantidadC =  @CantidadC-@CantidadCmp
										
							SET @CantidadCmp = 0
							update @tmpCmp
							set CPpal = 0 
							where Tr = @Tr and MinManual = @MinManualCmp

							update @tmpVnta
							set CPpal = @CantidadC
							where Tr = @Tr and  MinManual = @MinManualC
	
						END

					END
									
					fetch next from cur_vnta into 	@MinManualC, @CantidadC,@PrecioC
					END
									
					close cur_vnta
					deallocate cur_vnta

					If not exists (select 1 from Custodia..InfFIFO_ValorizadoxEsp where Abrev = @Tr)
					BEGIN
						Insert INTO Custodia..InfFIFO_ValorizadoxEsp(Abrev,VALORIZADO)
						VALUES (@Tr,@Valorizado)
					END
					ELSE
					BEGIN 
						update Custodia..InfFIFO_ValorizadoxEsp
						set VALORIZADO =  @Valorizado
						where Abrev = @Tr
					END

			Fetch next from cur_compras into 	@MinManualCmp, @CantidadCmp,@PrecioCmp
			END/*fin del cursor de compras*/
		close cur_compras
		deallocate cur_compras
		
		insert into #tmpEstados (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,PrecioPesificado,Valorizado)
			select Tr,MinManual,FchOrg,Case when Tipo = 'Cmp' then 'COMPRA' else'VENTA'end as Tipo,CPpal,EspPago,PrecioPesificado,CPpal*PrecioPesificado as Valorizado from @tmpCmp where Tr = @Tr 
			union
			select Tr,MinManual,FchOrg,Case when Tipo = 'Cmp' then 'COMPRA' else'VENTA'end,(CPpal*-1),EspPago,PrecioPesificado,CPpal*PrecioPesificado from @tmpVnta where Tr = @Tr order by FchOrg,MinManual
			
		END/*Fin del IF*/
		ELSE
		BEGIN
		/*Agregamos a la temporal los que son solo ventas o solo compras para evaluar la tenencia a fin de ejecucion*/
			insert into #tmpEstados (Tr,MinManual,FchOrg,Tipo,CPpal,EspPago,PrecioPesificado,Valorizado)
			select Tr,MinManual,FchOrg,Case when Tipo = 'Cmp' then 'COMPRA' else'VENTA'end as Tipo,CPpal,EspPago,PrecioPesificado,CPpal*PrecioPesificado as Valorizado from @tmpCmp where Tr = @Tr 
			union
			select Tr,MinManual,FchOrg,Case when Tipo = 'Cmp' then 'COMPRA' else'VENTA'end,(CPpal*-1),EspPago,PrecioPesificado,CPpal*PrecioPesificado from @tmpVnta where Tr = @Tr order by FchOrg,MinManual
			
		END
		select @flag = 1		
		
		delete from @tmpCmp where Tr = @Tr
		delete from @tmpVnta where Tr = @Tr
		
		FETCH NEXT FROM cur_Ctas  INTO @Tr
		END /*fin del cursor de especies*/

CLOSE cur_Ctas;  
DEALLOCATE cur_Ctas;

update Custodia..InfFIFO_ValorizadoxEsp
SET TENENCIA = t.Cantidad
FROM Custodia..InfFIFO_ValorizadoxEsp v 
INNER JOIN
	(select sum(CPpal) as Cantidad,Tr from #tmpEstados tt  group by tt.Tr )t   	on
	t.Tr = v.Abrev


INSERT INTO Custodia..InfFIFO_ValorizadoxEsp (Abrev,VALORIZADO,TENENCIA)
Select 
	Abrev,
	VALORIZADO2,
	CANTIDAD2  
from Custodia..[InfFIFO_SaldoFch] s where not exists (select 1 from Custodia..InfFIFO_Op t where t.Tr = s.Abrev)
union all
Select 
	Tr,
	0,
	sum(CPpal)
FROM #tmpEstados t  where not exists (select 1 from InfFIFO_ValorizadoxEsp v where t.Tr = v.Abrev)
group by Tr

drop table #tmpEstados

END
GO
