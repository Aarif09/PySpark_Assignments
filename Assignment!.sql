use AdventureWorks2022

--Q1.Find the average currency rate conversion from USD to Algerian Dinar and Australian Dollar
--Use USD - DZD ,USD-AUD
 select * From Sales.CountryRegionCurrency
select * From Sales.Currency
select * From Sales.CurrencyRate

select CONCAT_WS(' To ',FromCurrencyCode,ToCurrencyCode) Currency_Conversion,avg(AverageRate)
from Sales.CurrencyRate where FromCurrencyCode='USD' and ToCurrencyCode in('DZD','AUD')
group by FromCurrencyCode,ToCurrencyCode

--Q2.Find the products having offer on it and display product name ,
--safety Stock Level, Listprice, and product model id, type of discount, 
--percentage of discount, offer start date and offer end date


select * from Sales.SpecialOfferProduct
select * from Production.Product
select * From Sales.SpecialOffer

select
(select p.ProductModelID from Production.Product p where p.ProductID=sop.ProductID)as Product_ModelID,
(select p.Name from Production.Product p where p.ProductID=sop.ProductID)as Product_Name,
(select p.SafetyStockLevel from Production.Product p where p.ProductID=sop.ProductID)as Safety_Stock_Level,
(select p.ListPrice from Production.Product p where p.ProductID=sop.ProductID)as List_Price,
(select sp.DiscountPct from sales.SpecialOffer sp where sp.SpecialOfferID=sop.SpecialOfferID)as Percentage_of_discount,
(select sp.Type from sales.SpecialOffer sp where sp.SpecialOfferID=sop.SpecialOfferID)as Type_of_discount,
(select concat_ws('  and  ',sp.StartDate,sp.EndDate) from sales.SpecialOffer sp where sp.SpecialOfferID=sop.SpecialOfferID)as Start_and_end_date
from sales.SpecialOfferProduct sop

---3.create view to display Product name and Product review
select * from Production.Product
select *from Production.ProductReview

--create view ProductReviews as
SELECT p.Name,r.Comments
FROM Production.Product p

JOIN Production.ProductReview r ON p.ProductID = r.ProductID;

SELECT * FROM ProductReviews;

--4.find out the vendor for product paint, Adjustable Race and blade
Select * from Purchasing.ProductVendor
Select *from Purchasing.Vendor
Select * from Production.Product

Select pv.BusinessEntityId,(select Name from Purchasing.Vendor pv1 where pv1.BusinessEntityID=pv.BusinessEntityID)Vendor_name,
(select Name from Production.Product p
where p.Name in('Paint') or
p.Name in('Adjustable Race') or p.Name in('Blade')
and p.ProductID=pv.ProductID)Product_Name
From Purchasing.ProductVendor pv

select pv.BusinessEntityID,
	(select v.Name 
	from Purchasing.Vendor v 
	where v.BusinessEntityID=pv.BusinessEntityID) 
	VendorName,
	(select p.Name
	from Production.Product p 
	where pv.ProductID=p.ProductID) 
	ProductName
from Purchasing.ProductVendor pv
where pv.ProductID in 
(select p.ProductID 
from  Production.Product p 
where p.Name like '%paint%' or 
	  p.Name like '%Blade%' or 
	  p.Name ='Adjustable Race')

--find product details shipped through ZY - EXPRESS
select * from Purchasing.ShipMethod
select * from Production.Product
select * from Purchasing.PurchaseOrderDetail
select * from Purchasing.PurchaseOrderHeader

select

(select p.Name from Production.Product p where p.ProductID=pd.ProductID)as ProductName,
(select p.ProductNumber from Production.Product p where p.ProductID=pd.ProductID)as ProductNumber,
(select sm.ShipMethodID from Purchasing.ShipMethod sm where sm.ShipMethodID=ph.ShipMethodID)as ShipID,
(select sm.Name from Purchasing.ShipMethod sm where sm.ShipMethodID=ph.ShipMethodID)as ShipName
FROM Purchasing.PurchaseOrderDetail pd
JOIN Purchasing.PurchaseOrderHeader ph 
    ON pd.PurchaseOrderID = ph.PurchaseOrderID
WHERE ph.ShipMethodID = (
    SELECT s.ShipMethodID 
    FROM Purchasing.ShipMethod s 
    WHERE s.Name LIKE 'ZY - EXPRESS'
)

--Q6.)find the tax amt for products where order date and ship date are on the same day
select * from Production.Product
select * from Purchasing.PurchaseOrderHeader
select * from Purchasing.PurchaseOrderDetail

select 
(select p.Name from Production.Product p where p.ProductID=pd.ProductID)as ProductName,
ph.TaxAmt as Tax_Amount
from Purchasing.PurchaseOrderDetail pd
join Purchasing.PurchaseOrderHeader ph 
on pd.PurchaseOrderID = ph.PurchaseOrderID
where day(ph.OrderDate)=day(ph.ShipDate)


--8)find the name of employees working in day shift

select CONCAT_WS(' ',FirstName,LastName)as Emp_name from Person.Person
where BusinessEntityID in (select BusinessEntityID from HumanResources.EmployeeDepartmentHistory 
where ShiftID in (select ShiftID from HumanResources.Shift where ShiftID=1))

--9.based on product and product cost history find the name ,
--service provider time and average Standardcost
Select * from Production.Product
select * from Production.ProductCostHistory


