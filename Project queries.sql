  use project_2   
  select top 1 * from Customers
  select top 1 * from Orders
  select top 1 * from Products
  select top 1 * from Category
  select top 1 * from Shippers
  ---I want to categorize all the records based on condition 
  --All the records where country is United states we have to write 'US' and for Ausralia "AUS" for others we have to write "None"
  
  
 
  select * ,Case
  when Country ='United states'  then 'US'
  when Country = 'Australia' then 'AUS'
  else 'none'
  end as category
  from Customers


  --We have to categorized all the records where the email has more tha 16 charachters we have to write wron email else shor email.
  --and where 1st name has vowels starting and endind we have to give a output vowels else consonants
     
	 
	 Select CustomerId , FirstName , Email , case
     When len(Email) > 17 then 'long email'
	 else 'Short Email' end as Email_category,
	 case
	 when Firstname like  '[aeiou]%[aeiou]' then 'vowels'
	 else 'consonants' end as name_category
	 From Customers
	

	-- COUNT  THE LENGTH  OF EMAIL BEFORE @

	select Charindex('@' ,Email)-1 from Customers


	--Aggregation with case when

	Select * from Orders 

	Select Distinct(shipperid) from Orders


	-- I want 4 columns -3,1,2,8

	--Total Amount_Invested
	   
	Select 
	Sum(case when ShipperID=3 Then Total_order_amount else 0 end)as '3',
	Sum(case when ShipperID=1 Then Total_order_amount else 0 end)as '1',
    Sum(case when ShipperID=2 Then Total_order_amount else 0 end)as '2',
	Sum(case when ShipperID=8 Then Total_order_amount else 0 end)as '8'
	from Orders

	--number of counts of orders
	Select 
	count(case when ShipperID=3 Then OrderID  end)as '3',
	count(case when ShipperID=1 Then OrderID  end)as '1',
    count(case when ShipperID=2 Then OrderID  end)as '2',
	Count(case when ShipperID=8 Then OrderID  end)as '8'
	from 
	Orders

--If we want to join 2 queries called set operators
--columns (number of columns must be same)
--The sequence of the dataset must be same
--You can apply as much as where condition or anything  

	
--write a query to give the full name  of the customers who never orderd anything.
 select * from Customers
 select*from Orders
select FirstName+' '+LastName as Full_name
from Customers c
left join Orders o
on c.CustomerID = o.CustomerID  
where o.CustomerID is null;

--Write a query to find the top 10 customers[customers_id] who have ordered the most from 2019-2021?

select top 10 c.CustomerID,count(o.customerid) as count_of_order
from Customers c  
join orders o 
on c.CustomerID = o.CustomerID
where YEAR(o.OrderDate) in (2019,2020,2021)
group by c.CustomerID
order by  count_of_order desc

-- Write a query to show the number of customers ,number of orders placed ,and total order amount per month in the year 2021.

select datename(month,o.orderdate)as Month,count(c.CustomerID) as total_customers ,count(o.orderid) as total_orders
from Customers c 
join orders o
on c.CustomerID=o.CustomerID
group by datename(MONTH,o.OrderDate)

--The company is trying up with a bank for prividing offers to a certain set of premium 
-- customers only we want to know those customers who have ordered for a total amount of more than 7000 during the last quarter of year 2020

select * from Customers
select * from Orders  
select c.CustomerID 
from Customers c 
join orders o
on c.CustomerID=o.CustomerID
where datepart(quarter,o.OrderDate)=4 and year(o.OrderDate)=2020
group by datepart(quarter,o.orderdate),c.CustomerID
having sum(Total_order_amount)>7000

select c.CustomerID 
from Customers c 
join orders o
on c.CustomerID=o.CustomerID
where datepart(quarter,o.OrderDate)=4 and year(o.OrderDate)=2020
group by datepart(quarter,o.orderdate),c.CustomerID
having sum(Total_order_amount)>7000

-- by Using case
select datepart(year,o.OrderDate) as year_,datepart(quarter,o.OrderDate) as quarter_ ,c.CustomerId,
sum(Total_order_amount) as total_order,
Case when sum(Total_order_amount) > 7000 then 'offered'
else 'not offered'  end as 'category'
from Customers c 
join orders o
on c.CustomerID = o.CustomerID
where datepart(quarter,o.OrderDate)=4 and year(o.OrderDate)=2020
group by datepart(year,o.OrderDate),datepart(quarter,o.orderdate),c.CustomerID    


--Identify the month year combination which has the highest customer acquistion.

select * from customers
select * from Orders

select concat(month(o.orderdate),'-', YEAR(o.OrderDate)) as combination_monthyear ,count(o.orderid) as count_of_orders
from customers c 
left join Orders o 
On c.CustomerID =o.CustomerID
where o.customerID is not null
group by concat(month(o.orderdate),'-', YEAR(o.OrderDate))
order by count_of_orders desc

--CTE- Common Table Expression 

Use project_2

with cte as(
select * from Customers where FirstName like 'A%')
select * from cte where State = 'Belfast'

