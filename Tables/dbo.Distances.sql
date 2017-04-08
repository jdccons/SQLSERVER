CREATE TABLE [dbo].[Distances]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[DentKeyID] [int] NULL,
[DentZip] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DentLat] [float] NULL,
[DentLong] [float] NULL,
[SubID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubZip] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubLat] [float] NULL,
[SubLong] [float] NULL,
[Miles] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Distances] ADD CONSTRAINT [PK_Distances] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Temp table used to hold search distances for dentists.', 'SCHEMA', N'dbo', 'TABLE', N'Distances', NULL, NULL
GO
