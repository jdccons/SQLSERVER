SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW 
[dbo].[vw_MS_Tables]
AS
/* show the extended property value
	for tables */
SELECT
    'Table' AS PropertyType ,
    SCH.name AS SchemaName ,
    TBL.name AS TableName ,
    SEP.name AS DescriptionType ,
    SEP.value AS DescriptionDefinition
FROM
    sys.extended_properties SEP
    INNER JOIN sys.tables TBL
        ON SEP.major_id = TBL.object_id
    INNER JOIN sys.schemas SCH
        ON TBL.schema_id = SCH.schema_id
WHERE
    SEP.minor_id = 0
	AND SEP.name IN ('Purpose', 'Version', 'MS_Description');



GO
