SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--select * from vw_tpa_adds

CREATE VIEW [dbo].[vw_tpa_adds]
AS
/* ====================================================================================
	Object:			vw_tpa_adds
	Author:			John Criswell
	Create date:	2015-10-22	 
	Description:	Lists all the new subscribers and dependents since
					the last tpa synchronization
	Called from:			
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-10-22		1.0			J Criswell		Created
	2015-10-27		2.0			J Criswell		Added PLAN, COV and MBR_ST to view
	
======================================================================================= */ 
	/*  new subscribers and deps  */
	-- subscribers
	SELECT r.RCD_TYPE
		, r.SSN
		, r.SUB_ID
		, '' DEP_SSN
		, r.NO_DEP
		, r.MBR_ID
		, r.GRP_ID
		, r.LAST_NAME
		, r.FIRST_NAME
		, ISNULL(r.MI, '') AS MI
		, r.DOB
		, r.EFF_DT
		, r.PREX_DT
		, r.GENDER
		, r.REL
		, r.[PLAN]
		, r.COV
		, r.MBR_ST
	FROM (
		/*  All American Subscribers from QCD database   */
		SELECT s.SubSSN
			, s.SubID
			, s.SubLastName
			, s.SubFirstName
			, s.SubMiddleName
			, s.SubGroupID
			, s.SubCancelled
			, g.GRCancelled
			, g.GroupType
		FROM tblSubscr s
		INNER JOIN tblGrp g
			ON s.SubGroupID = g.GroupID
		WHERE g.GroupType IN (4) -- All American groups only
			AND g.GRCancelled = 0 -- active groups only	
			AND s.SubCancelled = 1 -- active subscribers only
		) s
	RIGHT OUTER JOIN (
		/*  Direct Care Administrators All American Subscribers  */
		SELECT r.RCD_TYPE
			, r.SSN
			, r.SUB_ID
			, r.MBR_ID
			, ISNULL(r.LAST_NAME, '') LAST_NAME
			, ISNULL(r.FIRST_NAME, '') FIRST_NAME
			, r.MI
			, r.GRP_ID
			, r.DOB
			, r.EFF_DT
			, r.PREX_DT
			, r.GENDER
			, r.NO_DEP
			,  CASE 
					WHEN r.REL = 0 THEN '' 
					WHEN r.REL = 1 THEN 'S' 
					WHEN r.REL = 2 THEN 'C' 
					WHEN r.REL = 3 THEN 'O' 
					ELSE '' 
				END	AS	REL
			, r.[PLAN]
			, r.COV
			, r.MBR_ST
		FROM tpa_data_exchange_sub r
		INNER JOIN tblGrp g
			ON r.GRP_ID = g.GroupID
		WHERE r.RCD_TYPE = 'S' -- subscribers only
			AND r.GRP_TYPE = 4 -- All American groups only
			AND g.GRCancelled = 0 -- active groups only
			AND (r.MBR_ST IN (1, 2)) -- only add and change transactions from tpa
		) r
		ON ISNULL(s.SubSSN, '') = ISNULL(r.SSN, '')
	WHERE (s.SubSSN IS NULL)

	UNION ALL

	-- dependents
	/*  tpa deps  */
	SELECT r.RCD_TYPE
		, r.SSN
		, r.SUB_ID
		, r.DEP_SSN
		, 0 NO_DEP
		, r.MBR_ID
		, r.GRP_ID
		, r.LAST_NAME
		, r.FIRST_NAME
		, r.MI
		, r.DOB
		, r.EFF_DT
		, r.PREX_DT
		, r.GENDER
		, CASE 
			WHEN r.REL = 0 THEN '' 
			WHEN r.REL = 1 THEN 'S' 
			WHEN r.REL = 2 THEN 'C' 
			WHEN r.REL = 3 THEN 'O' 
			ELSE '' 
		END AS REL
		, ISNULL(r.[PLAN], 0) AS [PLAN]
		, ISNULL(r.COV , 0) AS COV
		, ISNULL(r.MBR_ST, 0) AS MBR_ST
	FROM tpa_data_exchange_dep r
	INNER JOIN tblGrp g
		ON r.GRP_ID = g.GroupID
	LEFT OUTER JOIN
		/*  dependents who are in existing tblDependent filtered on active groups and subscribers  */
		(			
		SELECT d.EIMBRID
		FROM vw_GrpDep d
		WHERE d.GrpCancel = 'Active'
			AND d.GrpType = 'All American'
			AND d.SubCancel = 'Active'
			AND d.DepCancel = 'Active'		
		) m
		ON ISNULL(r.MBR_ID,'') = ISNULL(m.EIMBRID,'')
	WHERE m.EIMBRID IS NULL
	AND r.MBR_ST IN (1,2);




GO
