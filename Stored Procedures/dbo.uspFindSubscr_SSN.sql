SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspFindSubscr_SSN]
@SSN nvarchar(9), @FoundSubscr int OUTPUT 

AS

SELECT @FoundSubscr = Count(tblSubscr.SubSSN)
FROM tblSubscr
WHERE (((tblSubscr.SubSSN)= @SSN ))

GO
