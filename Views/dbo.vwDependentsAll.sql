SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwDependentsAll]
AS
SELECT	s.SubGroupID, 
		g.GroupType, 
		s.SubStatus, 
		d.DepSubID, 
		d.DepSSN, 
		d.DepLastName, 
		d.DepFirstName, 
		s.PlanID, 
		s.CoverID, 
		s.SubCity, 
		s.SubState, 
		s.SubZip
FROM tblDependent d
INNER JOIN tblSubscr s ON d.DepSubID = s.SubSSN
INNER JOIN tblGrp g ON s.SubGroupID = g.GroupID
WHERE g.GroupType IN (1,4,9)
	AND g.GRCancelled = 0
	AND s.SubCancelled = '1';
GO
