SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_PendingDeletions]
as
/*  these are active subscribers where DateDeleted is not default value  */
SELECT
    ID, SubSSN, SubID, EIMBRID, SubStatus, SubGroupID, SubClassKey, Sub_LUName, DateCreated,
    DateUpdated, DateDeleted, Flag
FROM
    tblSubscr
WHERE
    ( SubCancelled = 1 )
    AND ( DateDeleted <> '1901-01-01 00:00:00' )
    AND ( DateDeleted IS NOT NULL
          OR DateDeleted <> ''
        );

GO
