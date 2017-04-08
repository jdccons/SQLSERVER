SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspCntSpouses]

@SSN nvarchar(9),
@DepRel nvarchar(1)

AS

SELECT Count(DepSubID) As CntOfSpouses
FROM tblDependent
WHERE DepSubID = @SSN
AND DepRelationship = @DepRel

GO
