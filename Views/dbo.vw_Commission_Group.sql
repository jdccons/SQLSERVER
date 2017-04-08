SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Commission_Group]
AS
SELECT ga.AgentId
			, RTRIM(COALESCE(NULLIF(RTRIM(a.AgentLast), N'') + ', ', N'') + 
				COALESCE(NULLIF(RTRIM(a.AgentFirst), N'') + ' ', N'')) 
			AgentName
			, a.Agency Agency
			, a.AGENTactive [Active]
			, art.CustomerKey
			, art.DocumentNumber AS CheckNo
			, CONVERT(CHAR(4), DocumentDate, 120) + CONVERT(CHAR(2), 
				DocumentDate, 101) CommMonth
			, art.DocumentDate CheckDate
			, ISNULL((art.DocumentAmt * - 1), 0) AS CheckAmt
			, ISNULL(ga.AgentRATE, 0) AS AgentRate
			, (
				ISNULL((art.DocumentAmt * - 1), 0) * ISNULL(ga.
					AgentRATE, 0)
				) AS CommDue
			, CASE 
					WHEN a.PayCommTo = 0 THEN 'Prospective Agent' 
					WHEN a.PayCommTo = 1 THEN 'Agency' 
					WHEN a.PayCommto = 2 THEN 'Agent within Agency' 
					WHEN a.PayCommTo = 3 THEN 'Independent Agent' 
					WHEN a.PayCommTo = 4 THEN 'Employee' 
					ELSE 'Unknown' 
			END AgentType
			, ISNULL(art.ApplyTo, '') InvoiceNo
			, art.CustomerClassKey
			, 0 EnrollmentFee
			, a.PayCommTo PayCommTo
		FROM dbo.ARTRANH_local art
		INNER JOIN dbo.tblGrpAgt ga
			ON art.CustomerKey = ga.GroupID
		INNER JOIN dbo.tblAgent a
			ON ga.AgentID = a.AgentID
		WHERE art.TransactionType <> 'I'
			AND (art.CustomerClassKey = 'GROUP')
			AND (ga.AgentId <> 'CORPT')
			AND (ga.AgentId <> 'CORP' );
GO
