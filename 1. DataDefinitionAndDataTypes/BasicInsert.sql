

INSERT INTO Towns(Name)
VALUES ('Sofia'),
       ('Plovdiv'),
       ('Varna'),
       ('Burgas')

INSERT INTO Departments(Name)
VALUES ('Engineering'),
       ('Sales'),
       ('Marketing'),
       ('Software Development'),
       ('Quality Assurance')

INSERT INTO Addresses(AddressText, TownId)
VALUES ('Opalchenska', 1),
       ('Ohrid', 1),
       ('Smirnenski', 1)


INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle,
                       DepartmentID, HireDate, Salary, AddressId)
 VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4,'02/01/2013', 3500.00, 2),
    ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '03/02/2004', 4000.00, 1),
    ('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '08/28/2016', 525.25, 3),
    ('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '12/09/2007', 3000.00, 2),
    ('Peter', 'Pan', 'Pan', 'Intern', 3, '08/28/2016', 599.88, 1)

