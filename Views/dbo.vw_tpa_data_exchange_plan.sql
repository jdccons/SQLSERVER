SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_tpa_data_exchange_plan]
AS
SELECT r.GroupID GRP_ID, r.PlanID [PLAN], r.PlanDesc [PLAN_DESC], r.CoverID COVER, r.CoverDescr COV_DESC FROM vwRates r
INNER JOIN tblGrp g
	ON r.GroupID = g.GroupID
	WHERE g.GRCancelled = 0;
GO
