CREATE TABLE [dbo].[tmpGeoSel]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GEO] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GeoDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpGeoSel] ADD CONSTRAINT [PK_tmpGeoSel] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used for the Affiliated Dentist report.', 'SCHEMA', N'dbo', 'TABLE', N'tmpGeoSel', NULL, NULL
GO
