SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_Agent]
WITH SCHEMABINDING
AS
    SELECT  ID ,
            AgentID ,
            GroupID ,
            AgentRate ,
            CommOwed ,
            Sort
    FROM    dbo.vw_GrpAgt
    UNION
    SELECT  ID ,
            AgentID ,
            PltCustKey as GroupID,
            AgentRate ,
            CommOwed ,
            Sort
    FROM    dbo.vw_IndivAgt;

GO
