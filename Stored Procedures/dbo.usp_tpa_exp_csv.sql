SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[usp_tpa_exp_csv] (@GRP_TYPE integer)
AS 
	/* ======================================================================================
	Object:			usp_tpa_exp_csv
	Version:		1.0
	Author:			John Criswell
	Create date:	2015-11-07 
	Description:	Creates an export file for the tpa
					
					
	
					
	Parameters:		GRP_TYPE integer (1 for QCD Only; 4 for All American; 9 for Individuals)
	Where Used:		frmTPA_Export	
					
				
	Change Log:
	---------------------------------------------------------------------------------------
	Change Date		Version			Changed by		Reason
	2015-11-07		1.0				J Criswell		Created	


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
				SET @LastOperation = 'export data to csv file'
				DECLARE @cmd VARCHAR(1000);
				DECLARE @ssispath VARCHAR(1000);
				DECLARE @PackagePassword VARCHAR(20);
				SET @ssispath = '\\sql\ssis\data_exchange\tpa_data_exchange_sub_export.dtsx';
				SET @PackagePassword = 'HiRainwus304';
				SELECT @cmd = 'dtexec /de ' + '"' + @PackagePassword + '"' + ' /F "' + @ssispath + '"'
				SELECT @cmd = @cmd + ' /SET \Package.Variables[User::GRP_TYPE].Properties[Value];"' + convert(nchar(1), @GRP_TYPE) + '"'
				EXEC master..xp_cmdshell @cmd;
		 

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
EXEC sp_addextendedproperty N'Purpose', N'Runs SSIS package to export data to tpa...', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_tpa_exp_csv', NULL, NULL
GO
