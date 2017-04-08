SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_MS_Tables_Desc_RowCount]
AS
SELECT  t.PropertyType, t.SchemaName, t.TableName, t.DescriptionDefinition,
        trc.[RowCount]
FROM    vw_MS_Tables t
        INNER JOIN vw_MS_Tables_RowCounts trc ON t.TableName = trc.TableName;

GO
