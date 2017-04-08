SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[usp_AllAmericanInvoice_csv] (@InvoiceDate AS DateTime)
AS

/* ======================================================================================
  Object:			usp_AllAmericanInvoice_csv
  Version:			1.0
  Author:			John Criswell
  Create date:		2015-07-26 
  Description:		Runs SSIS package (AllAmericanInvoices.dtsx) to export
					AllAmerican invoice data to a CSV file
					
  Parameters:		@InvoiceDate DateTime
  Where Used:		
					
				
  Change Log:
  ---------------------------------------------------------------------------------------
  Change Date		Version			Changed by		Reason
  2015-07-26		1.0				JCriswell		Created	
  
	
========================================================================================= */
/*  ------------------  declarations  --------------------  */ 
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
    DECLARE @LastOperation VARCHAR(128) ,
        @ErrorMessage VARCHAR(8000) ,
        @ErrorSeverity INT ,
        @ErrorState INT

	
/*  ------------------------------------------------------  */


    BEGIN TRY
		BEGIN TRANSACTION

			/* t-sql to call an SSIS package with a package variable
			Webpage with reference:
			https://www.mssqltips.com/sqlservertip/1395/pass-dynamic-parameter-values-to-sql-server-integration-services/ 
			*/
			SET @LastOperation = 'All American invoices for QuickBooks'
			DECLARE @cmd varchar(1000)
			DECLARE @ssispath varchar(1000)
			DECLARE @PackagePassword varchar(20)
			SET @ssispath = '\\dc\datafiles\QuickBooks\SSIS\QuickBooks\AllAmericanInvoices.dtsx'

			SET @PackagePassword = 'd!7kZ[Cs8Qsw~7H'
			SELECT @cmd = 'dtexec /de ' + '"' + @PackagePassword + '"' + ' /F "' + @ssispath + '"'
			SELECT @cmd = @cmd + ' /SET \Package.Variables[User::InvoiceDate].Properties[Value];"' + CONVERT(varchar(12), @InvoiceDate) + '"'

			EXEC master..xp_cmdshell @cmd

		COMMIT TRANSACTION
		RETURN 1
	END TRY

	BEGIN CATCH 
		IF @@TRANCOUNT > 0 
			ROLLBACK

		SELECT  @ErrorMessage = ERROR_MESSAGE() + ' Last Operation: '
				+ @LastOperation ,
				@ErrorSeverity = ERROR_SEVERITY() ,
				@ErrorState = ERROR_STATE()
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		EXEC usp_CallProcedureLog 
		@ObjectID       = @@PROCID,
		@AdditionalInfo = @LastOperation;
		RETURN 0
	END CATCH;
GO
EXEC sp_addextendedproperty N'Purpose', N'Runs SSIS package to export AllAmerican invoices to QuickBooks...', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_AllAmericanInvoice_csv', NULL, NULL
GO
