SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspFindSubscr]
@SSN nvarchar(9)

AS

SELECT Count(tblSubscr.SubSSN) As CntOfSubscrs
FROM tblSubscr
WHERE (((tblSubscr.SubSSN)= @SSN ))

GO
