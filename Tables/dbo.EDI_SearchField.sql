CREATE TABLE [dbo].[EDI_SearchField]
(
[SearchID] [uniqueidentifier] NOT NULL,
[SearchFieldID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_EDI_SearchField_SearchFieldID] DEFAULT (newid()),
[SearchOrder] [int] NOT NULL CONSTRAINT [DF_EDI_SearchField_SearchOrder] DEFAULT ((0)),
[RecordType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FieldSeq] [int] NOT NULL,
[FieldValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [dbo].[trg_EDI_SearchField] on [dbo].[EDI_SearchField] after insert, update, delete

as

begin

update sf
   set sf.SearchOrder = x.SearchOrder
  from EDI_SearchField sf
  join (select SearchFieldID, row_number() over (Partition by SearchID Order by SearchOrder, SearchFieldID) as SearchOrder
          from EDI_SearchField
         where SearchID in (select SearchID from inserted
                            union
                            select SearchID from deleted)) x
    on sf.SearchFieldID = x.SearchFieldID

;with TriggerCTE as (
select SearchID from inserted
union
select SearchID from deleted)

update s
   set s.MatchBitmap = x.MatchBitmap
  from EDI_Search s
  join TriggerCTE t
    on s.SearchID = t.SearchID
  left join (select SearchID, sum(power(2, SearchOrder - 1)) as MatchBitmap
               from EDI_SearchField
              group by SearchID) x
    on t.SearchID = x.SearchID

end
GO
ALTER TABLE [dbo].[EDI_SearchField] ADD CONSTRAINT [PK_EDI_SearchField] PRIMARY KEY CLUSTERED  ([SearchID], [SearchFieldID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_SearchField] ADD CONSTRAINT [FK_EDI_SearchField_SearchID] FOREIGN KEY ([SearchID]) REFERENCES [dbo].[EDI_Search] ([SearchID])
GO
EXEC sp_addextendedproperty N'MS_Description', 'Processing table used for HIPAA downloads.', 'SCHEMA', N'dbo', 'TABLE', N'EDI_SearchField', NULL, NULL
GO
