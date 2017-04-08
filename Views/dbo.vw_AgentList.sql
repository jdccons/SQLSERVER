SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_AgentList]
WITH SCHEMABINDING
AS
SELECT AgentID, 
		COALESCE(Agency, ISNULL(COALESCE(NULLIF(RTRIM(AgentLast), N'') + ', ', N'') + RTRIM(AgentFirst), ''), 'NO NAME') AS AgencyName, 
		CASE 
		WHEN PayCommTo = 1
			THEN 'Agency'
		WHEN PayCommTo = 2
			THEN 'Agent within Agency'
		WHEN PayCommTo = 3
			THEN 'Independent Agent'
		END AgentType, 
		ISNULL(COALESCE(NULLIF(RTRIM(AgentLast), N'') + ', ', N'') + RTRIM(AgentFirst), '') AgentName, 
		ISNULL(AgentSSN, '') AgentSSN, 
		RTRIM(AgentStreet1) AgentStreet1, 
		ISNULL(RTRIM(AgentStreet2), '') AS AgentStreet2, 
		AgentCity, 
		AgentState, 
		AgentZip, 
		AgentPhone, 
		ISNULL(AgentCell, '') AgentCell, 
		ISNULL(AgentEmail, '') AgentEmail, 
		ISNULL(AgentTaxId, '') AgentTaxId, 
		AgentActive, 
		PayCommTo
FROM dbo.tblAgent
WHERE PayCommTo IN (1, 2, 3);

GO
