SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_EDI_App_Subscr_Indiv]
AS
    INSERT  INTO tblEDI_App_Subscr
            ( SubSSN ,
              SubID ,
              SubStatus ,
              SubGroupID ,
              PlanID ,
              CoverID ,
              SubLastName ,
              SubFirstName ,
              SubMiddleName ,
              SUB_LUname ,
              SubStreet1 ,
              SubStreet2 ,
              SubCity ,
              SubState ,
              SubZip ,
              SubPhoneHome ,
              SubPhoneWork ,
              SUBdob ,
              DepCnt ,
              SubGender ,
              SubAge ,
              SubEffDate ,
              PreexistingDate ,
              SubMaritalStatus ,
              SubCardPrt ,
              SubCardPrtDte ,
              TransactionType ,
              DateCreated ,
              DateUpdated ,
              DateDeleted ,
              RateID ,
              SubContBeg ,
              SubContEnd ,
              EIMBRID ,
              wSubID ,
              wUpt ,
              AmtPaid
            )
            SELECT  s.SSN ,
                    s.SubscriberID ,
                    'INDIV' AS Status ,
                    s.GroupID ,
                    s.PlanID ,
                    s.CoverID ,
                    s.LastName ,
                    s.FirstName ,
                    s.MiddleInitial ,
                    s.LastName + ', ' + s.FirstName + ' '
                    + SUBSTRING(s.MiddleInitial, 1, 1) AS LU_Name ,
                    s.Street1 ,
                    s.Street2 ,
                    s.City ,
                    s.State ,
                    s.Zip ,
                    ISNULL(s.PhoneHome, '') AS SubPhoneHome ,
                    s.PhoneWork ,
                    s.DOB ,
                    s.DepCnt ,
                    s.Gender ,
                    s.Age ,
                    s.EffectiveDate ,
                    s.PreexistingDate ,
                    s.MaritalStatus ,
                    s.CardPrinted ,
                    s.CardPrintedDate ,
                    s.MembershipStatus ,
                    s.DateCreated ,
                    s.DateChanged ,
                    s.DateDeleted ,
                    r.RateID ,
                    s.EffectiveDate AS SubContBeg ,
                    s.EmploymentDate AS SubContEnd ,
                    s.EIMBRID ,
                    s.wSubID ,
                    1 AS setU ,
                    s.AmtPaid
            FROM    tblSubscriber_temp AS s
                    INNER JOIN tblRates AS r ON s.CoverID = r.CoverID
                                                AND s.PlanID = r.PlanID
                                                AND s.GroupID = r.PlanID
            WHERE   ( s.MembershipStatus = 'Added' )
                    AND ( s.EIMBRID IN ( 'INDIV' ) )
                    OR ( s.MembershipStatus = 'Changed' )
                    AND ( s.EIMBRID IN ( 'INDIV' ) );
GO
