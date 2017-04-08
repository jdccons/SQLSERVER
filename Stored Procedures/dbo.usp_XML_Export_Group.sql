SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_XML_Export_Group]
AS
    IF OBJECT_ID('tempdb..#tblGroups_xml') IS NOT NULL
        DROP TABLE #tbLGroups_xml;
    CREATE TABLE #tblGroups_xml
        (
         [ID] [INT] NOT NULL
        ,[Name] [NVARCHAR](30) NOT NULL
        ,[GroupKey] [NVARCHAR](5) NOT NULL
        ,[Type] [SMALLINT] NOT NULL
        ,[ModifiedDate] [DATETIME] NULL
        ); 

    ALTER TABLE #tblGroups_xml ADD  CONSTRAINT [PK_Groups_XML] PRIMARY KEY CLUSTERED 
    (
    [GroupKey] ASC
    )WITH (PAD_INDEX = OFF, 
    STATISTICS_NORECOMPUTE = OFF, 
    IGNORE_DUP_KEY = OFF, 
    ALLOW_ROW_LOCKS = ON, 
    ALLOW_PAGE_LOCKS = ON);

    INSERT  INTO #tblGroups_xml
            (ID
            ,GroupKey
            ,Name
            ,[Type]
            ,ModifiedDate          
            )
            SELECT
                ID
               ,GroupID
               ,GRName
               ,GroupType
               ,DateModified
            FROM
                tblGrp
            WHERE
                GroupType IN ( 1, 4 )
                AND GRCancelled = 0;

    DECLARE @XML_Out AS NVARCHAR(MAX);

    SET @XML_Out = (
                     SELECT
                        [ID]
                       ,Name
                       ,GroupKey
                       ,[Type]
                       ,ModifiedDate
                     FROM
                        #tblGroups_xml
                   FOR
                     XML PATH('Group')
                        ,ROOT('Groups')
                   );

    DECLARE @ProcessedFile VARCHAR(MAX);
    DECLARE @Messages VARCHAR(MAX);
    DECLARE @UnprocessedFile VARCHAR(MAX);
    SELECT
        @UnprocessedFile = @XML_Out;
    EXECUTE usp_HTMLtidy @UnprocessedFile, @ProcessedFile OUTPUT,
        @Messages OUTPUT;
    EXECUTE usp_WriteStringToFile @ProcessedFile,
        '\\sql\ssis\data_exchange\Export_XML', 'group.xml';


GO
