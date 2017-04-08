SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vwSubscrWebsiteRec]
AS
SELECT SUBSTRING(rs.SSN,1,3) + '-' + SUBSTRING(rs.SSN,4,2) + '-' + SUBSTRING(rs.SSN,6,4)AS SSN, 
	   rs.GroupID, rs.LastName, rs.FirstName, rs.MembershipStatus, 
       rs.DateCreated, rs.DateChanged, rs.DateDeleted, rs.DownloadDate
FROM   [TRACENTRMTSRV].QCD.dbo.tblSubscriber AS rs 
	LEFT OUTER JOIN tblSubscr AS ls 
		ON rs.SSN = ls.SubSSN
WHERE  (ls.SubSSN IS NULL) 
		AND (rs.MembershipStatus <> 'Deleted')
		AND (rs.GroupID <> 'INDIV')
UNION
SELECT SUBSTRING(rs.SSN,1,3) + '-' + SUBSTRING(rs.SSN,4,2) + '-' + SUBSTRING(rs.SSN,6,4)AS SSN, 
	   rs.GroupID, rs.LastName, rs.FirstName, rs.MembershipStatus, 
       rs.DateCreated, rs.DateChanged, rs.DateDeleted, rs.DownloadDate
FROM   [TRACENTRMTSRV].QCD.dbo.tblSubscriber AS rs 
	LEFT OUTER JOIN tblSubscr AS ls 
		ON rs.SSN = ls.SubSSN
WHERE  (ls.SubStatus = 'INDIV' AND ls.SubCancelled = 1)
		AND (ls.SubSSN IS NULL) 



GO
