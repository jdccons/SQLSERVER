SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_CommissionCheck]
AS

/* ====================================================================================
	Object:			vw_CommissionCheck
	Author:			John Criswell
	Create date:	2015-12-01	 
	Description:	Brief listing of payment transactions in ARTRANH_local.  These payments 
					result in amounts to be used in calculation of commissions due to agents.
	Called from:			
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-12-01		1.0			J Criswell		Created
	
	
======================================================================================= */ 

/*  individual commissionable payments  */
SELECT DISTINCT art.CustomerKey CustKey
	, art.OrderNumber
	, art.DocumentDate
	, isnull(art.DocumentAmt, 0) * - 1 AS CheckAmt
FROM ARTRANH_local art
WHERE (
		((art.CustomerClassKey) = 'INDIV'
			)
		AND ((art.TransactionType) = 'P'
			)
		)

UNION

/*  group commissionable payments  */
SELECT DISTINCT art.CustomerKey AS CustKey
	, art.OrderNumber
	, art.DocumentDate
	, ISNULL(art.DocumentAmt, 0) * - 1 AS CheckAmt
FROM ARTRANH_local AS art
WHERE (
		((art.CustomerClassKey) = 'GROUP'
			)
		AND ((art.TransactionType) = 'P'
			)
		)
 

	

GO
