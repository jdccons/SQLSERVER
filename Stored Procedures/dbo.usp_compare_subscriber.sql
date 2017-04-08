SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* ====================================================================================
	Object:			usp_Compare_Subscriber
	Author:			John Criswell
	Create date:	2015-10-01	 
	Description:	Compares a single subscriber; QCD record versus DCA record
	Parameters:		@SubID @nchar(8) - the subscriber's SubID
					@SSN nchar(9) - the subscriber's SSN
	Called from:			
							
	Change Log:
	-----------------------------------------------------------------------------------
	Change Date		Versions	Changed by		Reason
	2015-10-01		1.0			J Criswell		Created
	
	
======================================================================================= */ 

CREATE PROCEDURE [dbo].[usp_compare_subscriber]
(
@SubID AS NCHAR(8), 
@SSN AS NCHAR(9)
)

AS


SELECT  'SSN Compare' CompareType ,
        'QCD' AS [Database] ,
        SubSSN ,
        SubID ,
        SubCancelled ,
        SubGroupID ,
        SubLastName ,
        SubFirstName ,
        SubMiddleName ,
        PlanID ,
        CoverID ,
        SubStreet1 ,
        SubStreet2 ,
        SubCity ,
        SubState ,
        SubZip ,
        SubEmail ,
        SubEffDate ,
        PreexistingDate ,
        SubPhoneHome ,
        SubPhoneWork ,
        SubDOB ,
        DepCnt
FROM    tblSubscr
WHERE   SubSSN = @SSN
UNION ALL
SELECT  'SSN Compare' CompareType ,
        'Dentist Direct' AS [Database] ,
        SSN ,
        SUB_ID ,
        '1' AS SubCancelled ,
        GRP_ID ,
        LAST_NAME ,
        FIRST_NAME ,
        MI ,
        [PLAN] ,
        COV ,
        ADDR1 ,
        ADDR2 ,
        CITY ,
        STATE ,
        ZIP ,
        EMAIL ,
        EFF_DT ,
        PREX_DT ,
        PHONE_HOME ,
        PHONE_WORK ,
        DOB ,
        NO_DEP
FROM    tpa_data_exchange
WHERE   RCD_TYPE = 'S'
        AND SSN = @SSN
UNION ALL
SELECT  'SubID Compare' CompareType ,
        'QCD' AS [Database] ,
        SubSSN ,
        SubID ,
        SubCancelled ,
        SubGroupID ,
        SubLastName ,
        SubFirstName ,
        SubMiddleName ,
        PlanID ,
        CoverID ,
        SubStreet1 ,
        SubStreet2 ,
        SubCity ,
        SubState ,
        SubZip ,
        SubEmail ,
        SubEffDate ,
        PreexistingDate ,
        SubPhoneHome ,
        SubPhoneWork ,
        SubDOB ,
        DepCnt
FROM    tblSubscr
WHERE   SubID = @SubID
UNION ALL
SELECT  'SubID Compare' CompareType ,
        'Dentist Direct' AS [Database] ,
        SSN ,
        SUB_ID ,
        '1' AS SubCancelled ,
        GRP_ID ,
        LAST_NAME ,
        FIRST_NAME ,
        MI ,
        [PLAN] ,
        COV ,
        ADDR1 ,
        ADDR2 ,
        CITY ,
        STATE ,
        ZIP ,
        EMAIL ,
        EFF_DT ,
        PREX_DT ,
        PHONE_HOME ,
        PHONE_WORK ,
        DOB ,
        NO_DEP
FROM    tpa_data_exchange
WHERE   RCD_TYPE = 'S'
        AND SUB_ID = @SubID
ORDER BY CompareType ,
        [Database];
GO
EXEC sp_addextendedproperty N'Purpose', N'Compares QCD and DCA subscriber records.', 'SCHEMA', N'dbo', 'PROCEDURE', N'usp_compare_subscriber', NULL, NULL
GO
