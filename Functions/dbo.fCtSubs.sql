SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fCtSubs](@GroupID nvarchar(5)) 
returns smallint 
as 

begin 
return (
		SELECT Count(tblSubscr.SubSSN) AS CountOfSubSSN
             FROM tblSubscr 
             WHERE (((tblSubscr.SubGroupID)= @GroupID))
	   ) 
end

GO
