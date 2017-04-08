SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[uspCntTotalDeps]
@SubGroupID varchar(5)

AS

SELECT COUNT(d.DepSubID) AS CurDCnt
FROM tblSubscr AS s INNER JOIN
tblDependent AS d ON s.SubSSN = d.DepSubID
WHERE (s.SubGroupID = @SubGroupID)





GO
