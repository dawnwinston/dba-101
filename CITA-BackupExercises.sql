--In all Labs replace the database name AdventureWorks00 to  your appropriate database = --AdventureWorks01, AdventureWorks02, etc…. 
--Lab 1 – Perform a full backup and transaction log backup of the AdventureWorks database
--Verify the AdventureWorks00database is set to the Full Recovery Model?
--What recovery model is the database set to?
--Right click on Adventureworks00 database
--Select Properties
--Select Options

--Change the database to “Full” Recovery Model
	Use Master;
	ALTER DATABASE AdventureWorks00 SET RECOVERY FULL;

-- Using SSMS perform a full back up of the database
--Right click on the AdventureWorks00 Database
--Select Tasks
--Select Backup
--Verify the Location is set to Backup to Disk
--Verify the backup path  - 
--'E:\MSSQL13.MSSQLSERVER\MSSQL\Backup\AdventureWorks00.bak' 

--Backup the Transaction Log using TSQL

BACKUP LOG [AdventureWorks00] TO  DISK = 
N'E:\MSSQL13.MSSQLSERVER\MSSQL\Backup\AdventureWorks00_LOG01.trn'

--Lab 2 – Restore the AdventureWorks00 Database to a point in time
--Query the database how many records are in the DatabaseLog table?
Use AdventureWorks00;
Select Top 1 * from DatabaseLog;
Select count(*) from DatabaseLog;

--Run the following Query to delete all the records.
	Use AdventureWorks00;
	Delete from DatabaseLog; 

--How many records are in DatabaseLog Table?
	Use AdventureWorks00;
	Select count(*) from DatabaseLog;

--Using TSQL Perform a log backup of the database

BACKUP LOG [AdventureWorks00] TO  DISK = 
N'E:\MSSQL13.MSSQLSERVER\MSSQL\Backup\AdventureWorks00_log02.trn'



--Using SSMS or TSQL Restore the Adventureworks00 database from backup before the logs -were deleted 


--How many records are in DatabaseLog Table?
	Use AdventureWorks00;
	Select Top 1 * from DatabaseLog;
	Select count(*) from DatabaseLog;

