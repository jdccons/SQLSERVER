SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vw_InvoiceLine]
	AS
    SELECT  DISTINCT DocumentNumber,
			CustomerKey ,
            DocumentDate ,
            RTRIM(p.PlanDesc) + ' ' + RTRIM(c.CoverDescr) ItemKey ,
             ItemDescription ,
            UnitPrice,
            QtyShipped
    FROM    ARLINH_local il
            INNER JOIN tblSubscr s ON SUBSTRING(il.ItemDescription, 1, 9) = s.SubSSN
            INNER JOIN dbo.tblPlans p ON s.PlanID = p.PlanID
            INNER JOIN tblCoverage c ON s.CoverID = c.CoverID;

GO
