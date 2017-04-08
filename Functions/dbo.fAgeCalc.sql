SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[fAgeCalc](@DOB datetime) 
returns smallint 
as 
----------------------------------------------------
-- * Created By David Wiseman, Updated 03/11/2006
-- * http://www.wisesoft.co.uk
-- * This function calculates a persons age at a 
-- * specified date from their date of birth.
-- * Usage:
-- * select dbo.fAgeCalc('1982-04-18',GetDate())
-- * select dbo.fAgeCalc('1982-04-18','2006-11-03')
----------------------------------------------------
BEGIN 
    RETURN (
	SELECT 
	CASE 
	WHEN DATEDIFF(yyyy,@DOB,GETDATE()) < 0 THEN 0
	WHEN MONTH(@DOB)>MONTH(GETDATE()) THEN DATEDIFF(yyyy,@DOB,GETDATE())-1 
	WHEN MONTH(@DOB)<MONTH(GETDATE()) THEN DATEDIFF(yyyy,@DOB,GETDATE()) 
	WHEN MONTH(@DOB)=MONTH(GETDATE()) THEN 
	CASE WHEN DAY(@DOB)>DAY(GETDATE())
		THEN DATEDIFF(yyyy,@DOB,GETDATE())-1
	ELSE DATEDIFF(yyyy,@DOB,GETDATE())
	END 
	END) 
END

--
GO
