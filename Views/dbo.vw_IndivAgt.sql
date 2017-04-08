SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_IndivAgt]
WITH SCHEMABINDING
AS
SELECT  ia.ID ,
        ia.AgentID ,
        ia.SubscrId ,
        ia.PltCustKey,        
        ia.AgentRate ,
        ISNULL(ia.CommOwed, 0) CommOwed ,
        ia.Sort
FROM    dbo.tblIndivAgt ia
	INNER JOIN dbo.tblSubscr s
		ON ia.SubscrID = s.SubID
WHERE s.SubCancelled = 1;
GO
CREATE UNIQUE CLUSTERED INDEX [CLIX_vw_AgtIndiv_AgentID_PltCustKey] ON [dbo].[vw_IndivAgt] ([AgentID], [PltCustKey]) ON [PRIMARY]
GO
