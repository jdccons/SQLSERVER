SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_EDI_App_Subscr_Key_Values]

AS
/* =============================================
	Object:			usp_EDI_App_Subscr_Key_Values
	Author:			John Criswell
	Create date:	09/29/2013	 
	Description:	Transfers key values from
					tblSubscr to tblEDI_App_Subscr
					
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	
	
	
============================================= */

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION

/*  website electronic enrollment
    update values on import table */

UPDATE
    eas
SET eas.SubID = s.SubID,
    eas.SubCardPrt = s.SubCardPrt,
    eas.SubCardPrtDte = s.SubCardPrtDte,
    eas.SubNotes = s.SubNotes
FROM
    tblEDI_App_Subscr eas
    INNER JOIN tblSubscr s
        ON eas.SubSSN = s.SubSSN

COMMIT TRAN;


GO
EXEC sp_addextendedproperty N'Purpose', 'Not currently being used anywhere.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_EDI_App_Subscr_Key_Values', NULL, NULL
GO
