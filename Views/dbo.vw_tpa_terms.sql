SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- select * from vw_tpa_terms

CREATE VIEW [dbo].[vw_tpa_terms]
AS
/* ====================================================================================
	Object:			
	Author:			John Criswell
	Create date:		 
	Description:
	Called from:			
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-10-27		4			J Criswell		Added PLAN, COV and MBR_ST to view.
	
	
======================================================================================= */ 
/*  terminations  */

	/*  subscribers  */ 

	--mis-match
	SELECT 'S' AS RCD_TYPE
		, s.SubSSN AS SSN
		, s.SubID AS SUB_ID
		, '' DEP_SSN
		, s.DepCnt AS NO_DEP
		, s.EIMBRID AS MBR_ID
		, s.SubGroupID AS GRP_ID
		, s.SubLastName AS LAST_NAME
		, s.SubFirstName AS FIRST_NAME
		, s.SubMiddleName AS MI
		, s.SubDOB AS DOB
		, s.SubEffDate AS EFF_DT
		, s.PreexistingDate AS PREX_DT
		, s.SubGender AS GENDER
		, '' AS REL
		, s.PlanID AS [PLAN]
		, s.CoverID AS COV
		, 3 AS MBR_ST
	FROM tblSubscr AS s
	INNER JOIN tblGrp g
		ON s.SubGroupID = g.GroupID
	LEFT OUTER JOIN (
		SELECT r.SSN
			, r.DT_UPDT
		FROM tpa_data_exchange_sub r
		INNER JOIN tblGrp g
			ON r.GRP_ID = g.GroupID
		WHERE r.RCD_TYPE = 'S' -- subscribers only
			AND r.GRP_TYPE = 4 -- All American groups only
			AND g.GRCancelled = 0 -- active groups only
		) r
		ON s.SubSSN = r.SSN
	WHERE (r.SSN IS NULL)
		AND (g.GroupType = 4) -- All American groups only
		AND (g.GRCancelled = 0) -- active groups only
		AND (s.SubCancelled = 1) -- active subscribers only
		
	UNION ALL

	/*  tpa identified  */
	SELECT r.RCD_TYPE
		, r.SSN
		, r.SUB_ID
		, '' DEP_SSN
		, r.NO_DEP
		, r.MBR_ID
		, r.GRP_ID
		, r.LAST_NAME
		, r.FIRST_NAME
		, r.MI
		, r.DOB
		, r.EFF_DT
		, r.PREX_DT
		, r.GENDER
		, '' AS REL
		, r.[PLAN]
		, r.COV
		, r.MBR_ST
	FROM tpa_data_exchange_sub r
	INNER JOIN tblSubscr s
		ON r.SSN = s.SubSSN
	WHERE MBR_ST = 3
		AND GRP_TYPE = 4

	UNION ALL	
	/*  dependents  */

	-- mismatch
	SELECT qcd.RCD_TYPE
		, qcd.SSN
		, qcd.SUB_ID
		, qcd.DEP_SSN
		, qcd.NO_DEP
		, qcd.MBR_ID
		, qcd.GRP_ID
		, qcd.LAST_NAME
		, qcd.FIRST_NAME
		, qcd.MI
		, qcd.DOB
		, qcd.EFF_DT
		, qcd.PREX_DT
		, qcd.GENDER
		, qcd.REL
		, qcd.[PLAN]
		, qcd.COV
		, qcd.MBR_ST
	FROM (
		-- qcd deps
		SELECT 'D' AS RCD_TYPE
				, d.SubSSN AS SSN
				, d.SubID AS SUB_ID
				, d.DepSSN AS DEP_SSN
				, 0 AS NO_DEP
				, d.EIMBRID AS MBR_ID
				, d.SubGroupID AS GRP_ID
				, d.DepLastName AS LAST_NAME
				, d.DepFirstName AS FIRST_NAME
				, d.DepMiddleName AS MI
				, d.DepDOB AS DOB
				, d.DepEffDate AS EFF_DT
				, d.DepPrexDate AS PREX_DT
				, d.DepGender AS GENDER
				, d.DepRel AS REL
				, 0 AS [PLAN]
				, 0 AS COV
				, 3 AS MBR_ST
		FROM vw_GrpDep AS d
		WHERE d.GrpCancel = 'Active'
			AND d.SubCancel = 'Active'
			AND d.GrpType = 'All American'
			AND d.DepCancel = 'Active'
		) qcd
	LEFT OUTER JOIN (
		-- tpa deps
		SELECT MBR_ID
		FROM tpa_data_exchange_dep
		WHERE GRP_TYPE = 4
			AND (MBR_ST IN (1, 2))
		) dca
		ON ISNULL(qcd.MBR_ID, '') = ISNULL(dca.MBR_ID, '')
	WHERE dca.MBR_ID IS NULL

	UNION ALL

	/* tpa identified  */
	SELECT RCD_TYPE
		, r.SSN
		, r.SUB_ID
		, r.DEP_SSN
		, r.NO_DEP
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
			WHEN r.REL = 1 THEN 'S'
			WHEN r.REL = 2 THEN 'C'
			WHEN r.REL = 3 THEN 'O'
			ELSE 'O'
		END AS REL
		, ISNULL(r.[PLAN], 0) AS [PLAN]
		, ISNULL(r.COV , 0) AS COV
		, ISNULL(r.MBR_ST, 3) AS MBR_ST
	FROM tpa_data_exchange_dep r
	INNER JOIN tblDependent d
		ON r.MBR_ID = d.EIMBRID
	WHERE r.RCD_TYPE = 'D'
		AND r.MBR_ST = 3
		AND r.GRP_TYPE = 4
		AND ISNULL(d.DepCancelled, 1) = 1;




GO
