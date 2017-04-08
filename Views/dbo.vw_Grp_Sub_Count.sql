SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Grp_Sub_Count]
AS
SELECT g.GroupID, g.GroupType, COUNT(s.SubSSN) SubCnt FROM tblGrp g
	INNER JOIN tblSubscr s
		ON g.GroupID = s.SubGroupID
WHERE g.GRCancelled = 0
AND s.SubCancelled = 1
GROUP BY g.GroupID, g.GroupType;
GO
