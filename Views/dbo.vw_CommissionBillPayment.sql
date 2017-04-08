SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_CommissionBillPayment]
AS

/* ====================================================================================
	Object:			vw_CommissionBillPayment
	Author:			John Criswell
	Create date:	2015-12-03	 
	Description:	Show all the checks/bill payments written to agensts
	Called from:	Form_Agent Bill Payment		
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-12-03		1.0			J Criswell		Created
	
	
======================================================================================= */ 		
SELECT bpc.TxnID, bpc.TimeCreated, rtrim(bpc.TxnNumber) TxnNumber, 
	rtrim(v.AccountNumber) AccountNumber, convert(nvarchar(12),rtrim(bpc.RefNumber)) 
	RefNumber, bpc.TxnDate, bpc.Amount, rtrim(bpc.Memo) Memo
FROM QuickBooks.dbo.billpaymentcheck AS bpc
INNER JOIN QuickBooks.dbo.vendor AS v
	ON bpc.PayeeEntityRef_FullName = v.NAME
INNER JOIN tblAgent AS a
	ON v.AccountNumber = a.AgentId;

GO
