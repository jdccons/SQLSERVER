SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteARCust] (
	@SubID AS NVARCHAR(8)
	, @UserName AS VARCHAR(20)
	)
AS
/* ========================================================================
	Object:			usp_DeleteARCust
	Author:			John Criswell
	Create date:	2015-02-23	 
	Description:	Deletes a single customer from
					ARCUST_local
	Change Log:
	--------------------------------------------
	Change Date		Version		Changed by		Reason
	2015-02-23		1.0			JCriswell		Created
	2015-12-30		2.0			J Criswell		Changed logic to set
												Rsrv1 to DELETED instead
												of deleting the record
	
=========================================================================== */
IF EXISTS (
			SELECT 1
			FROM ARCUST_local
			WHERE ((ARCUST_local.Spare) = @SubID )
		   )
BEGIN
	UPDATE ARCUST_local
	SET Rsrv1 = 3
		, Rsrv2 = 'DELETED'
		, RecUserID = @UserName
		, RecDate = CONVERT(VARCHAR(10), GETDATE(), 101)
		, RecTime = LTRIM(RIGHT(CONVERT(VARCHAR(20), GETDATE(), 100), 7	))
	WHERE (Spare = @SubID)

	RETURN 1
END
ELSE
	RETURN 0
GO
EXEC sp_addextendedproperty N'Purpose', N'Deletes a single customer from ARCUST_local', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_DeleteARCust', NULL, NULL
GO