-- If you are using any addtitonal colunm in cte that is not a part of your table on which u applied the cte Scenario the have to give the name of the column 
 --select * from Customers

 with Full_name_CTE  as (
select CONCAT(Firstname,'',lastname) as Full_name ,city from Customers)
select * from full_name_CTE

--we can never use orderby clause inside cte

with Full_name_CTE  as (
select CONCAT(Firstname,'',lastname) as Full_name ,city from Customers)
select * from full_name_CTE order by city desc

--We can use update function on cte but only on the column that are part of table by which u created the cte not the column that u made with the help of some functions or on your own 
--Why  we use cte??


 with Details_for_NY as(
 select * from Customers  
 where customerid%2=0),
 Details_for_Austria as (
 select * from Customers where Country ='Austria')
 select * 
 from details_for_NY c1 join  Details_for_Austria c2  ---on the basis of matching value
 on c1.Firstname =c2.Firstname
 
 --create a yoy analysis for the count of customers enrolled with the company each month.The output should look like:
  
   SELECT
    month,
    [2020] AS year_2020,
    [2021] AS year_2021
FROM
(
    SELECT
        MONTH(DateEntered) AS month,
        YEAR(DateEntered) AS year
    FROM
        Customers
) AS source_data
PIVOT
(
    COUNT(year)
    FOR year IN ([2020], [2021])
) AS pivot_data
ORDER BY
    month;

