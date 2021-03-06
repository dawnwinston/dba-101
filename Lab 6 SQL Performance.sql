-- #1 Connect to database and enable table re-creation --> options --> Designer

-- #2 Enable Explain Plain 

-- #3 Select 1000 records from [AdventureWorks10].[Person].[Person]

-- #4 What indexes are on this table 

-- #5 What is the primary key 

-- #6 What is the primary key index

-- #7 What is the clustered index 

-- #8 Are there other indexes?  

-- #9 What is a table scan vs index scan vs index seek

-- Let's play with some data


SELECT TOP (1000) [BusinessEntityID]
      ,[PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,[EmailPromotion]
      ,[AdditionalContactInfo]
      ,[Demographics]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks10].[Person].[Person]

  SELECT
      [FirstName],
      [MiddleName],
      [LastName]
  FROM [AdventureWorks10].[Person].[Person]

    SELECT
      [FirstName],
      [MiddleName],
      [LastName]
  FROM [AdventureWorks10].[Person].[Person]
  WHERE LastName = 'Adams'


--  Let's make a copy of Person.Person

select * 
into dbo.Person
from Person.Person 

-- how many rows did we have to read to find the answer

      SELECT
      [FirstName],
      [MiddleName],
      [LastName]
  FROM [Person].[Person]
  WHERE FirstName = 'Xavier'


  -- how many rows did we have to read to find the answer

      SELECT
      [FirstName],
      [MiddleName],
      [LastName]
  FROM [Person].[Person]
  WHERE  LastName = 'Adams' and FirstName = 'Xavier'
-- where clause match index order 
-- how many rows did we have to read to find the answer

        SELECT
      [FirstName],
      [MiddleName],
      [LastName]
  FROM [Person].[Person]
  WHERE   FirstName = 'Xavier' and LastName = 'Adams'

  -- where clause does not match index order but both columns are in the index 
-- how many rows did we have to read to find the answer


  
-- Now look at the data in dbo.person
-- How many rows do we have 
-- How many indexes do we have 

-- rerun the query on person.person
-- how many rows did we have to read to find the answer

        SELECT
      [FirstName],
      [MiddleName],
      [LastName]
  FROM [Person].[Person]
  WHERE   FirstName = 'Xavier' and LastName = 'Adams'


-- rerun the query on dbo.person


          SELECT
      [FirstName],
      [MiddleName],
      [LastName]
  FROM [dbo].[Person]
  WHERE   FirstName = 'Xavier' and LastName = 'Adams'

  -- how many rows did we have to read to find the answer



 -- Example of covered query 
         SELECT
      [FirstName],
      [MiddleName],
      [LastName],
	  ModifiedDate
  FROM [Person].[Person]
  WHERE   FirstName = 'Xavier' and LastName = 'Adams'


  --Let's Modify the LastName , FirstName index to include ModifiedDate 

           SELECT
      [FirstName],
      [MiddleName],
      [LastName],
	  ModifiedDate
  FROM [Person].[Person]
  WHERE   FirstName = 'Xavier' and LastName = 'Adams'

  -- How many rows did we have to read