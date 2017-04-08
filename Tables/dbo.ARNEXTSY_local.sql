CREATE TABLE [dbo].[ARNEXTSY_local]
(
[ID] [int] NOT NULL,
[NextSysDocID] [int] NULL,
[RecUserID] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecDate] [datetime] NULL,
[RecSpare] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecTime] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARNEXTSY_local] ADD CONSTRAINT [PK_ID] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Accounting table which maintains the next invoice number.', 'SCHEMA', N'dbo', 'TABLE', N'ARNEXTSY_local', NULL, NULL
GO
