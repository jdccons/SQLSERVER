SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_EDI_GetData](
      @FileID UNIQUEIDENTIFIER
)

WITH EXECUTE AS OWNER

AS

set nocount on

BEGIN

declare @SQL nvarchar(max), @Fields nvarchar(max)

create table #Data (FileID uniqueidentifier,
                    EntitySeq int,
                    OutcomeName varchar(max),
                    FieldValue varchar(max))

--set @Fields = stuff((select ',[' + OutcomeName + ']'
--                       from EDI_SearchOutcome
--                     for xml path('')), 1, 1, space(0))

--set @SQL = N'select * from #Data pivot (max(FieldValue) for OutcomeName in (' + @Fields + N')) x'

set @SQL = N'select x.EntitySeq, ' +
           stuff((select N', [' + cast(SearchOutcomeID as nvarchar(50)) +
                         N'].[' + cast(OutcomeName as nvarchar(max)) + N']'
                    from EDI_SearchOutcome
                   order by OutcomeName
                  for xml path('')), 1, 2, space(0)) + 
           N' from (select EntitySeq from #Data group by EntitySeq) x ' +
           stuff((select N' left join (select EntitySeq, FieldValue as [' + cast(OutcomeName as nvarchar(max)) +
                         N'] from #Data where OutcomeName = ''' + cast(OutcomeName as nvarchar(max)) + N''') as [' +
                         cast(SearchOutcomeID as nvarchar(50)) + N'] on x.EntitySeq = [' + 
                         cast(SearchOutcomeID as nvarchar(50)) + N'].EntitySeq'
                from EDI_SearchOutcome
               order by OutcomeName
              for xml path('')), 1, 1, space(1)) +
           N' order by x.EntitySeq'

;WITH CTE AS (
SELECT pe.FileID, pe.EntitySeq, pe.RecordType, pe.ParentID,
       x.SearchID, CAST(NULL AS INT) AS SearchOrder, 1 AS NextSearchOrder
  FROM EDI_Parse pe
  JOIN (SELECT DISTINCT s.SearchID, sf.RecordType
          FROM EDI_Search s
          JOIN EDI_SearchField sf
            ON s.SearchID = sf.SearchID) x
    ON pe.RecordType = x.RecordType
 WHERE pe.FileID = @FileID
   AND pe.[Level] = 1

UNION ALL

SELECT pe.FileID, pe.EntitySeq, c.RecordType, pe.ParentID,
       sf.SearchID, sf.SearchOrder, sf.SearchOrder + 1 AS NextSearchOrder
  FROM CTE c
  JOIN EDI_SearchField sf
    ON c.SearchID = sf.SearchID
   AND c.NextSearchOrder = sf.SearchOrder
   AND c.RecordType = sf.RecordType
  JOIN EDI_Parse pe
    ON c.FileID = pe.FileID
   AND c.EntitySeq = pe.EntitySeq
   AND sf.RecordType = pe.RecordType
   AND sf.FieldSeq = pe.Seq
   AND ISNULL(sf.FieldValue, pe.Value) = pe.Value
 WHERE pe.[Level] >= 2)

INSERT INTO #Data (FileID, EntitySeq, OutcomeName, FieldValue)
SELECT pe.FileID, pe.EntitySeq, so.OutcomeName, pe.Value
  FROM (SELECT c.FileID, c.EntitySeq, c.SearchID, c.ParentID
          FROM CTE c
          JOIN EDI_Search s
            ON c.SearchID = s.SearchID
         GROUP BY c.FileID, c.EntitySeq, c.SearchID, c.ParentID, s.MatchBitmap
        HAVING SUM(DISTINCT POWER(2, c.SearchOrder - 1)) = s.MatchBitmap) x
  JOIN EDI_Parse pe
    ON x.FileID = pe.FileID
   AND x.EntitySeq = pe.EntitySeq
   AND x.ParentID = pe.ParentID
  JOIN EDI_SearchOutcome so
    ON x.SearchID = so.SearchID
   AND pe.RecordType = so.RecordType
   AND pe.Seq = so.FieldSeq
 WHERE pe.[Level] >= 2

UNION ALL

SELECT pe.FileID, pe.EntitySeq, so.OutcomeName, pe.Value
  FROM EDI_Parse pe
  JOIN EDI_SearchOutcome so
    ON pe.RecordType = so.RecordType
   AND pe.Seq = so.FieldSeq
  JOIN EDI_Search s
    ON so.SearchID = s.SearchID
 WHERE pe.FileID = @FileID
   AND pe.[Level] >= 2
   AND ISNULL(s.MatchBitmap, 0) = 0

CREATE CLUSTERED INDEX IX_#Data ON #Data (EntitySeq)

EXEC (@SQL)

END
GO
