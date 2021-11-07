--------------------------�������-----------------------------

----------------------������� �1------------------------------
--������� ��� ���������� �� ������� Sales.Customer 
--------------------------------------------------------------

GO
SELECT *
FROM Sales.Customer

----------------------������� �2------------------------------
--������� ��� ���������� �� ������� Sales.Store ��������������� 
--�� Name � ���������� �������
--------------------------------------------------------------

GO
SELECT *
FROM Sales.Store
ORDER BY Name

----------------------������� �3------------------------------
--������� �� ������� HumanResources.Employee ��� ����������
--� ������ �����������, ������� �������� ����� 1989-09-28
--------------------------------------------------------------

GO
SELECT TOP 10 *
FROM HumanResources.Employee
WHERE BirthDate > '1989-09-28'

----------------------������� �4------------------------------
--������� �� ������� HumanResources.Employee �����������
--� ������� ��������� ������ LoginID �������� 0.
--������� ������ NationalIDNumber, LoginID, JobTitle.
--������ ������ ���� ������������� �� JobTitle �� ��������
--------------------------------------------------------------

GO
SELECT NationalIDNumber, LoginID, JobTitle
FROM HumanResources.Employee
WHERE LoginID LIKE '%0'
ORDER BY JobTitle DESC

----------------------������� �5------------------------------
--������� �� ������� Person.Person ��� ���������� � �������, ������� ���� 
--��������� � 2008 ���� (ModifiedDate) � MiddleName ��������
--�������� � Title �� �������� �������� 
--------------------------------------------------------------

GO
SELECT *
FROM Person.Person
WHERE DATEPART(yy, ModifiedDate) = 2008
AND MiddleName IS NOT NULL
AND TITLE IS NULL

/*
--Another variants:
--1)
WHERE CONVERT(VARCHAR(25), ModifiedDate, 120) LIKE '2008-%'

--2)
DECLARE @start DATETIME, @end DATETIME
SELECT @start = '2008-01-01', @end = '2008-12-31'
SELECT *
FROM Person.Person

WHERE ModifiedDate >= @start
AND ModifiedDate <= @end

--or

WHERE ModifiedDate BETWEEN @start and @end
*/

----------------------������� �6------------------------------
--������� �������� ������ (HumanResources.Department.Name) ��� ����������
--� ������� ���� ����������
--������������ ������� HumanResources.EmployeeDepartmentHistory � HumanResources.Department
--------------------------------------------------------------

GO
-- noncorrelated subquery
SELECT d.Name AS DepartmentName
FROM HumanResources.Department d
-- alias 'd' is assigned for better readability
WHERE d.DepartmentID in
(
SELECT e.DepartmentID
FROM HumanResources.EmployeeDepartmentHistory e
)
ORDER BY DepartmentName

/*
--Another variant:
GO
SELECT DISTINCT
(
SELECT d.Name
FROM HumanResources.Department d
-- alias 'd' is assigned for better readability
WHERE d.DepartmentID = e.DepartmentID
)
AS DepartmentName
FROM HumanResources.EmployeeDepartmentHistory e
*/

----------------------������� �7------------------------------
--������������ ������ �� ������� Sales.SalesPerson �� TerritoryID
--� ������� ����� CommissionPct, ���� ��� ������ 0
--------------------------------------------------------------

GO
SELECT TerritoryID, SUM(CommissionPct) AS CommissionPctSum
FROM Sales.SalesPerson
GROUP BY TerritoryID
HAVING SUM(CommissionPct) > 0

----------------------������� �8------------------------------
--������� ��� ���������� � ����������� (HumanResources.Employee) 
--������� ����� ����� ������� ���-�� 
--������� (HumanResources.Employee.VacationHours)
--------------------------------------------------------------

GO
SELECT *
FROM HumanResources.Employee
WHERE VacationHours = (SELECT MAX(VacationHours) FROM HumanResources.Employee)

----------------------������� �9------------------------------
--������� ��� ���������� � ����������� (HumanResources.Employee) 
--������� ����� ������� (HumanResources.Employee.JobTitle)
--'Sales Representative' ��� 'Network Administrator' ��� 'Network Manager'
--------------------------------------------------------------

GO
SELECT *
FROM HumanResources.Employee
WHERE JobTitle IN ('Sales Representative', 'Network Administrator', 'Network Manager')

----------------------������� �10-----------------------------
--������� ��� ���������� � ����������� (HumanResources.Employee) � 
--�� ������� (Purchasing.PurchaseOrderHeader). ���� � ���������� ���
--������� �� ������ ���� ������� ����!!!
--------------------------------------------------------------

GO
SELECT *
FROM HumanResources.Employee e
LEFT JOIN Purchasing.PurchaseOrderHeader p
ON e.BusinessEntityID = p.EmployeeID
