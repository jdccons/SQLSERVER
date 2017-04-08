SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vwAllGrpDependents]
AS
	SELECT	d.ID, d.DepSSN, d.EIMBRID, d.DepSubID, d.DepFirstName, 
			d.DepMiddleName, d.DepLastName, d.DepDOB, d.DepAge, 
			d.DepRelationship, d.DepGender, d.DepEffDate
	FROM dbo.tblDependent AS d
	INNER JOIN dbo.tblSubscr AS s
		ON d.DepSubID = s.SubSSN
	INNER JOIN tblGrp g
		ON s.SubGroupID = g.GroupID
	WHERE (g.GroupType in (1,4));
GO
