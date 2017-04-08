SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SaveTextResultToFile]
  @TheSQL VARCHAR(MAX),
  @Filename VARCHAR(255),
  @Unicode INT=0
/*
e.g. spSaveTextResultToFile 
	'Select logstring+'', ''+convert(char(11),insertionDate,113) from activitylog', 'C:\workbench\Logreport.txt'
*/
AS
  SET NOCOUNT ON
  DECLARE @MySpecialTempTable VARCHAR(255)
  DECLARE @Command NVARCHAR(4000)
  DECLARE @RESULT INT

  IF CHARINDEX ('Select ',LTRIM(@TheSQL))=0
       BEGIN
       RAISERROR ('Usage spSaveTextResultToFile <The SQL Expression> <The Filename)',16,1)
       RETURN 1
       END
--firstly we create a global temp table with a unique name
  SELECT  @MySpecialTempTable = '##temp'
       + CONVERT(VARCHAR(12), CONVERT(INT, RAND() * 1000000))
--then we create it using dynamic SQL,
--
  SELECT  @Command = 'create table ['
       + @MySpecialTempTable
       + '] (MyID int identity(1,1), MyLine varchar(MAX))
insert into ['
       + @MySpecialTempTable
       + '](MyLine) ' +@TheSQL
  EXECUTE sp_ExecuteSQL @command

--then we execute the BCP to save the file
  SELECT  @Command = 'bcp "select Myline from ['
          + @MySpecialTempTable + ']'
          + '" queryout '
          + @Filename
         + CASE WHEN @Unicode=0 THEN '-c' ELSE '-w' END
          + ' -T -S' + @@servername
  EXECUTE @RESULT= MASTER..xp_cmdshell @command, NO_OUTPUT
  EXECUTE ( 'Drop table ' + @MySpecialTempTable )
GO