select 
p.Name as Product_Name,
DATEDIFF_BIG(DAY,MIN(StartDate),MAX(EndDate)) as service_provider_time,
AVG(ph.StandardCost)as Average_Standard_Cost
from Production.ProductCostHistory ph
join Production.Product p on
ph.ProductID=p.ProductID
group by p.Name


---10.)find products with average cost more than 500
Select * from Production.Product
select * from Production.ProductCostHistory


select P.Name,Avg(pc.StandardCost)Avg_stand_cost 
from Production.ProductCostHistory pc
join Production.Product p on
pc.ProductID=p.ProductID
group by p.Name 
having avg(pc.StandardCost)>500


--11.find the employee who worked in multiple territory

select  * from Person.Person
Select * from HumanResources.Employee
select * from Sales.SalesTerritory
select * from Sales.SalesTerritoryHistory
SELECT 
    p.BusinessEntityID,
    CONCAT_WS(' ', p.FirstName, p.LastName) AS Emp_name,
    COUNT(DISTINCT sth.TerritoryID) AS TerritoryCount
from HumanResources.Employee e
join Person.Person p ON p.BusinessEntityID = e.BusinessEntityID
join Sales.SalesTerritoryHistory sth ON e.BusinessEntityID = sth.BusinessEntityID
group by p.BusinessEntityID, p.FirstName, p.LastName
having COUNT(DISTINCT sth.TerritoryID) > 1
order by TerritoryCount DESC;

--12.)Find out the product model name, product description for culture as Arabic
select * from Production.ProductModel
select * from Production.Culture
select * from Production.ProductDescription
select * from Production.ProductModelProductDescriptionCulture

select pm.Name as Product_Model_Name,
pd.Description as Product_Description
from Production.ProductModel pm
join Production.ProductModelProductDescriptionCulture pdc
on pm.ProductModelID=pdc.ProductModelID
join Production.ProductDescription pd
on pd.ProductDescriptionID=pd.ProductDescriptionID
join Production.Culture pc
on pc.CultureID=pdc.CultureID
where pc.Name like 'Arabic'
group by pm.Name,pd.Description

--13.display EMP name, territory name, saleslastyear salesquota and bonus

select territoryId,
(Select CONCAT(FirstName,' ',LastName) from Person.Person pp where pp.BusinessEntityID=sp.BusinessEntityID)as EmployeeName,
(Select Name from sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID)as TerritoryName,
(Select [Group] from Sales.SalesTerritory sl where sl.TerritoryID=sp.TerritoryID)as GroupName,
SalesLastYear,
SalesQuota,
Bonus 
from sales.SalesPerson sp

--Q14. display employee name, territory name, sales last year, sales quota and bonus from germany and united kingdom
select TerritoryID,
(Select CONCAT(FirstName,' ',LastName) from Person.Person pp where pp.BusinessEntityID=sp.BusinessEntityID)as EmployeeName,
(Select Name from sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID)as TerritoryName,
(Select [Group] from Sales.SalesTerritory sl where sl.TerritoryID=sp.TerritoryID)as GroupName,
SalesLastYear,
SalesQuota,
Bonus
from sales.SalesPerson sp
WHERE sp.TerritoryID IN (
    SELECT TerritoryID 
    FROM Sales.SalesTerritory 
    WHERE Name IN ('United Kingdom', 'Germany'))

--15.Find all employees who worked in all North America territory

select TerritoryID,
(select concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name  from Sales.SalesTerritory st where  st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_NAme,SalesLastYear,SalesQuota
from Sales.SalesPerson sp WHERE sp.TerritoryID IN (
    SELECT TerritoryID 
    FROM Sales.SalesTerritory 
    WHERE [Group] IN ('North America'))

--16.find all products in the cart
Select (select Name from Production.Product pp where pp.ProductID=si.ProductID)Prod_name,
(select ProductNumber from Production.Product pp1 where pp1.ProductID=si.ProductID)Prod_Number,
Quantity
from Sales.ShoppingCartItem si

--17.find all the products with special offer
select * from Sales.SpecialOffer
select * from Sales.SpecialOfferProduct

Select Distinct(Name) from Production.Product pp where pp.ProductID 
in(select ProductID from Sales.SpecialOfferProduct)

--18.find all employees name , job title, card details whose credit card expired in the month 11 and year as 2008

select(select CONCAT_WS(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=pc.BusinessEntityID)EmpName,
(select JobTitle from HumanResources.Employee  e where e.BusinessEntityID=pc.BusinessEntityID)Job_Description,
(select CONCAT_WS(' : ',ExpMonth,ExpYear )from Sales.CreditCard cc where cc.CreditCardID=pc.CreditCardID)Card_detail

from Sales.PersonCreditCard pc where pc.CreditCardID in(select CreditCardID from Sales.CreditCard cc where cc.ExpMonth=11 and cc.ExpYear=2008)

--19.Find the employee whose payment might be revised (Hint : Employee payment history)
select * From Person.Person
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory

SELECT e.BusinessEntityID, p.FirstName, p.LastName, COUNT(eph.RateChangeDate) AS PayRevisions
FROM HumanResources.EmployeePayHistory eph
JOIN HumanResources.Employee e 
ON eph.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p 
ON e.BusinessEntityID = p.BusinessEntityID
GROUP BY e.BusinessEntityID, p.FirstName, p.LastName
HAVING COUNT(eph.RateChangeDate) > 1;

