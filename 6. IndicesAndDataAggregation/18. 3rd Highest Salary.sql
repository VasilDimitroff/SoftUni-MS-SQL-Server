USE SoftUni

SELECT DISTINCT DepartmentID,
     Salary AS ThirdHighestSalary
FROM
       (SELECT DepartmentID,
        Salary,
       DENSE_RANK() over (PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Rank]
FROM Employees) AS result
WHERE [Rank] = 3

