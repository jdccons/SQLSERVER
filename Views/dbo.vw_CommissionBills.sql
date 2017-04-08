SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_CommissionBills]
as
SELECT AgentType
		, AgentID
		, AgentName
		, Agency
		, CommMonth
		, SUM(CommDue) AS SumOfCommDue
		, MAX(CheckDate) CheckDate
		, PayCommTo
	FROM vw_Commission AS c
	WHERE (PayCommTo IN (1, 2, 3))
	GROUP BY AgentType
		, AgentID
		, AgentName
		, Agency
		, CommMonth
		, PayCommTo

GO
