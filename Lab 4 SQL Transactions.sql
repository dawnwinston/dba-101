
-- #1 What is a database transaction 

-- #2 Let's talk about ACID

-- #3 What type of sytem are you designing?  
-- OLTP?  
-- Many users or few?



-- Create the table 
USE [AdventureWorks10]
GO



SELECT [SeatNumber]
      ,[CustomerNumber]
      ,[DateSold]
  FROM [AdventureWorks10].[dbo].[Seat]


USE [AdventureWorks10]
GO

/****** Object:  Table [dbo].[Seat]    Script Date: 6/27/2018 2:09:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE seat


CREATE TABLE [dbo].[Seat](
	[SeatNumber] [int] NOT NULL,
	[CustomerNumber] [int] NULL,
	[DateSold] [datetime] NULL,
 CONSTRAINT [PK_Seat] PRIMARY KEY CLUSTERED 
(
	[SeatNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

-- add ten available seats to the table 
insert into [dbo].[Seat] 
values (1,null,null),
 (2,null,null),
 (3,null,null),
 (4,null,null),
 (5,null,null),
 (6,null,null),
 (7,null,null),
 (8,null,null),
 (9,null,null),
 (10,null,null)



-- #1  review all the seats 
SELECT [SeatNumber]
      ,[CustomerNumber]
      ,[DateSold]
  FROM [AdventureWorks10].[dbo].[Seat]



-- #2 How may seats are available 
set nocount on 

SELECT [SeatNumber]
      ,[CustomerNumber]
      ,[DateSold]
  FROM [AdventureWorks10].[dbo].[Seat]
  WHERE CustomerNumber is null and DateSold is null


-- #3  With a manual transaction 

begin transaction 

update AdventureWorks10.dbo.seat 
set CustomerNumber = 2
where SeatNumber = 8
and DateSold is null

-- commit
-- rollback


-- review the seat I selected, now have everyone else try.
-- who has the seat, what problem does this create

SELECT [SeatNumber]
      ,[CustomerNumber]
      ,[DateSold]
  FROM [AdventureWorks10].[dbo].[Seat] 
  WHERE DateSold is null

  
-- What is a unit of work (a transaction)

-- #4 Now run as a transaction
declare @CustomerNumber  int
declare @SeatNumber int
declare @ccapproval int

select @CustomerNumber = 8  -- Group number 
select @SeatNumber = 2

set nocount on 

  begin tran


  -- select the seat 
  update AdventureWorks10.dbo.seat 
	set CustomerNumber = @CustomerNumber
	where SeatNumber = @SeatNumber
	and DateSold is null
 
 -- tenatively mark the seat as sold 
	update AdventureWorks10.dbo.seat 
	set DateSold = getdate()
	where SeatNumber = @SeatNumber
	and customerNumber = @CustomerNumber  
	and DateSold is null  -- so you can't purchase a seat you have already purchased

	select @@rowcount as NumRowsChanged

--simulate credit card apporval 
	 waitfor delay '00:00:10' --- ten seconds

--select @ccapproval = -1 --- failed 
  select @ccapproval = 100 --- succeeded  

	if @ccapproval <= 0 
		rollback  -- credit card transaction failed. Rollback transaction.
	else	
		commit  --  credit card was approved. Complete transaction.

-- 4.5 query for open transactions
SELECT ec.session_id, tst.is_user_transaction, st.text 
   FROM sys.dm_tran_session_transactions tst 
      INNER JOIN sys.dm_exec_connections ec ON tst.session_id = ec.session_id
      CROSS APPLY sys.dm_exec_sql_text(ec.most_recent_sql_handle) st 

	select @@TRANCOUNT





--###################################################
--Demonstrate an example of messaging on rollback
--###################################################

declare @CustomerNumber  int
declare @SeatNumber int
declare @ccapproval int
declare @msg varchar(100)

select @CustomerNumber = 8  -- Group number 
select @SeatNumber = 2

set nocount on 


BEGIN TRY 

  BEGIN TRAN

  --select 1/0

  -- select the seat 
  update AdventureWorks10.dbo.seat 
	set CustomerNumber = @CustomerNumber
	where SeatNumber = @SeatNumber
	and DateSold is null
 
 -- tenatively mark the seat as sold 
	update AdventureWorks10.dbo.seat 
	set DateSold = getdate()
	where SeatNumber = @SeatNumber
	and customerNumber =  @CustomerNumber 
	and DateSold is null  -- so you can't purchase a seat you have already purchased

	select @@rowcount as NumRowsChanged

--simulate credit card apporval 
	 waitfor delay '00:00:10' --- ten seconds

--select @ccapproval = -1 --- failed 
select @ccapproval = 100 --- succeeded  

	if @ccapproval <= 0 
		begin
			select @msg = 'Sorry. Credit card processing failed.'
			raiserror(@msg,18,1) -- force error
		end 
	else
		begin
			commit  --  credit card was approved. Complete transaction.
			print 'Thank you for your purchase.  Enjoy the concert.'
		end
END TRY 

BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber
     ,ERROR_SEVERITY() AS ErrorSeverity
     ,ERROR_STATE() AS ErrorState
     ,ERROR_PROCEDURE() AS ErrorProcedure
     ,ERROR_LINE() AS ErrorLine
     ,ERROR_MESSAGE() AS ErrorMessage;
	 ROLLBACK  -- rollback for any error
END CATCH
