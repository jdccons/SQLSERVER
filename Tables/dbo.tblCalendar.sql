CREATE TABLE [dbo].[tblCalendar]
(
[calID] [int] NOT NULL,
[calMonth] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCalendar] ADD CONSTRAINT [PK_tblCalendar] PRIMARY KEY CLUSTERED  ([calID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Lookup table with months of year.', 'SCHEMA', N'dbo', 'TABLE', N'tblCalendar', NULL, NULL
GO
