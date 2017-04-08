CREATE TABLE [dbo].[tblInvLin]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DOCUMENT NO] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUST KEY] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM KEY] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESCRIPTION] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UNIT PRICE] [float] NULL,
[QTY ORDERED] [float] NULL,
[QTY SHIPPED] [float] NULL,
[TAX CODE] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REV ACCT] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REV SUB] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SERIALIZED yn] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPARE] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPARE2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPARE3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineItemTy] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateModified] [datetime] NULL CONSTRAINT [DF_tblInvLin_DateModified] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblInvLin] ADD CONSTRAINT [PK_tblInvLin] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblInvLin] ADD CONSTRAINT [FK_tblInvLin_tblInvHdr] FOREIGN KEY ([DOCUMENT NO]) REFERENCES [dbo].[tblInvHdr] ([TRANS NO]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', 'Table used in the invoicing process.', 'SCHEMA', N'dbo', 'TABLE', N'tblInvLin', NULL, NULL
GO
