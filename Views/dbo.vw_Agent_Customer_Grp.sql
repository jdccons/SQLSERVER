SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_Agent_Customer_Grp]
WITH SCHEMABINDING
AS


SELECT  a.AgentID, 
		COALESCE(a.Agency, ISNULL(COALESCE(NULLIF(RTRIM(a.AgentLast), N'') + ', ', N'') + RTRIM(a.AgentFirst), ''), 'NO NAME') AS AgencyName, 
		CASE 
			WHEN a.PayCommTo = 1
				THEN 'Agency'
			WHEN a.PayCommTo = 2
				THEN 'Agent within Agency'
			WHEN a.PayCommTo = 3
				THEN 'Independent Agent'
			ELSE 'Employee'
		END AgentType, 
		ISNULL(COALESCE(NULLIF(RTRIM(AgentLast), N'') + ', ', N'') + RTRIM(AgentFirst), '') AgentName,
		g.GroupId CustomerKey ,
        CAST(g.GRName AS NVARCHAR(50)) CustomerName ,
        g.GRGeoID TerritoryKey ,
        ISNULL(g.GRStreet1, '') CustomerAddress1 ,
        ISNULL(g.GRStreet2, '') CustomerAddress2 ,
        g.GRCity CustomerCity ,
        g.GRState CustomerState ,
        g.GRZip CustomerZipCode ,
        ISNULL(g.GRMainCont, '') ContactName ,
        ISNULL(g.GREmail, '') EmailAddress ,
        ISNULL(g.GRPhone1, '') ContactPhone ,
        ISNULL(g.GRemail, '') TelexNumber ,
        'GROUP' CustomerClassKey ,
        '' LocationKey ,
        CASE WHEN g.GRCancelled = 1 THEN 'Y'
             WHEN g.GRCancelled = 0 THEN 'N'
             ELSE 'Y'
        END CreditHold ,
        '' Spare ,
        '' Spare2 ,
        CASE WHEN g.GroupType = '1' THEN 'QCD Only'
             WHEN g.GroupType = '4' THEN 'All American'
             ELSE 'Unknown'
        END Spare3
FROM    dbo.tblGrp g
	INNER JOIN dbo.tblGrpAgt ga ON ga.GroupID = g.GroupID
	INNER JOIN dbo.tblAgent a ON a.AgentID = ga.AgentID;


GO
