CREATE TABLE [dbo].[tmpAA_VarianceReport]
(
[DEID] [int] NOT NULL IDENTITY(1, 1),
[DataElementTitle] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataElement] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubSSN] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AAGrpID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RptDate] [datetime] NULL,
[PrtOrder] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpAA_VarianceReport] ADD CONSTRAINT [PK_tmpAA_VarianceReport] PRIMARY KEY CLUSTERED  ([DEID]) ON [PRIMARY]
GO
