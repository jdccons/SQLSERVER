SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_EDI_StartFile](
      @EDIVersion CHAR(5),
      @FilePath VARCHAR(MAX),
      @FileID UNIQUEIDENTIFIER = NULL OUT
)

AS

SET NOCOUNT ON

BEGIN

  DECLARE @ErrorMsg VARCHAR(MAX)

  IF NOT EXISTS (SELECT 1
                   FROM EDI_Version
                  WHERE [Version] = @EDIVersion 
                    AND EndDtTm IS NULL)
    BEGIN
      SET @ErrorMsg = 'No active entries for EDI file format [' + @EDIVersion + ']'
      RAISERROR(@ErrorMsg, 16, 1)
    END
  ELSE
    BEGIN
      SET @FileID = NEWID()

      DELETE FROM EDI_Parse
      DELETE FROM EDI_ParseIdentifier

      INSERT INTO EDI_ParseFile (FileID, FilePath, VersionID)
      SELECT @FileID, @FilePath, VersionID
        FROM EDI_Version
       WHERE [Version] = @EDIVersion
         AND EndDtTm IS NULL

      SELECT i.IdentifierID, i.IdentifierType, il.[Level], i.Position, i.[Length], i.RelativeIdentifier
        FROM EDI_Version v
        JOIN EDI_Identifier i ON v.VersionID = i.VersionID
        JOIN EDI_IdentifierLevel il ON i.IdentifierID = il.IdentifierID
       WHERE v.[Version] = @EDIVersion
         AND v.EndDtTm IS NULL
       ORDER BY il.[Level]
    END

END
GO
