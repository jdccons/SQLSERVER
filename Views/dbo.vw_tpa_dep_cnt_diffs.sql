SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_tpa_dep_cnt_diffs]
AS
/* ====================================================================================
	Object:			vw_tpa_dep_cnt_diffs
	Author:			Tim Cook
	Create date:	2007-01-01	 
	Description:	Comparison of depdendent counts by subscriber -
					tpa versus QCD
					populates a temporary report table
	Called from:	fdlgAASync.cmdPrint
	Report name:	rptAA_NewSubscribers	
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2007-01-01		1.0			T Cook			Created
	2015-10-20		2.0			J Criswell		Simplified the original view
	
	
======================================================================================= */ 
SELECT l.SubSSN
FROM (
	SELECT SubSSN
		, COUNT(SubSSN) DepCnt
	FROM vw_GrpDep
	WHERE GrpCancel = 'Active'
		AND GrpType = 'All American'
		AND SubCancel = 'Active'
	GROUP BY SubSSN
	) l --1218
INNER JOIN (
	SELECT SSN
		, count(SSN) NO_DEP
	FROM tpa_data_exchange_dep
	WHERE GRP_TYPE = 4
		AND MBR_ST IN (1, 2)
	GROUP BY SSN
	) r
	ON l.SubSSN = r.SSN
WHERE l.DepCnt != r.NO_DEP;

GO
