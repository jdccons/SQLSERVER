SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[uspMarkCardPrinted]

@strSSN nvarchar(9)

 AS


UPDATE tblSubscr
	SET SUBcardPRT = 1, SUBcardPRTdte = Convert(datetime, (Convert(varchar,GetDate(),101)))
WHERE SUBssn = @strSSN
GO
