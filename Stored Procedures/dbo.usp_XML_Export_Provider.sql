SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_XML_Export_Provider]
AS
    IF OBJECT_ID('tempdb..#tblDentists_xml') IS NOT NULL
        DROP TABLE #tblDentists_xml;
    CREATE TABLE #tblDentists_xml
        (
          [DentKeyID] [INT] NOT NULL
        , [LName] [NVARCHAR](50) NULL
        , [FName] [NVARCHAR](50) NULL
        , [Address] [NVARCHAR](50) NULL
        , [Address2] [NVARCHAR](50) NULL
        , [City] [NVARCHAR](50) NULL
        , [STATE] [NVARCHAR](2) NULL
        , [Zipcode] [NVARCHAR](9) NULL
        , [Specialty] [NVARCHAR](19) NULL
        , [DentSchool] [NVARCHAR](30) NULL
        , [DentGradYr] [NCHAR](4) NULL
        , [DentAffilDate] [DATETIME] NULL
        , [DentCloseOff] [NVARCHAR](255) NULL
        , [Phone] [NVARCHAR](10) NULL
        , [DentSpecialPrc] [NVARCHAR](255) NULL
        , [DentBilingual] [NVARCHAR](255) NULL
        , [DentWebsite] [NVARCHAR](255) NULL
        , [SearchCity] [NVARCHAR](255) NULL
        , [ZipSearch] [NVARCHAR](255) NULL
        , [SpecSearch] [NVARCHAR](6) NULL
        , [Latitude] [NUMERIC](9, 6) NULL
        , [Longitude] [NUMERIC](9, 6) NULL
        , [Website] [NVARCHAR](255) NULL
        , [CreateDate] [DATETIME] NULL
        , [ModifyDate] [DATETIME] NULL
        ); 


    ALTER TABLE #tblDentists_xml ADD  CONSTRAINT [PK_tblDentists] PRIMARY KEY CLUSTERED 
    (
    [DentKeyID] ASC
    )WITH (PAD_INDEX = OFF, 
    STATISTICS_NORECOMPUTE = OFF, 
    IGNORE_DUP_KEY = OFF, 
    ALLOW_ROW_LOCKS = ON, 
    ALLOW_PAGE_LOCKS = ON); 
 
    CREATE NONCLUSTERED INDEX IX_tblDentist_XML_ZipCode
    ON #tblDentists_xml (Zipcode); 
			
    INSERT  INTO #tblDentists_xml
            ( DentKeyID
            , LName
            , FName
            , [Address]
            , Address2
            , City
            , [STATE]
            , [Zipcode]
            , Specialty
            , DentSchool
            , DentGradYr
            , DentAffilDate
            , DentCloseOff
            , Phone
            , DentSpecialPrc
            , DentBilingual
            , DentWebsite
            , SearchCity
            , ZipSearch
            , SpecSearch
            )
            SELECT 
                DentKeyID
              , DentLast
              , DentFirst
              , DentStreet1
              , DentStreet2
              , DentCity
              , DentState
              , REPLACE(DentZip, '-', '')
              , DentSpecialty
              , DentSchool
              , DentGradYr
              , DentAffilDate
              , DentCloseMyOff
              , DentPhoneOffice
              , DentSpecialPrice
              , DentBilingual
              , DentWebsite
              , REPLACE(DentCity, ' ', '') AS SearchCity
              , LEFT(DentZip, 5) AS ZipSearch
              , DentSpecialty
            FROM
                tblDentist
            WHERE
                DentStatus = 'A'
				AND DentZip IS NOT null;

		-- add the latitude and longitude to the dentist's record
    UPDATE
        di
    SET
        di.Latitude = CAST(z.Latitude AS NUMERIC(9, 6))
      , di.Longitude = CAST(z.Longitude AS NUMERIC(9, 6))
    FROM
        #tblDentists_xml di
    INNER JOIN ProZip z ON di.ZipSearch = z.ZipCode;

		-- add the description of the dentist's speciality to the dentist's record
    UPDATE
        di
    SET
        di.Specialty = ds.SpecialtyDesc
    FROM
        #tblDentists_xml di
    INNER JOIN tblDentistSpec ds ON di.Specialty = ds.SpecialtyID;

		-- add new patient notice
    UPDATE
        #tblDentists_xml
    SET
        DentCloseOff = ( CASE WHEN DentCloseOff = '0'
                              THEN 'Accepting New Patients:  Yes'
                              ELSE CASE WHEN DentCloseOff = '1'
                                        THEN 'Accepting New Patients:  No'
                                        ELSE DentCloseOff
                                   END
                         END )
    FROM
        #tblDentists_xml;

		-- add special pricing notice
    UPDATE
        #tblDentists_xml
    SET
        DentSpecialPrc = ( CASE WHEN DentSpecialPrc = '1'
                                THEN 'Exception pricing on speciality services:  Yes *'
                                ELSE CASE WHEN DentSpecialPrc = '0'
                                          THEN 'Exception pricing on speciality services::  No *'
                                          ELSE DentSpecialPrc
                                     END
                           END )
    FROM
        #tblDentists_xml;

		-- add bi-lingual notice
    UPDATE
        #tblDentists_xml
    SET
        DentBilingual = ( CASE WHEN DentBilingual = '0' THEN 'Bi-Lingual:  No'
                               ELSE CASE WHEN DentBilingual = '1'
                                         THEN 'Bi-lingual:  Yes'
                                         ELSE DentBilingual
                                    END
                          END )
    FROM
        #tblDentists_xml;

    DECLARE @XML_Out AS NVARCHAR(MAX);

    SET @XML_Out = (
                     SELECT
                        DentKeyID
                       ,ISNULL(LName, '') AS LName
                       ,ISNULL(FName, '') AS FName
                       ,ISNULL([Address], '') AS [Address]
                       ,ISNULL(Address2, '') AS Address2
                       ,ISNULL(City, '') AS City
                       ,ISNULL([STATE], '') AS [STATE]
                       ,ISNULL(Zipcode, '') AS Zipcode
                       ,ISNULL(Specialty, '') AS Specialty
                       ,ISNULL(DentSchool, '') AS DentSchool
                       ,ISNULL(DentGradYr, '') AS DentGradYr
                       ,ISNULL(DentAffilDate, '1901-01-01 00:00:00') AS DentAffilDate
                       ,ISNULL(DentCloseOff, '') AS DentCloseOff
                       ,ISNULL(Phone, '') AS Phone
                       ,ISNULL(DentSpecialPrc, '') AS DentSpecialPrc
                       ,ISNULL(DentBilingual, '') AS DentBilingual
                       ,ISNULL(DentWebsite, '') AS DentWebsite
                       ,ISNULL(SearchCity, '') AS SearchCity
                       ,ISNULL(ZipSearch, '') AS ZipSearch
                       ,ISNULL(SpecSearch, '') AS SpecSearch
                       ,Latitude
                       ,Longitude
                       ,ISNULL(Website, '') Website
                       ,CreateDate ModifyDate
                     FROM
                        #tblDentists_xml
					WHERE Latitude IS NOT NULL
                    AND Longitude IS NOT NULL
                     FOR
                        XML PATH('Dentist')
                           ,ROOT('Dentists')
                   );

    DECLARE @ProcessedFile VARCHAR(MAX);
    DECLARE @Messages VARCHAR(MAX);
    DECLARE @UnprocessedFile VARCHAR(MAX);
    SELECT
        @UnprocessedFile = @XML_Out;
    EXECUTE usp_HTMLtidy @UnprocessedFile, @ProcessedFile OUTPUT,
        @Messages OUTPUT;
    EXECUTE usp_WriteStringToFile @ProcessedFile, 'g:\test', 'Dentists_2.xml';


GO
