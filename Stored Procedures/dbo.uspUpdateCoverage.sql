SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

/****** Object:  Stored Procedure dbo.uspUpdateCoverage    Script Date: 11/3/2006 11:55:40 AM ******/
CREATE PROCEDURE [dbo].[uspUpdateCoverage]

@CoverID int,
@CoverCode varchar(5),
@CoverDesc varchar(20)

 AS


UPDATE tblCoverage Set CoverCode = @CoverCode, CoverDescr = @CoverDesc WHERE CoverID = @CoverID
GO
