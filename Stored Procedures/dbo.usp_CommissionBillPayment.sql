SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_CommissionBillPayment]
    (
      @InvoiceDate AS DATETIME
			
    )
AS 
/* ====================================================================================
	Object:			usp_CommissionBillPayment
	Author:			John Criswell
	Create date:	2015-12-01	 
	Description:	Pulls paid commission transactions to agents from QuickBooks and
					populates table in Access
	Called from:	frmCommissionBillPayment		
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-12-01		1.0			J Criswell		Created
	
	
======================================================================================= */ 
    INSERT  INTO tblCommissionBillPayment ( TxnID, TimeCreated, TimeModified,
                                            EditSequence, TxnNumber,
                                            PayeeEntityRef_ListID,
                                            PayeeEntityRef_FullName,
                                            AccountNumber, APAccountRef_ListID,
                                            TxnDate, BankAccountRef_ListID,
                                            BankAccountRef_FullName, Amount,
                                            CurrencyRef_ListID,
                                            CurrencyRef_FullName, ExchangeRate,
                                            AmountInHomeCurrency, RefNumber,
                                            Memo, Address_Addr1, Address_Addr2,
                                            Address_City, Address_State,
                                            Address_PostalCode,
                                            Address_Country, Address_Note,
                                            IsToBePrinted, Status )
            SELECT  DISTINCT CONVERT(VARCHAR(20), bpc.TxnID) TxnID, bpc.TimeCreated,
                    bpc.TimeModified,
                    CONVERT(VARCHAR(15), bpc.EditSequence) EditSequence,
                    bpc.TxnNumber,
                    CONVERT(VARCHAR(30), bpc.PayeeEntityRef_ListID) PayeeEntityRef_ListID,
                    CONVERT(VARCHAR(50), bpc.PayeeEntityRef_FullName) PayeeEntityRef_FullName,
                    CONVERT(VARCHAR(5), v.AccountNumber) AccountNumber,
                    CONVERT(VARCHAR(30), bpc.APAccountRef_ListID) APAccountRef_ListID,
                    bpc.TxnDate,
                    CONVERT(VARCHAR(30), bpc.BankAccountRef_ListID) BankAccountRef_ListID,
                    CONVERT(VARCHAR(30), bpc.BankAccountRef_FullName) BankAccountRef_FullName,
                    bpc.Amount,
                    CONVERT(VARCHAR(30), bpc.CurrencyRef_ListID) CurrencyRef_ListID,
                    CONVERT(VARCHAR(30), bpc.CurrencyRef_FullName) CurrencyRef_FullName,
                    bpc.ExchangeRate, bpc.AmountInHomeCurrency,
                    CONVERT(VARCHAR(15), bpc.RefNumber) RefNumber, bpc.Memo,
                    CONVERT(VARCHAR(50), bpc.Address_Addr1) Address_Addr1,
                    CONVERT(VARCHAR(50), bpc.Address_Addr2) Address_Addr2,
                    CONVERT(VARCHAR(50), bpc.Address_City) Address_City,
                    CONVERT(VARCHAR(2), bpc.Address_State) Address_State,
                    CONVERT(VARCHAR(12), bpc.Address_PostalCode) Address_PostalCode,
                    CONVERT(VARCHAR(50), bpc.Address_Country) Address_Country,
                    bpc.Address_Note, bpc.IsToBePrinted, bpc.Status
            FROM    QuickBooks.dbo.billpaymentcheck AS bpc
                    INNER JOIN QuickBooks.dbo.vendor AS v ON bpc.PayeeEntityRef_FullName = v.Name
                    INNER JOIN dbo.tblAgent AS a ON v.AccountNumber = a.AgentId
                    LEFT OUTER JOIN tblCommissionBillPayment AS cbp ON bpc.TxnID = cbp.TxnID
            WHERE   ( bpc.TxnDate BETWEEN dbo.udf_GetFirstDayOfMonth(@InvoiceDate)
                                  AND     dbo.udf_GetLastDayOfMonth(@InvoiceDate) )
                    AND cbp.TxnID IS NULL;

GO
EXEC sp_addextendedproperty N'Purpose', N'Records QuickBooks payments to agents in transaction table.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_CommissionBillPayment', NULL, NULL
GO
