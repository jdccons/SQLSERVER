SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_Commission_Individual]
 
AS
	/*  individual transactions  */ 
    SELECT  
			ia.AgentId ,
            RTRIM(COALESCE(NULLIF(RTRIM(a.AgentLast), N'') + ', ', N'')
                  + COALESCE(NULLIF(RTRIM(a.AgentFirst), N'') + ' ', N'')) AgentName ,
            a.Agency Agency ,
            a.AgentActive [Active] ,
            art.CustomerKey ,
            art.DocumentNumber AS CheckNo ,
            CONVERT(CHAR(4), DocumentDate, 120)
            + CONVERT(CHAR(2), DocumentDate, 101) CommMonth ,
            art.DocumentDate CheckDate ,
            ISNULL(( art.DocumentAmt * -1 ), 0) AS CheckAmt ,
            ISNULL(ia.AgentRATE, 0) AS AgentRate ,
            ( ISNULL(( art.DocumentAmt * -1 ), 0) * ISNULL(ia.AgentRATE, 0) ) AS CommDue ,
            CASE WHEN PayCommTo = 0 THEN 'Prospective Agent'
                 WHEN PayCommTo = 1 THEN 'Agency'
                 WHEN PayCommto = 2 THEN 'Agent within Agency'
                 WHEN PayCommTo = 3 THEN 'Independent Agent'
                 WHEN PayCommTo = 4 THEN 'Employee'
                 ELSE 'Unknown'
            END AgentType ,
            ISNULL(art.ApplyTo, '') InvoiceNo ,
            art.CustomerClassKey ,
            0 EnrollmentFee ,
            a.PayCommTo PayCommTo
    FROM    dbo.ARTRANH_local art
            INNER JOIN dbo.tblIndivAgt ia ON art.Spare = ia.SubscrID
            INNER JOIN dbo.tblAgent a ON ia.AgentID = a.AgentID            
    WHERE   art.TransactionType <> 'I'
            AND art.CustomerClassKey = 'INDIV'
            AND ( ia.AgentId <> 'CORPT' )
            AND ( ia.AgentId <> 'CORP' );



GO
