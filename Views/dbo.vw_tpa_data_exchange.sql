SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ====================================================================================
	Object:			vw_tpa_data_exchange
	Author:			John Criswell
	Create date:	2015-11-01	 
	Description:	Displays active QCD Only and Individual subscribers and their
					dependents
	Called from:	usp_tpa_export_csv1		
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-11-01		1.0			J Criswell		Created
	2016-12-02		2.0			J Criswell		Bug in select for dependents;
												changed the join from SubID to SubSSN
	
	
======================================================================================= */ 


CREATE VIEW [dbo].[vw_tpa_data_exchange]
AS
    SELECT	g.GroupType GRP_TYPE,
			'S' RCD_TYPE, 
			s.SubSSN SSN,
			s.SubID SUB_ID,
			s.SubSSN DEP_SSN,
			s.SubLastName LAST_NAME,
			s.SubFirstName FIRST_NAME,
			s.SubMiddleName MI,
			s.SubDOB DOB,			
			s.SubGroupID GRP_ID, 
			s.PlanID [PLAN], 
			s.CoverID COV,
			s.SubEffDate [EFF_DT],			
			s.PreexistingDate [PREX_DT],
			s.Email [EMAIL],
			s.SubStreet1 ADDR1,
			s.SubStreet2 ADDR2,
			s.SubCity CITY,
			s.SubState [STATE],
			s.SubZip ZIP,
			s.SubPhoneWork PHONE_WORK,
			s.SubPhoneHome PHONE_HOME,			
            s.DepCnt AS NO_DEP,
            0 REL,
            s.SubCardPrt CARD_PRT,
            s.SubCardPrtDte CARD_PRT_DT,
            1 MBR_ST,
            GetDate() DT_UPDT            
        FROM dbo.tblSubscr s
        INNER JOIN tblGrp g
			on s.SubGroupId = g.GroupID
        WHERE ( s.SubCancelled = 1 )  
            
        UNION
        
    SELECT g.GroupType GRP_TYPE,
			'D' RCD_TYPE, 
			s.SubSSN SSN,
			d.SubID SUB_ID,
			d.DepSSN DEP_SSN,
			d.DepLastName LAST_NAME,
			d.DepFirstName FIRST_NAME,
			d.DepMiddleName MI,
			d.DepDOB DOB,			
			s.SubGroupID GRP_ID, 
			s.PlanID [PLAN], 
			s.CoverID COV,
			COALESCE(d.DepEffDate, s.SubEffDate) [EFF_DT],			
			COALESCE(d.PreexistingDate, s.PreexistingDate) [PREX_DT],
			s.Email [EMAIL],
			s.SubStreet1 ADDR1,
			s.SubStreet2 ADDR2,
			s.SubCity CITY,
			s.SubState [STATE],
			s.SubZip ZIP,
			s.SubPhoneWork PHONE_WORK,
			s.SubPhoneHome PHONE_HOME,			
            0 AS NO_DEP,            
            CASE
				WHEN DepRelationship = 'S' THEN 1
				WHEN DepRelationship = 'C' THEN 2
				WHEN DepRelationship = 'O' THEN 3
				ELSE 2
			END REL,
            s.SubCardPrt CARD_PRT,
            s.SubCardPrtDte CARD_PRT_DT,
            1 MBR_ST,
            GetDate() DT_UPDT 
			from tblDependent d
				inner join tblSubscr s
					on d.DepSubID = s.SubSSN
				inner join tblGrp g
					on s.SubGroupID = g.GroupID
			WHERE ( s.SubCancelled = 1 );
GO
