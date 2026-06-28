Drop table Departments;
drop table projects;
drop table employees;
CREATE TABLE Departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO Departments (department_name)
VALUES
('Sales'),
('Engineering'),
('Human Resources');

CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT  REFERENCES Departments(department_id),
    salary INT NOT NULL,
    joining_date DATE NOT NULL
);
INSERT INTO Employees(first_name, last_name, department_id, salary, joining_date)
VALUES
('Aman', 'Chaudhary', 2, 55000, '2022-01-15'),
('Rahul', 'Sharma', 1, 45000, '2021-08-10'),
('Priya', 'Singh', 3, 70000, '2019-11-20'),
('Ankit', 'Verma', 2, 80000, '2023-05-11'),
('Sneha', 'Gupta', 1, 50000, '2020-09-18'),
('Ajay', 'Kumar', 2, 65000, '2024-02-12');

CREATE TABLE Projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    department_id INT REFERENCES Departments(department_id),
    status VARCHAR(20) DEFAULT 'ongoing'
);
INSERT INTO Projects
(project_name, department_id, status)
VALUES
('New Project', 2, 'ongoing'),
('Sales Dashboard', 1, 'completed'),
('HR Portal', 3, 'ongoing'),
('Outdated Project', 1, 'completed');

select * from Projects;

SELECT *
FROM Employees;

UPDATE Employees
SET salary = 60000
WHERE employee_id = 5;

DELETE FROM Projects
WHERE project_name = 'Outdated Project';

SELECT * FROM Employees
WHERE joining_date > '2020-12-31';

SELECT * FROM Employees
WHERE salary BETWEEN 40000 AND 70000;

SELECT * FROM Employees 
JOIN Departments 
ON Employees.department_id = Departments.department_id
WHERE department_name = 'Sales';

SELECT * FROM Employees
WHERE first_name LIKE 'A%';

SELECT * FROM Employees
ORDER BY salary DESC
LIMIT 3;

SELECT * FROM Projects
WHERE status <> 'completed';

SELECT * FROM Employees 
JOIN Departments 
ON  Employees.department_id = Departments.department_id;

SELECT project_name, department_name,status FROM Projects 
JOIN Departments 
ON Projects.department_id = Departments.department_id;

SELECT
first_name,
last_name,
project_name
FROM Employees 
JOIN Departments 
ON Employees.department_id = Departments.department_id
JOIN Projects 
ON Departments.department_id = Projects.department_id
WHERE project_name = 'New Project';

SELECT department_name,SUM(salary) 
FROM Employees 
JOIN Departments 
ON Employees.department_id = Departments.department_id
GROUP BY department_name;

SELECT AVG(salary)
FROM Employees;

SELECT COUNT(employee_id),department_name
FROM Departments 
LEFT JOIN Employees 
ON Departments.department_id = Employees.department_id
GROUP BY department_name;

select * from Employees
order by salary desc
limit 1;

select count(employee_id), department_name from Employees
JOIN Departments
ON Departments.department_id = Employees.department_id
group by department_name
Having count(employee_id) > 5;

SELECT *
FROM Employees
WHERE salary >
(
    SELECT AVG(salary)
    FROM Employees
);

ALTER TABLE Projects
ADD CONSTRAINT unique_project_name
UNIQUE(project_name);

ALTER TABLE Projects
DROP COLUMN status;

SELECT *
FROM Employees
WHERE department_id IS NULL;

SELECT department_name
FROM Departments 
LEFT JOIN Projects 
ON Departments.department_id = Projects.department_id
WHERE project_id IS NULL;

SELECT *
FROM Employees
WHERE last_name LIKE '%S%';

SELECT *
FROM Projects
WHERE project_name LIKE '%System';

SELECT *
FROM Employees
ORDER BY joining_date DESC;

SELECT *
FROM Employees
ORDER BY salary;