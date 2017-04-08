SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_Commission]

AS

/* =============================================
	Object:			vw_Commission
	Version:		5
	Author:			John Criswell
	Create date:	2014-09-16	 
	Description:	Brief listing of payment transactions in ARTRANH_local.  These payments 
					result in amounts to be used in calculation of commissions due to agents.  
					Uses two indexed views connected through UNION: 
						vw_Commission_Group 
						vw_Commission_Individual	
						
					Shows all the payment transactions from both QuickBooks and Access/Platinum.  
					Calculates the commissions due on these payments.				
								
							
	Change Log:
	--------------------------------------------
	Change Date		Version			Changed by		Reason
	2015-01-09		2.0				JCriswell		Added c.CreditHold = 'N'
													to WHERE clause; this means
													we will not pay commissions
													for cancelled groups.
	2015-1-12		3.0				JCriswell		Reversed the above change
	2015-12-03		4.0				JCriswell		Indexed the view.
	2015-12-03		5.0				JCriswell		Changed to two indexed views.
	
============================================= */

/*  individual transactions  */
SELECT AgentID, AgentName, Agency, Active, CustomerKey, CheckNo, 
	CommMonth, CheckDate, CheckAmt, AgentRate, CommDue, AgentType, 
	InvoiceNo, CustomerClassKey, EnrollmentFee, PayCommTo
FROM dbo.vw_Commission_Individual

UNION ALL

/*  group transactions  */
SELECT AgentID, AgentName, Agency, Active, CustomerKey, CheckNo, 
	CommMonth, CheckDate, CheckAmt, AgentRate, CommDue, AgentType, 
	InvoiceNo, CustomerClassKey, EnrollmentFee, PayCommTo
FROM dbo.vw_Commission_Group;






GO
EXEC sp_addextendedproperty N'MS_Description', N'Brief listing of payment transactions in ARTRANH_local.  Used to calculate agent commissions.', 'SCHEMA', N'dbo', 'VIEW', N'vw_Commission', NULL, NULL
GO
