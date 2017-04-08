SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_tpa_plan_cover]
as
SELECT t.SSN
	, t.GRP_ID
	, t.[PLAN]
	, t.COV
FROM tpa_data_exchange_sub t
	INNER JOIN tblGrp g
		ON t.GRP_ID = g.GroupID
	LEFT OUTER JOIN tblRates r
		ON t.COV = r.CoverID
		AND t.[PLAN] = r.PlanID
		AND t.GRP_ID = r.GroupID
WHERE (g.GRCancelled = 0)
	AND (g.GroupType = 4)	
	AND 
	((r.GroupID IS NULL)
	OR (r.PlanID IS NULL)
	OR (r.CoverID IS NULL));
GO
