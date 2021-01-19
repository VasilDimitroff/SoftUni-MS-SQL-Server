USE SoftUni

SELECT  EmployeeID, FirstName, LastName, D.Name
      FROM Employees
JOIN Departments D on D.DepartmentID = Employees.DepartmentID
    WHERE D.Name = 'Sales'
ORDER BY EmployeeID ASC