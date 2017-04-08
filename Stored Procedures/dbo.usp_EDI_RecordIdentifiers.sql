SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[usp_EDI_RecordIdentifiers](
      @FileID uniqueidentifier,
      @IdentifierID uniqueidentifier,
      @Level int,
      @Value varchar(max)
)

as

set nocount on

begin

  insert into EDI_ParseIdentifier (FileID, IdentifierID, [Level], Value)
  values (@FileID, @IdentifierID, @Level, @Value)

end
GO
