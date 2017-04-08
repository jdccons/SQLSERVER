SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_GrpDep]
AS
/* ============================================================
	Object:			vw_GrpDep
	Author:			John Criswell
	Create date:	2007-01-01	 
	Description:	Lists all group subscribers and their attributes		
							
	Change Log:
	-----------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2007-01-01		1.0			J Criswell		Created
	2015-10-23		2.0			J Criswell		Added DepCancelled and DateDeleted
	
=============================================================== */ 
	SELECT	d.ID, d.DepSubID AS SubSSN, d.SubID AS SubID, 
			ISNULL(d.DepSSN, '') AS 
			DepSSN, ISNULL(d.EIMBRID, '') AS EIMBRID, s.SubStatus, 
			CASE 
				WHEN s.SubCancelled = 1 THEN 'Active'
				WHEN s.SubCancelled = 2	THEN 'Pending'
				WHEN s.SubCancelled = 3	THEN 'Cancelled'
				ELSE 'Active'
			END AS SubCancel, 
			CASE 
				WHEN d.DepCancelled = 1 AND s.SubCancelled = 1 THEN 'Active'
				WHEN d.DepCancelled = 2	AND s.SubCancelled = 2 THEN 'Pending'
				WHEN d.DepCancelled = 3	OR s.SubCancelled = 3 THEN 'Cancelled'
				ELSE 'Active'
			END AS DepCancel,
			d.DepLastName, 
			ISNULL(d.DepFirstName, '') AS DepFirstName, 
			ISNULL(d.DepMiddleName, '') AS DepMiddleName, s.
			SubGroupID, g.GRname AS GrpName, 
			CASE 
				WHEN g.GroupType = 1 THEN 'QCD Only'
				WHEN g.GroupType = 4 THEN 'All American'
				ELSE 'Unknown'
			END AS GrpType, 
			g.GRcontBEG AS GrpConBeg, 
			g.GRcontEND AS GrpConEnd, 
			CASE 
				WHEN g.GRcancelled = 1 THEN 'Cancelled'
				WHEN g.GRcancelled = 0 THEN 'Active'
				ELSE 'Unknown'
			END AS GrpCancel, 
			g.GRhold AS GrpHold, 
			c.CoverDescr, 
			ISNULL(d.DepGender, '') DepGender, 
			ISNULL(d.DepDOB,'1900-01-01 00:00:00') AS DepDOB, 
			CASE 
				WHEN DepDOB IS NOT NULL	THEN dbo.fAgeCalc(d.DepDOB)
				WHEN DepDOB <> '1900-01-01 00:00:00' THEN dbo.fAgeCalc(d.DepDOB)
				WHEN DepDOB <> '' THEN dbo.fAgeCalc(d.DepDOB)
				ELSE ''
			END AS Age, 
			d.DepRelationship AS DepRel,
			d.DepEffDate,
			d.PreexistingDate AS DepPrexDate, 
			ISNULL(s.SubMaritalStatus, '') AS SubMaritalStatus, 
			ISNULL(s.CreateDate, '1900-01-01 00:00:00') AS CreateDate, 
			ISNULL(s.ModifyDate, '1900-01-01 00:00:00') AS ModifyDate,
			ISNULL(s.DateDeleted, '1900-01-01 00:00:00') AS TermDate
			
	FROM tblDependent d
	INNER JOIN tblSubscr s
		ON d.DepSubID = s.SubSSN
	INNER JOIN tblGrp g
		ON s.SubGroupID = g.GroupID
	INNER JOIN tblCoverage c
		ON s.CoverID = c.CoverID
	WHERE g.GroupType IN (1,4);


GO
