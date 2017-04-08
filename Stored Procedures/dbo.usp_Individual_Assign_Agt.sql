SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_Individual_Assign_Agt] 
		(
		@SubID NCHAR(8),
		@CustKey NCHAR(5)
		)
AS
INSERT INTO tblIndivAgt (
	AgentID
	, SubscrID
	, PltCustKey
	, [PRIMARY]	
	, AgentRate
	, CommOwed
	)
VALUES (
	'CORPT'
	, @SubID
	, @CustKey
	, 1
	, 0
	, 0
	)
	RETURN 1
	;


GO
EXEC sp_addextendedproperty N'Purpose', N'creates the default agent for individuals', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_Individual_Assign_Agt', NULL, NULL
GO
