CREATE TABLE [dbo].[tmpGeo]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GEO] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GeoDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Moved] [bit] NOT NULL CONSTRAINT [DF_tmpGeo_Moved] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpGeo] ADD CONSTRAINT [PK_tmpGeo] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used for the Affiliated Dentist report.', 'SCHEMA', N'dbo', 'TABLE', N'tmpGeo', NULL, NULL
GO
