CREATE TABLE [dbo].[ProZip]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ZipCode] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Latitude] [float] NULL,
[Longitude] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProZip] ADD CONSTRAINT [PK_ProZip] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCIX_ProZip_ZipCode] ON [dbo].[ProZip] ([ZipCode]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'City/State data with Zip Codes.', 'SCHEMA', N'dbo', 'TABLE', N'ProZip', NULL, NULL
GO
