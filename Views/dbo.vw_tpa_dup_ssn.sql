SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_tpa_dup_ssn]
as
SELECT *
FROM tpa_data_exchange_sub
WHERE SSN IN (
		SELECT SSN
		FROM tpa_data_exchange_sub
		group by SSN
		having COUNT(SSN) > 1
		);
GO
