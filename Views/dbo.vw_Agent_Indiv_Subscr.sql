SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Agent_Indiv_Subscr]
AS
SELECT DISTINCT ia.AgentId, a.Agent_LUname, a.Agency
FROM tblIndivAgt AS ia
INNER JOIN tblAgent AS a ON ia.AgentId = a.AgentId
INNER JOIN tblSubscr s ON ia.PltCustKey = s.PltCustKey
WHERE (
		((a.AgentActive) = 'A')
		AND (s.SubCancelled = 1)
		AND (a.PayCommTo IN (1, 2, 3))
		);


GO
