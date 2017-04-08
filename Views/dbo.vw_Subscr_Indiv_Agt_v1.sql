SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dbo].[vw_Subscr_Indiv_Agt_v1]
AS
/* =============================================
	Object:			vw_Subscr_Indiv_Agt
	Author:			John Criswell
	Create date:	9/2/2014	 
	Description:	List of indiviudal subscribers
					and their assigned Agent
					
	Change Log:
	--------------------------------------------
	Change Date		Changed by		Reason
	
	
	
============================================= */
SELECT  s.SubID ,
        s.SubSSN ,
        ISNULL(s.SubLastName, '') SubLastName ,
        ISNULL(s.SubFirstName, '') SubFirstName ,
        s.SubStatus ,
        s.SubCancelled ,
        s.SubGroupID ,
        a.AgentId ,
        a.Agency ,
        ISNULL(a.AgentSSN,'') AgentSSN ,
        ISNULL(a.AgentLast,'') AgentLast ,
        ISNULL(a.AgentFirst, '') AgentFirst ,
        ia.[Primary] ,
        ISNULL(ia.AgentRate,0) AgentRate ,
        ISNULL(ia.CommOwed, 0) CommOwed ,
        ia.Sort ,
        s.PlanID ,
        s.CoverID ,
        s.RateID
FROM    tblAgent AS a
        INNER JOIN tblIndivAgt AS ia ON a.AgentID = ia.AgentID
        INNER JOIN tblSubscr AS s ON ia.SubscrID = s.SubID
        INNER JOIN tblGrp AS g ON s.SubGroupID = g.GroupID
WHERE	g.GroupType = 9;





GO
