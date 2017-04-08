SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_IndividualSubscriber]
AS
SELECT DISTINCT
        s.SubID, s.SubSSN, CASE WHEN s.SubCancelled = 1 THEN 'Active'
                                WHEN s.SubCancelled = 3 THEN 'Canceled'
                                ELSE 'Unknown'
                           END SubCancelled, s.SubLastName, s.SubFirstName,
        s.SubContBeg, s.SubContEnd, r.Rate, [pi].PlanIndType, c.CoverDescr,
        ia.AgentId
FROM    dbo.tblGrp g
        INNER JOIN tblSubscr s ON g.GroupID = s.SubGroupID
        INNER JOIN tblRates r ON s.PlanID = r.PlanID
                                 AND s.CoverID = r.CoverID
                                 AND s.SubGroupID = r.GroupID
        INNER JOIN dbo.tblIndivAgt ia ON s.PltCustKey = ia.PltCustKey
        INNER JOIN dbo.tblPlanIndiv [pi] ON pi.CoverID = s.CoverID
                                            AND pi.PlanID = s.PlanID
                                            AND pi.GroupID = s.SubGroupID
        INNER JOIN dbo.tblCoverage c ON s.CoverID = c.CoverID
WHERE   g.GroupID IN ( 'INDVM', 'INDV1', 'INDV2', 'INDV3' );  


GO
EXEC sp_addextendedproperty N'MS_Description', N'Individual subscriber information including AgentID, Plan, Cover and coverage dates.', 'SCHEMA', N'dbo', 'VIEW', N'vw_IndividualSubscriber', NULL, NULL
GO
