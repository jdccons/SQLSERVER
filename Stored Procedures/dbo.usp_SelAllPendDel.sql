SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_SelAllPendDel]
AS
    UPDATE
        s
    SET Flag = 1
    FROM
        tblSubscr s
    INNER JOIN vw_PendingDeletions pd ON s.SubSSN = pd.SubSSN;

GO
