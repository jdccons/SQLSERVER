SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		John Criswell
-- Create date: 9/25/2009
-- Description:	Populates a table with
--              with data on subscribers
--              to determine the differences in
--              key fields ie Zip, etc
-- =============================================

CREATE PROCEDURE [dbo].[uspWebsiteRec]

AS

/* delete contents of temp table - tblWebsiteRec */
DELETE FROM tblWebsiteRec

/* compare remote subs to local subs and list the ones
where the zip is different */
INSERT INTO tblWebsiteRec (Description, SSN, GroupID, LastName, FirstName, Zip_r, Zip_l, 
MembershipStatus, DateCreated, DateChanged, DateDeleted)
SELECT 'Zip discrepancy' As Description 
, rs.SSN
, rs.GroupID
, rs.LastName
, rs.FirstName
, rs.Zip As Zip_r
, ls.SubZip As Zip_l
, rs.MembershipStatus
, rs.DateCreated
, rs.DateChanged
, rs.DateDeleted
FROM tblSubscr AS ls RIGHT OUTER JOIN
[TRACENTRMTSRV].QCD.dbo.tblSubscriber AS rs ON ls.SubSSN = rs.SSN
WHERE (rs.Zip <> ls.SubZip)

/* compare remote subs to local subs and list the ones
where the number of dependents are different */
INSERT INTO tblWebsiteRec (Description, SSN, GroupID, LastName, FirstName, DepCnt_r, DepCnt_l, 
MembershipStatus, DateCreated, DateChanged, DateDeleted)
SELECT 'Dep cnt discrepancy'
, rs.SSN
, rs.GroupID
, rs.LastName
, rs.FirstName
, rs.DepCnt AS DepCnt_r
, ls.DepCnt AS DepCnt_l
, rs.MembershipStatus
, rs.DateCreated
, rs.DateChanged
, rs.DateDeleted
FROM tblSubscr AS ls RIGHT OUTER JOIN
[TRACENTRMTSRV].QCD.dbo.tblSubscriber AS rs ON ls.SubSSN = rs.SSN
WHERE (rs.DepCnt <> ls.DepCnt)

/* compare remote subs to local subs and list the ones
where the coverage are different */
INSERT INTO tblWebsiteRec (Description, SSN, GroupID, LastName, FirstName, Cov_r, Cov_l, 
MembershipStatus, DateCreated, DateChanged, DateDeleted)
SELECT 'Cover discrepancy'
, rs.SSN
, rs.GroupID
, rs.LastName
, rs.FirstName
, rs.CoverID AS Cov_r
, ls.CoverID AS Cov_l
, rs.MembershipStatus
, rs.DateCreated
, rs.DateChanged
, rs.DateDeleted
FROM tblSubscr AS ls RIGHT OUTER JOIN
[TRACENTRMTSRV].QCD.dbo.tblSubscriber AS rs ON ls.SubSSN = rs.SSN
WHERE (rs.CoverID <> ls.CoverID)

/* compare remote subs to local subs and list the ones
where the plan is different */
INSERT INTO tblWebsiteRec (Description, SSN, GroupID, LastName, FirstName, Plan_r, Plan_l, 
MembershipStatus, DateCreated, DateChanged, DateDeleted)
SELECT 'Plan discrepancy'  
, rs.SSN
, rs.GroupID
, rs.LastName
, rs.FirstName
, rs.PlanID AS Plan_r
, ls.PlanID AS Plan_l
, rs.MembershipStatus
, rs.DateCreated
, rs.DateChanged
, rs.DateDeleted
FROM tblSubscr AS ls RIGHT OUTER JOIN
[TRACENTRMTSRV].QCD.dbo.tblSubscriber AS rs ON ls.SubSSN = rs.SSN
WHERE (rs.PlanID <> ls.PlanID)



GO
