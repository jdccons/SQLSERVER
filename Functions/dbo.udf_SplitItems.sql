SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[udf_SplitItems](
      @String varchar(max),
      @Delimiter varchar(10)
)

returns @Split table (id int identity(1, 1),
                      item varchar(max))

as

begin
  while left(@String, len(@Delimiter)) = @Delimiter
    begin
      set @String = stuff(@String, 1, len(@Delimiter), '')
    end

  if right(@String, len(@Delimiter)) != @Delimiter
    begin
      set @String = @String + @Delimiter
    end

  declare @Pos1 int, @Pos2 int

  select @Pos1 = 1, @Pos2 = 1

  while @Pos1 > 0
    begin
      set @Pos1 = charindex(@Delimiter, @String, @Pos1)
      
      if @Pos1 > 0
        begin
          insert into @Split (item)
          values (substring(@String, @Pos2, @Pos1 - @Pos2))

          set @Pos2 = @Pos1 + len(@Delimiter)
          set @Pos1 = @Pos2
       end
    end

  return
end
GO
