use AdventureWorks2022
select * from HumanResources.Employee where MaritalStatus='M';

---Find all employee under job title as marketing
select * from HumanResources.Employee where JobTitle like '%Marketing%'
-------Find the Technician----------
select * from HumanResources.Employee where JobTitle like '%Technician%'
select * from HumanResources.Employee where JobTitle like '%Engineer%' and MaritalStatus='M'
-------------------------------------------------------------------------------------------
select count (*) from HumanResources.Employee where MaritalStatus='M';
select count (*) from HumanResources.Employee 

select count (*) from HumanResources.Employee where Gender='M';
select count (*) from HumanResources.Employee where Gender='F';

select count (*) from HumanResources.Employee where MaritalStatus='M' and Gender='M';
---------Find employee having salraied flag as 1-----------
select count (*) from HumanResources.Employee where SalariedFlag=1;
-------------find all employee having vacation hr more than 70-------
select count (*) from HumanResources.Employee where VacationHours>70;

-----------find emplyee done vacation hr more than 70 less than 90
select count (*) from HumanResources.Employee where VacationHours>70 and VacationHours<90;
select count (*) from HumanResources.Employee where VacationHours between 70 and 90;
---------------Find all jobs having title as designer
select * from HumanResources.Employee where JobTitle like '%Designer%'
---------------find total employee worked as technician------
select count(*) from HumanResources.Employee where JobTitle like '%Technician%'
-----------------Display data having NationalIDNumber,jbtitle, matital staus,gender for all under marketing
select NationalIDNumber,JobTitle,MaritalStatus,Gender  from HumanResources.Employee  where JobTitle like '%Marketing%'

-----------Unique Values----------
select distinct MaritalStatus from  HumanResources.Employee
------------------Find person having max vacations hrs------
Select max(VacationHours) from HumanResources.Employee
Select min(VacationHours) from HumanResources.Employee

----------------find less sick leave-----------
Select min(SickLeaveHours) from HumanResources.Employee
Select max(SickLeaveHours) from HumanResources.Employee

select * from HumanResources.Department

------------find all emp from production dept
select * from HumanResources.Department where Name='Production'
select * from HumanResources.Department where Name='Research and Development'
select * from HumanResources.Department where GroupName='Research and Development'

select * from HumanResources.Employee where BusinessEntityID
in 
( select BusinessEntityID from HumanResources.EmployeeDepartmentHistory where DepartmentID
in
(select DepartmentID from HumanResources.Department where GroupName='Research and Development'))

select * from HumanResources.Department where GroupName='Research and Development'

select * from HumanResources.EmployeeDepartmentHistory where DepartmentID=7

------Subquery from where------------------
--find all employee who work in day shift
select count(*) from HumanResources.Employee where BusinessEntityId in(
select BusinessEntityId from HumanResources.EmployeeDepartmentHistory where ShiftID
in(
select ShiftID from HumanResources.Shift where Name='Day'))

---- pay frequency should be 1---

select count(*) from HumanResources.Employee where BusinessEntityId in
(select BusinessEntityId from HumanResources.EmployeePayHistory where PayFrequency='1')

----find all job ids which are not placed -----
select * from HumanResources.JobCandidate a where a.JobCandidateID not in
(select JobCandidateID from HumanResources.JobCandidate b where BusinessEntityID 
in (select BusinessEntityID from HumanResources.Employee))


select count(*) from HumanResources.Employee where BusinessEntityId not in(select JobCandidateID  from HumanResources.JobCandidate)

----find the address of employee---
select * from Person.Address where AddressID in(
select AddressID from Person.BusinessEntityAddress where BusinessEntityID in(
select BusinessEntityID from HumanResources.Employee))

select count(*) from Person.Address where AddressID in(
select AddressID from Person.BusinessEntityAddress where BusinessEntityID in(
select BusinessEntityID from HumanResources.Employee))

---Find the name for employee working in gruop research and dev

Select FirstName,LastName from Person.Person 
where BusinessEntityID in
(select BusinessEntityID from HumanResources.EmployeeDepartmentHistory 
where DepartmentID in
(select DepartmentID from HumanResources.Department 
where GroupName='Research and Development'))

--
select BusinessEntityId,NationalIDNumber,jobtitle,
(select firstname from Person.Person p where p.BusinessEntityID=e.BusinessEntityId)
Firstname
from HumanResources.Employee e
--add personal details of employee,middle name,last name

select BusinessEntityId,NationalIDNumber,jobtitle,
(select firstname from Person.Person p where p.BusinessEntityID=e.BusinessEntityId)
Firstname,
(select MiddleName from Person.Person p where p.BusinessEntityID=e.BusinessEntityId)
Middlename,
(select LastName from Person.Person p where p.BusinessEntityID=e.BusinessEntityId)
Lastname
from HumanResources.Employee e


--concat uses to give whole single 
select BusinessEntityId,NationalIDNumber,jobtitle,
(select CONCAT( firstname,' ',MiddleName,' ',LastName)from Person.Person p where p.BusinessEntityID=e.BusinessEntityId)
FullName
from HumanResources.Employee e


