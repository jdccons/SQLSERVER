SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_CallProcedureLog]
 @ObjectID       INT,
 @DatabaseID     INT = NULL,
 @AdditionalInfo NVARCHAR(MAX) = NULL
AS
/* =============================================
	Object:			usp_CallProcedureLog	
	Author:			John Criswell
	Create date:	2015-02-23	 
	Description:	Logs stored procedure errors to
					ProcedureLog table
					
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	2015-02-23		JCriswell		Created
	
	
============================================= */
BEGIN
 SET NOCOUNT ON;

 DECLARE 
  @ProcedureName NVARCHAR(400);

 SELECT
  @DatabaseID = COALESCE(@DatabaseID, DB_ID()),
  @ProcedureName = COALESCE
  (
   QUOTENAME(DB_NAME(@DatabaseID)) + '.'
   + QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectID, @DatabaseID)) 
   + '.' + QUOTENAME(OBJECT_NAME(@ObjectID, @DatabaseID)),
   ERROR_PROCEDURE()
  );

 INSERT ProcedureLog
 (
  DatabaseID,
  ObjectID,
  ProcedureName,
  ErrorLine,
  ErrorMessage,
  AdditionalInfo
 )
 SELECT
  @DatabaseID,
  @ObjectID,
  @ProcedureName,
  ERROR_LINE(),
  ERROR_MESSAGE(),
  @AdditionalInfo;
END


GO
EXEC sp_addextendedproperty N'Purpose', 'Logs stored procedure errors to ProcedureLog table', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_CallProcedureLog', NULL, NULL
GO
