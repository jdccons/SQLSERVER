CREATE TABLE [dbo].[tblConstants]
(
[FieldName] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldDateValue] [datetime] NULL,
[TID] [int] NOT NULL IDENTITY(1, 1),
[TimeStmp] [timestamp] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblConstants] ADD CONSTRAINT [PK_tblConstants] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used to store constant date values like invoice data.', 'SCHEMA', N'dbo', 'TABLE', N'tblConstants', NULL, NULL
GO
