USE [master]
GO
/****** Object:  UserDefinedFunction [dbo].[IsLeapYear]    Script Date: 08/25/2011 12:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Reza Rad
-- Create date: 8/25/2011
-- Description:    IsLeapYear
-- =============================================
CREATE FUNCTION [dbo].[IsLeapYear]
(
    @Year int
)
RETURNS bit
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar bit

    -- Add the T-SQL statements to compute the return value here
    if @Year % 400 = 0
       Begin
            set @ResultVar=1
       end
    else if @Year % 100 = 0
       Begin
            set @ResultVar=0
       end
    else if @Year % 4 = 0
       Begin
            set @ResultVar=1
       end
    else
       Begin
            set @ResultVar=0
       end

    -- Return the result of the function
    RETURN @ResultVar

END
GO
/****** Object:  UserDefinedFunction [dbo].[NumberOfDaysInMonthGregorian]    Script Date: 08/25/2011 12:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Reza Rad
-- Create date: 8/25/2011
-- Description:    Fetch number of days in gregorian month
-- =============================================
CREATE FUNCTION [dbo].[NumberOfDaysInMonthGregorian]
(
    @Year int
    ,@Month int
)
RETURNS int
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar int

    -- Add the T-SQL statements to compute the return value here
    if(@Month<>2)
    begin
        set @ResultVar=30+((@Month + FLOOR(@Month/8)) % 2)
    end
    else
    begin
        if(dbo.IsLeapYear(@Year)=1)
        begin
            set @ResultVar=29
        end
        else
        begin
            set @ResultVar=28
        end
    end

    -- Return the result of the function
    RETURN @ResultVar

END
GO
/****** Object:  UserDefinedFunction [dbo].[NumberOfDayInMonthPersian]    Script Date: 08/25/2011 12:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Reza Rad
-- Create date: 8/25/2011
-- Description:    Fetch number of days in Persian month
-- =============================================
CREATE FUNCTION [dbo].[NumberOfDayInMonthPersian]
(
    @Year int,-- Gregorian Year
    @Month int -- Presian Month
)
RETURNS int
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar int

    -- Add the T-SQL statements to compute the return value here
    if(@Month<=6)
        set @ResultVar=31
    else
        if(@Month=12)
            if(dbo.IsLeapYear(@Year-1)=1)
                set @ResultVar=30
            else
                set @ResultVar=29
        else
            set @ResultVar=30

    -- Return the result of the function
    RETURN @ResultVar

END
GO
/****** Object:  UserDefinedFunction [dbo].[GregorianToPersian]    Script Date: 08/25/2011 12:16:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Reza Rad
-- Create date: 8/25/2011
-- Description:    Convert gregorian date in type of yyyy-MM-dd format to persian/shamsi date string
-- =============================================
CREATE FUNCTION [dbo].[GregorianToPersian]
(
    @Date varchar(10)
)
RETURNS varchar(10)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @ResultVar varchar(10)

    -- Add the T-SQL statements to compute the return value here
    declare @Year int
    declare @Month int
    declare @Day int
    declare @PersianYear int
    declare @PersianMonth int
    declare @PersianDay int
    declare @StartMonthGregorianDateInPersianCalendar int=10
    declare @StartDayGregorianDateInPersianCalendar int=11

    set @Year=convert(int,substring(@Date,1,4))
    set @Month=convert(int,substring(@Date,6,2))
    set @Day=convert(int,substring(@Date,9,2))

    --print @year
    --print @month
    --print @day
    declare @GregorianDayIndex int=0

    if(dbo.IsLeapYear(@Year)=1)
        set @StartDayGregorianDateInPersianCalendar=11
    else
        if(dbo.IsLeapYear(@Year-1)=1)
            set @StartDayGregorianDateInPersianCalendar=12
        else
            set @StartDayGregorianDateInPersianCalendar=11

    --print @StartDayGregorianDateInPersianCalendar           

    declare @m_index int=1
    while @m_index<=@Month-1
    begin
        set @GregorianDayIndex=@GregorianDayIndex+dbo.NumberOfDaysInMonthGregorian(@Year,@m_index)
        set @m_index=@m_index+1
    end
    set @GregorianDayIndex=@GregorianDayIndex+@Day

    if(@GregorianDayIndex>=80)
    begin
        set @PersianYear=@Year-621
    end
    else
    begin
        set @PersianYear=@Year-622
    end

    declare @mdays int
    declare @m int
    declare @index int=@GregorianDayIndex
    set @m_index=0
    while 1=1
    begin
        if(@m_index<=2)
            set @m=@StartMonthGregorianDateInPersianCalendar+@m_index
        else
            set @m=@m_index-2

        --print 'm='+convert(varchar(max),@m    )
        set @mdays=dbo.NumberOfDayInMonthPersian(@Year,@m)
        if(@m=@StartMonthGregorianDateInPersianCalendar)
            set @mdays=@mdays-@StartDayGregorianDateInPersianCalendar+1

        --print 'mday='+convert(varchar(max),@mdays)
        --print 'index='+convert(varchar(max),@index)
        --print 'm_index='+convert(varchar(max),@m_index)

        if(@index<=@mdays)
        begin
            set @PersianMonth=@m
            if(@m=@StartMonthGregorianDateInPersianCalendar)
                set @PersianDay=@index+@StartDayGregorianDateInPersianCalendar-1
            else
                set @PersianDay=@index
            break
        end
        else
        begin
            set @index=@index-@mdays
            set @m_index=@m_index+1
        end           
    end

    set @ResultVar=
    convert(varchar(4),@PersianYear)+'-'+
    right('0'+convert(varchar(2),@PersianMonth),2)+'-'+
    right('0'+convert(varchar(2),@PersianDay),2)

    -- Return the result of the function
    RETURN @ResultVar

END
GO