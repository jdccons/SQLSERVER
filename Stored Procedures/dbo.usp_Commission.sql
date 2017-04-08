SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[usp_Commission]
    (
      @BeginDate DATETIME ,
      @EndDate DATETIME
    )
AS 
/* =====================================================
	Object:			usp_Commission
	Version:		1
	Author:			John Criswell
	Create date:	2014-09-03	 
	Description:	Pulls ARTRANH_local data into
					tblCommission in order to run
					commission report  
					
							
	Change Log:
	-----------------------------------------------------
	Change Date		Version		Changed by		Reason
	2014-09-03		1.0			J Criswell		Created
	
	
========================================================= */
    DELETE FROM tblCommission;

	/*  individual payments inserted into tblCommission */
    INSERT  INTO tblCommission ( CommCustKey, CommCustName, CommCheckNo,
                                 CommInvoiceNo, CommOrderNo, CommCheckAmt,
                                 CommAgent, CommRate, CommCustClass,
                                 CommCheckDate, CommAgentType )
            SELECT  art.CustomerKey CustKey, s.Sub_LUName CustName,
                    ISNULL(art.DocumentNumber, '') CheckNo,
                    ISNULL(art.ApplyTo, '') InvoiceNo,
                    ISNULL(art.OrderNumber, '') OrderNumber,
                    SUM(( [art].[DocumentAmt] * ( -1 ) )) AS CheckAmt,
                    a.AgentId Agent, ISNULL(ia.AgentRate, 0) Rate,
                    art.CustomerClassKey CustClass, art.DocumentDate CheckDate,
                    a.PayCommTo AgentType
            FROM    ARTRANH_local art
                    INNER JOIN tblSubscr s ON art.CustomerKey = s.PltCustKey
                    INNER JOIN tblIndivAgt ia ON s.SubID = ia.SubscrId
                    INNER JOIN tblAgent a ON ia.AgentId = a.AgentId
            WHERE   ( ( ( art.CustomerClassKey ) = 'INDIV' )
                      AND ( MONTH(DocumentDate) = MONTH(@BeginDate) )
                      AND ( YEAR(DocumentDate) = YEAR(@BeginDate) )
                      AND ( ( art.TransactionType ) = 'P' )
                    )
            GROUP BY art.CustomerKey, s.Sub_LUName, art.DocumentNumber,
                    art.ApplyTo, art.OrderNumber, a.AgentId, ia.AgentRate,
                    art.CustomerClassKey, art.DocumentDate, a.PayCommTo;
        
	/*  group payments inserted into tblCommission */
    INSERT  INTO tblCommission ( CommCustKey, CommCustName, CommCheckNo,
                                 CommOrderNo, CommInvoiceNo, CommCheckAmt,
                                 CommAgent, CommRate, CommCustClass,
                                 CommCheckDate, CommAgentType )
            SELECT  art.CustomerKey AS CustKey, g.GRName AS CustName,
                    ISNULL(art.DocumentNumber, N'') AS CheckNo,
                    ISNULL(art.OrderNumber, N'') AS CommOrderNo,
                    ISNULL(art.ApplyTo, N'') AS CommInvoiceNo,
                    ISNULL(art.DocumentAmt, 0) * -1 AS CheckAmt,
                    ga.AgentId AS Agent, ga.AgentRate AS Rate,
                    art.CustomerClassKey AS CustClass,
                    art.DocumentDate AS CheckDate, a.PayCommTo AS AgentType
            FROM    ARTRANH_local AS art
                    INNER JOIN tblGrp AS g ON art.CustomerKey = g.GroupID
                    INNER JOIN tblGrpAgt AS ga ON g.GroupID = ga.GroupId
                    INNER JOIN tblAgent AS a ON ga.AgentId = a.AgentId
            WHERE   ( MONTH(art.DocumentDate) = MONTH(@BeginDate) )
                    AND ( YEAR(art.DocumentDate) = YEAR(@BeginDate) )
                    AND ( art.TransactionType = 'P' );
    
    /* update pay commission to*/                
    UPDATE  tblCommission
    SET     tblCommission.PayCommTo = [tblAgent].[PayCommTo]
    FROM    tblCommission
            INNER JOIN tblAgent ON tblCommission.CommAgent = tblAgent.AgentId;



GO
EXEC sp_addextendedproperty N'Purpose', N'Pulls ARTRANH_local data into tblCommission in order to run commission report', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_Commission', NULL, NULL
GO
