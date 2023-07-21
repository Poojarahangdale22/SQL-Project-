--If we want to join 2 queries called set operators
--columns (number of columns must be same)
--The sequence of the dataset must be same
--You can apply as much as where condition or anything  
      

	  use class_three
	  Select * from pets 
	  Select  name ,kind, count(*) from pets
	  Group By Name ,Kind
	  having Count(*) = 1
	  Union All
	  Select  name ,City, count(*) from Owners 
	  Group By Name ,City
	  having Count(*)=1
	  Union All
	  Select  name ,City, count(*) from Owners 
	  Group By Name ,City
	  having Count(*)=2

	  -- which is perfect Union or  union all?
	  -- Union all is faster than union ?
	 -- Why?   In Union all there is only operation that it combine.

	 --Intersect(common Records)
	 Select OwnerID from pets where OwnerID %2=0
	 intersect
	 Select OwnerID from owners

	 --Except Operator
	 A= [1,2,3,4]
	 B =[2,3,4]
	 Output = 1  

	 Select Name, kind  from pets
	 UNION 
	 select Name, null from pets

	--Joins -how we establish relationship between n number of tables.
	 use class_three
	  select  top 1 * from pets 
	  Select  top 1 * from owners
	  select  top 1* from ProceduresDetails
	  Select  top 1 * from ProceduresHistory

	  --There are 4 types Of Joins
	 -- join/Inner Join  - We will get the records which are common in both the records (matching value betwwen them not column)
	    
		select * from PETS Join  ProceduresHistory
		On Pets.PetID = ProceduresHistory.PetID 

		--Inner Join
	    select count( * ) from PETS  Inner Join  ProceduresHistory
		On Pets.PetID = ProceduresHistory.PetID 

		--LeFt Join
		select count( * ) from PETS  Left Join  ProceduresHistory
		On Pets.PetID = ProceduresHistory.PetID 

		--rightjoin
		select count( * ) from PETS  Right Join  ProceduresHistory
		On Pets.PetID = ProceduresHistory.PetID 

	   --convert left join into inner join
	   select count( * ) from PETS  Left Join  ProceduresHistory
	    On Pets.PetID = ProceduresHistory.PetID 
		where ProceduresHistory.PetID is Not Null

		--Full Outer Join 
		select count( * ) from PETS  Full Outer Join  ProceduresHistory
		On Pets.PetID = ProceduresHistory.PetID 
		where ProceduresHistory.PetID is Not Null 

	-- I want  top 10 pets name and  Sum(price) for all the pets on whom procedure is performed !!
	  
	  Select  top 10 Name,ph.proceduretype , sum(price) as total_price
	  from pets as p join ProceduresHistory as ph 
	  on p.PetID=ph.PetID join ProceduresDetails as pd 
	  on ph.ProcedureType = pd.ProcedureType
	  where name like'B%' or Name like 'D%'--substring(name,1,1) in ('B','C')
      group by name ,ph.proceduretype 
	  having sum(price)>5000
	  order by total_price desc
	  
	  --