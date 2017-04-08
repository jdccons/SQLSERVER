SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



    
    CREATE PROCEDURE [dbo].[util_generate_inserts_v2] ( @Query VARCHAR(MAX) )
    AS
        SET NOCOUNT ON;                  
                              
        DECLARE @WithStrINdex AS INT;                            
        DECLARE @WhereStrINdex AS INT;                            
        DECLARE @INDExtouse AS INT;                            
                            
        DECLARE @SchemaAndTAble VARCHAR(270);                            
        DECLARE @Schema_name VARCHAR(30);                            
        DECLARE @Table_name VARCHAR(240);                            
        DECLARE @Condition VARCHAR(MAX);                             
                            
        SET @WithStrINdex = 0;                            
                            
        SELECT
            @WithStrINdex = CHARINDEX('With', @Query)
           ,@WhereStrINdex = CHARINDEX('WHERE', @Query);                            
                            
                            
                            
        IF ( @WithStrINdex != 0 )
            SELECT
                @INDExtouse = @WithStrINdex;                            
        ELSE
            SELECT
                @INDExtouse = @WhereStrINdex;                            
                            
                            
                            
                            
                            
        SELECT
            @SchemaAndTAble = LEFT(@Query, @INDExtouse - 1);                            
                            
        SELECT
            @SchemaAndTAble = LTRIM(RTRIM(@SchemaAndTAble));                            
                            
                            
        SELECT
            @Schema_name = LEFT(@SchemaAndTAble,
                                CHARINDEX('.', @SchemaAndTAble) - 1)
           ,@Table_name = SUBSTRING(@SchemaAndTAble,
                                    CHARINDEX('.', @SchemaAndTAble) + 1,
                                    LEN(@SchemaAndTAble))
           ,@Condition = SUBSTRING(@Query, @WhereStrINdex + 6, LEN(@Query));--27+6                            
                            
                              
                              
        DECLARE @COLUMNS TABLE
            (
             Row_number SMALLINT
            ,Column_Name VARCHAR(MAX)
            );                              
        DECLARE @CONDITIONS AS VARCHAR(MAX);                              
        DECLARE @Total_Rows AS SMALLINT;                              
        DECLARE @Counter AS SMALLINT;              
            
        DECLARE @ComaCol AS VARCHAR(MAX);            
        SELECT
            @ComaCol = '';            
            
                            
        SET @Counter = 1;                              
        SET @CONDITIONS = '';                              
                              
                              
        INSERT  INTO @COLUMNS
                SELECT
                    ROW_NUMBER() OVER ( ORDER BY ORDINAL_POSITION ) [Count]
                   ,COLUMN_NAME
                FROM
                    INFORMATION_SCHEMA.COLUMNS
                WHERE
                    TABLE_SCHEMA = @Schema_name
                    AND TABLE_NAME = @Table_name
                    AND COLUMN_NAME NOT IN ( 'SyncDestination',
                                             'PendingSyncDestination', 'SkuID',
                                             'SaleCreditedto' );                  
                              
        SELECT
            @Total_Rows = COUNT(1)
        FROM
            @COLUMNS;                              
                           
        SELECT
            @Table_name = '[' + @Table_name + ']';                      
                                   
        SELECT
            @Schema_name = '[' + @Schema_name + ']';                      
                         
                              
                              
                              
        WHILE ( @Counter <= @Total_Rows )
            BEGIN                               
--PRINT @Counter                              
                
                SELECT
                    @ComaCol = @ComaCol + '[' + Column_Name + '],'
                FROM
                    @COLUMNS
                WHERE
                    [Row_number] = @Counter;                          
                              
                SELECT
                    @CONDITIONS = @CONDITIONS + ' +Case When [' + Column_Name
                    + '] is null then ''Null'' Else ''''''''+                              
                                
 Replace( Convert(varchar(Max),[' + Column_Name
                    + ']  ) ,'''''''',''''  )                              
                                
  +'''''''' end+' + ''','''
                FROM
                    @COLUMNS
                WHERE
                    [Row_number] = @Counter;                              
       
                SET @Counter = @Counter + 1;                              
                              
            END;                              
                              
                              
                              
        SELECT
            @CONDITIONS = RIGHT(@CONDITIONS, LEN(@CONDITIONS) - 2);                              
                              
        SELECT
            @CONDITIONS = LEFT(@CONDITIONS, LEN(@CONDITIONS) - 4);              
        SELECT
            @ComaCol = SUBSTRING(@ComaCol, 0, LEN(@ComaCol));                            
                              
        SELECT
            @CONDITIONS = '''INSERT INTO ' + @Schema_name + '.' + @Table_name
            + '(' + @ComaCol + ')' + ' Values( ' + '''' + '+' + @CONDITIONS;                              
                              
        SELECT
            @CONDITIONS = @CONDITIONS + '+' + ''')''';                              
                              
        SELECT
            @CONDITIONS = 'Select  ' + @CONDITIONS + 'FRom  ' + @Schema_name
            + '.' + @Table_name + ' With(NOLOCK) ' + ' Where ' + @Condition;                              
        PRINT ( @CONDITIONS );                              
        EXEC(@CONDITIONS);             
GO
