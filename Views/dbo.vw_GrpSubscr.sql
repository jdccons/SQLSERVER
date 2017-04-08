SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_GrpSubscr]
WITH SCHEMABINDING
AS
/* ============================================================
	Object:			vw_GrpSubscr
	Author:			John Criswell
	Create date:	2007-01-01	 
	Description:	Lists all group subscribers and their attributes		
							
	Change Log:
	-----------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2007-01-01		1.0			J Criswell		Created
	2015-10-18		2.0			J Criswell		Added SubCancelled
	
=============================================================== */ 
SELECT  s.SubID ,
        s.SubSSN ,
        s.EIMBRID ,
        s.SubStatus ,
        CASE WHEN  s.SubCancelled = 1 THEN 'Active'
             WHEN s.SubCancelled = 2 THEN 'Pending'
             WHEN s.SubCancelled = 3 THEN 'Cancelled'
             ELSE 'Unknown'
        END AS SubCancel,
        s.SubLastName ,
        ISNULL(s.SubFirstName, '') AS SubFirstName ,
        ISNULL(s.SubMiddleName, '') AS SubMiddleName ,
        s.SubGroupID ,
        g.GRname AS GrpName ,
        CASE WHEN g.GroupType = 1 THEN 'QCD Only'
             WHEN g.GroupType = 4 THEN 'All American'
             ELSE 'Unknown'
        END AS GrpType ,
        g.GRcontBEG AS GrpConBeg ,
        g.GRcontEND AS GrpConEnd ,
        CASE WHEN g.GRcancelled = 1 THEN 'Cancelled'
             WHEN g.GRcancelled = 0 THEN 'Active'
             ELSE 'Unknown'
        END AS GrpCancel ,
        g.GRhold AS GrpHold ,
        c.CoverDescr ,
        ISNULL(s.SubGender, '') SubGender ,
        ISNULL(s.SUBdob, CONVERT(datetime, '1900-01-01 00:00:00', 121)) AS DOB ,
    --    CASE 
			 --WHEN SUBdob IS NOT NULL THEN dbo.fAgeCalc(s.SUBdob)
			 --WHEN SubDob <> '1900-01-01 00:00:00' THEN dbo.fAgeCalc(s.SUBdob)
			 --WHEN SUBdob <> '' THEN dbo.fAgeCalc(s.SUBdob)
			 --ELSE ''
    --    END AS Age ,
        s.DepCnt AS Deps ,
        ISNULL(s.SubMaritalStatus, '') SubMaritalStatus ,
        ISNULL(s.CreateDate, CONVERT(datetime, '1900-01-01 00:00:00', 121)) AS CreateDate ,
        ISNULL(s.ModifyDate, CONVERT(datetime, '1900-01-01 00:00:00', 121)) AS ModifyDate
FROM    dbo.tblSubscr AS s
        JOIN dbo.tblGrp AS g ON s.SubGroupID = g.GROUPid
        JOIN dbo.tblCoverage AS c ON s.CoverID = c.CoverID
WHERE   ( g.GroupType IN (1,4) );


GO
CREATE UNIQUE CLUSTERED INDEX [CLIX_vw_GrpSubscr_SubSSN] ON [dbo].[vw_GrpSubscr] ([SubSSN]) ON [PRIMARY]
GO
