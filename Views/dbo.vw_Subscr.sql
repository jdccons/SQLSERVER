SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--SELECT * FROM dbo.vw_Subscr;
CREATE VIEW [dbo].[vw_Subscr]
AS
/* ============================================================
	Object:			vw_Subscr
	Author:			John Criswell
	Create date:	2007-01-01	 
	Description:	Lists all subscribers and their attributes		
							
	Change Log:
	-----------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2007-01-01		1.0			J Criswell		Created
	
	
=============================================================== */ 
    SELECT
        s.SubSSN ,
        s.SubID ,
        s.EIMBRID ,
        ISNULL(s.SubStatus, '') SubStatus,
        s.SubGroupID ,
        ISNULL(s.PltCustKey, '') PltCustKey,
        s.PlanID ,
        p.PlanDesc ,
        s.CoverID ,
        c.CoverDescr ,
        c.CoverCode ,
        s.RateID ,
        r.Rate SubRate ,
        ISNULL(s.AmtPaid, 0) AmtPaid ,        
        CASE WHEN  s.SubCancelled = 1 THEN 'Active'
             WHEN s.SubCancelled = 2 THEN 'Pending'
             WHEN s.SubCancelled = 3 THEN 'Cancelled'
             ELSE 'Unknown'
        END AS SubCancel, 
        ISNULL(s.Sub_LUName, '') Sub_LUName,
        ISNULL(s.SubLastName, '') SubLastName,
        ISNULL(s.SubFirstName, '') SubFirstName,
        ISNULL(s.SubMiddleName, '') SubMiddleName,
        ISNULL(s.SubStreet1, '') SubStreet1,
        ISNULL(s.SubStreet2, '') SubStreet2,
        ISNULL(s.SubCity, '') SubCity,
        ISNULL(s.SubState, '') SubState,
        ISNULL(s.SubZip, '') SubZip,
        ISNULL(s.SubPhoneWork, '') SubPhoneWork,
        ISNULL(s.SubPhoneHome, '') SubPhoneHome,
        ISNULL(s.SubEmail, '') SubEmail,        
        s.SubDOB ,
        s.DepCnt ,
        ISNULL(s.SubGender, '') SubGender,
        CASE 
		 WHEN SUBdob IS NOT NULL THEN dbo.fAgeCalc(s.SUBdob)
		 WHEN SubDob <> '1900-01-01 00:00:00' THEN dbo.fAgeCalc(s.SUBdob)
		 WHEN SUBdob <> '' THEN dbo.fAgeCalc(s.SUBdob)
		 ELSE ''
        END AS Age ,
        ISNULL(s.SubMaritalStatus, '') SubMaritalStatus,
        s.SubEffDate ,
        s.SubExpDate ,
        s.SubContBeg ,
        s.SubContEnd ,
        s.PreexistingDate ,
        s.SubCardPrt ,
        s.SubCardPrtDte ,
        s.SubNotes ,
        s.SubCOBRA ,
        s.SubLOA ,
        ISNULL(s.TransactionType, '') TransactionType ,       
        s.SubBankDraftNo ,
        s.SubPymtFreq ,
        s.SubGeoID ,        
        s.Flag ,
        s.UserName ,
        s.DateCreated ,
        s.DateUpdated ,
        s.DateDeleted ,        
        s.SubMissing ,
        s.CreateDate ,
        s.ModifyDate ,        
        s.wSubID ,        
        g.GRContBeg ,
        g.GRContEnd ,
        g.GRName ,
        g.GRCancelled ,
        g.GRHold ,
        CASE WHEN g.GroupType = 1 THEN 'QCD Only'
             WHEN g.GroupType = 4 THEN 'All American'
             WHEN g.GroupType = 9 THEN 'Individual'
             ELSE 'Unknown'
        END AS GrpType ,      
        s.User01 ,
        s.User02 ,
        s.User03 ,
        s.User04 ,
        s.User05 ,
        s.User06 ,
        s.User07 ,
        s.User08 ,
        s.User09
    FROM
        tblSubscr AS s
        JOIN tblGrp AS g
            ON s.SubGroupID = g.GroupID        
        JOIN tblRates AS r
            ON s.SubGroupID = r.GroupID
               AND s.PlanID = r.PlanID
               AND s.CoverID = r.CoverID
        JOIN tblPlans p
			ON r.PlanID = p.PlanID
        JOIN tblCoverage AS c
            ON r.CoverID = c.CoverID
GO
