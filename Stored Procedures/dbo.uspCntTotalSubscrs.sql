SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[uspCntTotalSubscrs]
@SubGroupID varchar(5)

AS

SELECT COUNT(SubSSN) AS CurSCnt FROM tblSubscr 
WHERE SubGroupID = @SubGroupID

GO
