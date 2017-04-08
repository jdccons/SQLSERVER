SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_GrpAgt]
WITH SCHEMABINDING
as
/* =============================================================
	Object:			vw_GrpAgt
	Version:		2
	Author:			John Criswell
	Create date:	2017-04-06 
	Description:	List of Agents assigned to groups
								
							
	Change Log:
	--------------------------------------------
	Change Date		Version			Changed by		Reason
	2015-01-09		1.0				JCriswell		Created
	2017-04-06		2.0				JCriswell		Added rank function to
													create field called level;
													this decides priority for multiple
													agents for the group
================================================================ */
SELECT  ID ,
        AgentID ,
        GroupID ,
        AgentRate ,
        ISNULL(CommOwed, 0) CommOwed ,
        Sort ,
        RANK() OVER ( PARTITION BY GroupID ORDER BY AgentRate DESC, AgentId ) [Level]
FROM    dbo.tblGrpAgt

GO
