SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[vw_GrpSub_local_not_web]
AS
    /* ====================================================================================
	Object:			vw_GrpSub_local_not_web
	Author:			John Criswell
	Create date:	2016-11-10	 
	Description:	reconciles group subs between on-premise and web
	Called from:	frmSubscrInquire		
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2016-11-10		1.0			JCriswell		Created
	
	
======================================================================================= */  

SELECT
    sl.ID, sl.SubSSN, sl.SubID, sl.EIMBRID, sl.SubStatus, sl.SubGroupID,
    sl.PltCustKey, sl.PlanID, sl.CoverID, sl.RateID, sl.SubCancelled,
    sl.Sub_LUName, sl.SubLastName, sl.SubFirstName, sl.SubMiddleName,
    sl.SubStreet1, sl.SubStreet2, sl.SubCity, sl.SubState, sl.SubZip,
    sl.SubPhoneWork, sl.SubPhoneHome, sl.SubEmail, sl.SubDOB, sl.DepCnt,
    sl.SubGender, sl.SubAge, sl.SubMaritalStatus, sl.SubEffDate, sl.SubExpDate,
    sl.SubClassKey, sl.PreexistingDate, sl.SubCardPrt, sl.SubCardPrtDte,
    sl.SubNotes, sl.TransactionType, sl.SubContBeg, sl.SubContEnd,
    sl.SubPymtFreq, sl.SubGeoID, sl.SubBankDraftNo, sl.Flag, sl.UserName,
    sl.DateCreated, sl.DateUpdated, sl.DateDeleted, sl.SubFlyerPrtDte,
    sl.SubRate, sl.SubCOBRA, sl.SubLOA, sl.SubMissing, sl.CreateDate,
    sl.ModifyDate, sl.AmtPaid, sl.wSubID, sl.User01, sl.User02, sl.User03,
    sl.User04, sl.User05, sl.User06, sl.User07, sl.User08, sl.User09, sl.Email,
    sl.DateModified, sl.TimeStamp, sl.GUID
FROM
    (
      SELECT
        sl.ID, SubSSN, SubID, EIMBRID, SubStatus, SubGroupID, PltCustKey, PlanID,
        CoverID, RateID, SubCancelled, Sub_LUName, SubLastName, SubFirstName,
        SubMiddleName, SubStreet1, SubStreet2, SubCity, SubState, SubZip,
        SubPhoneWork, SubPhoneHome, SubEmail, SubDOB, DepCnt, SubGender,
        SubAge, SubMaritalStatus, SubEffDate, SubExpDate, SubClassKey,
        PreexistingDate, SubCardPrt, SubCardPrtDte, SubNotes, TransactionType,
        SubContBeg, SubContEnd, SubPymtFreq, SubGeoID, SubBankDraftNo, Flag,
        UserName, sl.DateCreated, sl.DateUpdated, DateDeleted, SubFlyerPrtDte,
        SubRate, SubCOBRA, SubLOA, SubMissing, CreateDate, ModifyDate, AmtPaid,
        wSubID, sl.User01, sl.User02, sl.User03, sl.User04, sl.User05, sl.User06, sl.User07, sl.User08,
        sl.User09, Email, sl.DateModified, TimeStamp, GUID
      FROM
        tblSubscr AS sl
			inner join tblGrp g
			on sl.SubGroupID = g.GroupID
      WHERE
        ( SubCancelled = 1 )
        AND ( SubStatus = 'GRSUB' )
		AND g.GroupType = 1
		AND g.GRCancelled = 0
    ) AS sl
LEFT OUTER JOIN (
                  SELECT
                    SubID, SSN, EIMBRID, SubscriberID, GroupID, PlanID,
                    CoverID, LastName, FirstName, MiddleInitial, Street1,
                    Street2, City, State, Zip, PhoneWork, PhoneHome, Email,
                    DOB, DepCnt, Gender, Age, EffectiveDate, PreexistingDate,
                    EmploymentDate, EmploymentStatus, Occupation_Title,
                    MaritalStatus, CardPrinted, CardPrintedDate,
                    MembershipStatus, DateCreated, DateChanged, DateDeleted,
                    Download, DownloadDate, PaymentStatus, ContractLength,
                    PseudoSSN, Password, SubGroupID, SubExpDate,
                    SubBankDraftNo, lSubID, AmtPaid, PriceID, UserName,
                    CreateDate, ModifyDate, User01, User02, User03, User04,
                    User05, User06, User07, User08, User09
                  FROM
                    TRACENTRMTSRV.QCD.dbo.tblSubscriber
                  WHERE
                    ( GroupID <> 'INDIV' )
                    AND ( MembershipStatus IN ( 'Current', 'Legacy', 'Changed',
                                                'Initial', 'Added' ) )
                ) AS sr ON sl.SubSSN = sr.SSN
WHERE
    ( sr.SSN IS NULL );







GO
