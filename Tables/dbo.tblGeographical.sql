CREATE TABLE [dbo].[tblGeographical]
(
[GEOid] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GEOdesc] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GEOcities] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGeographical] ADD CONSTRAINT [PK_tblGeographical] PRIMARY KEY CLUSTERED  ([GEOid]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Lookup table for sales areas.', 'SCHEMA', N'dbo', 'TABLE', N'tblGeographical', NULL, NULL
GO