--find Out the top 4 best selling products in each of the categories(in the categories that are currently active on website).
 select * from Products
 select * from Category
 select *  from Shippers
 select * from Suppliers
 select * from Orders
   select top 5 Product ,sum(
 sale_price) as totalprice
   from Products p join Category c 
   on c.CategoryID = p.Category_ID 
   where Active = 1
   group by Product
   order by  totalprice desc

   --find out the least selling products in each of the categories (in the categories that are currently
   select top 5 Product ,sum(sale_price) as totalprice
   from Products p join Category c 
   on c.CategoryID = p.Category_ID 
   where Active = 1
   group by Product
   order by  totalprice asc

   --find the cumulative sum of total orders placed for the year 2021 (solve using both self join & window function)
   select year(orderdate),
   total_orders, 
   sum(total_orders) over (order by orderdate) as cumulative_sum
   from ( 
         select 
		 orderdate,
		 count(*) as total_orders
		 from orders
		 group by
		 OrderDate)
		 as order_counts
where year(orderdate) = 2021
order by
month(orderdate)

--we want to understand  the impact  of running a compaign during julu'21-oct'21
--what was the total sales generated for the categories "foodgrains,oil&masala" and ""fruits &vegetables
--entire customer base
--customer who enrolled with the company during the same period


--select  top 1 * from Customers
--select  top 1 * from Category
--select  top 1 * from Products
--select top 1 * from Orders

 with cte as (
 select customerId,YEAR(deliverydate) as year_,Month(deliverydate) as Month_,Total_order_amount from  Orders where year(deliverydate)=2021
 and Month(DeliveryDate) in (7,8,9,10))
 Select Sum(cte.Total_order_amount) as total_sales,c.categoryname 
 from category  c join Products p on p.Category_ID =c.CategoryID 
 join OrderDetails od on  od.productid=p.productid
 join orders on orders.OrderID=od.OrderID 
 join cte on cte.customerId = Orders.CustomerID
 where CategoryName in ('Foodgrains, Oil & Masala','Fruits & Vegetables')
 group by CategoryName
 order by total_sales desc 

 --enrolled

 with cte as (
 select customerId,YEAR(DateEntered) as year_,Month(DateEntered) as Month_  from  Customers where year(DateEntered)=2021
 and Month(DateEntered) in (7,8,9,10))
 Select Sum(Orders.Total_order_amount) as total_sales,c.categoryname 
 from category  c join Products p on p.Category_ID =c.CategoryID 
 join OrderDetails od on  od.productid=p.productid
 join orders on orders.OrderID=od.OrderID 
 join cte on cte.customerId = Orders.CustomerID
 where CategoryName in ('Foodgrains, Oil & Masala','Fruits & Vegetables')
 group by CategoryName
 order by total_sales desc 


-- create a quarter - wise ranking in terms of revenue generated in each category in year 2021

   --categorytable  --categoryname group by 
   --total sale price from product table 
   --quarter wise ranking in year 2021 means delivery date from  order table order
    SELECT 
    c.categoryname,
    datepart(QUARTER ,orders.deliverydate) AS quarter,
    SUM(p.Sale_Price) AS total_revenue
FROM
     category  c join Products p on p.Category_ID =c.CategoryID 
 join OrderDetails od on  od.productid=p.productid
 join orders on orders.OrderID=od.OrderID 
WHERE
    Datepart(YEAR , Orders.deliverydate) = 2021
GROUP BY
    c.categoryname,
	datepart(QUARTER ,orders.deliverydate)
   
ORDER BY
    quarter asc,
    total_revenue DESC;

-- find the top 3 shipper companies interms of 
--a. Average delivery time for each  category for the latest year

select top 1 * from Shippers
select top 1 * from Customers
select top 1* from Suppliers
select top 1 * from OrderDetails
select top 1 * from Products
select  top 1 * from Category
select top 1 * from Orders

--delivery time from order table--categorayname from category table
--datediff(day,orderdate,deliverydate)
 SELECT TOP 3
    s.CompanyName,
    c.CategoryName,
    AVG(DATEDIFF(day, o.orderdate, o.deliverydate)) AS avg_delivery_time
FROM
    orders o
	join OrderDetails od on Od.orderid=o.OrderID
	join Suppliers s on s.SupplierID = od.SupplierID
	join Products p on p.ProductID = od.ProductID
	join Category c on c.CategoryID = p.Category_ID
WHERE
    YEAR(o.deliverydate) = (SELECT MAX(YEAR(deliverydate)) FROM Orders)
GROUP BY
    s.CompanyName,
    c.categoryname
ORDER BY
    avg_delivery_time ASC

	--volume of latest year

	SELECT TOP 3
    s.CompanyName,
    c.CategoryName,
    AVG(DATEDIFF(day, o.orderdate, o.deliverydate)) AS avg_delivery_time
FROM
    orders o
	join OrderDetails od on Od.orderid=o.OrderID
	join Suppliers s on s.SupplierID = od.SupplierID
	join Products p on p.ProductID = od.ProductID
	join Category c on c.CategoryID = p.Category_ID
WHERE
    YEAR(o.deliverydate) = (SELECT MAX(YEAR(deliverydate)) FROM Orders)
GROUP BY
    s.CompanyName,
    c.categoryname
ORDER BY
    avg_delivery_time ASC


	SELECT TOP 3
    s.CompanyName,
    c.CategoryName,
    sum(od.quantity) AS total_volume
FROM
    orders o
	join OrderDetails od on Od.orderid=o.OrderID
	join Suppliers s on s.SupplierID = od.SupplierID
	join Products p on p.ProductID = od.ProductID
	join Category c on c.CategoryID = p.Category_ID
WHERE
    YEAR(o.deliverydate) = (SELECT MAX(YEAR(deliverydate)) FROM Orders)
GROUP BY
    s.CompanyName,
    c.categoryname
ORDER BY
    total_volume ASC


	--Find the top 25 customers in terms of 
	--total no. of orders placed for year 2020
	--Total prurchase amount for the year 2020

	SELECT  top 25 concat(Customers.FirstName,'',Customers.LastName) as customername , COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE YEAR(Orders.OrderDate) = 2020
GROUP BY concat(Customers.FirstName,'',Customers.LastName)
ORDER BY TotalOrders DESC
--totalpurchase amount 

  SELECT concat(Customers.FirstName,'',Customers.LastName) as customername, SUM( Products.sale_Price) AS TotalPurchaseAmount
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID 
join Products  on Products.ProductID=OrderDetails.ProductID

WHERE YEAR(Orders.OrderDate) = 2020
GROUP BY concat(Customers.FirstName,'',Customers.LastName) 
ORDER BY TotalPurchaseAmount DESC

 --Find the Cumulative average order amount at a weekly level for months
 --feb and march of the year 2020

 SELECT
    YEAR(orders.OrderDate) AS Year,
    MONTH(orders.OrderDate) AS Month,
    DATEPART(WEEK,orders.OrderDate) AS Week,sale_price,
    avg(sale_price) over (order by orders.orderdate  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_avg
FROM
    Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID 
join Products  on Products.ProductID=OrderDetails.ProductID
WHERE
    (YEAR(orders.OrderDate) = 2020) AND (MONTH(Orders.OrderDate) IN (2, 3))
GROUP BY
    orders.orderdate,
	Sale_Price

ORDER BY
    YEAR(OrderDate),
    MONTH(OrderDate),
    DATEPART(WEEK, OrderDate)


	-- aggregation using  window function 

	select orderId,customerid,paymentid,sum(total_order_amount)
	over(partition by paymentid,shipperid) from Orders

	
	select orderId,customerid,paymentid,avg(total_order_amount)
	over(partition by paymentid,shipperid) from Orders


	-- cumulative sum 
	select * ,sum(Total_order_amount) over( partition by customerid order By orderdate) as cumulativesum
	from Orders;

	-- I want cumulative sum month wise with help of my order_date

	--select * from Orders

	 with xyz as(
	 select month(orderdate) as month,sum(total_order_amount) as t_o_a from Orders group by Month(OrderDate))
	 select * ,sum(t_o_a) over(order by Month asc) as cumulative_sum from xyz
	    
-- Rank functions --
--rank
--denserank
--row_number
	
	-- i want the top 10 customers ranking by the total order amount forv each customers
	with cte as(
	select customerid,sum(total_order_amount) as t_o_a
	from orders
	group by customerid),cte_2 as(
	select *,rank()over(order by t_o_a desc) as rank from cte)
	select * from cte_2 where rank<=10;

	-- without cte 
	select *,rank() over(order by total_order_amount desc ) as ranking from Orders
	

   
