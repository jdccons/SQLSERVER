SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_IndivBillingGroup]
as
    SELECT DISTINCT
        [pi].PlanIndType ,
        [pi].PlanIndDesc ,
        [pi].PlanMonths ,
        [pi].GroupID ,
        [pi].CoverID ,
        [pi].PlanID ,
        [pi].ID
    FROM
        tblSubscr AS s
        INNER JOIN tblPlanIndiv AS [pi]
            ON s.PlanID = [pi].PlanID
               AND s.CoverID = [pi].CoverID
               AND s.SubGroupID = [pi].GroupID;
GO