--cooncat_ws specifies spaces 
--syntax :concat_ws(separator,str1,str2,str3)
select BusinessEntityId,NationalIDNumber,jobtitle,
(select concat_ws(' - ',firstname,MiddleName,LastName)
from Person.Person p where p.BusinessEntityID=e.BusinessEntityId)
FullName
from HumanResources.Employee e

--for all employee display natId,firstName,lastName ,dept name ,deptgroup



select (select concat_ws('-',firstname,lastname)from Person.Person p 
where p.BusinessEntityID = ed.BusinessEntityID) Person_details,
(select NationalIdNumber from HumanResources.Employee e where e.BusinessEntityID=ed.BusinessEntityId) Emp_Details,
(select concat(Name,GroupName) from HumanResources.Department d  where d.DepartmentID = ed.DepartmentId) dept_details
from HumanResources.EmployeeDepartmentHistory ed

---display f_name,l_name,department ,ship time

select(select concat('  ',firstname,lastname)from Person.Person p where p.BusinessEntityID=ed.BusinessEntityID) Ename,
(select CONCAT('-',name,groupname) from HumanResources.Department d where d.DepartmentID=ed.DepartmentID)Department,
(select concat(starttime,'-' ,endtime) from HumanResources.Shift s where s.ShiftID=ed.ShiftID) Shift_time
from HumanResources.EmployeeDepartmentHistory ed


---display product name and product review based on production schema




----OutPut is using Join--------
SELECT 
    e.NationalIDNumber, 
    d.GroupName AS DepartmentGroup, 
    CONCAT_WS('-', p.FirstName, p.LastName) AS FullName
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory ed 
    ON e.BusinessEntityID = ed.BusinessEntityID
JOIN HumanResources.Department d 
    ON ed.DepartmentID = d.DepartmentID
JOIN Person.Person p 
    ON e.BusinessEntityID = p.BusinessEntityID;

--find employe name job title,
--credit card expire in  month 11 and year 2000
select *  from HumanResources.Employee;
select * from Sales.CreditCard
select * from Sales.PersonCreditCard


-----------------------
select(select CONCAT_WS(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=pc.BusinessEntityID)EmpName,
(select JobTitle from HumanResources.Employee  e where e.BusinessEntityID=pc.BusinessEntityID)Job_Description,
(select CONCAT_WS(' : ',ExpMonth,ExpYear )from Sales.CreditCard cc where cc.CreditCardID=pc.CreditCardID)Card_detail

from Sales.PersonCreditCard pc


select(select CONCAT_WS(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=pc.BusinessEntityID)EmpName,
(select JobTitle from HumanResources.Employee  e where e.BusinessEntityID=pc.BusinessEntityID)Job_Description,
(select CONCAT_WS(' : ',ExpMonth,ExpYear )from Sales.CreditCard cc where cc.CreditCardID=pc.CreditCardID)Card_detail

from Sales.PersonCreditCard pc where pc.CreditCardID in(select CreditCardID from Sales.CreditCard cc where cc.ExpMonth=11 and cc.ExpYear=2008)


---display records from currency rate from USD to AUD

Select * from Sales.CurrencyRate

select * from Sales.CurrencyRate where FromCurrencyCode='USD' and ToCurrencyCode='AUD'
--------------------------------------------------------------------------------
select * from Sales.SalesTerritory

select * from Sales.SalesPerson
select * from Sales.SalesPersonQuotaHistory


-------display emp ,name ,territory name,group,saleslastYear,SaleData,bonus

select TerritoryID,
(select concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name from Sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_NAme,SalesLastYear,SalesQuota
from Sales.SalesPerson sp

-------display emp ,name ,territory name,group,saleslastYear,SaleData,bonus from Germany and UnitedKIgdom
select TerritoryID,
(select concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name  from Sales.SalesTerritory st where  st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_NAme,SalesLastYear,SalesQuota
from Sales.SalesPerson sp WHERE sp.TerritoryID IN (
    SELECT TerritoryID 
    FROM Sales.SalesTerritory 
    WHERE Name IN ('United Kingdom', 'Germany'))


Select * from Sales.CountryRegionCurrency

----Find all emp who worked in all North Territory

select TerritoryID,
(select concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name  from Sales.SalesTerritory st where  st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_NAme,SalesLastYear,SalesQuota
from Sales.SalesPerson sp WHERE sp.TerritoryID IN (
    SELECT TerritoryID 
    FROM Sales.SalesTerritory 
    WHERE [Group] IN ('North America'))

-----Find product details in cart
Select (select Name from Production.Product pp where pp.ProductID=si.ProductID)Prod_name,
(select ProductNumber from Production.Product pp1 where pp1.ProductID=si.ProductID)Prod_Number,
Quantity
from Sales.ShoppingCartItem si

----find product with special offer
select * from Sales.SpecialOffer
select * from Sales.SpecialOfferProduct

Select Distinct(Name) from Production.Product pp where pp.ProductID 
in(select ProductID from Sales.SpecialOfferProduct)



----find the average currency rate conversion from USD to Algerian Dinar nd Australian Doller 
select * from Sales.CountryRegionCurrency
select * from Sales.Currency
select * from Sales.CurrencyRate

select Avg(AverageRate) from Sales.CurrencyRate
group by ToCurrencyCode having ToCurrencyCode='AUD'