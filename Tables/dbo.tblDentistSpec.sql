CREATE TABLE [dbo].[tblDentistSpec]
(
[SPECIALTYID] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SpecialtyDesc] [nvarchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REPORTgrouping] [smallint] NULL,
[TID] [int] NOT NULL IDENTITY(1, 1),
[TimeStmp] [timestamp] NULL,
[DateModified] [date] NULL CONSTRAINT [DF_tblDentistSpec_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_tblDentistSpec_DateModified] ON [dbo].[tblDentistSpec]
FOR UPDATE
AS
BEGIN


	/* update date modified */
	UPDATE spec
	SET DateModified = GETDATE()
	from tblDentistSpec spec
	INNER JOIN inserted i
		ON spec.TID = i.TID;
END
GO
ALTER TABLE [dbo].[tblDentistSpec] ADD CONSTRAINT [PK_tbldentistspec] PRIMARY KEY CLUSTERED  ([SPECIALTYID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', 'Lookup table of specialties for dentists.', 'SCHEMA', N'dbo', 'TABLE', N'tblDentistSpec', NULL, NULL
GO
