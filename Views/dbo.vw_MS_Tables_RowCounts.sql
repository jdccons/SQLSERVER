SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_MS_Tables_RowCounts]
AS
SELECT
      sOBJ.name AS [TableName]
      , SUM(sdmvPTNS.row_count) AS [RowCount]
FROM
      sys.objects AS sOBJ
      INNER JOIN sys.dm_db_partition_stats AS sdmvPTNS
            ON sOBJ.object_id = sdmvPTNS.object_id
WHERE 
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
      AND sdmvPTNS.index_id < 2
GROUP BY
      sOBJ.schema_id
      , sOBJ.name;


GO
