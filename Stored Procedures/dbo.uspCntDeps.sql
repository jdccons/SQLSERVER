SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspCntDeps]
@SSN nvarchar(9)

AS

SELECT Count(tblDependent.DEPsubID) As CntOfDeps
FROM tblDependent
WHERE (((tblDependent.DEPsubID)= @SSN ))

GO
