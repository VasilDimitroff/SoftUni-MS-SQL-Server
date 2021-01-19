 CREATE TABLE Orders (
     Id INT PRIMARY KEY IDENTITY ,
     ProductName VARCHAR(30) NOT NULL,
     OrderDate DATETIME2 NOT NULL
 )

 INSERT INTO Orders(ProductName, OrderDate)
 VALUES ('Butter', '2016-09-19 00:00:00.000'),
        ('Milk', '2016-09-30 00:00:00.000'),
        ('Cheese', '2016-09-04 00:00:00.000'),
        ('Bread', '2015-12-20 00:00:00.000'),
        ('Tomatoes', '2015-12-30 00:00:00.000')

SELECT ProductName,
       OrderDate,
       DATEADD(DD, 3, OrderDate) AS 'Pay Due',
       DATEADD(MM, 1, OrderDate) AS 'Deliever Due'
FROM Orders