SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_GrpSubscr_Zip_Cnt] as
SELECT isnull(s.SubZip, 'No Zip') SubZip, count(s.SubSSN) Cnt
FROM tblSubscr s
INNER JOIN tblGrp g ON s.SubGroupID = g.GroupID
WHERE g.GroupType IN (1,4)
	AND g.GRCancelled = 0
	AND s.SubCancelled = 1
GROUP BY s.SubZip;
GO
